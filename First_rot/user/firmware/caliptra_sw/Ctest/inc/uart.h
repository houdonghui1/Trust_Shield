#ifndef __UART_H_
#define __UART_H_

void uart_tx(uint8_t data);

uint8_t uart_rx();

void enable_uart();

void end_sim_if_uart_disabled();

int run_loopback_test();

#endif