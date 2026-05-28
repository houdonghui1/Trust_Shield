//===============================================
//
//	File: main.c
//	Author: afterGlow,4ever
//	Group: Fall For Laboratory
//	Date: 08182023
//	Version: v1.0
//
// 	This is bootloader for mcu in itcm.
//	Including:
//	1. system init
//
//===============================================

#include "main.h"

#define FWSTORE_ADDR 0x00040000

UART_HandleTypeDef huart0;

typedef struct {
    uint32_t* initial_sp;
    void (*fwstore)(void);
} FWstore_t;

static inline void memcpy_fw_to_fwstore(const void *src, void *dest, uint32_t size) {
  uint32_t *src_ptr = (uint32_t *)src;
  uint32_t *dest_ptr = (uint32_t *)dest;

  for (uint32_t i = 0; i < size / sizeof(uint32_t); i++) {
      dest_ptr[i] = src_ptr[i];
  }
}

int Validate_TargetBootloader(uint32_t target_base) 
{
    FWstore_t *vt = (FWstore_t*)target_base;

    if ((uint32_t)vt->initial_sp > 0x6FFFF) {
        return 1;
    }

    if ((uint32_t)vt->fwstore > 0x6FFFF) {
        return 1;
    }

    return 0;
}

void jump_to_FWstore(uint32_t fwstore_base) 
{
    __disable_irq();

    SCB->VTOR = fwstore_base;

    __set_MSP(*(volatile uint32_t*)fwstore_base);

    void (*target_reset)(void) = (void (*)(void))(*(volatile uint32_t*)(fwstore_base + 4));

    target_reset();

    while(1);
}

int main(void)
{
	uint8_t ch;
    uint32_t status;
    uint8_t tx_buffer[4] = {0};
    uint8_t rx_buffer[8704] = {0};

	huart0.regs = UART0;
	drv_uart_default_config(&huart0);
	drv_uart_init(&huart0);

	drv_uart_printf("------------------------------------\n");
    drv_uart_printf("               SOC ROM...           \n");
    drv_uart_printf("------------------------------------\n");
    drv_uart_printf("Compiled on: %s at %s\n", __DATE__, __TIME__);

    writereg32(CALIPTRA_TOP_REG_GENERIC_AND_FUSE_REG_CPTRA_DBG_MANUF_SERVICE_REG, GENERIC_AND_FUSE_REG_CPTRA_SECURITY_STATE_SCAN_MODE_MASK);

    test_info info = {
        .rom = {NULL},
        .image_bundle = {NULL},
        .fuses = {{0}},
    };

	caliptra1x_set_fuses(&info);

	status = caliptra1x_drv_init(&info,false);
	drv_uart_printf("func: %s, line: %d, status = %d\n", __func__, __LINE__, status);

    struct parcel parcel = {
        .command = OP_RECV_SOC_FW,
        .tx_buffer = tx_buffer,
        .tx_bytes = sizeof(tx_buffer),
        .rx_buffer = rx_buffer,
        .rx_bytes = sizeof(rx_buffer)
    };

    status = 1;
    while(status){
        status = pack_and_execute_command(&parcel, false);
        drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
    }

    drv_uart_printf("soc firmware:\n");
    for(uint32_t j = 0; j < parcel.rx_bytes; j++) {
        drv_uart_printf("0x%02x ", parcel.rx_buffer[j]);
        if (j % 16 == 15) {
            drv_uart_printf("\n");
        }
    }

    memcpy_fw_to_fwstore(parcel.rx_buffer, (void *)FWSTORE_ADDR, parcel.rx_bytes);
	if(!Validate_TargetBootloader(FWSTORE_ADDR)) {
		drv_uart_printf("func: %s, line: %d \r\n", __func__, __LINE__);
		jump_to_FWstore(FWSTORE_ADDR);
	}

	while(1)
	{
		drv_uart_getchar(&huart0, &ch);
		drv_uart_putchar(&huart0, &ch);
	}
}