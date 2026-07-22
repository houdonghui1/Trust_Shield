#include <fcntl.h>
#include <termios.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <openssl/evp.h>
#include <openssl/x509.h>
#include <openssl/x509v3.h>
#include <openssl/ec.h>
#include <openssl/pem.h>
#include <openssl/rand.h>

#define UART_DEV            "/dev/ttyCH343_PORT1"
#define DEVICE_PATH 	    "/dev/caliptra_dev"
#define TRIGGER_STR         "0x5a"
#define FINISH_STR          "0x6a"
#define CERT_CMD_STR        "0x7a"
#define RECV_CERT_STR	    "0x8a"
#define ROM_PACKET_SIZE     32U
#define BUFFER_SIZE         4096
#define ACK_BYTE            0x06
#define ACK_TIMEOUT_MS      1000
#define MAX_RETRY_PER_BLOCK 3

#define CALIP_IOCTL_MAGIC 'C'
#define CALIP_GENERATE_2ND_CXT_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 4, int)
#define CALIP_SAVE_2ND_CTX_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 5, int)

struct ioctl_data {
    unsigned int size;
    unsigned char *buf;
};

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

static int caliptra_save_cert(unsigned char *buf, unsigned int *len)
{
    if (!buf || !len || *len == 0 || *len > 4096) {
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

int handle_tbs_and_cert(int fd, char *recv_buf, int *idx) {
    unsigned char tbs_der[BUFFER_SIZE] = {0};
    int tbs_len = sizeof(tbs_der);
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
    for (int i = 0; i < tbs_len; i++) {
        printf("%02x", tbs_der[i]);
    }
    printf("\nSending TBS to device...\n");

    printf("===================================\n");
    printf("Waiting for 0x7a command...\n");
    printf("===================================\n");

    tcflush(fd, TCIFLUSH);

    while (1) {
        ssize_t ret = read(fd, &c, 1);
        if (ret <= 0) {
            continue;
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
    unsigned char ack_byte = 0;

    while (offset < tbs_len) {
        size_t send_len = tbs_len - offset;
        if (send_len > ROM_PACKET_SIZE) {
            send_len = ROM_PACKET_SIZE;
        }

        ssize_t written = write(fd, tbs_der + offset, send_len);
        if (written < 0) {
            perror("Failed to send TBS block");
            return -1;
        }
        offset += written;

        while (1) {
            ssize_t ack_read = read(fd, &ack_byte, 1);
            if (ack_read <= 0) {
                perror("Failed to receive ACK");
                return -1;
            }
            if (ack_byte == 0x06) {
                break;
            }
        }

        if (offset % 100 == 0) {
            printf("Sent TBS: %zu / %d bytes\n", offset, tbs_len);
        }
    }

    printf("TBS transmission complete! Total sent: %d bytes\n", tbs_len);
    
    printf("===================================\n");
    printf("Waiting for 0x8a command...\n");
    printf("===================================\n");

    char cmd_buf[5] = {0};
    int cmd_idx = 0;
    *idx = 0;

    while (1) {
        read(fd, &c, 1);
        printf("Waiting cmd signal: %c (0x%02X)\n", c, c);

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

    printf("Receiving certificate...\n");

    while (rx_len < 1024 && retry < 10) {
        fd_set readfds;
        struct timeval timeout;

        FD_ZERO(&readfds);
        FD_SET(fd, &readfds);

        timeout.tv_sec = 0;
        timeout.tv_usec = 500000;

        int ret = select(fd + 1, &readfds, NULL, NULL, &timeout);
        if (ret > 0) {
            read(fd, &rx_char, 1);
            cert_der[rx_len++] = rx_char;
            retry = 0;
            printf("Received %d bytes\n", rx_len);
        } else if (ret == 0) {
            retry++;
            printf("Timeout %d/20, waiting for next chunk...\n", retry);
        } else {
            perror("select failed");
            break;
        }
    }

    // Save DER format
    FILE *fp_der = fopen("device_2nd_cert.der", "wb");
    if (fp_der) {
        fwrite(cert_der, 1, rx_len, fp_der);
        fclose(fp_der);
        printf("Device certificate saved : device_2nd_cert.der, length: %d bytes\n", rx_len);
    }

    // Convert DER to PEM and save
    const unsigned char *p = (const unsigned char *)cert_der;
    X509 *dev_cert = d2i_X509(NULL, &p, rx_len);
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
        printf("Failed to parse device certificate DER\n");
    }

    result = caliptra_save_cert(cert_der, &rx_len);
    if (result < 0) {
        printf("Failed to save certificate!\n");
        return -1;
    }

    return 0;
}

int main() {
    setbuf(stdout, NULL);
    int fd = open(UART_DEV, O_RDWR | O_NOCTTY);

    struct termios tty;
    tcgetattr(fd, &tty);
    cfsetispeed(&tty, B115200);
    cfsetospeed(&tty, B115200);
    tty.c_iflag = 0;
    tty.c_oflag = 0;
    tty.c_lflag = 0;
    tty.c_cflag = CS8 | CREAD | CLOCAL;
    tty.c_cc[VMIN] = 1;
    tcsetattr(fd, TCSANOW, &tty);

    printf("===================================\n");
    printf("Waiting for the measurement signal\n");
    printf("===================================\n");

    char recv_buf[5] = {0};
    int idx = 0;
    unsigned char c;
    unsigned char ack_byte = 0;
    const int TARGET = 2880;
    while (1) {
        read(fd, &c, 1);
        printf("Received: %c (0x%02X)\n", c, c);

        recv_buf[idx++] = c;
        idx %= 4;

        if (strstr(recv_buf, TRIGGER_STR) != NULL) {
            printf("\nReceived measurement signal\n");

            printf("Read the firmware stored in the SD card\n");
            int rom_fd = open("/home/ubuntu/work/test/caliptra_rom/caliptraROMC.bin", O_RDONLY);
            char buf[ROM_PACKET_SIZE] = {0};
            int len, total = 0;

            printf("Starting Firmware transmission...\n");

	    while (total < TARGET) {
    		int to_read = (TARGET - total) < ROM_PACKET_SIZE ? (TARGET - total) : ROM_PACKET_SIZE;
    		int len = read(rom_fd, buf, to_read);
    
    		if (len <= 0) 
        	    break;
    
    		write(fd, buf, len);
    		total += len;
    
    		if (total % 100 == 0) {
        	    printf("Sent: %d\n", total);
    		}
    
    		read(fd, &ack_byte, 1); 
	    }
            close(rom_fd);

            printf("===================================\n");
            printf("Waiting for measurement results\n");
            printf("===================================\n");

            memset(recv_buf, 0, sizeof(recv_buf));
            idx = 0;

            while (1) {
                read(fd, &c, 1);
                printf("Waiting finish signal: %c (0x%02X)\n", c, c);

		memmove(recv_buf, recv_buf + 1, 3);
		recv_buf[3] = c;

                if (strstr(recv_buf, FINISH_STR) != NULL) {
                    printf("\nReceived measurement results, Measurement success!\n");
                    printf("start load BMC Firmware\n");
                    sleep(3);
                    system("/home/ubuntu/work/test/start.sh");

                    handle_tbs_and_cert(fd, recv_buf, &idx);

                    close(fd);
                    return 0;
                }
            }
        }
    }

    printf("Measurement failed!");
    close(fd);
    return 0;
}

