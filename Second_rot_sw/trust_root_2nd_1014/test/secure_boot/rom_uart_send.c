#include <fcntl.h>
#include <errno.h>
#include <termios.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/select.h>
#include <sys/stat.h>
#include <openssl/x509.h>
#include <openssl/pem.h>

#define UART_DEV            "/dev/ttyCH343_PORT1"
#define DEVICE_PATH 	    "/dev/caliptra_dev"
#define TRIGGER_STR         "0x5a"
#define FINISH_STR          "0x6a"
#define CERT_CMD_STR        "0x7a"
#define RECV_CERT_STR	    "0x8a"
#define ROM_PACKET_SIZE     32U
#define BUFFER_SIZE         4608
#define TBS_BUFFER_SIZE     4096
#define ACK_BYTE            0x06
#define FAILURE_BYTE        0xba
#define ACK_TIMEOUT_MS      3000
#define L3_COMPRESSED_PUBLIC_KEY_BYTES 49
#define L2_INSTALL_HEADER_BYTES (4 + L3_COMPRESSED_PUBLIC_KEY_BYTES)

#define CALIP_IOCTL_MAGIC 'C'
#define CALIP_GENERATE_2ND_CXT_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 4, int)
#define CALIP_SAVE_2ND_CTX_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 5, int)
#define CALIP_BLS_GET_L2_REGISTRATION_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 11, int)

#define BLS_REGISTRATION_BYTES 162U
#define CBR1_HEADER_BYTES 7U

struct ioctl_data {
    unsigned int size;
    unsigned char *buf;
};

static const unsigned char k_l2_install_magic[4] = {'L', '2', 'C', '1'};

static int write_all(int fd, const unsigned char *data, size_t length)
{
    size_t offset = 0;

    while (offset < length) {
        ssize_t written = write(fd, data + offset, length - offset);
        if (written < 0) {
            if (errno == EINTR)
                continue;
            return -1;
        }
        if (written == 0)
            return -1;
        offset += (size_t)written;
    }
    return tcdrain(fd);
}

/* Wait for the exact one-byte response emitted by L3.  The old code accepted
 * any byte as an ACK, allowing stale/noise bytes to advance the sender and
 * overrun L3's 32-byte UART FIFO. */
static int wait_for_rom_ack(int fd)
{
    for (;;) {
        fd_set readfds;
        struct timeval timeout;
        unsigned char response;
        int ready;

        FD_ZERO(&readfds);
        FD_SET(fd, &readfds);
        timeout.tv_sec = ACK_TIMEOUT_MS / 1000;
        timeout.tv_usec = (ACK_TIMEOUT_MS % 1000) * 1000;
        ready = select(fd + 1, &readfds, NULL, NULL, &timeout);
        if (ready < 0) {
            if (errno == EINTR)
                continue;
            return -1;
        }
        if (ready == 0)
            return -1;
        if (read(fd, &response, 1) != 1)
            return -1;
        if (response == ACK_BYTE)
            return 0;
        if (response == FAILURE_BYTE)
            return -2;
        fprintf(stderr, "Ignoring non-ACK byte: 0x%02x\n", response);
    }
}

static int read_uart_byte(int fd, unsigned char *value)
{
    for (;;) {
        ssize_t ret = read(fd, value, 1);
        if (ret == 1)
            return 0;
        if (ret == 0 ||
            (ret < 0 && (errno == EINTR || errno == EAGAIN ||
                         errno == EWOULDBLOCK || errno == EIO))) {
            if (ret != -1 || errno != EINTR)
                usleep(10000);
            continue;
        }
        return -1;
    }
}

static int caliptra_get_tbs(unsigned char *buf, unsigned int *len)
{
    int fd = open(DEVICE_PATH, O_RDWR);
    if (fd < 0) {
        perror("open caliptra dev failed");
        return -1;
    }

    struct ioctl_data req = {
        .size = *len,
        .buf  = buf
    };

    if (ioctl(fd, CALIP_GENERATE_2ND_CXT_IOCTL_GEN, &req) < 0) {
        perror("get tbs ioctl failed");
        close(fd);
        return -1;
    }

    *len = req.size;
    printf("req.size = 0x%x, actual len = 0x%x \n", req.size, *len);
    close(fd);
    return 0;
}

static int caliptra_get_l2_bls_registration(unsigned char *buf,
                                             unsigned int *len)
{
    int fd;
    struct ioctl_data req;

    if (!buf || !len || *len != BLS_REGISTRATION_BYTES)
        return -1;
    fd = open(DEVICE_PATH, O_RDWR);
    if (fd < 0) {
        perror("open caliptra dev failed");
        return -1;
    }
    req.size = *len;
    req.buf = buf;
    if (ioctl(fd, CALIP_BLS_GET_L2_REGISTRATION_IOCTL_GEN, &req) < 0) {
        perror("get L2 BLS registration ioctl failed");
        close(fd);
        return -1;
    }
    close(fd);
    if (req.size != BLS_REGISTRATION_BYTES)
        return -1;
    *len = req.size;
    return 0;
}

static int caliptra_save_cert(unsigned char *buf, unsigned int *len)
{
    if (!buf || !len || *len == 0 || *len > BUFFER_SIZE) {
        printf("invalid save cert input param\n");
        return -1;
    }

    int fd = open(DEVICE_PATH, O_RDWR);
    if (fd < 0) {
        perror("open caliptra dev failed");
        return -1;
    }

    struct ioctl_data req = {
        .size = *len,
        .buf  = buf
    };

    if (ioctl(fd, CALIP_SAVE_2ND_CTX_IOCTL_GEN, &req) < 0) {
        perror("save 2nd cert ioctl failed");
        close(fd);
        return -1;
    }

    *len = req.size;
    printf("req.size = 0x%x, actual return len = 0x%x \n", req.size, *len);
    close(fd);
    return 0;
}

static int der_expected_length(const unsigned char *der, size_t available,
                               size_t *total_len)
{
    size_t header_len;
    size_t content_len;

    if (!der || !total_len || available < 2 || der[0] != 0x30)
        return 0;
    if ((der[1] & 0x80) == 0) {
        header_len = 2;
        content_len = der[1];
    } else if (der[1] == 0x81) {
        if (available < 3)
            return 0;
        header_len = 3;
        content_len = der[2];
    } else if (der[1] == 0x82) {
        if (available < 4)
            return 0;
        header_len = 4;
        content_len = ((size_t)der[2] << 8) | der[3];
    } else {
        return -1;
    }
    if (header_len + content_len > 4096)
        return -1;
    *total_len = header_len + content_len;
    return 1;
}

int handle_tbs_and_cert(int fd, int *idx) {
    unsigned char tbs_der[TBS_BUFFER_SIZE] = {0};
    unsigned char cbr1[BUFFER_SIZE] = {0};
    unsigned char bls_registration[BLS_REGISTRATION_BYTES] = {0};
    unsigned int tbs_len = sizeof(tbs_der);
    unsigned int bls_registration_len = sizeof(bls_registration);
    size_t cbr1_len;
    unsigned char c;
    int match_state = 0;
    const char *cmd = CERT_CMD_STR;
    int cmd_len = strlen(cmd);

    printf("===================================\n");
    printf("Generating TBS Certificate\n");
    printf("===================================\n");

    int result = caliptra_get_tbs(tbs_der, &tbs_len);
    if (result < 0) {
        printf("Failed to generate TBS certificate!\n");
        return -1;
    }

    printf("tbs_len = 0x%x \n", tbs_len);
    printf("TBS hex:\n");
    for (unsigned int i = 0; i < tbs_len; i++) {
        printf("%02x", tbs_der[i]);
    }
    printf("\n");

    /* BLS is an additional step after the original TBS ioctl succeeds. */
    if (caliptra_get_l2_bls_registration(bls_registration,
                                         &bls_registration_len) != 0) {
        printf("Failed to get L2 BLS registration!\n");
        return -1;
    }
    cbr1_len = CBR1_HEADER_BYTES + BLS_REGISTRATION_BYTES + tbs_len;
    if (cbr1_len > sizeof(cbr1) || tbs_len > 0xffffU)
        return -1;
    memcpy(cbr1, "CBR1", 4);
    cbr1[4] = 1;
    cbr1[5] = (unsigned char)(tbs_len >> 8);
    cbr1[6] = (unsigned char)tbs_len;
    memcpy(cbr1 + CBR1_HEADER_BYTES, bls_registration,
           BLS_REGISTRATION_BYTES);
    memcpy(cbr1 + CBR1_HEADER_BYTES + BLS_REGISTRATION_BYTES,
           tbs_der, tbs_len);
    printf("L2 BLS registration collected; sending CBR1 to L3\n");

    printf("===================================\n");
    printf("Waiting for 0x7a command...\n");
    printf("===================================\n");

    while (1) {
        if (read_uart_byte(fd, &c) != 0) {
            perror("Failed to receive 0x7a command");
            return -1;
        }

        if (c == cmd[match_state]) {
            match_state++;
            if (match_state == cmd_len) {
                printf("\nReceived 0x7a command\n");
                break;
            }
        } else {
            match_state = 0;
            if (c == cmd[0]) {
                match_state = 1;
            }
        }
	printf("recv: %c (0x%02x), state: %d\n", c, (unsigned char)c, match_state);
    }

    tcflush(fd, TCIFLUSH);

    size_t offset = 0;

    while (offset < cbr1_len) {
        size_t send_len = cbr1_len - offset;
        if (send_len > ROM_PACKET_SIZE) {
            send_len = ROM_PACKET_SIZE;
        }

        if (write_all(fd, cbr1 + offset, send_len) != 0) {
            perror("Failed to send CBR1 block");
            return -1;
        }
        offset += send_len;

        int ack_status = wait_for_rom_ack(fd);
        if (ack_status != 0) {
            if (ack_status == -2)
                fprintf(stderr, "L3 rejected the CBR1 request\n");
            else
                fprintf(stderr, "CBR1 ACK timeout at %zu/%zu bytes\n",
                        offset, cbr1_len);
            return -1;
        }

        if (offset % 100 == 0) {
        printf("Sent CBR1: %zu / %zu bytes\n", offset, cbr1_len);
        }
    }

    printf("CBR1 transmission complete! Total sent: %zu bytes\n", cbr1_len);
    
    printf("===================================\n");
    printf("Waiting for 0x8a command...\n");
    printf("===================================\n");

    char cmd_buf[5] = {0};
    int cmd_idx = 0;
    *idx = 0;

    while (1) {
        if (read_uart_byte(fd, &c) != 0) {
            perror("Failed to receive 0x8a command");
            return -1;
        }
        printf("Waiting cmd signal: %c (0x%02X)\n", c, c);

        if (c == FAILURE_BYTE) {
            fprintf(stderr,
                    "L3 rejected the authenticated CBR1/BLS binding (0xba)\n");
            return -1;
        }

        if (cmd_idx < 4) {
            cmd_buf[cmd_idx++] = c;
        } else {
            memmove(cmd_buf, cmd_buf + 1, 3);
            cmd_buf[3] = c;
        }

        if (strcmp(cmd_buf, RECV_CERT_STR) == 0) {
            printf("\nReceived 0x8a command\n");
            break;
        }
    }

    char cert_der[BUFFER_SIZE] = {0};
    int rx_len = 0;
    unsigned char rx_char;
    int retry = 0;
    size_t expected_cert_len = 0;
    size_t certificate_der_len = 0;

    printf("Receiving certificate...\n");

    while (rx_len < BUFFER_SIZE && retry < 10 &&
           (expected_cert_len == 0 || (size_t)rx_len < expected_cert_len)) {
        fd_set readfds;
        struct timeval timeout;

        FD_ZERO(&readfds);
        FD_SET(fd, &readfds);

        timeout.tv_sec = 0;
        timeout.tv_usec = 500000;

        int ret = select(fd + 1, &readfds, NULL, NULL, &timeout);
        if (ret > 0) {
            if (read_uart_byte(fd, &rx_char) != 0) {
                perror("Failed to receive certificate byte");
                return -1;
            }
            cert_der[rx_len++] = rx_char;
            retry = 0;
            printf("Received %d bytes\n", rx_len);
            if (rx_len == 4 &&
                memcmp(cert_der, k_l2_install_magic,
                       sizeof(k_l2_install_magic)) != 0) {
                fprintf(stderr, "Invalid L2 certificate installation magic\n");
                return -1;
            }
            if (expected_cert_len == 0 &&
                (size_t)rx_len > L2_INSTALL_HEADER_BYTES) {
                int length_status = der_expected_length(
                    (const unsigned char *)cert_der + L2_INSTALL_HEADER_BYTES,
                    (size_t)rx_len - L2_INSTALL_HEADER_BYTES,
                    &certificate_der_len);
                if (length_status < 0) {
                    fprintf(stderr, "Invalid or oversized certificate DER\n");
                    return -1;
                }
                if (length_status > 0)
                    expected_cert_len = L2_INSTALL_HEADER_BYTES +
                                        certificate_der_len;
            }
        } else if (ret == 0) {
            retry++;
            printf("Timeout %d/20, waiting for next chunk...\n", retry);
        } else {
            perror("select failed");
            break;
        }
    }

    if (expected_cert_len == 0 || certificate_der_len == 0 ||
        (size_t)rx_len != expected_cert_len) {
        fprintf(stderr, "Incomplete certificate: got %d bytes, expected %zu\n",
                rx_len, expected_cert_len);
        return -1;
    }

    // Save DER format
    FILE *fp_der = fopen("device_2nd_cert.der", "wb");
    if (!fp_der) {
        perror("Failed to open device_2nd_cert.der");
        return -1;
    }
    if (fwrite(cert_der + L2_INSTALL_HEADER_BYTES, 1, certificate_der_len,
               fp_der) != certificate_der_len) {
        perror("Failed to save device_2nd_cert.der");
        fclose(fp_der);
        return -1;
    }
    if (fclose(fp_der) != 0) {
        perror("Failed to close device_2nd_cert.der");
        return -1;
    }
    printf("Device certificate saved : device_2nd_cert.der, length: %zu bytes\n",
           certificate_der_len);

    // Convert DER to PEM and save
    const unsigned char *p =
        (const unsigned char *)cert_der + L2_INSTALL_HEADER_BYTES;
    X509 *dev_cert = d2i_X509(NULL, &p, (long)certificate_der_len);
    if (dev_cert) {
        FILE *fp_pem = fopen("device_2nd_cert.pem", "w");
        if (fp_pem) {
            PEM_write_X509(fp_pem, dev_cert);
            fclose(fp_pem);
            printf("Device certificate saved : device_2nd_cert.pem\n");
        } else {
            printf("Failed to save device certificate PEM\n");
        }
        X509_free(dev_cert);
    } else {
        fprintf(stderr, "Failed to parse device certificate DER\n");
        return -1;
    }

    {
        unsigned int install_len = (unsigned int)rx_len;
        result = caliptra_save_cert((unsigned char *)cert_der, &install_len);
    }
    if (result < 0) {
        printf("Failed to verify or save certificate installation package!\n");
        return -1;
    }

    printf("L2 certificate received, verified, and installed successfully\n");
    return 0;
}

int main(void) {
    setbuf(stdout, NULL);
    int fd = open(UART_DEV, O_RDWR | O_NOCTTY);

    if (fd < 0) {
        perror("Failed to open L3 UART");
        return 1;
    }
    if (ioctl(fd, TIOCEXCL) != 0) {
        perror("Failed to lock L3 UART exclusively");
        close(fd);
        return 1;
    }

    struct termios tty;
    if (tcgetattr(fd, &tty) != 0) {
        perror("Failed to read L3 UART settings");
        close(fd);
        return 1;
    }
    cfsetispeed(&tty, B115200);
    cfsetospeed(&tty, B115200);
    tty.c_iflag = 0;
    tty.c_oflag = 0;
    tty.c_lflag = 0;
    tty.c_cflag = CS8 | CREAD | CLOCAL;
    tty.c_cc[VMIN] = 1;
    tty.c_cc[VTIME] = 0;
    if (tcsetattr(fd, TCSANOW, &tty) != 0) {
        perror("Failed to configure L3 UART");
        close(fd);
        return 1;
    }

    printf("===================================\n");
    printf("Waiting for the measurement signal\n");
    printf("ROM transfer protocol: exact-ACK-v2\n");
    printf("===================================\n");

    char recv_buf[5] = {0};
    int idx = 0;
    size_t trigger_match_state = 0U;
    unsigned char c;
    const int TARGET = 2880;
    while (1) {
        if (read_uart_byte(fd, &c) != 0) {
            perror("Failed to receive measurement signal");
            close(fd);
            return 1;
        }
        printf("Received: %c (0x%02X)\n", c, c);

        if (c == (unsigned char)TRIGGER_STR[trigger_match_state]) {
            ++trigger_match_state;
        } else {
            trigger_match_state =
                (c == (unsigned char)TRIGGER_STR[0]) ? 1U : 0U;
        }

        if (trigger_match_state == sizeof(TRIGGER_STR) - 1U) {
            printf("\nReceived measurement signal\n");

            printf("Read the firmware stored in the SD card\n");
            int rom_fd = open("/home/ubuntu/work/test/caliptra_rom/caliptraROMC.bin", O_RDONLY);
            unsigned char buf[ROM_PACKET_SIZE] = {0};
            struct stat rom_stat;
            int total = 0;

            if (rom_fd < 0) {
                perror("Failed to open L2 ROM image");
                close(fd);
                return 1;
            }
            if (fstat(rom_fd, &rom_stat) != 0 || rom_stat.st_size < TARGET) {
                fprintf(stderr,
                        "L2 ROM image is missing or too short: need %d bytes\n",
                        TARGET);
                close(rom_fd);
                close(fd);
                return 1;
            }

            printf("Starting Firmware transmission...\n");
            tcflush(fd, TCIFLUSH);

            while (total < TARGET) {
                int to_read = (TARGET - total) < (int)ROM_PACKET_SIZE
                                  ? (TARGET - total)
                                  : (int)ROM_PACKET_SIZE;
                ssize_t len = read(rom_fd, buf, (size_t)to_read);
                int ack_status;

                if (len < 0 && errno == EINTR)
                    continue;
                if (len <= 0) {
                    fprintf(stderr,
                            "Unexpected end of L2 ROM image at %d/%d bytes\n",
                            total, TARGET);
                    close(rom_fd);
                    close(fd);
                    return 1;
                }
                if (write_all(fd, buf, (size_t)len) != 0) {
                    perror("Failed to send L2 ROM block");
                    close(rom_fd);
                    close(fd);
                    return 1;
                }

                ack_status = wait_for_rom_ack(fd);
                if (ack_status != 0) {
                    if (ack_status == -2)
                        fprintf(stderr, "L3 rejected the ROM transfer\n");
                    else
                        fprintf(stderr,
                                "ACK timeout after %d/%d ROM bytes\n",
                                total, TARGET);
                    close(rom_fd);
                    close(fd);
                    return 1;
                }
                total += (int)len;
                if (total % 256 == 0 || total == TARGET)
                    printf("Sent: %d / %d bytes\n", total, TARGET);
	    }
            close(rom_fd);

            printf("Firmware transmission complete: %d bytes\n", total);

            printf("===================================\n");
            printf("Waiting for measurement results\n");
            printf("===================================\n");

            memset(recv_buf, 0, sizeof(recv_buf));
            idx = 0;

            while (1) {
                if (read_uart_byte(fd, &c) != 0) {
                    perror("Failed to receive measurement result");
                    close(fd);
                    return 1;
                }
                printf("Waiting finish signal: %c (0x%02X)\n", c, c);

		memmove(recv_buf, recv_buf + 1, 3);
		recv_buf[3] = c;

                if (strstr(recv_buf, FINISH_STR) != NULL) {
                    printf("\nReceived measurement results, Measurement success!\n");
                    printf("start load BMC Firmware\n");
                    sleep(3);
                    int start_status = system("/home/ubuntu/work/test/start.sh");
                    if (start_status != 0) {
                        fprintf(stderr, "BMC start script returned %d\n",
                                start_status);
                        close(fd);
                        return 1;
                    }

                    if (handle_tbs_and_cert(fd, &idx) != 0) {
                        fprintf(stderr,
                                "L2 certificate provisioning failed; "
                                "L1 measurement will not be started\n");
                        close(fd);
                        return 1;
                    }

                    close(fd);
                    return 0;
                }
                if (c == FAILURE_BYTE) {
                    fprintf(stderr,
                            "\nL3 reported ROM measurement failure (0xba)\n");
                    close(fd);
                    return 1;
                }
            }
        }
    }

    printf("Measurement failed!");
    close(fd);
    return 1;
}
