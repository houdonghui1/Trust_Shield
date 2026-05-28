#include <stdint.h>
#include <string.h>
#include "caliptra_reg.h"
#include "riscv_hw_if.h"
#include "qspi.h"

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

void spi_command_wait() {
    uint32_t status;
  
    // Wait for Status.active
    do {
      status = lsu_read_32(CLP_SPI_HOST_REG_STATUS);
    } while (0 == (status & SPI_HOST_REG_STATUS_ACTIVE_MASK));
}

void set_spi_csid(int host) { 
    lsu_write_32(CLP_SPI_HOST_REG_CSID, host); 
}

void write_tx_fifo(uint32_t data) {
    lsu_write_32(CLP_SPI_HOST_REG_TXDATA, data);
}

uint8_t read_rx_fifo() {
    return lsu_read_32(CLP_SPI_HOST_REG_RXDATA);
}

uint8_t spi_read_response() {
  
  return read_rx_fifo();
}

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

void enable_spi_host() {
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

uint8_t sd_send_cmd(uint32_t cmd, uint32_t arg, uint32_t datalen) {
    write_tx_fifo(cmd);
    write_tx_fifo(arg);
    if(datalen != 0) {
      datalen--;// length + 1
    }
    spi_command(0, 1, Dual, WrOnly);
    spi_command(datalen, 0, Dual, WrOnly);
    return spi_read_response();
}

uint32_t init_sd_card() {
    uint8_t res;
    uint32_t retry = 0, qspi_num = 0, sd_type = 0, cmd;
    uint8_t ocr[4];
  
    enable_spi_host();
    
    configure_spi_host(qspi_num);

    set_spi_csid(qspi_num);

    retry = 20;
    do
    {
      res = sd_send_cmd(SD_CARD_CMD0, 0, 0); //reset
    } while ((res != 0x01) && retry--);

    if((res != 0x01)){
      if(sd_send_cmd(SD_CARD_CMD8, 0x1AA, 2)) {//v2.0 or higher card
        retry = 1000;
        do {
          res = sd_send_cmd(SD_CARD_ACMD41, 0x40000000, 4);//HCS = 1,Does it support high-capacity cards?
        } while ((res != 0x01) && retry--);//Ask if init is complete?

        if(retry && sd_send_cmd(SD_CARD_CMD58, 0, 0) == 0) {
          for (int i = 0; i < 4; i++) {
            ocr[i] = read_rx_fifo();
          }
          if (ocr[0] & 0x40) {//check CCS
            sd_type = SD_TYPE_V2HC;
          } else {
            sd_type = SD_TYPE_V2;
          }
        }
        sd_send_cmd(SD_CARD_CMD16, 0x200, 2);//Set the block length to 512 bytes

      } else {
        retry = 1000;
        res = sd_send_cmd(SD_CARD_ACMD41, 0, 0);
        if (res <= 1) {
          sd_type = SD_TYPE_V1;
          cmd = SD_CARD_ACMD41;
        } else {
          sd_type = SD_TYPE_MMC;
          cmd = SD_CARD_CMD1;
        }
        do {
          res = sd_send_cmd(cmd, 0, 0);
        } while (res && retry--);
        if (retry == 0 || sd_send_cmd(SD_CARD_CMD16, 0x200, 2) != 0) {
          sd_type = SD_TYPE_ERR;//Wrong card
        }
      }
    }
    if (sd_type) {
      return 0;
    } 

    return -1;
}

uint8_t read_sd_card(uint32_t block_address, uint8_t *buffer, uint32_t cnt) {
    uint8_t res;
    if(cnt == 1){
      res = sd_send_cmd(SD_CARD_CMD17, block_address, sizeof(block_address));
      if(!res) {
        for (int i = 0; i < 512; i++) {
          buffer[i] = read_rx_fifo();
        }  
        read_rx_fifo();
        read_rx_fifo();
      }
    } else {
      res = sd_send_cmd(SD_CARD_CMD18, block_address, sizeof(block_address));
      if(!res) {
        do
        {
          for (int i = 0; i < 512; i++) {
            buffer[i] = read_rx_fifo();
          }  
          buffer += 512;
        } while (--cnt);
        sd_send_cmd(SD_CARD_CMD12, 0, 0);
      }
    }

    return res;
}

uint8_t write_sd_card(uint32_t block_address, uint8_t *buffer, uint32_t cnt) {
  uint8_t res;
  if(cnt == 1){
    res = sd_send_cmd(SD_CARD_CMD24, block_address, sizeof(block_address));
    if(!res) {
      for (int i = 0; i < 512; i++) {
        write_tx_fifo(buffer[i]);
      }  
      read_rx_fifo();
      read_rx_fifo();
    }
  } else {
    res = sd_send_cmd(SD_CARD_CMD25, block_address, sizeof(block_address));
    if(!res) {
      do
      {
        for (int i = 0; i < 512; i++) {
          write_tx_fifo(buffer[i]);
        }  
        buffer += 512;
      } while (--cnt);
      write_tx_fifo(0);
    }
  }

  return res;
}