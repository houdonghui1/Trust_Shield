#define _DEFAULT_SOURCE
#define _POSIX_C_SOURCE 200809L
#include <sys/ioctl.h>
#include <linux/ioctl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <time.h>
#include <stdint.h>
#include <ctype.h>
#include <errno.h>
#include <signal.h>
#include <openssl/evp.h>
#include <openssl/x509.h>
#include <openssl/x509v3.h>
#include <openssl/ec.h>
#include <openssl/pem.h>
#include <openssl/rand.h>


#define UART_DEV       "/dev/ttyCH343_PORT3"
#define BAUD           B115200
#define TARGET_STR     "Soc start"
#define WAIT_TIME      30
#define ROM_EXPECT     "68fe04b85f0ecda5bebbe5ad3c3bf8c22bbed10d3f66ef9735ad6f85c7204e5f8359bf6b243588c889de430ec4e073327255a1b74751a9bdcfe3ab7fbacb2e31"
#define CSR_TARGET     "CSR :"
#define CSR_HEX_LEN    578
#define BUFFER_SIZE    32768

#define DEVICE_PATH "/dev/caliptra_dev"
#define CALIP_IOCTL_MAGIC 'C'
#define CALIP_SIGN_1ST_CTX_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 7, int)

int fd;
char recv_buf[BUFFER_SIZE] = {0};
volatile int running = 1;

static struct timespec start_time;

struct ioctl_data {
    unsigned int size;
    unsigned char *buf;
};

uint64_t get_ms(void) {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (uint64_t)tv.tv_sec * 1000 + tv.tv_usec / 1000;
}

void uart_config(void) {
    struct termios tty;
    tcgetattr(fd, &tty);
    cfsetispeed(&tty, BAUD);
    cfsetospeed(&tty, BAUD);
    tty.c_cflag &= ~(PARENB | CSTOPB | CSIZE | CRTSCTS);
    tty.c_cflag |= CS8 | CREAD | CLOCAL;
    tty.c_iflag &= ~(IXON | IXOFF | IXANY);
    tty.c_lflag = 0;
    tty.c_oflag = 0;
    tty.c_cc[VMIN] = 0;
    tty.c_cc[VTIME] = 5;
    tcflush(fd, TCIFLUSH);
    tcsetattr(fd, TCSANOW, &tty);
}


ssize_t read_uart(void) {
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

void send_cmd(char c) {
    char cmd[2] = {c, '\r'};
    write(fd, cmd, 2);
    tcflush(fd, TCIFLUSH);
    usleep(100000);
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

void bin2hex(const unsigned char *bin, int len, char *hex) {
    for (int i = 0; i < len; i++) sprintf(hex + i*2, "%02x", bin[i]);
}

static int caliptra_sign_1st_cert(unsigned char *buf, unsigned int *len)
{
    if (!buf || !len || *len == 0 || *len > 4096) {
        printf("invalid sign cert input param\n");
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

    if (ioctl(fd, CALIP_SIGN_1ST_CTX_IOCTL_GEN, &req) < 0) {
        perror("sign 1st cert ioctl failed");
        close(fd);
        return -1;
    }

    *len = req.size; 
    printf("req.size = 0x%x, actual return len = 0x%x \n", req.size, *len);
    close(fd);
    return 0;
}

void send_cert_to_uart(unsigned char *cert, int cert_len)
{
    char hex_buf[4096] = {0};
    bin2hex(cert, cert_len, hex_buf);

    uint16_t total_len = cert_len * 2;
    printf("DEBUG: DER length = %d, HEX length = %d\n", cert_len, total_len);

    printf("\n=== HOST SENDING CERT (length: %d bytes) ===\n", cert_len);
    for (int i = 0; i < cert_len; i ++) {
        printf("%02x", cert[i]);
    }
    printf("\n");
    printf("\n=== HOST SENDING CERT HEX (length: %d bytes) ===\n", total_len);
    for (int i = 0; i < total_len; i += 64) {
        printf("%.*s\n", 64, hex_buf + i);
    }

    struct termios old_tty, new_tty;
    tcgetattr(fd, &old_tty);
    new_tty = old_tty;
    new_tty.c_cc[VMIN] = 1;
    new_tty.c_cc[VTIME] = 0;
    tcsetattr(fd, TCSANOW, &new_tty);

    tcflush(fd, TCIOFLUSH);
    usleep(200000);

    const uint8_t sync[2] = {0xAA, 0x55};
    write(fd, sync, 2);
    tcdrain(fd);
    usleep(100000);
    printf("DEBUG: Sent sync header\n");

    uint8_t len_buf[2] = { (total_len >> 8) & 0xFF, total_len & 0xFF };
    write(fd, len_buf, 2);
    tcdrain(fd);
    usleep(100000);
    printf("DEBUG: Sent length: 0x%02X 0x%02X (%d bytes)\n", len_buf[0], len_buf[1], total_len);

    int pos = 0;
    while (pos < total_len)
    {
        char c = hex_buf[pos];
        write(fd, &c, 1);
        tcdrain(fd);
        usleep(2000);

        pos++;

        if (pos == 640)
        {
            usleep(1000000);
            printf("DEBUG: Reached 640 bytes, waiting 1 second...\n");
        }
    }

    printf("DEBUG: All %d bytes sent successfully\n", total_len);
    tcsetattr(fd, TCSANOW, &old_tty);
}

int main(void) {
    char *result;
    time_t wait_time = time(NULL);
    char pure_hex[CSR_HEX_LEN + 1] = {0};
    unsigned char der_buf[BUFFER_SIZE] = {0};
    int hex_count = 0, der_len = 0, ret = 0;
    unsigned char cert_buf[4096];
    unsigned int buf_len = sizeof(cert_buf);

    fd = open(UART_DEV, O_RDWR | O_NOCTTY);
    if (fd < 0) {
        perror("open failed");
        return -1;
    }
    uart_config();
    printf("serial init ok\n\n");

    memset(recv_buf, 0, sizeof(recv_buf));
    send_cmd('1');

    printf("\nwait rom data...\n");

    while (running && (time(NULL) - wait_time) < 5) {
        result = strstr(recv_buf, ROM_EXPECT);
        if (result != NULL) {
            break;
        }
        read_uart();
    }

    if (result == NULL) {
        printf("\n1st ROM measure failed!\n");
        printf("\nterminate startup!\n");
        close(fd);
        return -1;
    }

    printf("\nmeasure success!\n");
    send_cmd('2');

    printf("\nwait receive CSR...\n");

    memset(recv_buf, 0, sizeof(recv_buf));
    tcflush(fd, TCIFLUSH);

    while(1){
        read_uart();
        if(strstr(recv_buf, CSR_TARGET)) break;
        usleep(10000);
    }

    char *csr_ptr = strstr(recv_buf, CSR_TARGET) + strlen(CSR_TARGET);

    uint64_t start_time = get_ms();
    while(hex_count < CSR_HEX_LEN && (get_ms() - start_time < 5000)) {
        while(*csr_ptr && hex_count < CSR_HEX_LEN) {
            if(isxdigit((unsigned char)*csr_ptr)) {
                pure_hex[hex_count++] = *csr_ptr;
            }
            csr_ptr++;
        }

        if(hex_count < CSR_HEX_LEN) {
            read_uart();
            csr_ptr = recv_buf + strlen(recv_buf) - (csr_ptr - recv_buf);
        }
    }
    pure_hex[hex_count] = 0;

    printf("Collected CSR hex length: %d (expected: %d)\n", hex_count, CSR_HEX_LEN);

    if(hex_count != CSR_HEX_LEN) {
        printf("Incomplete CSR data\n");
        send_cmd('3');
        close(fd);
        return -1;
    }

    der_len = hex2bin(pure_hex, der_buf, BUFFER_SIZE);
    printf("DER data length: %d bytes\n", der_len);
    
    memcpy(cert_buf, der_buf, der_len);
    buf_len = der_len;

    printf("User tx head: %02x %02x %02x %02x, len=0x%x\n", cert_buf[0], cert_buf[1], cert_buf[2], cert_buf[3], buf_len);
    ret = caliptra_sign_1st_cert(cert_buf, &buf_len);
    if (ret != 0) {
        printf("sign 1st cert failed\n");
        return -1;
    }

    FILE *fp_der = fopen("device_cert.der", "wb");
    if (fp_der) {
	fwrite(cert_buf, 1, buf_len, fp_der);
        fclose(fp_der);
    }

    const unsigned char *p = (const unsigned char *)cert_buf;
    X509 *dev_cert = d2i_X509(NULL, &p, buf_len);
    if (dev_cert) {
        FILE *fp_pem = fopen("device_cert.pem", "w");
        if (fp_pem) {
            PEM_write_X509(fp_pem, dev_cert);
            fclose(fp_pem);
            printf("Device certificate saved : device_cert.pem\n");
        } else {
            printf("Failed to save device certificate PEM\n");
        }
        X509_free(dev_cert);
    } else {
        printf("Failed to parse device certificate DER\n");
    }

    memset(recv_buf, 0, sizeof(recv_buf));
    send_cmd('4');
    printf("Sent command 4, waiting for device READY...\n");
    
    uint64_t start = get_ms();
    while (!strstr(recv_buf, "READY") && (get_ms() - start < 5000) && running) {
        read_uart();
        usleep(1000);
    }
    
    if (!strstr(recv_buf, "READY")) {
        printf("ERROR: Device did not send READY signal within 5 seconds\n");
        send_cmd('3');
        close(fd);
        return -1;
    }
    
    printf("Device is ready, starting certificate transmission\n");
    
    memset(recv_buf, 0, sizeof(recv_buf));
    tcflush(fd, TCIFLUSH);
    
    send_cert_to_uart(cert_buf, buf_len);

    printf("\ntask all done\n");
    printf("\nWaiting for device response...\n");

    for (int i = 0; i < 1000; i++) {
        read_uart();
        usleep(10000); 
    }

    printf("\nDevice response received, program exit!\n");
    close(fd);
    return 0;
}

