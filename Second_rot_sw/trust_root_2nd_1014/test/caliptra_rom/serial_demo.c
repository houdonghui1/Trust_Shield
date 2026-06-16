#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <errno.h>
#include <sys/select.h>

#define DEVICE "/dev/ttyCH341USB0"
#define BAUDRATE B115200
#define TIMEOUT_MS 500

int configure_port(int fd) {
    struct termios tty;
    memset(&tty, 0, sizeof(tty));
    
    if(tcgetattr(fd, &tty) != 0) {
        fprintf(stderr, "Error %d getting port settings: %s\n", errno, strerror(errno));
        return -1;
    }

    cfsetispeed(&tty, BAUDRATE);
    cfsetospeed(&tty, BAUDRATE);

    tty.c_cflag &= ~PARENB;
    tty.c_cflag &= ~CSTOPB;
    tty.c_cflag &= ~CSIZE;
    tty.c_cflag |= CS8;

    tty.c_cflag &= ~CRTSCTS;
    tty.c_iflag &= ~(IXON | IXOFF | IXANY);

    tty.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
    tty.c_oflag &= ~OPOST;

    tty.c_cc[VMIN] = 0;
    tty.c_cc[VTIME] = 1; 

    if(tcsetattr(fd, TCSANOW, &tty) != 0) {
        fprintf(stderr, "Error %d setting port attributes: %s\n", errno, strerror(errno));
        return -1;
    }
    return 0;
}

int serial_write(int fd, const char* data, size_t len) {
    int n = write(fd, data, len);
    if(n < 0) {
        fprintf(stderr, "Write failed: %s\n", strerror(errno));
        return -1;
    }
    tcdrain(fd); 
    return n;
}

int serial_read(int fd, char* buf, size_t buf_size) {
    fd_set fds;
    struct timeval tv;
    int total_bytes = 0;
    int bytes_read;
    
    tv.tv_sec = TIMEOUT_MS / 1000;
    tv.tv_usec = (TIMEOUT_MS % 1000) * 1000;
    
    while(total_bytes < buf_size - 1) {
        FD_ZERO(&fds);
        FD_SET(fd, &fds);
        
        int ret = select(fd+1, &fds, NULL, NULL, &tv);
        if(ret < 0) {
            return -1;
        } else if(ret == 0) {
            break;
        } else {
            bytes_read = read(fd, buf + total_bytes, buf_size - 1 - total_bytes);
            if(bytes_read < 0) {
                return -1;
            } else if(bytes_read == 0) {
                break;
            } else {
                total_bytes += bytes_read;
            }
        }
        
        tv.tv_sec = 0;
        tv.tv_usec = 100000; 
    }
    
    buf[total_bytes] = '\0'; 
    return total_bytes;
}

int main(int argc, char *argv[]) {
    if(argc < 2) {
        fprintf(stderr, "Usage: %s <command>\n", argv[0]);
        return 1;
    }

    char *cmd = argv[1];
    char full_cmd[3];
    char  rx_buf[1024] = {0};

    int fd = open(DEVICE, O_RDWR | O_NOCTTY | O_SYNC);
    if(fd < 0) {
        fprintf(stderr, "Error %d opening %s: %s\n", errno, DEVICE, strerror(errno));
        return 1;
    }

    if(configure_port(fd) < 0) {
        close(fd);
        return 1;
    }

    printf("CH341 device connected\n");
    
    tcflush(fd, TCIFLUSH);
    
    snprintf(full_cmd, sizeof(full_cmd), "%s\r\n", cmd);
    printf("send: %s", full_cmd);
    if(serial_write(fd, full_cmd, strlen(full_cmd)) < 0) {
        close(fd);
        return 1;
    }

    usleep(100000);
    
    int n = serial_read(fd, rx_buf, sizeof(rx_buf));
    if(n > 0) {
        printf("Received %d byte: \n%s\n", n, rx_buf);
    } else if(n == 0) {
        printf("timeout!\n");
    } else {
        fprintf(stderr, "error: %s\n", strerror(errno));
    }

    close(fd);
    return 0;
}
