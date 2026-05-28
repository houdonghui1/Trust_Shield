#include "uart.h"

void uart_tx(uint8_t data) {
    uint32_t status, tx_full, wdata;
    // Check the TX fifo is not full
    do {
      status = lsu_read_32(CLP_UART_STATUS);
      tx_full = ((status & UART_STATUS_TXFULL_MASK) >> UART_STATUS_TXFULL_LOW);
    } while (tx_full);
  
    wdata = data;
    lsu_write_32(CLP_UART_WDATA, wdata);
}
  
uint8_t uart_rx() {
    uint32_t status, rx_empty, data;
    uint8_t rdata;
  
    // Check the RX Empty
    do {
      status = lsu_read_32(CLP_UART_STATUS);
      rx_empty = ((status & UART_STATUS_RXEMPTY_MASK) >> UART_STATUS_RXEMPTY_LOW);
    } while (rx_empty);
  
    // read the data
    data = lsu_read_32(CLP_UART_RDATA);
    rdata = data & 0xff;
    return rdata;
}

// enable uart tx and rx
void enable_uart() {
    uint64_t nco, baud_rate, ip_frequency;
    uint32_t ctrl;
  
    baud_rate = 115200;
    ip_frequency = 40000000;  // 40 MHz
  
    // 31:16 NCO
    // 9:8   rxblvl
    // 7     parity_odd
    // 6     parity_even
    // 5     line loopback enable
    // 4     system loopback enable
    // 2     RX Noise Filter
    // 1     Rx Enable
    // 0     Tx Enable
    // NCO Equation: 2^20 * Fbaud
    //              --------------
    //                   Fclk
    // Fbaud = baud rate in bits per second
    // Fclk  = fixed frequency of the IP
    nco = baud_rate << 20;
    nco = nco / ip_frequency;
  
    ctrl = ((nco & 0xffff) << UART_CTRL_NCO_LOW) | UART_CTRL_TX_MASK |
           UART_CTRL_RX_MASK;
    lsu_write_32(CLP_UART_CTRL, ctrl);  // Enable RX/TX
}

void end_sim_if_uart_disabled() {
  uint32_t hw_cfg;
  hw_cfg = lsu_read_32(CLP_SOC_IFC_REG_CPTRA_HW_CONFIG);
  if (hw_cfg & SOC_IFC_REG_CPTRA_HW_CONFIG_UART_EN_MASK) {
  } else {
    while (1)
      ;
  }
}

void init_uart() {
  end_sim_if_uart_disabled();

  enable_uart();
}

int run_loopback_test() {
  int error = 0;
  //uint8_t rxdata;
  uint8_t txdata;

  txdata = 0x63;
  uart_tx(txdata);
  txdata = 0x61;
  uart_tx(txdata);
  txdata = 0x6C;
  uart_tx(txdata);
  txdata = 0x69;
  uart_tx(txdata);
  txdata = 0x70;
  uart_tx(txdata);
  txdata = 0x74;
  uart_tx(txdata);
  txdata = 0x72;
  uart_tx(txdata);
  txdata = 0x61;
  uart_tx(txdata);
  txdata = 0x0;
  uart_tx(txdata);
  
/*     for (int ii = 0; ii < 10; ii++) {
    txdata = 3 * ii + 7;
    uart_tx(txdata);

    rxdata = uart_rx();

    if (rxdata != txdata) {
      error += 1;
    }
  } */

  return error;
}