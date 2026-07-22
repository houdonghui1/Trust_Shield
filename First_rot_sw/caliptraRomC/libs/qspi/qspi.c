#include "qspi.h"

#define RXFIFO_DEPTH  256

#define DELAY_LOOP_COUNT 1000

void check_spi_status() {
    uint32_t status = lsu_read_32(CLP_SPI_HOST_REG_STATUS);
    uint32_t error = lsu_read_32(CLP_SPI_HOST_REG_ERROR_STATUS);
    uint32_t __attribute__((unused)) rxfifo;
    
/*     printf("  SPI Status: 0x%ld\n", status);
    printf("  Active: %d\n", !!(status & SPI_HOST_REG_STATUS_ACTIVE_MASK));
    printf("  Ready: %d\n", !!(status & SPI_HOST_REG_STATUS_READY_MASK));
    printf("  TX Full: %d\n", !!(status & SPI_HOST_REG_STATUS_TXFULL_MASK));
    printf("  TX Empty: %d\n", !!(status & SPI_HOST_REG_STATUS_TXEMPTY_MASK));
    printf("  RX Full: %d\n", !!(status & SPI_HOST_REG_STATUS_RXFULL_MASK));
    printf("  RX Empty: %d\n", !!(status & SPI_HOST_REG_STATUS_RXEMPTY_MASK));
    printf("  RX QD: %ld\n", (status & SPI_HOST_REG_STATUS_RXQD_MASK) >> SPI_HOST_REG_STATUS_RXQD_LOW); */
    
    while (((status & SPI_HOST_REG_STATUS_RXFULL_MASK) != 0) || ((status & SPI_HOST_REG_STATUS_RXEMPTY_MASK) == 0)) {
      //printf("Read RXFIFO!\n");
      rxfifo = lsu_read_32(CLP_SPI_HOST_REG_RXDATA);

      delay_ms(1);

      status = lsu_read_32(CLP_SPI_HOST_REG_STATUS);

/*       if((status & SPI_HOST_REG_STATUS_RXFULL_MASK) != 0) {
        printf("RXFIFO full!\n");
      }

      if((status & SPI_HOST_REG_STATUS_RXEMPTY_MASK) != 0) {
        printf("RXFIFO read empty!\n");
      } */
      
    }

    //printf("func: %s, line: %d\n", __func__, __LINE__);
    while ((status & SPI_HOST_REG_STATUS_ACTIVE_MASK) != 0) {
      status = lsu_read_32(CLP_SPI_HOST_REG_STATUS);
    } 

    //printf("func: %s, line: %d\n", __func__, __LINE__);
    status = lsu_read_32(CLP_SPI_HOST_REG_STATUS);
/*     printf("  SPI Status: 0x%ld\n", status);
    printf("  Active: %d\n", !!(status & SPI_HOST_REG_STATUS_ACTIVE_MASK));
    printf("  Ready: %d\n", !!(status & SPI_HOST_REG_STATUS_READY_MASK));
    printf("  TX Full: %d\n", !!(status & SPI_HOST_REG_STATUS_TXFULL_MASK));
    printf("  TX Empty: %d\n", !!(status & SPI_HOST_REG_STATUS_TXEMPTY_MASK));
    printf("  RX Full: %d\n", !!(status & SPI_HOST_REG_STATUS_RXFULL_MASK));
    printf("  RX Empty: %d\n", !!(status & SPI_HOST_REG_STATUS_RXEMPTY_MASK));
    printf("  RX QD: %ld\n", (status & SPI_HOST_REG_STATUS_RXQD_MASK) >> SPI_HOST_REG_STATUS_RXQD_LOW); */

    if(error) {
        printf("SPI Errors: 0x%08lX\n", error);
        if(error & SPI_HOST_REG_ERROR_STATUS_CSIDINVAL_MASK) printf("  Command Invalid\n");
        if(error & SPI_HOST_REG_ERROR_STATUS_CMDINVAL_MASK) printf("  CSID Invalid\n");
        if(error & SPI_HOST_REG_ERROR_STATUS_ACCESSINVAL_MASK) printf("  Access Invalid\n");
        if(error & SPI_HOST_REG_ERROR_STATUS_OVERFLOW_MASK) printf("  FIFO Overflow\n");
        
        lsu_write_32(CLP_SPI_HOST_REG_ERROR_STATUS, error);
    }
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

int write_tx_fifo(uint32_t data) {
    uint32_t status;
    int time = 1000;

    do {
        status = lsu_read_32(CLP_SPI_HOST_REG_STATUS);
        time--;
        if(time <=0) {
          return -1;
        }
    } while (status & SPI_HOST_REG_STATUS_TXFULL_MASK);
    
    lsu_write_32(CLP_SPI_HOST_REG_TXDATA, data);

    return 0;
}

void spi_command(int length, int csaat, speed_t speed, direction_t direction) {
    uint32_t status;
    int time = 1000;
    // Wait for Status.ready
    do {
      status = lsu_read_32(CLP_SPI_HOST_REG_STATUS);
      time -= 1;
      if(time <= 0) {
        break;
      }
    } while (0 == (status & SPI_HOST_REG_STATUS_READY_MASK));

    lsu_write_32(CLP_SPI_HOST_REG_COMMAND,
                 (direction << SPI_HOST_REG_COMMAND_DIRECTION_LOW) |
                     (speed << SPI_HOST_REG_COMMAND_SPEED_LOW) |
                     (csaat << SPI_HOST_REG_COMMAND_CSAAT_LOW) |
                     (length << SPI_HOST_REG_COMMAND_LEN_LOW));
}

uint8_t spi_read_response() {
    uint8_t response;
    uint32_t  median;
    uint32_t timeout = 1000;

    while((lsu_read_32(CLP_SPI_HOST_REG_STATUS) & SPI_HOST_REG_STATUS_RXEMPTY_MASK)) {
      //printf("func: %s, line: %d\n", __func__, __LINE__);
      timeout--;
      if(!timeout) {
        return 0xFF;
      }
    }

    
    median = lsu_read_32(CLP_SPI_HOST_REG_RXDATA);
    //printf(" line: %d, median = 0x%lx\n", __LINE__, median);
    response = (median >> 8) & 0xFF;
    //printf(" line: %d, response = 0x%02x\n", __LINE__, response);
    
    return response;
}

uint8_t spi_read_response2() {
    uint32_t response = 0;
    uint32_t timeout = 1000;
    uint8_t byte = 0;

    while((lsu_read_32(CLP_SPI_HOST_REG_STATUS) & SPI_HOST_REG_STATUS_RXEMPTY_MASK)) {
      //printf("func: %s, line: %d\n", __func__, __LINE__);
      timeout--;
      if(!timeout) {
        return 0xFF;
      }
    }
    
    response = lsu_read_32(CLP_SPI_HOST_REG_RXDATA);

    for (int i = 0; i < 4; i++) {
        byte = (response >> (i * 8)) & 0xFF;
        if (byte == 0xFE) {
            return byte;
        }
    }

    return 0xFF;
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

void enable_spi_host() {
    lsu_write_32(CLP_SPI_HOST_REG_CONTROL,
                (1 << SPI_HOST_REG_CONTROL_SPIEN_LOW) |
                    (1 << SPI_HOST_REG_CONTROL_OUTPUT_EN_LOW) |
                    (0x7f << SPI_HOST_REG_CONTROL_RX_WATERMARK_LOW));
}

void disable_spi_host() {
    lsu_write_32(CLP_SPI_HOST_REG_CONTROL,
                (0 << SPI_HOST_REG_CONTROL_SPIEN_LOW) &
                    (0 << SPI_HOST_REG_CONTROL_OUTPUT_EN_LOW) &
                    (0 << SPI_HOST_REG_CONTROL_RX_WATERMARK_LOW));
}

void init_qspi() {
    end_sim_if_qspi_disabled();

    enable_spi_host();
}

void configure_spi_host_slow(int host) {
    uint32_t offset;
  
    if (host == 0) {
      offset = CLP_SPI_HOST_REG_CONFIGOPTS_0;
    } else {
      offset = CLP_SPI_HOST_REG_CONFIGOPTS_1;
    }
  
    lsu_write_32(offset, 
      ((1 << SPI_HOST_REG_CONFIGOPTS_0_CPOL_LOW)  & SPI_HOST_REG_CONFIGOPTS_0_CPOL_MASK)  |
      ((1 << SPI_HOST_REG_CONFIGOPTS_0_CPHA_LOW)  & SPI_HOST_REG_CONFIGOPTS_0_CPHA_MASK)  |
      ((0 << SPI_HOST_REG_CONFIGOPTS_0_FULLCYC_LOW) & SPI_HOST_REG_CONFIGOPTS_0_FULLCYC_MASK) |
      ((0 << SPI_HOST_REG_CONFIGOPTS_0_CSNLEAD_LOW) & SPI_HOST_REG_CONFIGOPTS_0_CSNLEAD_MASK) |
      ((0 << SPI_HOST_REG_CONFIGOPTS_0_CSNTRAIL_LOW) & SPI_HOST_REG_CONFIGOPTS_0_CSNTRAIL_MASK) |
      ((0 << SPI_HOST_REG_CONFIGOPTS_0_CSNIDLE_LOW) & SPI_HOST_REG_CONFIGOPTS_0_CSNIDLE_MASK) |
      ((49 << SPI_HOST_REG_CONFIGOPTS_0_CLKDIV_LOW) & SPI_HOST_REG_CONFIGOPTS_0_CLKDIV_MASK)
    );
}

void configure_spi_host_fast(int host) {
    uint32_t offset;
  
    if (host == 0) {
      offset = CLP_SPI_HOST_REG_CONFIGOPTS_0;
    } else {
      offset = CLP_SPI_HOST_REG_CONFIGOPTS_1;
    }
  
    lsu_write_32(offset, 
      ((1 << SPI_HOST_REG_CONFIGOPTS_0_CPOL_LOW)  & SPI_HOST_REG_CONFIGOPTS_0_CPOL_MASK)  |
      ((1 << SPI_HOST_REG_CONFIGOPTS_0_CPHA_LOW)  & SPI_HOST_REG_CONFIGOPTS_0_CPHA_MASK)  |
      ((0 << SPI_HOST_REG_CONFIGOPTS_0_FULLCYC_LOW) & SPI_HOST_REG_CONFIGOPTS_0_FULLCYC_MASK) |
      ((0 << SPI_HOST_REG_CONFIGOPTS_0_CSNLEAD_LOW) & SPI_HOST_REG_CONFIGOPTS_0_CSNLEAD_MASK) |
      ((0 << SPI_HOST_REG_CONFIGOPTS_0_CSNTRAIL_LOW) & SPI_HOST_REG_CONFIGOPTS_0_CSNTRAIL_MASK) |
      ((0 << SPI_HOST_REG_CONFIGOPTS_0_CSNIDLE_LOW) & SPI_HOST_REG_CONFIGOPTS_0_CSNIDLE_MASK) |
      ((3 << SPI_HOST_REG_CONFIGOPTS_0_CLKDIV_LOW) & SPI_HOST_REG_CONFIGOPTS_0_CLKDIV_MASK)//2:0,4:1,8:3,16:7
    );
}

uint8_t sd_send_cmd(uint32_t cmd, uint32_t arg, uint8_t *recv_data, uint32_t recv_size) {
    uint8_t response;
    int i = 0;
    set_spi_csid(0);

    write_tx_fifo(cmd);
    spi_command(0, 1, Standard, WrOnly);
    write_tx_fifo(arg >> 24);
    spi_command(0, 1, Standard, WrOnly);
    write_tx_fifo(arg >> 16);
    spi_command(0, 1, Standard, WrOnly);
    write_tx_fifo(arg >> 8);
    spi_command(0, 1, Standard, WrOnly);
    write_tx_fifo(arg);
    spi_command(0, 1, Standard, WrOnly);
    if(cmd == SD_CARD_CMD0) {
      write_tx_fifo(0x95);
    } else if (cmd == SD_CARD_CMD8) {
      write_tx_fifo(0x87);
    } else {
      write_tx_fifo(0xFF);
    }
    spi_command(0, 1, Standard, WrOnly);

    spi_command_wait();

    if(cmd == SD_CARD_CMD18) {
      uint32_t  word;
      uint32_t  block_value = recv_size/512;
      uint32_t  fe_index = 0;
      uint32_t  recv_count, once_count;
      uint32_t  data[1024] = {0};
 
      response = 0x0;

      for (i = 0; i < 64; i++) {
        write_tx_fifo(0xffffffff);
      }
      spi_command(RXFIFO_DEPTH-1, 1, Standard, BiDir);
      spi_command_wait();

      for(recv_count = 0; recv_count < block_value; recv_count++) {
        for(once_count = 0; once_count < 4; once_count++) {
          spi_command(RXFIFO_DEPTH-1, 1, Standard, BiDir);
          spi_command_wait();
          fifo_rx_wait(RXFIFO_DEPTH/4);
          for (i = 0; i < RXFIFO_DEPTH; i+=4) {
            while((lsu_read_32(CLP_SPI_HOST_REG_STATUS) & SPI_HOST_REG_STATUS_RXEMPTY_MASK));
            word = lsu_read_32(CLP_SPI_HOST_REG_RXDATA);
            data[once_count*RXFIFO_DEPTH+i]   = word & 0xFF;
            data[once_count*RXFIFO_DEPTH+i+1] = (word >> 8) & 0xFF;
            data[once_count*RXFIFO_DEPTH+i+2] = (word >> 16) & 0xFF;
            data[once_count*RXFIFO_DEPTH+i+3] = (word >> 24) & 0xFF;
            write_tx_fifo(0xFFFFFFFF);
          }
        }
        for (uint32_t i = 0; i < 1024; i++) {
          if (data[i] == 0xFE) {
              fe_index = i + 1;
              break;
            }
        }
        spi_command(RXFIFO_DEPTH-1, 1, Standard, BiDir);
    
        if (fe_index > 0 && fe_index + 512 <= 1024) {
          memcpy(recv_data + recv_count * 512, (uint8_t *)data + fe_index, 512);
        }
      }

      set_spi_csid(1);
      write_tx_fifo(0xff);
      spi_command(0, 0, Standard, WrOnly);
    } else if(cmd == SD_CARD_CMD17) {
      uint32_t  word = 0;
      uint8_t   data[1024] = {0};
      uint32_t  fe_index = 0;

      response = 0x0;
      for (i = 0; i < 64; i++) {
        write_tx_fifo(0xffffffff);
      }
      spi_command(RXFIFO_DEPTH-1, 1, Standard, BiDir);
      spi_command_wait();
      lsu_read_32(CLP_SHA256_REG_SHA256_STATUS);

      spi_command(RXFIFO_DEPTH-1, 1, Standard, BiDir);
      spi_command_wait();
      fifo_rx_wait(RXFIFO_DEPTH/4);
      for (i = 0; i < RXFIFO_DEPTH; i+=4) {
        while((lsu_read_32(CLP_SPI_HOST_REG_STATUS) & SPI_HOST_REG_STATUS_RXEMPTY_MASK));
        word = lsu_read_32(CLP_SPI_HOST_REG_RXDATA);
        data[i]   = word & 0xFF;
        data[i+1] = (word >> 8) & 0xFF;
        data[i+2] = (word >> 16) & 0xFF;
        data[i+3] = (word >> 24) & 0xFF;
        write_tx_fifo(0xFFFFFFFF);
      }
      spi_command(RXFIFO_DEPTH-1, 1, Standard, BiDir);
      spi_command_wait();
      fifo_rx_wait(RXFIFO_DEPTH/4);
      for (i = RXFIFO_DEPTH; i < RXFIFO_DEPTH*2; i+=4) {
        while((lsu_read_32(CLP_SPI_HOST_REG_STATUS) & SPI_HOST_REG_STATUS_RXEMPTY_MASK));
        word = lsu_read_32(CLP_SPI_HOST_REG_RXDATA);
        data[i]   = word & 0xFF;
        data[i+1] = (word >> 8) & 0xFF;
        data[i+2] = (word >> 16) & 0xFF;
        data[i+3] = (word >> 24) & 0xFF;
        write_tx_fifo(0xFFFFFFFF);
      }
      spi_command(RXFIFO_DEPTH-1, 1, Standard, BiDir);
      spi_command_wait();
      fifo_rx_wait(RXFIFO_DEPTH/4);
      for (i = RXFIFO_DEPTH*2; i < RXFIFO_DEPTH*3; i+=4) {
        while((lsu_read_32(CLP_SPI_HOST_REG_STATUS) & SPI_HOST_REG_STATUS_RXEMPTY_MASK));
        word = lsu_read_32(CLP_SPI_HOST_REG_RXDATA);
        data[i]   = word & 0xFF;
        data[i+1] = (word >> 8) & 0xFF;
        data[i+2] = (word >> 16) & 0xFF;
        data[i+3] = (word >> 24) & 0xFF;
        write_tx_fifo(0xFFFFFFFF);
      }
      spi_command(RXFIFO_DEPTH-1, 0, Standard, BiDir);
      set_spi_csid(1);
      spi_command_wait();
      fifo_rx_wait(RXFIFO_DEPTH/4);
      for (i = RXFIFO_DEPTH*3; i < RXFIFO_DEPTH*4; i+=4) {
        while((lsu_read_32(CLP_SPI_HOST_REG_STATUS) & SPI_HOST_REG_STATUS_RXEMPTY_MASK));
        word = lsu_read_32(CLP_SPI_HOST_REG_RXDATA);
        data[i]   = word & 0xFF;
        data[i+1] = (word >> 8) & 0xFF;
        data[i+2] = (word >> 16) & 0xFF;
        data[i+3] = (word >> 24) & 0xFF;
        write_tx_fifo(0xFFFFFFFF);
      }
     
      write_tx_fifo(0xffffffff);
      write_tx_fifo(0xffffffff);
      spi_command(7, 0, Standard, WrOnly);
      
      for (uint32_t i = 0; i < 1024; i++) {
        if (data[i] == 0xFE) {
          fe_index = i + 1;
          break;
        }
      }
      if (fe_index > 0 && fe_index + 512 <= 1024) {
          memcpy(recv_data, &data[fe_index], 512);
      }
    } else {
      spi_command(1, 0, Standard, RdOnly);
      set_spi_csid(1);
      spi_command_wait();
      response = spi_read_response();
      write_tx_fifo(0xff);
      spi_command(0, 0, Standard, WrOnly);
    }

    return response;
}

void sendpulse() {
    write_tx_fifo(0xffffffff);

    spi_command(3, 0, Standard, WrOnly);
}

uint32_t init_sd_card() {
    uint8_t res;
    uint32_t retry = 0, sd_type = 0, cmd;
    enable_spi_host();
    
    configure_spi_host_slow(0);
    configure_spi_host_slow(1);
    
    set_spi_csid(1);

    for (uint32_t i = 0; i < 3; i++)
    {
      sendpulse();
    }

    retry = 20;
    do {
      res = sd_send_cmd(SD_CARD_CMD0, 0, NULL, 0); //reset
    } while ((res != 0x01) && retry--);
    //printf("func: %s, line: %d\n", __func__, __LINE__);
    if((res == 0x01)){
      do {
        res = sd_send_cmd(SD_CARD_CMD8, 0x1AA, NULL, 0);
      } while ((res != 0x01) && retry--);
      //printf("func: %s, line: %d, res: 0x%02X\n", __func__, __LINE__, res);
      if (res == 0x01) {
        //printf("func: %s, line: %d\n", __func__, __LINE__);
        retry = 1000;
        do {
          res = sd_send_cmd(SD_CARD_CMD55, 0, NULL, 0);
          if(res == 0x1) {
            res = sd_send_cmd(SD_CARD_ACMD41, 0x40000000, NULL, 0);//HCS = 1,Does it support high-capacity cards?
            //printf("func: %s, line: %d, SD_CARD_ACMD41 response = 0x%02x\n", __func__, __LINE__, res);
            if(res == 0x0) {
              sd_type = SD_TYPE_V2;
            }
          }
        } while (res && retry--);//Ask if init is complete?
      } else {
        //printf("func: %s, line: %d\n", __func__, __LINE__);
        retry = 1000;
        res = sd_send_cmd(SD_CARD_ACMD41, 0, NULL, 0);
        if (res <= 1) {
          sd_type = SD_TYPE_V1;
          cmd = SD_CARD_ACMD41;
        } else {
          sd_type = SD_TYPE_MMC;
          cmd = SD_CARD_CMD1;
        }
        do {
          res = sd_send_cmd(cmd, 0, NULL, 0);
        } while (res && retry--);
        if (retry == 0 || sd_send_cmd(SD_CARD_CMD16, 0x200, NULL, 0) != 0) {
          sd_type = SD_TYPE_ERR;//Wrong card
        }
      }
    }
    if (sd_type) {
/*       configure_spi_host_fast(0);
      configure_spi_host_fast(1); */
      //printf("func: %s, line: %d\n", __func__, __LINE__);
      return 0;
    } 
    //printf("func: %s, line: %d\n", __func__, __LINE__);
    return -1;
}

uint8_t read_sd_card(uint32_t block_address, uint8_t *buffer, uint32_t buffer_size, uint32_t cnt) {
    uint8_t res;

    check_spi_status();
    
    if(cnt == 0){
      res = sd_send_cmd(SD_CARD_CMD17, block_address, buffer, 0);
    } else {
      res = sd_send_cmd(SD_CARD_CMD18, block_address, buffer, buffer_size);
    }

    return res;
}