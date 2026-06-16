
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define DEVICE_PATH "/dev/caliptra-rom-backdoor"
#define ROM_PATH "caliptraROMC.bin"

int main() {
    int dev_fd, rom_fd;
    struct stat st;
    char *write_buf, *read_buf;
    ssize_t ret;

    if(stat(ROM_PATH, &st) == -1) {
        perror("stat failed");
        exit(EXIT_FAILURE);
    }

    write_buf = malloc(st.st_size);
    read_buf = malloc(st.st_size);
    if(!write_buf || !read_buf) {
        perror("malloc failed");
        exit(EXIT_FAILURE);
    }

    rom_fd = open(ROM_PATH, O_RDONLY);
    if(rom_fd < 0) {
        perror("ROM file open failed");
        free(write_buf);
        free(read_buf);
        exit(EXIT_FAILURE);
    }

    ret = read(rom_fd, write_buf, st.st_size);
    if(ret != st.st_size) {
        perror("read failed");
        close(rom_fd);
        free(write_buf);
        free(read_buf);
        exit(EXIT_FAILURE);
    }
    close(rom_fd);

    for(int i = 0; i < 512; i++) {
        printf("%02x ", write_buf[i]);
    }
    printf("\n");

    dev_fd = open(DEVICE_PATH, O_RDWR);
    if(dev_fd < 0) {
        perror("device open failed");
        free(write_buf);
        free(read_buf);
        exit(EXIT_FAILURE);
    }

    printf("Writing %ld bytes to device...\n", st.st_size);
    ret = write(dev_fd, write_buf, st.st_size);
    if(ret != st.st_size) {
        perror("write failed");
        close(dev_fd);
        free(write_buf);
        free(read_buf);
        exit(EXIT_FAILURE);
    }

    dev_fd = open(DEVICE_PATH, O_RDWR);
    if(dev_fd < 0) {
        perror("device open failed");
        free(write_buf);
        free(read_buf);
        exit(EXIT_FAILURE);
    }

    ret = read(dev_fd, read_buf, st.st_size);
    if(ret != st.st_size) {
        perror("read failed");
        close(dev_fd);
        free(write_buf);
        free(read_buf);
        exit(EXIT_FAILURE);
    }

    for(int i = 0; i < 512; i++) {
        printf("%02x ", read_buf[i]);
    }
    printf("\n");

    close(dev_fd);
    free(write_buf);
    free(read_buf);
    return 0;
}

