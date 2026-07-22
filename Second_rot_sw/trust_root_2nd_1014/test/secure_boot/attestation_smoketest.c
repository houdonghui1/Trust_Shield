#include <fcntl.h>
#include <termios.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdint.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <sys/select.h>
#include <openssl/evp.h>
#include <openssl/x509.h>
#include <openssl/x509v3.h>
#include <openssl/ec.h>
#include <openssl/pem.h>
#include <openssl/rand.h>

#define UART_DEV_1          "/dev/ttyCH343_PORT1"
#define UART_DEV_3          "/dev/ttyCH343_PORT3"
#define DEVICE_PATH         "/dev/caliptra_dev"
#define TRIGGER_STR         "0x5a"
#define FINISH_STR          "0x6a"
#define CERT_CMD_STR        "0x9a"
#define VERIFY_CERT_SUCCESS 0xaa
#define VERIFY_CERT_FAILED  0xba
#define BUFFER_SIZE         4096
#define CERT_TARGET         "CA certificate:"
#define CERT_HEX_LEN        1024
#define ROM_PACKET_SIZE     32

#define CALIP_IOCTL_MAGIC 'C'
#define CALIP_GET_2ND_CTX_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 6, int)
#define CALIP_VERIFY_1ST_CTX_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 8, int)

unsigned char cert_buf[BUFFER_SIZE] = {0};
unsigned char der_buf[BUFFER_SIZE] = {0};
char pure_hex[CERT_HEX_LEN + 1] = {0};
int cert_len = sizeof(cert_buf);
char recv_buf[CERT_HEX_LEN] = {0};
int idx = 0;
int hex_count = 0, der_len = 0, ret = 0;

struct ioctl_data {
    unsigned int size;
    unsigned char *buf;
};

static int caliptra_get_cert(unsigned char *buf, unsigned int *len)
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

    if (ioctl(fd, CALIP_GET_2ND_CTX_IOCTL_GEN, &req) < 0) {
        perror("get cert ioctl failed");
        close(fd);
        return -1;
    }

    *len = req.size;
    printf("req.size = 0x%x, actual len = 0x%x \n", req.size, *len);
    close(fd);
    return 0;
}

static int caliptra_verify_cert(unsigned char *buf, unsigned int *len)
{
    if (!buf || !len || *len == 0 || *len > 4096) {
        printf("invalid verify cert input param\n");
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

    if (ioctl(fd, CALIP_VERIFY_1ST_CTX_IOCTL_GEN, &req) < 0) {
        perror("verify 1st cert ioctl failed");
        close(fd);
        return -1;
    }

    *len = req.size;
    printf("req.size = 0x%x, actual return len = 0x%x \n", req.size, *len);
    
    if(req.buf[0] != 0x10) {
    	return -1;
    }
    close(fd);
    return 0;
}

uint64_t get_ms(void) {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (uint64_t)tv.tv_sec * 1000 + tv.tv_usec / 1000;
}

void send_cmd(int fd, char c) {
    char cmd[2] = {c, '\r'};
    write(fd, cmd, 2);
    tcflush(fd, TCIFLUSH);
    usleep(100000);
}

ssize_t read_uart(int fd, char *recv_buf) {
    char tmp[512];
    ssize_t total_len = 0;
    ssize_t len;
    while((len = read(fd, tmp, sizeof(tmp)-1)) > 0){
        tmp[len] = '\0';
        printf("%s", tmp);
        strncat(recv_buf, tmp, sizeof(recv_buf)-strlen(recv_buf)-1);
        total_len += len;
    }
    return total_len;
}

int hex2bin(const char *hex, unsigned char *bin, int max_len) {
    int i = 0, bin_len = 0;
    while(hex[i] && hex[i+1] && bin_len < max_len) {
        if(isxdigit((unsigned char)hex[i]) && isxdigit((unsigned char)hex[i+1])) {
            sscanf(hex+i, "%02hhx", &bin[bin_len++]);
            i += 2;
        } else {
            i++;
        }
    }
    return bin_len;
}

void init_dev_uart(int fd, int num) {

    if(num == 1) {

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
    } else {

	struct termios tty;
        tcgetattr(fd, &tty);
        cfsetispeed(&tty, B115200);
        cfsetospeed(&tty, B115200);
        tty.c_iflag = 0;
        tty.c_oflag = 0;
        tty.c_lflag = 0;
        tty.c_cflag = CS8 | CREAD | CLOCAL;
        tty.c_cc[VMIN] = 0;
        tty.c_cc[VTIME] = 10;
        tcsetattr(fd, TCSANOW, &tty);
    }
}

int verify_1st() {
    int fd = open(UART_DEV_3, O_RDWR | O_NOCTTY);
    init_dev_uart(fd, 3);

    printf("===================================\n");
    printf("Waiting for the verify 1st cert\n");
    printf("===================================\n");

    send_cmd(fd, '2');

    printf("\nwait receive cert...\n");

    memset(recv_buf, 0, sizeof(recv_buf));
    tcflush(fd, TCIFLUSH);

    int found_target = 0;
    uint64_t last_rx_time = get_ms();

    while (1) {
        char ch;
        int n = read(fd, &ch, 1);
        if (n == 1) {
            size_t len = strlen(recv_buf);
            if (len < sizeof(recv_buf) - 1) {
                recv_buf[len] = ch;
                recv_buf[len + 1] = '\0';
            }
            last_rx_time = get_ms();
            if (!found_target && strstr(recv_buf, CERT_TARGET)) {
                found_target = 1;
            }
        } else if (n == 0) {
            if (found_target && (get_ms() - last_rx_time > 500)) {
                break;
            }
        } else {
            break;
        }
    }

    if (!found_target) {
        printf("Error: CERT_TARGET not found\n");
        close(fd);
        return -1;
    }

    char *cert_ptr = strstr(recv_buf, CERT_TARGET) + strlen(CERT_TARGET);

    hex_count = 0;
    while (*cert_ptr && hex_count < CERT_HEX_LEN) {
        if (isxdigit((unsigned char)*cert_ptr)) {
            pure_hex[hex_count++] = *cert_ptr;
        }
        cert_ptr++;
    }
    pure_hex[hex_count] = 0;

    printf("Collected CERT hex length: %d (expected: %d)\n", hex_count, CERT_HEX_LEN);

    der_len = hex2bin(pure_hex, der_buf, BUFFER_SIZE);
    printf("DER data length: %d bytes\n", der_len);

    memcpy(cert_buf, der_buf, der_len);
    cert_len = der_len;

    printf("cert len = 0x%x\n", cert_len);
    for (int i = 0; i < cert_len; i++) {
        printf("%02x", cert_buf[i]);
    }
    printf("\n");

    int ret = caliptra_verify_cert(cert_buf, &cert_len);
    if (ret == 0) {
        printf("\n1st verify success\n");
        close(fd);
        return 0;
    } else {
        printf("\n1st verify failed\n");
        close(fd);
        return -1;
    }
}

int verify_2nd() {
    const int TARGET = 2880;
    unsigned char c;
    unsigned char ack_byte = 0;

    int fd = open(UART_DEV_1, O_RDWR | O_NOCTTY);
    init_dev_uart(fd, 1);

    printf("===================================\n");
    printf("Waiting for the attestation smoketest\n");
    printf("===================================\n");

    while (1) {
        read(fd, &c, 1);
        printf("Received: %c (0x%02X)\n", c, c);

        recv_buf[idx++] = c;
        idx %= 4;

        if (strstr(recv_buf, TRIGGER_STR) != NULL) {
            printf("\nReceived measurement signal\n");

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
            printf("Waiting for 2nd measurement results\n");
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
                    sleep(3);

                    int result = caliptra_get_cert(cert_buf, &cert_len);
                    if (result < 0) {
                        printf("Failed to get 2nd cert!\n");
                        close(fd);
			return -1;
                    }

                    size_t offset = 0;
                    unsigned char ack_byte = 0;

                    while (offset < cert_len) {
                        size_t send_len = cert_len - offset;
                        if (send_len > ROM_PACKET_SIZE) {
                            send_len = ROM_PACKET_SIZE;
                        }

                        ssize_t written = write(fd, cert_buf + offset, send_len);
                        if (written < 0) {
                            perror("Failed to send cert block");
                            close(fd);
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
                            printf("Sent cert: %zu / %d bytes\n", offset, cert_len);
                        }
                    }

                    printf("TBS transmission complete! Total sent: %d bytes\n", cert_len);

                    printf("===================================\n");
                    printf("Waiting for verify 2nd cert\n");
                    printf("===================================\n");

                    char recv_buf[5];
		    int idx = 0;
		    while(idx < 4) {
    			char c;
    			if (read(fd, &c, 1) != 1) break;
    			printf("Received: %c (0x%02X)\n", c, c);
    			recv_buf[idx++] = c;
		    }
		    recv_buf[4] = '\0';

		    if (strcmp(recv_buf, "0x9a") == 0) {
    		    	printf("\n2nd verify success\n");
    		    	close(fd);
    			return 0;
		    } else {
    			printf("\n2nd verify failed\n");
    			close(fd);
    			return -1;
		    }
		}
            }
        }
    }
}

int main() {
    int ret = 0;

    setbuf(stdout, NULL);

    ret = verify_2nd();
    if(ret !=0) {
        return -1;
    }

    sleep(3);

    ret = verify_1st();

    int fd = open(UART_DEV_1, O_RDWR | O_NOCTTY);
    init_dev_uart(fd, 1);

    if(ret != 0) {
        send_cmd(fd, VERIFY_CERT_FAILED);
        return -1;
    }

    send_cmd(fd, VERIFY_CERT_SUCCESS);


    return 0;
}
