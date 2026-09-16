#define _DEFAULT_SOURCE
#define _POSIX_C_SOURCE 200809L

#include "cluster_bls_relay.h"

#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <unistd.h>

#define DEVICE_PATH "/dev/caliptra_dev"
#define BAUD B115200
#define FRAME_TIMEOUT_MS 120000
#define L1_OPERATION_TIMEOUT_MS (-1)
#define FRAME_MAX_PAYLOAD 4096
#define FRAME_HEADER_BYTES 8
#define FRAME_CRC_BYTES 4
#define BLS_REGISTRATION_BYTES 162
#define BLS_CHALLENGE_BYTES 32
#define BLS_SIGNATURE_BYTES 96
#define BLS_SCALE_GROUP_CHILDREN 10U
#define BLS_SCALE_MAX_GROUPS 1000U
#define BLS_SCALE_L1_RESPONSE_BYTES 116U
#define BLS_SCALE_L2_REQUEST_BYTES (40U + BLS_SCALE_GROUP_CHILDREN * BLS_SIGNATURE_BYTES)
#define BLS_SCALE_L2_RESPONSE_BYTES 124U
#define BLS_SCALE_L3_RESPONSE_BYTES 296U
#define BLS_SCALE_CACHED_L1_KEYS 10U
#define L3_BLS_RESPONSE_BYTES (4 + BLS_SIGNATURE_BYTES)
#define ECDSA_SCALE_REQUEST_BYTES 60U
#define ECDSA_SCALE_RESPONSE_BYTES 116U
#define ECDSA_CERT_VERIFY_REQUEST_BYTES 4U
#define ECDSA_CERT_VERIFY_RESPONSE_BYTES 24U
#define L3_KEY_LIST_RESPONSE_HEADER_BYTES \
    (4 + 4 + 1 + 2 * BLS_REGISTRATION_BYTES + 4 + 4)
#define L3_KEY_LIST_RESPONSE_MAX_BYTES \
    (L3_KEY_LIST_RESPONSE_HEADER_BYTES + 2 * FRAME_MAX_PAYLOAD)

#define CALIP_IOCTL_MAGIC 'C'
#define CALIP_GET_2ND_CTX_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 6, int)
#define CALIP_BLS_AGGREGATE_CHALLENGE_IOCTL_GEN \
    _IOR(CALIP_IOCTL_MAGIC, 10, int)
#define CALIP_BLS_GET_L2_REGISTRATION_IOCTL_GEN \
    _IOR(CALIP_IOCTL_MAGIC, 11, int)
#define CALIP_BLS_REGISTER_L1_IOCTL_GEN \
    _IOR(CALIP_IOCTL_MAGIC, 12, int)
#define CALIP_ECDSA_SCALE_SIGN_IOCTL_GEN \
    _IOR(CALIP_IOCTL_MAGIC, 13, int)
#define CALIP_ECDSA_CERT_VERIFY_IOCTL_GEN \
    _IOR(CALIP_IOCTL_MAGIC, 14, int)

enum frame_type {
    FRAME_GET_L1_REGISTRATION = 3,
    FRAME_L1_REGISTRATION = 4,
    FRAME_CHALLENGE = 5,
    FRAME_L1_SIGNATURE = 6,
    FRAME_ERROR = 0x7f,
};

enum l3_request_type {
    L3_REQUEST_CHALLENGE,
    L3_REQUEST_SCALE_CHALLENGE,
    L3_REQUEST_KEY_LIST,
    L3_REQUEST_ECDSA_SCALE,
    L3_REQUEST_ECDSA_CERT_VERIFY,
    L3_REQUEST_ECDSA_CERT_VERIFY_ACK,
};

struct scale_l1_cache {
    int valid;
    uint8_t challenge[BLS_CHALLENGE_BYTES];
    uint8_t signatures[BLS_SCALE_CACHED_L1_KEYS][BLS_SIGNATURE_BYTES];
    uint8_t timings[BLS_SCALE_CACHED_L1_KEYS][16U];
};

struct scale_session_cache {
    int valid;
    uint8_t challenge[BLS_CHALLENGE_BYTES];
    uint8_t group_valid[BLS_SCALE_MAX_GROUPS];
    uint8_t group_response[BLS_SCALE_MAX_GROUPS]
                          [BLS_SCALE_L3_RESPONSE_BYTES];
};

static struct scale_l1_cache g_scale_l1_cache;
static struct scale_session_cache g_scale_session_cache;
static uint8_t g_ecdsa_verify_response[ECDSA_CERT_VERIFY_RESPONSE_BYTES];
static uint32_t g_ecdsa_verify_chains;
static int g_ecdsa_verify_response_pending;

struct ioctl_data {
    unsigned int size;
    unsigned char *buf;
};

static const uint8_t k_frame_magic[4] = {'C', 'B', 'P', '1'};
static const uint8_t k_l3_request_magic[4] = {'B', 'L', 'C', '1'};
static const uint8_t k_l3_scale_request_magic[4] = {'B', 'L', 'S', '2'};
static const uint8_t k_l3_response_magic[4] = {'B', 'L', 'A', '1'};
static const uint8_t k_l3_key_list_request_magic[4] = {'K', 'L', 'R', '1'};
static const uint8_t k_l3_key_list_response_magic[4] = {'K', 'L', 'A', '1'};
static const uint8_t k_l3_ecdsa_request_magic[4] = {'E', 'C', 'S', '1'};
static const uint8_t k_l3_ecdsa_verify_magic[4] = {'E', 'C', 'V', '2'};
static const uint8_t k_l3_ecdsa_verify_ack_magic[4] = {'E', 'C', 'A', '2'};

static int request_l1_registration(
    int l1_uart_fd, uint8_t registration[BLS_REGISTRATION_BYTES]);

static int register_l1_at_l2(
    const uint8_t registration[BLS_REGISTRATION_BYTES])
{
    uint8_t buffer[BLS_REGISTRATION_BYTES];
    struct ioctl_data request;
    uint32_t firmware_status;
    int device_fd;

    memcpy(buffer, registration, sizeof(buffer));
    request.size = sizeof(buffer);
    request.buf = buffer;
    device_fd = open(DEVICE_PATH, O_RDWR);
    if (device_fd < 0) {
        perror("open L2 caliptra device");
        return -1;
    }
    if (ioctl(device_fd, CALIP_BLS_REGISTER_L1_IOCTL_GEN, &request) != 0) {
        perror("register L1 BLS identity ioctl");
        close(device_fd);
        return -1;
    }
    close(device_fd);
    if (request.size != sizeof(firmware_status)) {
        fprintf(stderr, "Invalid L2 BLS registration response length: %u\n",
                request.size);
        return -1;
    }
    memcpy(&firmware_status, buffer, sizeof(firmware_status));
    if (firmware_status != 0x11111111U) {
        fprintf(stderr, "L2 rejected L1 BLS registration: 0x%08x\n",
                firmware_status);
        return -1;
    }
    return 0;
}

static uint32_t crc32_update(uint32_t crc, const uint8_t *data, size_t len)
{
    size_t bit;

    while (len-- != 0) {
        crc ^= *data++;
        for (bit = 0; bit < 8; ++bit)
            crc = (crc & 1U) ? ((crc >> 1) ^ 0xedb88320U) : (crc >> 1);
    }
    return crc;
}

static uint32_t frame_crc(const uint8_t header[FRAME_HEADER_BYTES],
                          const uint8_t *payload, size_t payload_len)
{
    uint32_t crc = crc32_update(0xffffffffU, header, FRAME_HEADER_BYTES);

    if (payload_len != 0U)
        crc = crc32_update(crc, payload, payload_len);
    return crc ^ 0xffffffffU;
}

static int write_all(int fd, const uint8_t *data, size_t len)
{
    while (len != 0U) {
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

static int write_crc_packet(int fd, const uint8_t *data, size_t len)
{
    uint8_t crc_bytes[4];
    uint32_t crc;

    crc = crc32_update(0xffffffffU, data, len) ^ 0xffffffffU;
    crc_bytes[0] = (uint8_t)(crc >> 24);
    crc_bytes[1] = (uint8_t)(crc >> 16);
    crc_bytes[2] = (uint8_t)(crc >> 8);
    crc_bytes[3] = (uint8_t)crc;
    return write_all(fd, data, len) == 0 &&
                   write_all(fd, crc_bytes, sizeof(crc_bytes)) == 0
               ? 0
               : -1;
}

static int read_byte(int fd, uint8_t *byte, int timeout_ms)
{
    struct pollfd poll_fd = {.fd = fd, .events = POLLIN, .revents = 0};

    for (;;) {
        int result = poll(&poll_fd, 1, timeout_ms);
        if (result == 0)
            return 1;
        if (result < 0) {
            if (errno == EINTR)
                continue;
            return -1;
        }
        if ((poll_fd.revents & POLLIN) == 0)
            return -1;
        result = (int)read(fd, byte, 1);
        if (result == 1)
            return 0;
        if (result < 0 && errno == EINTR)
            continue;
        return -1;
    }
}

static int read_exact(int fd, uint8_t *data, size_t len, int timeout_ms)
{
    while (len-- != 0U) {
        if (read_byte(fd, data++, timeout_ms) != 0)
            return -1;
    }
    return 0;
}

static int send_frame(int fd, enum frame_type type, const uint8_t *payload,
                      size_t payload_len)
{
    uint8_t header[FRAME_HEADER_BYTES];
    uint8_t crc_bytes[FRAME_CRC_BYTES];
    uint32_t crc;

    if (payload_len > FRAME_MAX_PAYLOAD ||
        (payload_len != 0U && payload == NULL))
        return -1;
    memcpy(header, k_frame_magic, sizeof(k_frame_magic));
    header[4] = 1U;
    header[5] = (uint8_t)type;
    header[6] = (uint8_t)(payload_len >> 8);
    header[7] = (uint8_t)payload_len;
    crc = frame_crc(header, payload, payload_len);
    crc_bytes[0] = (uint8_t)(crc >> 24);
    crc_bytes[1] = (uint8_t)(crc >> 16);
    crc_bytes[2] = (uint8_t)(crc >> 8);
    crc_bytes[3] = (uint8_t)crc;
    if (write_all(fd, header, sizeof(header)) != 0 ||
        (payload_len != 0U && write_all(fd, payload, payload_len) != 0) ||
        write_all(fd, crc_bytes, sizeof(crc_bytes)) != 0)
        return -1;
    return 0;
}

static int read_frame(int fd, enum frame_type *type, uint8_t *payload,
                      size_t payload_capacity, size_t *payload_len,
                      int timeout_ms)
{
    uint8_t header[FRAME_HEADER_BYTES];
    uint8_t crc_bytes[FRAME_CRC_BYTES];
    uint8_t byte;
    size_t matched = 0U;
    size_t length;
    uint32_t expected_crc;

    if (type == NULL || payload == NULL || payload_len == NULL)
        return -1;
    while (matched < sizeof(k_frame_magic)) {
        if (read_byte(fd, &byte, timeout_ms) != 0)
            return -1;
        if (byte == k_frame_magic[matched])
            ++matched;
        else
            matched = byte == k_frame_magic[0] ? 1U : 0U;
    }
    memcpy(header, k_frame_magic, sizeof(k_frame_magic));
    if (read_exact(fd, header + sizeof(k_frame_magic),
                   FRAME_HEADER_BYTES - sizeof(k_frame_magic),
                   timeout_ms) != 0 ||
        header[4] != 1U)
        return -1;
    length = ((size_t)header[6] << 8) | header[7];
    if (length > payload_capacity || length > FRAME_MAX_PAYLOAD)
        return -1;
    if ((length != 0U &&
         read_exact(fd, payload, length, timeout_ms) != 0) ||
        read_exact(fd, crc_bytes, sizeof(crc_bytes), timeout_ms) != 0)
        return -1;
    expected_crc = ((uint32_t)crc_bytes[0] << 24) |
                   ((uint32_t)crc_bytes[1] << 16) |
                   ((uint32_t)crc_bytes[2] << 8) | crc_bytes[3];
    if (expected_crc != frame_crc(header, payload, length))
        return -1;
    *type = (enum frame_type)header[5];
    *payload_len = length;
    return 0;
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
    tty.c_iflag = 0;
    tty.c_lflag = 0;
    tty.c_oflag = 0;
    tty.c_cc[VMIN] = 0;
    tty.c_cc[VTIME] = 1;
    if (tcsetattr(fd, TCSANOW, &tty) != 0)
        return -1;
    return tcflush(fd, TCIOFLUSH);
}

static int open_uart(const char *path)
{
    int fd;

    if (path == NULL)
        return -1;
    fd = open(path, O_RDWR | O_NOCTTY);
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

static int activate_l1_proxy(int l1_uart_fd)
{
    uint8_t registration[BLS_REGISTRATION_BYTES];

    if (request_l1_registration(l1_uart_fd, registration) != 0 ||
        register_l1_at_l2(registration) != 0) {
        fprintf(stderr, "L1 runtime did not enter Cluster-BLS proxy mode\n");
        return -1;
    }
    printf("L1 Cluster-BLS proxy is ready.\n");
    return 0;
}

static int der_total_length(const uint8_t *der, size_t available,
                            size_t *total_length)
{
    size_t header_length;
    size_t content_length;

    if (der == NULL || total_length == NULL || available < 2U || der[0] != 0x30)
        return -1;
    if ((der[1] & 0x80U) == 0U) {
        header_length = 2U;
        content_length = der[1];
    } else if (der[1] == 0x81U && available >= 3U) {
        header_length = 3U;
        content_length = der[2];
    } else if (der[1] == 0x82U && available >= 4U) {
        header_length = 4U;
        content_length = ((size_t)der[2] << 8) | der[3];
    } else {
        return -1;
    }
    if (header_length + content_length > available)
        return -1;
    *total_length = header_length + content_length;
    return 0;
}

static int read_binary_file(const char *path, uint8_t *data, size_t capacity,
                            size_t *data_len)
{
    FILE *file;
    size_t length;

    if (path == NULL || data == NULL || data_len == NULL)
        return -1;
    file = fopen(path, "rb");
    if (file == NULL)
        return -1;
    length = fread(data, 1, capacity, file);
    if (ferror(file) || (!feof(file) && length == capacity)) {
        fclose(file);
        return -1;
    }
    if (fclose(file) != 0 || length == 0U)
        return -1;
    *data_len = length;
    return 0;
}

static int read_l2_blob(unsigned long command, uint8_t *buffer,
                        size_t capacity, size_t *length)
{
    struct ioctl_data request;
    int device_fd;

    if (buffer == NULL || length == NULL || capacity > UINT32_MAX)
        return -1;
    request.size = (unsigned int)capacity;
    request.buf = buffer;
    device_fd = open(DEVICE_PATH, O_RDWR);
    if (device_fd < 0) {
        perror("open L2 caliptra device");
        return -1;
    }
    if (ioctl(device_fd, command, &request) != 0) {
        perror("read L2 BLS material ioctl");
        close(device_fd);
        return -1;
    }
    close(device_fd);
    if (request.size == 0U || request.size > capacity)
        return -1;
    *length = request.size;
    return 0;
}

static int request_l1_registration(
    int l1_uart_fd, uint8_t registration[BLS_REGISTRATION_BYTES])
{
    enum frame_type type;
    size_t registration_len;

    if (tcflush(l1_uart_fd, TCIFLUSH) != 0 ||
        send_frame(l1_uart_fd, FRAME_GET_L1_REGISTRATION, NULL, 0U) != 0) {
        fprintf(stderr, "Could not obtain L1 BLS registration\n");
        return -1;
    }
    for (;;) {
        if (read_frame(l1_uart_fd, &type, registration,
                       BLS_REGISTRATION_BYTES, &registration_len,
                       L1_OPERATION_TIMEOUT_MS) != 0) {
            fprintf(stderr, "Could not obtain L1 BLS registration\n");
            return -1;
        }
        if (type == FRAME_L1_SIGNATURE &&
            (registration_len == BLS_SIGNATURE_BYTES ||
             registration_len == BLS_SCALE_L1_RESPONSE_BYTES)) {
            fprintf(stderr,
                    "Discarded a late L1 signature before registration\n");
            continue;
        }
        break;
    }
    if (type == FRAME_ERROR && registration_len == 4U) {
        fprintf(stderr, "L1 BLS bridge rejected registration: status=%u\n",
                (unsigned int)registration[3]);
        return -1;
    }
    if (type != FRAME_L1_REGISTRATION ||
        registration_len != BLS_REGISTRATION_BYTES) {
        fprintf(stderr,
                "Invalid L1 BLS registration response: type=%u len=%zu\n",
                (unsigned int)type, registration_len);
        return -1;
    }
    return 0;
}

static int aggregate_l1_at_l2(
    const uint8_t challenge[BLS_CHALLENGE_BYTES],
    const uint8_t l1_signature[BLS_SIGNATURE_BYTES],
    uint8_t aggregate[BLS_SIGNATURE_BYTES])
{
    uint8_t request_buffer[FRAME_MAX_PAYLOAD] = {0};
    struct ioctl_data request;
    int device_fd;

    memcpy(request_buffer, challenge, BLS_CHALLENGE_BYTES);
    memcpy(request_buffer + BLS_CHALLENGE_BYTES, l1_signature,
           BLS_SIGNATURE_BYTES);
    request.size = BLS_CHALLENGE_BYTES + BLS_SIGNATURE_BYTES;
    request.buf = request_buffer;
    device_fd = open(DEVICE_PATH, O_RDWR);
    if (device_fd < 0) {
        perror("open L2 caliptra device");
        return -1;
    }
    if (ioctl(device_fd, CALIP_BLS_AGGREGATE_CHALLENGE_IOCTL_GEN,
              &request) != 0) {
        perror("BLS aggregate challenge ioctl");
        close(device_fd);
        return -1;
    }
    close(device_fd);
    if (request.size != BLS_SIGNATURE_BYTES)
        return -1;
    memcpy(aggregate, request_buffer, BLS_SIGNATURE_BYTES);
    return 0;
}

static uint32_t get_u32_be(const uint8_t in[4])
{
    return ((uint32_t)in[0] << 24) | ((uint32_t)in[1] << 16) |
           ((uint32_t)in[2] << 8) | in[3];
}

static uint64_t get_u64_be(const uint8_t in[8])
{
    uint64_t value = 0U;
    size_t index;

    for (index = 0U; index < 8U; ++index)
        value = (value << 8U) | in[index];
    return value;
}

static void put_u32_be(uint8_t out[4], uint32_t value)
{
    out[0] = (uint8_t)(value >> 24);
    out[1] = (uint8_t)(value >> 16);
    out[2] = (uint8_t)(value >> 8);
    out[3] = (uint8_t)value;
}

static void put_u64_be(uint8_t out[8], uint64_t value)
{
    size_t index;

    for (index = 0U; index < 8U; ++index) {
        out[7U - index] = (uint8_t)value;
        value >>= 8U;
    }
}

static int request_l1_ecdsa_signature(
    int l1_uart_fd, const uint8_t request[ECDSA_SCALE_REQUEST_BYTES],
    uint8_t response[ECDSA_SCALE_RESPONSE_BYTES])
{
    enum frame_type type;
    size_t response_len;

    if (send_frame(l1_uart_fd, FRAME_CHALLENGE, request,
                   ECDSA_SCALE_REQUEST_BYTES) != 0 ||
        read_frame(l1_uart_fd, &type, response,
                   ECDSA_SCALE_RESPONSE_BYTES, &response_len,
                   L1_OPERATION_TIMEOUT_MS) != 0) {
        fprintf(stderr, "Could not obtain L1 ECDSA scale signature\n");
        return -1;
    }
    if (type == FRAME_ERROR && response_len == 4U) {
        fprintf(stderr, "L1 ECDSA scale request rejected: 0x%08x\n",
                get_u32_be(response));
        return -1;
    }
    if (type != FRAME_L1_SIGNATURE ||
        response_len != ECDSA_SCALE_RESPONSE_BYTES) {
        fprintf(stderr,
                "Invalid L1 ECDSA scale response: type=%u len=%zu\n",
                (unsigned int)type, response_len);
        return -1;
    }
    return 0;
}

static int request_l2_ecdsa_signature(
    const uint8_t request[ECDSA_SCALE_REQUEST_BYTES],
    uint8_t response[ECDSA_SCALE_RESPONSE_BYTES])
{
    uint8_t buffer[ECDSA_SCALE_RESPONSE_BYTES] = {0};
    struct ioctl_data ioctl_request;
    int device_fd;

    memcpy(buffer, request, ECDSA_SCALE_REQUEST_BYTES);
    ioctl_request.size = ECDSA_SCALE_REQUEST_BYTES;
    ioctl_request.buf = buffer;
    device_fd = open(DEVICE_PATH, O_RDWR);
    if (device_fd < 0) {
        perror("open L2 caliptra device");
        return -1;
    }
    if (ioctl(device_fd, CALIP_ECDSA_SCALE_SIGN_IOCTL_GEN,
              &ioctl_request) != 0) {
        perror("L2 ECDSA scale sign ioctl");
        close(device_fd);
        return -1;
    }
    close(device_fd);
    if (ioctl_request.size != ECDSA_SCALE_RESPONSE_BYTES) {
        fprintf(stderr, "Invalid L2 ECDSA scale response length: %u\n",
                ioctl_request.size);
        return -1;
    }
    memcpy(response, buffer, ECDSA_SCALE_RESPONSE_BYTES);
    return 0;
}

static int request_l2_ecdsa_certificate_verification(
    uint32_t chains, uint8_t response[ECDSA_CERT_VERIFY_RESPONSE_BYTES])
{
    uint8_t buffer[ECDSA_CERT_VERIFY_RESPONSE_BYTES] = {0};
    struct ioctl_data ioctl_request;
    int device_fd;
    uint32_t batch;
    uint32_t batch_completed;
    uint32_t completed = 0U;
    uint32_t group = 0U;
    uint32_t groups = chains / 10U;
    uint64_t cycles = 0U;

    ioctl_request.buf = buffer;
    printf("[ECDSA 1/3] L2 is verifying %u L1 certificates in %u groups...\n",
           chains, groups);
    fflush(stdout);
    device_fd = open(DEVICE_PATH, O_RDWR);
    if (device_fd < 0) {
        perror("open L2 caliptra device");
        return -1;
    }
    while (completed < chains) {
        batch = chains - completed;
        if (batch > 10U)
            batch = 10U;
        memset(buffer, 0, sizeof(buffer));
        put_u32_be(buffer, batch);
        ioctl_request.size = ECDSA_CERT_VERIFY_REQUEST_BYTES;
        if (ioctl(device_fd, CALIP_ECDSA_CERT_VERIFY_IOCTL_GEN,
                  &ioctl_request) != 0) {
            perror("L2 ECDSA certificate verify ioctl");
            close(device_fd);
            return -1;
        }
        if (ioctl_request.size != ECDSA_CERT_VERIFY_RESPONSE_BYTES ||
            memcmp(buffer, "EVR2", 4U) != 0 ||
            get_u32_be(buffer + 4U) != 0U ||
            get_u32_be(buffer + 8U) != batch) {
            fprintf(stderr,
                    "Invalid L2 ECDSA certificate verify response in group %u\n",
                    group + 1U);
            close(device_fd);
            return -1;
        }
        batch_completed = get_u32_be(buffer + 12U);
        if (batch_completed != batch) {
            fprintf(stderr,
                    "L2 ECDSA certificate verification stopped in group %u: %u/%u\n",
                    group + 1U, batch_completed, batch);
            close(device_fd);
            return -1;
        }
        completed += batch_completed;
        cycles += get_u64_be(buffer + 16U);
        ++group;
        printf("[ECDSA 1/3] Verified L1 group %u/%u: %u/%u certificates\n",
               group, groups, completed, chains);
        fflush(stdout);
    }
    close(device_fd);
    memset(response, 0, ECDSA_CERT_VERIFY_RESPONSE_BYTES);
    memcpy(response, "EVR2", 4U);
    put_u32_be(response + 4U, 0U);
    put_u32_be(response + 8U, chains);
    put_u32_be(response + 12U, completed);
    put_u64_be(response + 16U, cycles);
    printf("[ECDSA 1/3] L2 certificate verification completed: %u/%u\n",
           completed, chains);
    fflush(stdout);
    return 0;
}

static int collect_ecdsa_scale_signature(
    int l1_uart_fd, const uint8_t request[ECDSA_SCALE_REQUEST_BYTES],
    uint8_t response[ECDSA_SCALE_RESPONSE_BYTES])
{
    uint32_t level;
    uint32_t index;

    if (memcmp(request, k_l3_ecdsa_request_magic, 4U) != 0)
        return -1;
    level = get_u32_be(request + 4U);
    index = get_u32_be(request + 8U);
    if (level == 1U) {
        if (request_l1_ecdsa_signature(l1_uart_fd, request, response) != 0)
            return -1;
    } else if (level == 2U) {
        if (request_l2_ecdsa_signature(request, response) != 0)
            return -1;
    } else {
        return -1;
    }
    if (memcmp(response, "ECR1", 4U) != 0 ||
        get_u32_be(response + 4U) != level ||
        get_u32_be(response + 8U) != index) {
        fprintf(stderr,
                "Invalid ECDSA scale identity: requested L%u/%u\n",
                level, index);
        return -1;
    }
    return 0;
}

static int aggregate_scale_l1_at_l2(
    uint8_t request_buffer[BLS_SCALE_L2_REQUEST_BYTES])
{
    struct ioctl_data request;
    int device_fd;

    request.size = BLS_SCALE_L2_REQUEST_BYTES;
    request.buf = request_buffer;
    device_fd = open(DEVICE_PATH, O_RDWR);
    if (device_fd < 0) {
        perror("open L2 caliptra device");
        return -1;
    }
    if (ioctl(device_fd, CALIP_BLS_AGGREGATE_CHALLENGE_IOCTL_GEN,
              &request) != 0) {
        perror("BLS scale aggregate challenge ioctl");
        close(device_fd);
        return -1;
    }
    close(device_fd);
    if (request.size != BLS_SCALE_L2_RESPONSE_BYTES) {
        fprintf(stderr,
                "Invalid L2 scale aggregate response length: %u, expected %u\n",
                request.size, (unsigned int)BLS_SCALE_L2_RESPONSE_BYTES);
        return -1;
    }
    return 0;
}

static int collect_l1_l2_aggregate(
    int l1_uart_fd, const uint8_t challenge[BLS_CHALLENGE_BYTES],
    uint8_t aggregate[BLS_SIGNATURE_BYTES])
{
    enum frame_type type;
    uint8_t l1_signature[FRAME_MAX_PAYLOAD];
    size_t signature_len;

    if (tcflush(l1_uart_fd, TCIFLUSH) != 0 ||
        send_frame(l1_uart_fd, FRAME_CHALLENGE, challenge,
                   BLS_CHALLENGE_BYTES) != 0 ||
        read_frame(l1_uart_fd, &type, l1_signature, sizeof(l1_signature),
                   &signature_len, FRAME_TIMEOUT_MS) != 0) {
        fprintf(stderr, "Could not obtain L1 BLS signature\n");
        return -1;
    }
    if (type == FRAME_ERROR && signature_len == 4U) {
        uint32_t firmware_status = ((uint32_t)l1_signature[0] << 24) |
                                   ((uint32_t)l1_signature[1] << 16) |
                                   ((uint32_t)l1_signature[2] << 8) |
                                   (uint32_t)l1_signature[3];
        const char *reason = "bridge error";
        if (firmware_status == 0x4c314101U) {
            reason = "L1 BLS signing failed";
        } else if (firmware_status == 0x4c314102U) {
            reason = "L1 BLS signature decode failed";
        } else if (firmware_status == 0x4c314103U) {
            reason = "L1 BLS signature is not in G2";
        } else if (firmware_status == 0x4c314104U) {
            reason = "L1 BLS signature is infinity";
        }
        fprintf(stderr,
                "L1 BLS bridge rejected challenge: status=0x%08x (%s)\n",
                firmware_status, reason);
        return -1;
    }
    if (type != FRAME_L1_SIGNATURE || signature_len != BLS_SIGNATURE_BYTES) {
        fprintf(stderr, "Invalid L1 BLS signature response: type=%u len=%zu\n",
                (unsigned int)type, signature_len);
        return -1;
    }
    printf("L1 BLS signature head:");
    for (size_t i = 0U; i < 16U; ++i)
        printf("%02x", l1_signature[i]);
    printf(" tail:");
    for (size_t i = BLS_SIGNATURE_BYTES - 16U;
         i < BLS_SIGNATURE_BYTES; ++i)
        printf("%02x", l1_signature[i]);
    printf("\n");
    if ((l1_signature[0] & 0xc0U) != 0x80U) {
        fprintf(stderr, "L1 returned a non-canonical compressed BLS signature\n");
        return -1;
    }
    if (aggregate_l1_at_l2(challenge, l1_signature, aggregate) != 0) {
        fprintf(stderr, "Could not aggregate the L1 signature at L2\n");
        return -1;
    }
    printf("Collected L1 signature and generated L1/L2 aggregate\n");
    return 0;
}

static uint32_t collect_scale_l1_l2_aggregate(
    int l1_uart_fd, uint32_t group,
    const uint8_t challenge[BLS_CHALLENGE_BYTES],
    uint8_t response[BLS_SCALE_L3_RESPONSE_BYTES],
    struct scale_l1_cache *cache)
{
    enum frame_type type;
    uint8_t request[40U];
    uint8_t l1_response[BLS_SCALE_L1_RESPONSE_BYTES];
    uint8_t l2_request[BLS_SCALE_L2_REQUEST_BYTES];
    size_t signature_len;
    int cache_filled = 0;

    if (group == 0U || group > BLS_SCALE_MAX_GROUPS || cache == NULL) {
        return 0x53430001U;
    }
    memcpy(request, "SCL2", 4U);
    memcpy(request + 8U, challenge, BLS_CHALLENGE_BYTES);
    memcpy(l2_request, "SCA2", 4U);
    put_u32_be(l2_request + 4U, group);
    memcpy(l2_request + 8U, challenge, BLS_CHALLENGE_BYTES);
    if (!cache->valid ||
        memcmp(cache->challenge, challenge, BLS_CHALLENGE_BYTES) != 0) {
        printf("Collecting 10 physical L1 signatures for a new challenge\n");
        cache->valid = 0;
        for (uint32_t child = 0U; child < BLS_SCALE_GROUP_CHILDREN; ++child) {
            uint32_t index = child + 1U;
            put_u32_be(request + 4U, index);
            if (send_frame(l1_uart_fd, FRAME_CHALLENGE, request,
                           sizeof(request)) != 0 ||
                read_frame(l1_uart_fd, &type, l1_response,
                           sizeof(l1_response), &signature_len,
                           L1_OPERATION_TIMEOUT_MS) != 0) {
                fprintf(stderr, "Could not obtain cached L1 %u signature\n",
                        index);
                return 0x53430002U;
            }
            if (type == FRAME_ERROR && signature_len == 4U) {
                uint32_t status = get_u32_be(l1_response);
                fprintf(stderr, "Cached L1 %u rejected: 0x%08x\n", index,
                        status);
                return status != 0U ? status : 0x53430003U;
            }
            if (type != FRAME_L1_SIGNATURE ||
                signature_len != BLS_SCALE_L1_RESPONSE_BYTES ||
                get_u32_be(l1_response) != index ||
                (l1_response[20U] & 0xc0U) != 0x80U) {
                fprintf(stderr, "Invalid cached L1 %u signature response\n",
                        index);
                return 0x53430004U;
            }
            memcpy(cache->signatures[child], l1_response + 20U,
                   BLS_SIGNATURE_BYTES);
            memcpy(cache->timings[child], l1_response + 4U, 16U);
        }
        memcpy(cache->challenge, challenge, BLS_CHALLENGE_BYTES);
        cache->valid = 1;
        cache_filled = 1;
    }
    printf("Aggregating BLS group %u with cached L1 signatures\n", group);
    for (uint32_t child = 0U; child < BLS_SCALE_GROUP_CHILDREN; ++child) {
        memcpy(l2_request + 40U + child * BLS_SIGNATURE_BYTES,
               cache->signatures[child], BLS_SIGNATURE_BYTES);
        if (cache_filled)
            memcpy(response + 108U + child * 16U,
                   cache->timings[child], 16U);
        else
            memset(response + 108U + child * 16U, 0, 16U);
    }
    if (aggregate_scale_l1_at_l2(l2_request) != 0) {
        fprintf(stderr, "Could not generate virtual L2 group %u aggregate\n", group);
        return 0x53430005U;
    }
    if (get_u32_be(l2_request) != group) {
        fprintf(stderr,
                "Invalid virtual L2 group response: got %u, expected %u\n",
                get_u32_be(l2_request), group);
        return 0x53430005U;
    }
    if ((l2_request[28U] & 0xc0U) != 0x80U) {
        fprintf(stderr,
                "Virtual L2 group %u returned a non-canonical signature\n",
                group);
        return 0x53430005U;
    }
    memcpy(response + 12U, l2_request + 28U, BLS_SIGNATURE_BYTES);
    memcpy(response + 268U, l2_request + 4U, 24U);
    printf("Generated L2 group %u aggregate (10 L1 + 1 L2)\n", group);
    return 0U;
}

static int build_l3_key_list_response(int l1_uart_fd, uint8_t *response,
                                      size_t capacity, size_t *response_len)
{
    uint8_t l2_registration[BLS_REGISTRATION_BYTES];
    uint8_t l1_registration[BLS_REGISTRATION_BYTES];
    uint8_t l2_certificate[FRAME_MAX_PAYLOAD];
    uint8_t l1_certificate[FRAME_MAX_PAYLOAD];
    size_t l2_registration_len;
    size_t l2_certificate_len;
    size_t l1_certificate_len;
    size_t parsed_len;
    size_t offset = 0U;
    size_t total_len;
    const char *l1_certificate_path = getenv("CLUSTER_BLS_L1_CERT_OUT");

    if (response == NULL || response_len == NULL ||
        capacity < L3_KEY_LIST_RESPONSE_HEADER_BYTES)
        return -1;
    if (l1_certificate_path == NULL)
        l1_certificate_path = "device_cert.der";
    if (read_l2_blob(CALIP_BLS_GET_L2_REGISTRATION_IOCTL_GEN,
                     l2_registration, sizeof(l2_registration),
                     &l2_registration_len) != 0 ||
        l2_registration_len != sizeof(l2_registration) ||
        request_l1_registration(l1_uart_fd, l1_registration) != 0 ||
        read_l2_blob(CALIP_GET_2ND_CTX_IOCTL_GEN, l2_certificate,
                     sizeof(l2_certificate), &l2_certificate_len) != 0 ||
        read_binary_file(l1_certificate_path, l1_certificate,
                         sizeof(l1_certificate), &l1_certificate_len) != 0 ||
        der_total_length(l2_certificate, l2_certificate_len, &parsed_len) != 0 ||
        parsed_len != l2_certificate_len ||
        der_total_length(l1_certificate, l1_certificate_len, &parsed_len) != 0 ||
        parsed_len != l1_certificate_len) {
        fprintf(stderr, "Could not collect the L2/L1 key-list material\n");
        return -1;
    }
    total_len = L3_KEY_LIST_RESPONSE_HEADER_BYTES +
                l2_certificate_len + l1_certificate_len;
    if (total_len > capacity || total_len > UINT32_MAX)
        return -1;
    memcpy(response + offset, k_l3_key_list_response_magic, 4U);
    offset += 4U;
    put_u32_be(response + offset, (uint32_t)total_len);
    offset += 4U;
    response[offset++] = 1U;
    memcpy(response + offset, l2_registration, sizeof(l2_registration));
    offset += sizeof(l2_registration);
    memcpy(response + offset, l1_registration, sizeof(l1_registration));
    offset += sizeof(l1_registration);
    put_u32_be(response + offset, (uint32_t)l2_certificate_len);
    offset += 4U;
    put_u32_be(response + offset, (uint32_t)l1_certificate_len);
    offset += 4U;
    memcpy(response + offset, l2_certificate, l2_certificate_len);
    offset += l2_certificate_len;
    memcpy(response + offset, l1_certificate, l1_certificate_len);
    offset += l1_certificate_len;
    if (offset != total_len)
        return -1;
    *response_len = total_len;
    return 0;
}

static int receive_l3_request_magic(int fd, enum l3_request_type *request)
{
    uint8_t window[4] = {0};
    size_t used = 0U;

    if (request == NULL)
        return -1;
    for (;;) {
        uint8_t byte;
        if (read_byte(fd, &byte, -1) != 0)
            return -1;
        if (used < sizeof(window))
            window[used++] = byte;
        else {
            memmove(window, window + 1U, sizeof(window) - 1U);
            window[sizeof(window) - 1U] = byte;
        }
        if (used != sizeof(window))
            continue;
        if (memcmp(window, k_l3_request_magic, sizeof(window)) == 0) {
            *request = L3_REQUEST_CHALLENGE;
            return 0;
        }
        if (memcmp(window, k_l3_scale_request_magic,
                   sizeof(window)) == 0) {
            *request = L3_REQUEST_SCALE_CHALLENGE;
            return 0;
        }
        if (memcmp(window, k_l3_key_list_request_magic,
                   sizeof(window)) == 0) {
            *request = L3_REQUEST_KEY_LIST;
            return 0;
        }
        if (memcmp(window, k_l3_ecdsa_request_magic,
                   sizeof(window)) == 0) {
            *request = L3_REQUEST_ECDSA_SCALE;
            return 0;
        }
        if (memcmp(window, k_l3_ecdsa_verify_magic,
                   sizeof(window)) == 0) {
            *request = L3_REQUEST_ECDSA_CERT_VERIFY;
            return 0;
        }
        if (memcmp(window, k_l3_ecdsa_verify_ack_magic,
                   sizeof(window)) == 0) {
            *request = L3_REQUEST_ECDSA_CERT_VERIFY_ACK;
            return 0;
        }
    }
}

static int serve_l3(int l1_uart_fd, int l3_uart_fd)
{
    uint8_t challenge[BLS_CHALLENGE_BYTES];
    uint8_t response[L3_BLS_RESPONSE_BYTES];
    uint8_t key_list_response[L3_KEY_LIST_RESPONSE_MAX_BYTES];
    size_t key_list_response_len;

    printf("Attestation smoketest is serving L3 attestation requests\n");
    if (g_ecdsa_verify_response_pending) {
        printf("Resending cached L2 ECDSA verification result\n");
        if (write_crc_packet(l3_uart_fd, g_ecdsa_verify_response,
                             sizeof(g_ecdsa_verify_response)) != 0)
            return -1;
    }
    for (;;) {
        enum l3_request_type request;
        if (receive_l3_request_magic(l3_uart_fd, &request) != 0)
            return -1;
        if (g_ecdsa_verify_response_pending &&
            request != L3_REQUEST_ECDSA_CERT_VERIFY_ACK) {
            g_ecdsa_verify_response_pending = 0;
        }
        if (request == L3_REQUEST_CHALLENGE) {
            if (read_exact(l3_uart_fd, challenge, sizeof(challenge),
                           FRAME_TIMEOUT_MS) != 0)
                return -1;
            memcpy(response, k_l3_response_magic,
                   sizeof(k_l3_response_magic));
            if (collect_l1_l2_aggregate(
                    l1_uart_fd, challenge,
                    response + sizeof(k_l3_response_magic)) != 0 ||
                write_all(l3_uart_fd, response, sizeof(response)) != 0)
                return -1;
            continue;
        }
        if (request == L3_REQUEST_SCALE_CHALLENGE) {
            uint8_t group_bytes[4];
            uint8_t scale_response[BLS_SCALE_L3_RESPONSE_BYTES] = {0};
            uint32_t group;
            uint32_t result;
            if (read_exact(l3_uart_fd, group_bytes, sizeof(group_bytes),
                           FRAME_TIMEOUT_MS) != 0 ||
                read_exact(l3_uart_fd, challenge, sizeof(challenge),
                           FRAME_TIMEOUT_MS) != 0)
                return -1;
            group = get_u32_be(group_bytes);
            if (group != 0U && group <= BLS_SCALE_MAX_GROUPS &&
                (!g_scale_session_cache.valid ||
                 memcmp(g_scale_session_cache.challenge, challenge,
                        BLS_CHALLENGE_BYTES) != 0)) {
                memset(g_scale_session_cache.group_valid, 0,
                       sizeof(g_scale_session_cache.group_valid));
                memcpy(g_scale_session_cache.challenge, challenge,
                       BLS_CHALLENGE_BYTES);
                g_scale_session_cache.valid = 1;
            }
            if (group == 0U || group > BLS_SCALE_MAX_GROUPS) {
                result = 0x53430001U;
            } else if (g_scale_session_cache.valid &&
                       memcmp(g_scale_session_cache.challenge, challenge,
                              BLS_CHALLENGE_BYTES) == 0 &&
                       g_scale_session_cache.group_valid[group - 1U]) {
                memcpy(scale_response,
                       g_scale_session_cache.group_response[group - 1U],
                       sizeof(scale_response));
                printf("Resending cached BLS group %u response\n", group);
                if (write_all(l3_uart_fd, scale_response,
                              sizeof(scale_response)) != 0)
                    return -1;
                continue;
            } else {
                result = 0U;
            }
            memcpy(scale_response, "BLR2", 4U);
            memcpy(scale_response + 8U, group_bytes, 4U);
            if (result == 0U) {
                result = collect_scale_l1_l2_aggregate(
                    l1_uart_fd, group, challenge, scale_response,
                    &g_scale_l1_cache);
            }
            put_u32_be(scale_response + 4U, result);
            put_u32_be(scale_response + 292U,
                crc32_update(0xffffffffU, scale_response, 292U) ^ 0xffffffffU);
            if (result == 0U) {
                memcpy(g_scale_session_cache.group_response[group - 1U],
                       scale_response, sizeof(scale_response));
                g_scale_session_cache.group_valid[group - 1U] = 1U;
            }
            if (write_all(l3_uart_fd, scale_response, sizeof(scale_response)) != 0)
                return -1;
            continue;
        }
        if (request == L3_REQUEST_KEY_LIST) {
            if (build_l3_key_list_response(
                    l1_uart_fd, key_list_response,
                    sizeof(key_list_response), &key_list_response_len) != 0 ||
                write_all(l3_uart_fd, key_list_response,
                          key_list_response_len) != 0)
                return -1;
            printf("Returned current L2/L1 key-list material to L3 (%zu bytes)\n",
                   key_list_response_len);
            continue;
        }
        if (request == L3_REQUEST_ECDSA_SCALE) {
            uint8_t ecdsa_request[ECDSA_SCALE_REQUEST_BYTES];
            uint8_t ecdsa_response[ECDSA_SCALE_RESPONSE_BYTES] = {0};
            uint8_t crc_bytes[4];
            uint32_t received_crc;
            uint32_t calculated_crc;
            int result;

            memcpy(ecdsa_request, k_l3_ecdsa_request_magic, 4U);
            if (read_exact(l3_uart_fd, ecdsa_request + 4U,
                           sizeof(ecdsa_request) - 4U,
                           FRAME_TIMEOUT_MS) != 0 ||
                read_exact(l3_uart_fd, crc_bytes, sizeof(crc_bytes),
                           FRAME_TIMEOUT_MS) != 0)
                return -1;
            received_crc = get_u32_be(crc_bytes);
            calculated_crc = crc32_update(0xffffffffU, ecdsa_request,
                                           sizeof(ecdsa_request)) ^
                             0xffffffffU;
            result = received_crc == calculated_crc
                         ? collect_ecdsa_scale_signature(
                               l1_uart_fd, ecdsa_request, ecdsa_response)
                         : -1;
            if (result != 0) {
                memset(ecdsa_response, 0, sizeof(ecdsa_response));
                memcpy(ecdsa_response, "ECE1", 4U);
                memcpy(ecdsa_response + 4U, ecdsa_request + 4U, 8U);
            }
            if (write_crc_packet(l3_uart_fd, ecdsa_response,
                                 sizeof(ecdsa_response)) != 0)
                return -1;
            continue;
        }
        if (request == L3_REQUEST_ECDSA_CERT_VERIFY) {
            uint8_t request_packet[8];
            uint8_t response_packet[ECDSA_CERT_VERIFY_RESPONSE_BYTES] = {0};
            uint8_t crc_bytes[4];
            uint32_t chains;
            uint32_t received_crc;
            uint32_t calculated_crc;

            memcpy(request_packet, k_l3_ecdsa_verify_magic, 4U);
            if (read_exact(l3_uart_fd, request_packet + 4U, 4U,
                           FRAME_TIMEOUT_MS) != 0 ||
                read_exact(l3_uart_fd, crc_bytes, sizeof(crc_bytes),
                           FRAME_TIMEOUT_MS) != 0)
                return -1;
            received_crc = get_u32_be(crc_bytes);
            calculated_crc = crc32_update(0xffffffffU, request_packet,
                                           sizeof(request_packet)) ^
                             0xffffffffU;
            chains = get_u32_be(request_packet + 4U);
            printf("Received ECDSA verification request from L3: %u chains\n",
                   chains);
            fflush(stdout);
            if (received_crc != calculated_crc ||
                request_l2_ecdsa_certificate_verification(
                    chains, response_packet) != 0) {
                memcpy(response_packet, "EVR2", 4U);
                put_u32_be(response_packet + 4U, 0xffffffffU);
                put_u32_be(response_packet + 8U, chains);
            }
            memcpy(g_ecdsa_verify_response, response_packet,
                   sizeof(g_ecdsa_verify_response));
            g_ecdsa_verify_chains = chains;
            g_ecdsa_verify_response_pending = 1;
            if (write_crc_packet(l3_uart_fd, response_packet,
                                 sizeof(response_packet)) != 0)
                return -1;
            printf("[ECDSA 2/3] L2 result sent to L3; waiting for L3 acknowledgement...\n");
            fflush(stdout);
            continue;
        }
        if (request == L3_REQUEST_ECDSA_CERT_VERIFY_ACK) {
            uint8_t ack_packet[8];
            uint8_t crc_bytes[4];
            uint32_t received_crc;
            uint32_t calculated_crc;
            uint32_t chains;

            memcpy(ack_packet, k_l3_ecdsa_verify_ack_magic, 4U);
            if (read_exact(l3_uart_fd, ack_packet + 4U, 4U,
                           FRAME_TIMEOUT_MS) != 0 ||
                read_exact(l3_uart_fd, crc_bytes, sizeof(crc_bytes),
                           FRAME_TIMEOUT_MS) != 0)
                return -1;
            received_crc = get_u32_be(crc_bytes);
            calculated_crc = crc32_update(0xffffffffU, ack_packet,
                                           sizeof(ack_packet)) ^
                             0xffffffffU;
            chains = get_u32_be(ack_packet + 4U);
            if (received_crc == calculated_crc &&
                g_ecdsa_verify_response_pending &&
                chains == g_ecdsa_verify_chains) {
                g_ecdsa_verify_response_pending = 0;
                printf("[ECDSA 3/3] L3 acknowledged the L2 ECDSA verification result\n");
                fflush(stdout);
            }
            continue;
        }
    }
}

int cluster_bls_relay_run(const char *l1_uart_path, int l3_uart_fd)
{
    int l1_uart_fd;
    int result;

    if (l3_uart_fd < 0)
        return -1;
    l1_uart_fd = open_uart(l1_uart_path);
    if (l1_uart_fd < 0) {
        close(l3_uart_fd);
        return -1;
    }
    if (activate_l1_proxy(l1_uart_fd) != 0) {
        close(l1_uart_fd);
        close(l3_uart_fd);
        return -1;
    }
    result = serve_l3(l1_uart_fd, l3_uart_fd);
    close(l3_uart_fd);
    close(l1_uart_fd);
    return result;
}
