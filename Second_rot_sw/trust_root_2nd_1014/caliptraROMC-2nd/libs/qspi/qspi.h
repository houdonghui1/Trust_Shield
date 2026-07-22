#ifndef __QSPI_H_
#define __QSPI_H_

#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include "caliptra_reg.h"
#include "riscv_hw_if.h"
#include "printf.h"

typedef enum { Dummy = 0, RdOnly = 1, WrOnly = 2, BiDir = 3 } direction_t;
typedef enum { Standard = 0, Dual = 1, Quad = 2 } speed_t;

#define SD_CARD_CMD0    (0x40)
#define SD_CARD_CMD1    (SD_CARD_CMD0 | 1)
#define SD_CARD_CMD8    (SD_CARD_CMD0 | 8)
#define SD_CARD_CMD9    (SD_CARD_CMD0 | 9)
#define SD_CARD_CMD12   (SD_CARD_CMD0 | 12)
#define SD_CARD_CMD13   (SD_CARD_CMD0 | 13)
#define SD_CARD_CMD16   (SD_CARD_CMD0 | 16)
#define SD_CARD_CMD17   (SD_CARD_CMD0 | 17)
#define SD_CARD_CMD18   (SD_CARD_CMD0 | 18)
#define SD_CARD_CMD24   (SD_CARD_CMD0 | 24)
#define SD_CARD_CMD25   (SD_CARD_CMD0 | 25)
#define SD_CARD_CMD55   (SD_CARD_CMD0 | 55)
#define SD_CARD_CMD58   (SD_CARD_CMD0 | 58)
#define SD_CARD_ACMD41  (SD_CARD_CMD0 | 41)

#define SD_TYPE_ERR     0x0
#define SD_TYPE_V2      0x1
#define SD_TYPE_V2HC    0x2
#define SD_TYPE_V1      0x3
#define SD_TYPE_MMC     0x4

#define BUFFER_SIZE     512

void init_qspi();

uint32_t init_sd_card();

uint8_t read_sd_card(uint32_t block_address, uint8_t *buffer, uint32_t buffer_size, uint32_t cnt);

uint8_t sd_send_cmd(uint32_t cmd, uint32_t arg, uint8_t *recv_data, uint32_t recv_size);
#endif