#include <stdint.h>
#include <string.h>
#include "caliptra_reg.h"
#include "riscv_hw_if.h"
#include "caliptra_defines.h"
#include "riscv-csr.h"
//#include "uart.h"
//#include "qspi.h"

void end_sim_if_uart_disabled() {
    uint32_t hw_cfg;
    hw_cfg = lsu_read_32(CLP_SOC_IFC_REG_CPTRA_HW_CONFIG);
    if (hw_cfg & SOC_IFC_REG_CPTRA_HW_CONFIG_UART_EN_MASK) {
    } else {
      while (1)
        ;
    }
  }

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

typedef enum { Dummy = 0, RdOnly = 1, WrOnly = 2, BiDir = 3 } direction_t;
typedef enum { Standard = 0, Dual = 1, Quad = 2 } speed_t;
typedef enum { CmdJedecId = 0x9f, CmdReadQuad = 0x6b } cmd_spi_t;


// read data and compare against expected value. If there is no error, return 0
int read_and_compare(uint32_t addr, uint32_t exp_data) {
  uint32_t act_data;
  act_data = lsu_read_32(addr);
  if (act_data != exp_data) {
    return 1;
  }
  return 0;
}

void end_sim_if_qspi_disabled() {
  uint32_t hw_cfg;
  hw_cfg = lsu_read_32(CLP_SOC_IFC_REG_CPTRA_HW_CONFIG);
  if (hw_cfg & SOC_IFC_REG_CPTRA_HW_CONFIG_QSPI_EN_MASK) {
  } else {
    while (1)
      ;
  }
}

void set_spi_csid(int host) { lsu_write_32(CLP_SPI_HOST_REG_CSID, host); }

void spi_command(int length, int csaat, speed_t speed, direction_t direction) {
  uint32_t status;

  // Wait for Status.ready
  do {
    status = lsu_read_32(CLP_SPI_HOST_REG_STATUS);
  } while (0 == (status & SPI_HOST_REG_STATUS_READY_MASK));

  lsu_write_32(CLP_SPI_HOST_REG_COMMAND,
               (direction << SPI_HOST_REG_COMMAND_DIRECTION_LOW) |
                   (speed << SPI_HOST_REG_COMMAND_SPEED_LOW) |
                   (csaat << SPI_HOST_REG_COMMAND_CSAAT_LOW) |
                   (length << SPI_HOST_REG_COMMAND_LEN_LOW));
}

void spi_command_wait() {
  uint32_t status;

  // Wait for Status.active
  do {
    status = lsu_read_32(CLP_SPI_HOST_REG_STATUS);
  } while (0 == (status & SPI_HOST_REG_STATUS_ACTIVE_MASK));
}

int fifo_rx_wait(int queue_depth) {
  uint32_t rxqd, status;
  int timeout = 0;
  do {
    status = lsu_read_32(CLP_SPI_HOST_REG_STATUS);
    rxqd = ((status & SPI_HOST_REG_STATUS_RXQD_MASK) >>
            SPI_HOST_REG_STATUS_RXQD_LOW);
    timeout++;
    if (timeout > 1000) {
      return 1;
    }
  } while (rxqd != queue_depth);
  return 0;
}

void write_tx_fifo(uint32_t data) {
  lsu_write_32(CLP_SPI_HOST_REG_TXDATA, data);
}

// configure_spi_host enables the IP and sets the timing behavior
void enable_spi_host() {
  uint32_t read_data;
  lsu_write_32(CLP_SPI_HOST_REG_CONTROL,
               (1 << SPI_HOST_REG_CONTROL_SPIEN_LOW) |
                   (1 << SPI_HOST_REG_CONTROL_OUTPUT_EN_LOW) |
                   (0x7f << SPI_HOST_REG_CONTROL_RX_WATERMARK_LOW));
}

void configure_spi_host(int host) {
  uint32_t offset;

  if (host == 0) {
    offset = CLP_SPI_HOST_REG_CONFIGOPTS_0;
  } else {
    offset = CLP_SPI_HOST_REG_CONFIGOPTS_1;
  }

  lsu_write_32(offset, (0 << SPI_HOST_REG_CONFIGOPTS_0_CPOL_LOW) |
                           (0 << SPI_HOST_REG_CONFIGOPTS_0_CPHA_LOW) |
                           (0 << SPI_HOST_REG_CONFIGOPTS_0_FULLCYC_LOW) |
                           (0 << SPI_HOST_REG_CONFIGOPTS_0_CSNLEAD_LOW) |
                           (0 << SPI_HOST_REG_CONFIGOPTS_0_CSNTRAIL_LOW) |
                           (0 << SPI_HOST_REG_CONFIGOPTS_0_CSNIDLE_LOW) |
                           (0 << SPI_HOST_REG_CONFIGOPTS_0_CLKDIV_LOW));
}

//----------------------------------------------------------------
// run_jedec_id_test()
//
// Configures the spi_host to request the jedec id
// The spiflash device will return 7 bytes of continuous code ('h7f)
// followed by the JedecId ('h1f) and the DeviceId ('h1234)
//----------------------------------------------------------------
int run_jedec_id_test(int host) {
  uint32_t status, rxqd, rx_data;
  uint32_t exp_data[3];
  int error = 0, words;

  exp_data[0] = 0x7f7f7f7f;
  exp_data[1] = 0x1f7f7f7f;
  if (host == 0) {
    exp_data[2] = 0xf10a;
  } else {
    exp_data[2] = 0xf10b;
  }

  // Load the TX FIFO with instructions and data to be transmitted
  write_tx_fifo(CmdJedecId);

  // Specify which device should receive the next command
  set_spi_csid(host);

  // Issue speed, direction and length details for the next command
  // segment.  If a command consists of multiple segments, set csaat to one
  // for all segments except the last one.
  //
  // Issue Command Instruction
  run_loopback_test();
  spi_command(0,         // length + 1
              1,         // csaat
              Standard,  // Speed
              WrOnly     // Direction
  );
  run_loopback_test();
  // spi flash will return 10 bytes for the jedec command
  spi_command(9,         // length + 1
              0,         // csaat
              Standard,  // Speed
              RdOnly     // Direction
  );

  // Wait for spi commands to finish before reading responses
  spi_command_wait();

  words = sizeof(exp_data) / 4;
  error += fifo_rx_wait(words);

  for (int ii = 0; ii < words; ii += 1) {
    error += read_and_compare(CLP_SPI_HOST_REG_RXDATA, exp_data[ii]);
  }

  return error;
}

//----------------------------------------------------------------
// run_read_test()
//
// Configures the spi_host to request data from the spi flash
//----------------------------------------------------------------
int run_read_test(int host) {
  uint32_t exp_data;
  uint32_t addr;
  int error = 0;
  int NumBytes = 256;
  int SpiFlashAddr = 0x00ABCD;  // 3B Address

  // Load the TX FIFO with instructions and data to be transmitted
  write_tx_fifo(CmdReadQuad);
  // Upper Bytes are transmitted first
  write_tx_fifo((SpiFlashAddr & 0xff0000) >> 0 | (SpiFlashAddr & 0xff00) |
                (SpiFlashAddr & 0xff) << 16);

  // Specify which device should receive the next command
  set_spi_csid(host);

  // Issue speed, direction and length details for the next command
  // segment.  If a command consists of multiple segments, set csaat to one
  // for all segments except the last one.
  //
  // Issue Command Instruction
  spi_command(0,         // length + 1
              1,         // csaat
              Standard,  // Speed
              WrOnly);   // Direction
  // Issue 3 Byte Address - (Send the CmdEn4B if 4B is needed)
  spi_command(2,         // length + 1
              1,         // csaat
              Standard,  // Speed
              WrOnly);   // Direction

  // Issue 2 Dummy Cycles - This is derived from spiflash.DummyQuad-1
  spi_command(1,       // length + 1
              1,       // csaat
              Quad,    // Speed
              Dummy);  // Direction

  // Request 13 bytes of data
  spi_command(NumBytes - 1,  // length + 1
              0,             // csaat
              Quad,          // Speed
              RdOnly);       // Direction

  // Wait for spi commands to finish before reading responses
  spi_command_wait();


  error += fifo_rx_wait(NumBytes / 4);

  addr = SpiFlashAddr;
  // Read and compare the bytes for comparison
  for (int ii = 0; ii < NumBytes / 4; ii += 1) {
    // calculate expected data
    exp_data = addr & 0xff;

    // compare
    error += read_and_compare(CLP_SPI_HOST_REG_RXDATA,
                              (exp_data + 3) << 24 | (exp_data + 2) << 16 |
                                  (exp_data + 1) << 8 | (exp_data + 0) << 0);
    addr += 4;
  };
  return error;
}

void main() {
  int error = 0;
  uint8_t rxdata;
  // Parameters
  int NUM_QSPI = 2;
  
   // wait for SHA to be ready
  while((lsu_read_32(CLP_SHA256_REG_SHA256_STATUS) & SHA256_REG_SHA256_STATUS_READY_MASK) == 0);

  end_sim_if_uart_disabled();
  enable_uart();

  end_sim_if_qspi_disabled();
  enable_spi_host();

  error = (*(volatile uint32_t *)(0x20000014));
  uart_tx((uint8_t)error);
  rxdata = uart_rx();

  error = lsu_read_32(0x20000014);
  uart_tx((uint8_t)error);
  rxdata = uart_rx();
  
  *(volatile uint32_t *) (0x20000014) = 0xABCD;
  lsu_write_32(0x20000014, 0xEEFF);

  error = (*(volatile uint32_t *)(0x20001014));
  uart_tx((uint8_t)error);
  rxdata = uart_rx();

  error = lsu_read_32(0x20001014);
  uart_tx((uint8_t)error);
  rxdata = uart_rx();
  *(volatile uint32_t *) (0x20001014) = 0xABCD;
  lsu_write_32(0x20001014, 0xEEFF);

  for (int host = 0; host < NUM_QSPI; host++) {
    configure_spi_host(host);
    error += run_jedec_id_test(host);

    error += run_read_test(host);

    error += run_read_test(host);

    error += run_read_test(host);

  }

}