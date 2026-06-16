#ifndef SERIAL_COMM_H
#define SERIAL_COMM_H

#include <linux/module.h>
#include <linux/init.h>
#include <linux/tty.h>
#include <linux/serial.h>
#include <linux/serial_8250.h>
#include <linux/errno.h>
#include <linux/string.h>
#include <linux/delay.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/kernel.h>

int serial_comm(char* cmd, char* rx_buf);

#endif
