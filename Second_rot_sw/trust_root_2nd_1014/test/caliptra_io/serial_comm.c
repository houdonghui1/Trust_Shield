#include "serial_comm.h"

#define DEVICE "/dev/ttyCH341USB0"
#define BAUDRATE B115200
#define TIMEOUT_MS 500

static struct file *serial_file = NULL;

static int configure_port(void) {
    struct tty_struct *tty;
    struct ktermios termios;
    
    if (!serial_file) {
        printk(KERN_ERR "Serial file not open\n");
        return -ENODEV;
    }
    
    tty = serial_file->private_data;
    if (!tty || !tty->ops) {
        printk(KERN_ERR "No tty operations available\n");
        return -ENODEV;
    }
    
    down_read(&tty->termios_rwsem);
    termios = tty->termios; 
    up_read(&tty->termios_rwsem);
    
    tty_termios_encode_baud_rate(&termios, B115200, B115200);
    
    termios.c_cflag &= ~PARENB;
    termios.c_cflag &= ~CSTOPB;
    termios.c_cflag &= ~CSIZE;
    termios.c_cflag |= CS8;
    
    termios.c_cflag &= ~CRTSCTS;
    termios.c_iflag &= ~(IXON | IXOFF | IXANY);
    
    termios.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
    termios.c_oflag &= ~OPOST;
    
    termios.c_cc[VMIN] = 0;
    termios.c_cc[VTIME] = 5; 
    
    down_write(&tty->termios_rwsem);
    tty->termios = termios; 
    up_write(&tty->termios_rwsem);
    
    return 0;
}

static int serial_write(const char* data, size_t len) {
    struct tty_struct *tty;
    int written = 0;
    
    if (!serial_file) {
        printk(KERN_ERR "Serial file not open\n");
        return -ENODEV;
    }
    
    tty = serial_file->private_data;
    if (!tty || !tty->ops || !tty->ops->write) {
        printk(KERN_ERR "No tty write operation available\n");
        return -ENODEV;
    }
    
    written = tty->ops->write(tty, data, len);
    if (written < 0) {
        printk(KERN_ERR "Write failed: %d\n", written);
        return written;
    }
    
    tty->ops->wait_until_sent(tty, 0);
    
    return written;
}


static int serial_read(char* buf, size_t buf_size) {
    struct tty_struct *tty;
    int read = 0;
    mm_segment_t old_fs;
    
    if (!serial_file) {
        printk(KERN_ERR "Serial file not open\n");
        return -ENODEV;
    }
    
    tty = serial_file->private_data;
    if (!tty) {
        printk(KERN_ERR "No tty structure available\n");
        return -ENODEV;
    }
    
    old_fs = get_fs();
    set_fs(KERNEL_DS);
    
    if (tty->ops->read) {
        read = tty->ops->read(tty, buf, buf_size);
    } else {
        printk(KERN_INFO "No direct read operation, using alternative method\n");
        
        if (tty->ldisc->ops->read) {
            struct file *file = NULL;
            read = tty->ldisc->ops->read(tty, file, (unsigned char __user *)buf, buf_size);
        } else {
            printk(KERN_ERR "No read operation available\n");
            read = -ENOTTY;
        }
    }
    
    set_fs(old_fs);
    
    if (read < 0) {
        printk(KERN_ERR "Read failed: %d\n", read);
    }
    
    return read;
}
static int serial_read_poll(char* buf, size_t buf_size) {
    struct tty_struct *tty;
    int total_read = 0;
    int retry_count = 10; 
    mm_segment_t old_fs;
    
    if (!serial_file) {
        printk(KERN_ERR "Serial file not open\n");
        return -ENODEV;
    }
    
    tty = serial_file->private_data;
    if (!tty) {
        printk(KERN_ERR "No tty structure available\n");
        return -ENODEV;
    }
    
    old_fs = get_fs();
    set_fs(KERNEL_DS);
    
    while (total_read < buf_size - 1 && retry_count > 0) {
        int n = 0;
        
        if (tty->ops->read) {
            n = tty->ops->read(tty, buf + total_read, buf_size - total_read - 1);
        }
        
        if (n > 0) {
            total_read += n;
        } else if (n == 0) {
            msleep(10);
            retry_count--;
        } else {
            break;
        }
    }
    
    set_fs(old_fs);
    
    buf[total_read] = '\0'; 
    return total_read;
}

int serial_comm(char* cmd, char* buf) {
    serial_file = filp_open(DEVICE, O_RDWR | O_NOCTTY | O_SYNC, 0);
    if (IS_ERR(serial_file)) {
        printk(KERN_ERR "Error opening %s: %ld\n", DEVICE, PTR_ERR(serial_file));
        serial_file = NULL;
        return PTR_ERR(serial_file);
    }

    if (configure_port() < 0) {
        printk(KERN_ERR "Failed to configure port\n");
        filp_close(serial_file, NULL);
        serial_file = NULL;
        return -EIO;
    }

    printk(KERN_INFO "CH341 device connected\n");
    
    printk("send: %s", cmd);
    if(serial_write(cmd, strlen(cmd)) < 0) {
        printk(KERN_ERR "Failed to send test command\n");
        filp_close(serial_file, NULL);
        serial_file = NULL;
        return 1;
    }

    msleep(100);
    
    int n = serial_read_poll(buf, sizeof(buf));
    if(n > 0) {
        printk("Received %d byte: \n%s\n", n, buf);
    } else if(n == 0) {
        printk("timeout!\n");
	return 1;
    } else {
    	printk(KERN_ERR "Read error: %d\n", n);
	return 1;
    }

    filp_close(serial_file, NULL);
    return 0;
}
