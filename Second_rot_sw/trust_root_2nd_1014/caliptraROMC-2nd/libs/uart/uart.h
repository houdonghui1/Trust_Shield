#ifndef __UART_H_
#define __UART_H_

#include <stdint.h>
#include <string.h>
#include "caliptra_reg.h"
#include "riscv_hw_if.h"

void uart_tx(uint8_t data);

uint8_t uart_rx();

void enable_uart();

void end_sim_if_uart_disabled();

void init_uart();

int run_loopback_test();

#endif