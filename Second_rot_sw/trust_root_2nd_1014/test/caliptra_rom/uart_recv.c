#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>

#define UART_BASE 0x80010000
#define MAP_SIZE 0x1000

#define RX_FIFO   0x00
#define STAT_REG  0x08
#define CTRL_REG  0x0C

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

    uart_virt = (volatile unsigned int *)mmap(NULL, MAP_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, mem_fd, UART_BASE);
    if (uart_virt == MAP_FAILED) {
        perror("mmap failed");
        close(mem_fd);
        return -1;
    }

    uart_virt[CTRL_REG/4] = 0x02;
    printf("=== 纯接收模式已启动，等待数据... ===\n");

    while(1) {
        if(uart_virt[STAT_REG/4] & RX_VALID) {
            char ch = uart_virt[RX_FIFO/4];
            printf("收到：%c (ASCII: 0x%02X)\n", ch, ch);
        }
        usleep(10000);
    }

    munmap((void *)uart_virt, MAP_SIZE);
    close(mem_fd);
    return 0;
}
