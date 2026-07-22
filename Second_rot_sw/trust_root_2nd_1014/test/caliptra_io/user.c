#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>

#define DEVICE_PATH "/dev/caliptra_dev"
#define CALIP_IOCTL_MAGIC 'C'
#define CALIP_TRNG_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 1, int)
#define CALIP_ECC_SIGH_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 2, int)
#define CALIP_ECC_VERIFY_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 3, int)

struct ioctl_data {
    unsigned int size;
    unsigned char *buf;
};

struct ecc_verify_data {
    unsigned int send_size;
    unsigned char *send_buf;
    unsigned int recv_size;
    unsigned char *recv_buf;
};

int main()
{	    
    struct ioctl_data req;
    struct ecc_verify_data ecc_verify_req;
    unsigned char buf[32] = {0x0};
    unsigned char ecc_sign_buf[192] = {0x0};
    unsigned char ecc_verify_buf[1] = {0x0};

    req.size = sizeof(buf);
    req.buf = buf;

    int fd = open(DEVICE_PATH, O_RDWR);
    if (fd < 0) {
        perror("Failed to open device");
        return -1;
    }
    
    if (ioctl(fd, CALIP_TRNG_IOCTL_GEN, &req) < 0) {
        perror("ioctl failed");
        close(fd);
        return -1;
    }

    printf("trng: ");
    for (int i = 0; i < sizeof(buf); i++) {
        printf("%02x ", buf[i]);
    }
    printf("\n");

    req.size = sizeof(ecc_sign_buf);
    req.buf = ecc_sign_buf;

    if (ioctl(fd, CALIP_ECC_SIGH_IOCTL_GEN, &req) < 0) {
        perror("ioctl failed");
        close(fd);
        return -1;
    }
    
    printf("recv: ");
    for (int i = 0; i < 192; i++) {
        printf("%02x", ecc_sign_buf[i]);
    }
    printf("\n");

    ecc_verify_req.send_size = sizeof(ecc_sign_buf);
    ecc_verify_req.send_buf = ecc_sign_buf;
    ecc_verify_req.recv_size = sizeof(ecc_verify_buf);
    ecc_verify_req.recv_buf = ecc_verify_buf;
    
    if (ioctl(fd, CALIP_ECC_VERIFY_IOCTL_GEN, &ecc_verify_req) < 0) {
        perror("ioctl failed");
        close(fd);
        return -1;
    }

    printf("recv: ");
    printf("%x", ecc_verify_buf[0]);

    close(fd);
    return 0;
}
