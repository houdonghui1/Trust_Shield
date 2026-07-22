#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>

#define UART_BASE 0x80010000
#define MAP_SIZE 0x1000

#define RX_FIFO   0x00
#define TX_FIFO   0x04
#define STAT_REG  0x08
#define CTRL_REG  0x0C

#define TX_EMPTY  (1 << 2)
#define RX_VALID  (1 << 0)

int main() {
    int mem_fd;
    volatile unsigned int *uart_virt;
    setbuf(stdout, NULL);

    mem_fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (mem_fd < 0) {
        perror("open failed");
        return -1;
    }

    uart_virt = (volatile unsigned int *)mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, mem_fd, UART_BASE);
    if (uart_virt == MAP_FAILED) {
        perror("mmap failed");
        close(mem_fd);
        return -1;
    }
    printf("MAP OK\n");

    uart_virt[CTRL_REG / 4] = 0x03;
    printf("FIFO CLEAR\n");

    char test_data[] = "Hello UART!\n";
    int i = 0;
    while (test_data[i] != '\0') {
        while (!(uart_virt[STAT_REG / 4] & TX_EMPTY));
        uart_virt[TX_FIFO / 4] = test_data[i++];
    }
    printf("SEND OK\n");

    munmap((void *)uart_virt, MAP_SIZE);
    close(mem_fd);
    printf("EXIT\n");
    return 0;
}
