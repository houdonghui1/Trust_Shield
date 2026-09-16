/* L2-side certificate enrollment. */
#define _DEFAULT_SOURCE
#define _POSIX_C_SOURCE 200809L

#include <errno.h>
#include <ctype.h>
#include <fcntl.h>
#include <poll.h>
#include <openssl/ec.h>
#include <openssl/evp.h>
#include <openssl/obj_mac.h>
#include <openssl/pem.h>
#include <openssl/x509.h>
#include <openssl/x509v3.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <termios.h>
#include <unistd.h>

#define UART_DEV "/dev/ttyCH343_PORT3"
#define DEVICE_PATH "/dev/caliptra_dev"
#define BAUD B115200
#define UART_TIMEOUT_MS 120000
#define FRAME_MAX_PAYLOAD 4096
#define CBR1_HEADER_BYTES 7
#define BLS_REGISTRATION_BYTES 162
#define L1_PARENT_PUBLIC_KEY_BYTES 96
#define L1_INSTALL_HEADER_BYTES (4 + L1_PARENT_PUBLIC_KEY_BYTES)
#define LEGACY_TEXT_BUFFER_BYTES 32768U
#define LEGACY_CSR_HEX_MAX_CHARS (FRAME_MAX_PAYLOAD * 2U)
#define LEGACY_BLS_REG_HEX_CHARS (BLS_REGISTRATION_BYTES * 2U)

#define CALIP_IOCTL_MAGIC 'C'
#define CALIP_BLS_SIGN_L1_CERT_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 9, int)
#define CALIP_GET_2ND_CTX_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 6, int)
#define CALIP_BLS_GET_L2_REGISTRATION_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 11, int)

struct ioctl_data {
    unsigned int size;
    unsigned char *buf;
};

static const uint8_t k_l1_install_magic[4] = {'L', '1', 'C', '1'};
static const char k_l1_runtime_marker[] =
    "start Cluster-BLS proxy service";
static const char k_default_l1_rom_measurement[] = "7aefe807e4647c2776feaf8fd88c769b2b80ef913fa67cccb3b91c7671ec6e27ef19c44b223f51462afe384004b66d46ddc64dccec6f7b62a9439dd605dca359";

static int parse_hex_exact(const char *hex, uint8_t *out, size_t out_len);

static int write_all(int fd, const uint8_t *data, size_t len)
{
    while (len != 0) {
        ssize_t written = write(fd, data, len);
        if (written < 0) {
            if (errno == EINTR)
                continue;
            return -1;
        }
        if (written == 0)
            return -1;
        data += written;
        len -= (size_t)written;
    }
    return tcdrain(fd) == 0 ? 0 : -1;
}

static int read_byte_timeout(int fd, uint8_t *byte, int timeout_ms)
{
    struct pollfd poll_fd = {.fd = fd, .events = POLLIN, .revents = 0};

    while (1) {
        int result = poll(&poll_fd, 1, timeout_ms);
        if (result == 0)
            return 1;
        if (result < 0) {
            if (errno == EINTR)
                continue;
            return -1;
        }
        if (!(poll_fd.revents & POLLIN))
            return -1;
        result = (int)read(fd, byte, 1);
        if (result == 1)
            return 0;
        if (result < 0 && errno == EINTR)
            continue;
        return -1;
    }
}

static int uart_configure(int fd)
{
    struct termios tty;

    if (tcgetattr(fd, &tty) != 0)
        return -1;
    cfsetispeed(&tty, BAUD);
    cfsetospeed(&tty, BAUD);
    tty.c_cflag &= ~(PARENB | CSTOPB | CSIZE | CRTSCTS);
    tty.c_cflag |= CS8 | CREAD | CLOCAL;
    tty.c_iflag &= ~(IXON | IXOFF | IXANY);
    tty.c_lflag = 0;
    tty.c_oflag = 0;
    tty.c_cc[VMIN] = 0;
    tty.c_cc[VTIME] = 1;
    tcflush(fd, TCIOFLUSH);
    return tcsetattr(fd, TCSANOW, &tty);
}

static int valid_cbr1(const uint8_t *request, size_t request_len)
{
    size_t tbs_len;
    const size_t prefix_len = CBR1_HEADER_BYTES + BLS_REGISTRATION_BYTES;

    if (request_len < prefix_len ||
        memcmp(request, "CBR1", 4) != 0 || request[4] != 1)
        return 0;
    tbs_len = ((size_t)request[5] << 8) | request[6];
    return tbs_len != 0 && request_len == prefix_len + tbs_len;
}

static int der_total_length(const uint8_t *der, size_t available,
                            size_t *total_length)
{
    size_t header_length;
    size_t content_length;

    if (der == NULL || total_length == NULL || available < 2 || der[0] != 0x30)
        return -1;
    if ((der[1] & 0x80u) == 0) {
        header_length = 2;
        content_length = der[1];
    } else if (der[1] == 0x81 && available >= 3) {
        header_length = 3;
        content_length = der[2];
    } else if (der[1] == 0x82 && available >= 4) {
        header_length = 4;
        content_length = ((size_t)der[2] << 8) | der[3];
    } else {
        return -1;
    }
    if (header_length + content_length > available)
        return -1;
    *total_length = header_length + content_length;
    return 0;
}

static const char *l1_certificate_error_reason(uint32_t status)
{
    switch (status) {
    case 0x4c310001U:
        return "L2 BLS signer initialization failed";
    case 0x4c310002U:
        return "invalid CBR1 request length";
    case 0x4c310003U:
        return "failed to add the BLS certificate binding";
    case 0x4c310004U:
        return "L1 certificate ECDSA signing failed";
    case 0x4c310005U:
        return "L1 BLS registration was rejected";
    case 0x4c310006U:
        return "L2 mailbox request read failed";
    case 0x4c310007U:
        return "invalid CBR1 header or encoded TBS length";
    case 0x4c310008U:
        return "L1 BLS registration or proof is invalid";
    default:
        return "unknown L2 certificate error";
    }
}

static int l2_sign_l1_certificate(const uint8_t *request, size_t request_len,
                                   uint8_t certificate[FRAME_MAX_PAYLOAD],
                                   size_t *certificate_len)
{
    struct ioctl_data req;
    int device_fd;
    size_t parsed_length;

    if (request == NULL || certificate == NULL || certificate_len == NULL ||
        !valid_cbr1(request, request_len))
        return -1;

    /*
     * The new ioctl uses the same buffer for CBR1 input and DER output.  It is
     * deliberately 4096 bytes, never the length of the incoming request.
     */
    memcpy(certificate, request, request_len);
    req.size = (unsigned int)request_len;
    req.buf = certificate;
    device_fd = open(DEVICE_PATH, O_RDWR);
    if (device_fd < 0) {
        perror("open L2 caliptra device");
        return -1;
    }
    if (ioctl(device_fd, CALIP_BLS_SIGN_L1_CERT_IOCTL_GEN, &req) != 0) {
        if (req.size == sizeof(uint32_t)) {
            uint32_t status;
            memcpy(&status, certificate, sizeof(status));
            fprintf(stderr, "BLS sign L1 certificate failed: 0x%08x (%s)\n",
                    status, l1_certificate_error_reason(status));
        } else {
            perror("BLS sign L1 certificate ioctl");
        }
        close(device_fd);
        return -1;
    }
    close(device_fd);

    if (req.size == 0 || req.size > FRAME_MAX_PAYLOAD ||
        der_total_length(certificate, req.size, &parsed_length) != 0 ||
        parsed_length != req.size)
        return -1;
    *certificate_len = req.size;
    return 0;
}

/*
 * Verify the newly issued L1 certificate with the already installed L2
 * certificate, then export L2's P-384 X||Y public key for the L1 Caliptra
 * mailbox.  The L1 ROM performs the same signature check independently.
 */
static int verify_l1_and_export_l2_key(
    const uint8_t *l1_der, size_t l1_der_len,
    const uint8_t *l2_der, size_t l2_der_len,
    uint8_t l2_public_key[L1_PARENT_PUBLIC_KEY_BYTES])
{
    const unsigned char *cursor;
    X509 *l1_certificate = NULL;
    X509 *l2_certificate = NULL;
    EVP_PKEY *l2_key = NULL;
    EC_KEY *ec_key = NULL;
    BASIC_CONSTRAINTS *constraints = NULL;
    ASN1_BIT_STRING *key_usage = NULL;
    const EC_GROUP *group;
    const EC_POINT *point;
    uint8_t encoded[1 + L1_PARENT_PUBLIC_KEY_BYTES];
    size_t encoded_len;
    int result = -1;

    if (l1_der == NULL || l2_der == NULL || l2_public_key == NULL)
        return -1;
    cursor = l1_der;
    l1_certificate = d2i_X509(NULL, &cursor, (long)l1_der_len);
    if (l1_certificate == NULL || cursor != l1_der + l1_der_len)
        goto cleanup;
    cursor = l2_der;
    l2_certificate = d2i_X509(NULL, &cursor, (long)l2_der_len);
    if (l2_certificate == NULL || cursor != l2_der + l2_der_len ||
        X509_NAME_cmp(X509_get_issuer_name(l1_certificate),
                      X509_get_subject_name(l2_certificate)) != 0)
        goto cleanup;

    l2_key = X509_get_pubkey(l2_certificate);
    constraints = X509_get_ext_d2i(l2_certificate, NID_basic_constraints,
                                   NULL, NULL);
    key_usage = X509_get_ext_d2i(l2_certificate, NID_key_usage, NULL, NULL);
    if (constraints == NULL || !constraints->ca || key_usage == NULL ||
        ASN1_BIT_STRING_get_bit(key_usage, 5) != 1 ||
        l2_key == NULL || EVP_PKEY_base_id(l2_key) != EVP_PKEY_EC ||
        X509_verify(l1_certificate, l2_key) != 1)
        goto cleanup;
    ec_key = EVP_PKEY_get1_EC_KEY(l2_key);
    if (ec_key == NULL)
        goto cleanup;
    group = EC_KEY_get0_group(ec_key);
    point = EC_KEY_get0_public_key(ec_key);
    if (group == NULL || point == NULL ||
        EC_GROUP_get_curve_name(group) != NID_secp384r1)
        goto cleanup;
    encoded_len = EC_POINT_point2oct(group, point,
                                     POINT_CONVERSION_UNCOMPRESSED,
                                     encoded, sizeof(encoded), NULL);
    if (encoded_len != sizeof(encoded) || encoded[0] != 0x04)
        goto cleanup;
    memcpy(l2_public_key, encoded + 1, L1_PARENT_PUBLIC_KEY_BYTES);
    result = 0;

cleanup:
    BASIC_CONSTRAINTS_free(constraints);
    ASN1_BIT_STRING_free(key_usage);
    EC_KEY_free(ec_key);
    EVP_PKEY_free(l2_key);
    X509_free(l2_certificate);
    X509_free(l1_certificate);
    return result;
}

static int parse_hex_exact(const char *hex, uint8_t *out, size_t out_len)
{
    size_t i;

    if (hex == NULL || strlen(hex) != out_len * 2)
        return -1;
    for (i = 0; i < out_len; ++i) {
        char pair[3] = {hex[i * 2], hex[i * 2 + 1], '\0'};
        char *end = NULL;
        unsigned long value = strtoul(pair, &end, 16);
        if (end == NULL || *end != '\0' || value > 0xff)
            return -1;
        out[i] = (uint8_t)value;
    }
    return 0;
}

static void print_hex(const uint8_t *data, size_t len)
{
    size_t i;
    for (i = 0; i < len; ++i)
        printf("%02x", data[i]);
    printf("\n");
}

static int write_binary_file(const char *path, const uint8_t *data, size_t len)
{
    FILE *file;
    int failed;

    if (path == NULL || data == NULL || len == 0)
        return -1;
    file = fopen(path, "wb");
    if (file == NULL)
        return -1;
    failed = fwrite(data, 1, len, file) != len;
    if (fclose(file) != 0)
        failed = 1;
    return failed ? -1 : 0;
}

static int read_l2_blob(unsigned long command, uint8_t *buffer,
                        size_t capacity, size_t *length)
{
    struct ioctl_data req;
    int device_fd;

    if (buffer == NULL || length == NULL || capacity == 0 ||
        capacity > UINT32_MAX)
        return -1;
    req.size = (unsigned int)capacity;
    req.buf = buffer;
    device_fd = open(DEVICE_PATH, O_RDWR);
    if (device_fd < 0) {
        perror("open L2 caliptra device");
        return -1;
    }
    if (ioctl(device_fd, command, &req) != 0) {
        perror("read L2 firmware object");
        close(device_fd);
        return -1;
    }
    close(device_fd);
    if (req.size == 0 || req.size > capacity)
        return -1;
    *length = req.size;
    return 0;
}

static int get_l2_registration(const char *output_path)
{
    uint8_t registration[BLS_REGISTRATION_BYTES];
    size_t length;

    if (read_l2_blob(CALIP_BLS_GET_L2_REGISTRATION_IOCTL_GEN,
                     registration, sizeof(registration), &length) != 0 ||
        length != sizeof(registration) || registration[0] != 1 ||
        registration[1] != 1) {
        fprintf(stderr, "Could not obtain a valid L2 BLS registration\n");
        return -1;
    }
    printf("L2 BLS key ID: ");
    print_hex(registration + 2, 16);
    printf("L2 BLS public key: ");
    print_hex(registration + 18, 48);
    printf("L2 BLS proof of possession: ");
    print_hex(registration + 66, 96);
    if (write_binary_file(output_path, registration, length) != 0) {
        perror("save L2 BLS registration");
        return -1;
    }
    printf("Saved L2 BLS registration to %s (%zu bytes).\n", output_path,
           length);
    return 0;
}

static int get_l2_public_key(const char *output_path)
{
    uint8_t registration[BLS_REGISTRATION_BYTES];
    size_t length;

    if (read_l2_blob(CALIP_BLS_GET_L2_REGISTRATION_IOCTL_GEN,
                     registration, sizeof(registration), &length) != 0 ||
        length != sizeof(registration) || registration[0] != 1 ||
        registration[1] != 1) {
        fprintf(stderr, "Could not obtain a valid L2 BLS public key\n");
        return -1;
    }
    printf("L2 BLS public key: ");
    print_hex(registration + 18, 48);
    if (write_binary_file(output_path, registration + 18, 48) != 0) {
        perror("save L2 BLS public key");
        return -1;
    }
    printf("Saved L2 BLS public key to %s (48 bytes).\n", output_path);
    return 0;
}

static int get_l2_certificate(const char *output_path)
{
    uint8_t certificate[FRAME_MAX_PAYLOAD];
    size_t length;
    size_t parsed_length;

    if (read_l2_blob(CALIP_GET_2ND_CTX_IOCTL_GEN, certificate,
                     sizeof(certificate), &length) != 0 ||
        der_total_length(certificate, length, &parsed_length) != 0 ||
        parsed_length != length) {
        fprintf(stderr, "Could not obtain a valid L2 certificate\n");
        return -1;
    }
    if (write_binary_file(output_path, certificate, length) != 0) {
        perror("save L2 certificate");
        return -1;
    }
    printf("Saved L2 certificate to %s (%zu bytes).\n", output_path, length);
    return 0;
}

static int open_uart_path(const char *path)
{
    int fd = open(path, O_RDWR | O_NOCTTY);
    if (fd < 0) {
        perror("open UART");
        return -1;
    }
    if (uart_configure(fd) != 0) {
        perror("configure UART");
        close(fd);
        return -1;
    }
    return fd;
}

static int open_uart(void)
{
    return open_uart_path(UART_DEV);
}

static int wait_for_text_marker(int fd, const char *marker)
{
    size_t matched = 0;
    size_t marker_len;

    if (marker == NULL || (marker_len = strlen(marker)) == 0)
        return -1;
    while (matched < marker_len) {
        uint8_t byte;
        if (read_byte_timeout(fd, &byte, UART_TIMEOUT_MS) != 0)
            return -1;
        putchar((int)byte);
        fflush(stdout);
        if (byte == (uint8_t)marker[matched])
            ++matched;
        else
            matched = byte == (uint8_t)marker[0] ? 1u : 0u;
    }
    return 0;
}

static uint64_t legacy_get_ms(void)
{
    struct timeval tv;

    gettimeofday(&tv, NULL);
    return (uint64_t)tv.tv_sec * 1000U + (uint64_t)tv.tv_usec / 1000U;
}

static ssize_t legacy_read_uart(int uart_fd, char *received, size_t capacity)
{
    char chunk[512];
    ssize_t total = 0;
    ssize_t length;

    if (received == NULL || capacity == 0)
        return -1;
    while ((length = read(uart_fd, chunk, sizeof(chunk) - 1U)) > 0) {
        size_t used = strlen(received);
        size_t copy_len = (size_t)length;

        chunk[length] = '\0';
        printf("%s", chunk);
        fflush(stdout);
        if (used + copy_len >= capacity)
            copy_len = capacity - used - 1U;
        if (copy_len != 0) {
            memcpy(received + used, chunk, copy_len);
            received[used + copy_len] = '\0';
        }
        total += length;
    }
    if (length < 0 && errno != EINTR && errno != EAGAIN &&
        errno != EWOULDBLOCK)
        return -1;
    return total;
}

static int legacy_send_cmd(int uart_fd, char command)
{
    uint8_t data[2] = {(uint8_t)command, '\r'};

    tcflush(uart_fd, TCIFLUSH);
    if (write_all(uart_fd, data, sizeof(data)) != 0)
        return -1;
    if (tcdrain(uart_fd) != 0)
        return -1;
    usleep(100000);
    return 0;
}

static size_t legacy_extract_hex(const char *received, const char *marker,
                                 char *hex, size_t expected_chars)
{
    const char *cursor;
    size_t count = 0;

    if (received == NULL || marker == NULL || hex == NULL)
        return 0;
    cursor = strstr(received, marker);
    if (cursor == NULL)
        return 0;
    cursor += strlen(marker);
    while (*cursor != '\0' && count < expected_chars) {
        if (isxdigit((unsigned char)*cursor)) {
            hex[count++] = *cursor;
        } else if (count != 0 && (*cursor == '\r' || *cursor == '\n')) {
            break;
        }
        ++cursor;
    }
    hex[count] = '\0';
    return count;
}

static int legacy_der_hex_length(const char *hex, size_t hex_chars,
                                 size_t *der_len)
{
    uint8_t header[4];
    size_t header_len;
    size_t content_len;
    size_t i;

    if (hex == NULL || der_len == NULL || (hex_chars & 1U) != 0)
        return -1;
    if (hex_chars < 4U)
        return 0;
    for (i = 0; i < 2U; ++i) {
        char pair[3] = {hex[i * 2U], hex[i * 2U + 1U], '\0'};
        char *end = NULL;
        unsigned long value = strtoul(pair, &end, 16);
        if (end == NULL || *end != '\0' || value > 0xffU)
            return -1;
        header[i] = (uint8_t)value;
    }
    if (header[0] != 0x30U)
        return -1;
    if ((header[1] & 0x80U) == 0) {
        header_len = 2U;
        content_len = header[1];
    } else if (header[1] == 0x81U) {
        header_len = 3U;
        content_len = 0U;
    } else if (header[1] == 0x82U) {
        header_len = 4U;
        content_len = 0U;
    } else {
        return -1;
    }
    if (hex_chars < header_len * 2U)
        return 0;
    for (i = 2U; i < header_len; ++i) {
        char pair[3] = {hex[i * 2U], hex[i * 2U + 1U], '\0'};
        char *end = NULL;
        unsigned long value = strtoul(pair, &end, 16);
        if (end == NULL || *end != '\0' || value > 0xffU)
            return -1;
        header[i] = (uint8_t)value;
    }
    if (header_len == 3U)
        content_len = header[2];
    else if (header_len == 4U)
        content_len = ((size_t)header[2] << 8) | header[3];
    *der_len = header_len + content_len;
    if (*der_len == 0U || *der_len > FRAME_MAX_PAYLOAD)
        return -1;
    if (hex_chars < *der_len * 2U)
        return 0;
    return hex_chars == *der_len * 2U ? 1 : -1;
}

static int legacy_send_cert_to_uart(int uart_fd, const uint8_t *certificate,
                                    size_t certificate_len)
{
    uint8_t sync[2] = {0xaa, 0x55};
    uint8_t length_bytes[2];
    char *hex;
    size_t total_len;
    size_t position;

    if (certificate == NULL || certificate_len == 0 ||
        certificate_len > FRAME_MAX_PAYLOAD)
        return -1;
    total_len = certificate_len * 2U;
    if (total_len > UINT16_MAX)
        return -1;
    hex = malloc(total_len + 1U);
    if (hex == NULL)
        return -1;
    for (position = 0; position < certificate_len; ++position)
        sprintf(hex + position * 2U, "%02x", certificate[position]);
    hex[total_len] = '\0';

    printf("DEBUG: DER length = %zu, HEX length = %zu\n", certificate_len,
           total_len);
    printf("\n=== HOST SENDING CERT (length: %zu bytes) ===\n",
           certificate_len);
    for (position = 0; position < certificate_len; ++position)
        printf("%02x", certificate[position]);
    printf("\n");
    printf("\n=== HOST SENDING CERT HEX (length: %zu bytes) ===\n",
           total_len);
    for (position = 0; position < total_len; position += 64U)
        printf("%.*s\n", (int)(total_len - position > 64U
                                   ? 64U
                                   : total_len - position),
               hex + position);

    tcflush(uart_fd, TCIOFLUSH);
    usleep(200000);
    if (write_all(uart_fd, sync, sizeof(sync)) != 0) {
        free(hex);
        return -1;
    }
    usleep(100000);
    printf("DEBUG: Sent sync header\n");

    length_bytes[0] = (uint8_t)(total_len >> 8);
    length_bytes[1] = (uint8_t)total_len;
    if (write_all(uart_fd, length_bytes, sizeof(length_bytes)) != 0) {
        free(hex);
        return -1;
    }
    usleep(100000);
    printf("DEBUG: Sent length: 0x%02X 0x%02X (%zu bytes)\n",
           length_bytes[0], length_bytes[1], total_len);

    for (position = 0; position < total_len; ++position) {
        if (write_all(uart_fd, (const uint8_t *)hex + position, 1) != 0) {
            free(hex);
            return -1;
        }
        usleep(2000);
        if (position + 1U == 640U) {
            usleep(1000000);
            printf("DEBUG: Reached 640 bytes, waiting 1 second...\n");
        }
    }
    printf("DEBUG: All %zu bytes sent successfully\n", total_len);
    free(hex);
    return 0;
}

static int enroll_l1(int uart_fd)
{
    char received[LEGACY_TEXT_BUFFER_BYTES] = {0};
    char csr_hex[LEGACY_CSR_HEX_MAX_CHARS + 1U] = {0};
    char registration_hex[LEGACY_BLS_REG_HEX_CHARS + 1U] = {0};
    uint8_t request[FRAME_MAX_PAYLOAD] = {0};
    uint8_t certificate[FRAME_MAX_PAYLOAD];
    uint8_t l2_certificate[FRAME_MAX_PAYLOAD];
    uint8_t registration[BLS_REGISTRATION_BYTES];
    size_t request_len;
    size_t certificate_len;
    size_t l2_certificate_len;
    size_t tbs_len;
    uint8_t l2_public_key[L1_PARENT_PUBLIC_KEY_BYTES];
    const char *certificate_output = getenv("CLUSTER_BLS_L1_CERT_OUT");
    const char *rom_expected = getenv("CLUSTER_BLS_L1_ROM_SHA512");
    uint64_t deadline;
    const unsigned char *certificate_cursor;
    X509 *parsed_certificate;
    FILE *pem_file;

    if (rom_expected == NULL)
        rom_expected = k_default_l1_rom_measurement;
    printf("serial init ok\n\n");
    if (legacy_send_cmd(uart_fd, '1') != 0)
        return -1;
    printf("\nwait rom data...\n");
    deadline = legacy_get_ms() + 5000U;
    while (legacy_get_ms() < deadline && strstr(received, rom_expected) == NULL) {
        if (legacy_read_uart(uart_fd, received, sizeof(received)) < 0)
            return -1;
    }
    if (strstr(received, rom_expected) == NULL) {
        printf("\n1st ROM measure failed!\n");
        printf("\nterminate startup!\n");
        return -1;
    }

    printf("\nmeasure success!\n");
    if (legacy_send_cmd(uart_fd, '2') != 0)
        return -1;
    printf("\nwait receive CSR...\n");
    memset(received, 0, sizeof(received));
    deadline = legacy_get_ms() + 10000U;
    while (legacy_get_ms() < deadline) {
        size_t csr_chars;
        size_t registration_chars;

        if (legacy_read_uart(uart_fd, received, sizeof(received)) < 0)
            return -1;
        csr_chars = legacy_extract_hex(received, "CSR :", csr_hex,
                                       LEGACY_CSR_HEX_MAX_CHARS);
        registration_chars = legacy_extract_hex(
            received, "BLS_REG :", registration_hex,
            LEGACY_BLS_REG_HEX_CHARS);
        if (legacy_der_hex_length(csr_hex, csr_chars, &tbs_len) == 1 &&
            registration_chars == LEGACY_BLS_REG_HEX_CHARS)
            break;
        usleep(1000);
    }
    if (legacy_der_hex_length(csr_hex, strlen(csr_hex), &tbs_len) != 1 ||
        strlen(registration_hex) != LEGACY_BLS_REG_HEX_CHARS) {
        printf("Collected CSR hex length: %zu\n", strlen(csr_hex));
        printf("Incomplete CSR data\n");
        (void)legacy_send_cmd(uart_fd, '3');
        return -1;
    }
    printf("Collected CSR hex length: %zu (expected from DER: %zu)\n",
           strlen(csr_hex), tbs_len * 2U);
    if (parse_hex_exact(csr_hex,
                        request + CBR1_HEADER_BYTES + BLS_REGISTRATION_BYTES,
                        tbs_len) != 0 ||
        parse_hex_exact(registration_hex, registration,
                        sizeof(registration)) != 0) {
        printf("Incomplete CSR data\n");
        return -1;
    }
    printf("DER data length: %zu bytes\n", tbs_len);
    memcpy(request, "CBR1", 4);
    request[4] = 1;
    request[5] = (uint8_t)(tbs_len >> 8);
    request[6] = (uint8_t)tbs_len;
    memcpy(request + CBR1_HEADER_BYTES, registration, sizeof(registration));
    request_len = CBR1_HEADER_BYTES + sizeof(registration) + tbs_len;
    printf("CBR1 tx head: %02x %02x %02x %02x, total=0x%zx, tbs=0x%zx\n",
           request[0], request[1], request[2], request[3], request_len,
           tbs_len);

    if (l2_sign_l1_certificate(request, request_len, certificate,
                               &certificate_len) != 0) {
        printf("sign 1st cert failed\n");
        return -1;
    }
    printf("req.size = 0x%x, actual return len = 0x%x \n",
           (unsigned int)certificate_len, (unsigned int)certificate_len);

    if (certificate_output == NULL)
        certificate_output = "device_cert.der";
    if (write_binary_file(certificate_output, certificate,
                           certificate_len) != 0) {
        perror("save L1 certificate");
        return -1;
    }
    certificate_cursor = certificate;
    parsed_certificate = d2i_X509(NULL, &certificate_cursor,
                                  (long)certificate_len);
    if (parsed_certificate != NULL) {
        pem_file = fopen("device_cert.pem", "w");
        if (pem_file != NULL) {
            PEM_write_X509(pem_file, parsed_certificate);
            fclose(pem_file);
            printf("Device certificate saved : device_cert.pem\n");
        } else {
            printf("Failed to save device certificate PEM\n");
        }
        X509_free(parsed_certificate);
    } else {
        printf("Failed to parse device certificate DER\n");
        return -1;
    }
    if (read_l2_blob(CALIP_GET_2ND_CTX_IOCTL_GEN, l2_certificate,
                     sizeof(l2_certificate),
                      &l2_certificate_len) != 0 ||
        verify_l1_and_export_l2_key(certificate, certificate_len,
                                    l2_certificate, l2_certificate_len,
                                    l2_public_key) != 0) {
        fprintf(stderr,
                "L1 certificate was not issued by the installed L2 certificate\n");
        return -1;
    }
    if (certificate_len + L1_INSTALL_HEADER_BYTES > sizeof(certificate)) {
        fprintf(stderr, "L1 certificate installation package is too large\n");
        return -1;
    }
    memmove(certificate + L1_INSTALL_HEADER_BYTES, certificate,
            certificate_len);
    memcpy(certificate, k_l1_install_magic, sizeof(k_l1_install_magic));
    memcpy(certificate + sizeof(k_l1_install_magic), l2_public_key,
           sizeof(l2_public_key));
    certificate_len += L1_INSTALL_HEADER_BYTES;

    memset(received, 0, sizeof(received));
    if (legacy_send_cmd(uart_fd, '4') != 0)
        return -1;
    printf("Sent command 4, waiting for device READY...\n");
    deadline = legacy_get_ms() + 5000U;
    while (legacy_get_ms() < deadline && strstr(received, "READY") == NULL) {
        if (legacy_read_uart(uart_fd, received, sizeof(received)) < 0)
            return -1;
        usleep(1000);
    }
    if (strstr(received, "READY") == NULL) {
        printf("ERROR: Device did not send READY signal within 5 seconds\n");
        (void)legacy_send_cmd(uart_fd, '3');
        return -1;
    }
    printf("Device is ready, starting certificate transmission\n");
    tcflush(uart_fd, TCIFLUSH);
    if (legacy_send_cert_to_uart(uart_fd, certificate, certificate_len) != 0) {
        perror("send L1 certificate installation package");
        return -1;
    }
    printf("\ntask all done\n");
    printf("\nWaiting for device response...\n");
    if (wait_for_text_marker(uart_fd, k_l1_runtime_marker) != 0) {
        fprintf(stderr, "L1 certificate provisioning did not reach the SOC runtime\n");
        return -1;
    }
    printf("\nL1 certificate provisioning completed\n");
    return 0;
}

static void usage(const char *program)
{
    fprintf(stderr,
            "Usage: %s [--enroll | --l2-registration [output.bin] |\n"
            "           --l2-public-key [output.bin] |\n"
            "           --l2-certificate [output.der]]\n",
            program);
}

int main(int argc, char **argv)
{
    int uart_fd;
    int result;

    if (argc >= 2 && strcmp(argv[1], "--l2-registration") == 0) {
        if (argc > 3) {
            usage(argv[0]);
            return 2;
        }
        return get_l2_registration(argc == 3 ? argv[2]
                                               : "l2_bls_registration.bin") == 0
                   ? 0
                   : 1;
    }
    if (argc >= 2 && strcmp(argv[1], "--l2-certificate") == 0) {
        if (argc > 3) {
            usage(argv[0]);
            return 2;
        }
        return get_l2_certificate(argc == 3 ? argv[2]
                                              : "l2_certificate.der") == 0
                   ? 0
                   : 1;
    }
    if (argc >= 2 && strcmp(argv[1], "--l2-public-key") == 0) {
        if (argc > 3) {
            usage(argv[0]);
            return 2;
        }
        return get_l2_public_key(argc == 3 ? argv[2]
                                           : "l2_bls_public_key.bin") == 0
                   ? 0
                   : 1;
    }
    if (argc > 2) {
        usage(argv[0]);
        return 2;
    }

    uart_fd = open_uart();
    if (uart_fd < 0)
        return 1;

    if (argc == 1 || (argc == 2 && strcmp(argv[1], "--enroll") == 0)) {
        result = enroll_l1(uart_fd);
    } else {
        usage(argv[0]);
        result = -1;
    }

    close(uart_fd);
    return result == 0 ? 0 : 1;
}
