// See LICENSE.Sifive for license details.
#include <stdint.h>
#include <platform.h>
#include "common.h"
#include "kprintf.h"
#include "drv_caliptra1x.h"
#include "mailbox.h"

#define FWSTORE_ADDR 0x8000000UL

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

int Validate_TargetBootloader(uint32_t target_base) {
    uintptr_t base = (uintptr_t)target_base;
    FWstore_t *vt = (FWstore_t*)base;
    

    if ((uintptr_t)vt->fwstore < 0x8000000 || (uintptr_t)vt->fwstore > 0x8FFFFFF) {
        kprintf("Invalid reset vector: 0x%08x (expected 0x8000000-0x8FFFFFF)\n", (uintptr_t)vt->fwstore);
        return 1;
    }

    return 0;
}

int main(void)
{
    uint32_t status;
    uint8_t tx_buffer[4] = {0};
    uint8_t rx_buffer[9728] = {0};

	REG32(uart, UART_REG_TXCTRL) = UART_TXEN;
    REG32(uart, UART_REG_RXCTRL) = UART_RXEN;
	kprintf("------------------------------------\n");
    kprintf("               SOC ROM...           \n");
    kprintf("------------------------------------\n");
    kprintf("Compiled on: %s at %s\n", __DATE__, __TIME__);

    writereg32(CALIPTRA_TOP_REG_GENERIC_AND_FUSE_REG_CPTRA_DBG_MANUF_SERVICE_REG, GENERIC_AND_FUSE_REG_CPTRA_SECURITY_STATE_SCAN_MODE_MASK);

    test_info info = {
        .rom = {NULL},
        .image_bundle = {NULL},
        .fuses = {{0}},
    };

	caliptra1x_set_fuses(&info);
    kprintf("func: %s, line: %d \r\n", __func__, __LINE__);
	status = caliptra1x_drv_init(&info,false);
	kprintf("func: %s, line: %d, status = %x\n", __func__, __LINE__, status);

    struct parcel parcel = {
        .command = OP_RECV_SOC_FW,
        .tx_buffer = tx_buffer,
        .tx_bytes = sizeof(tx_buffer),
        .rx_buffer = rx_buffer,
        .rx_bytes = sizeof(rx_buffer)
    };
    kprintf("func: %s, line: %d \r\n", __func__, __LINE__);
    status = 1;
    while(status){
        status = pack_and_execute_command(&parcel, false);
        kprintf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
    }

    kprintf("soc firmware:\n");
    for(uint32_t j = 0; j < parcel.rx_bytes; j++) {
        kprintf("0x%02x ", parcel.rx_buffer[j]);
        if (j % 16 == 15) {
            kprintf("\n");
        }
    }

    memcpy_fw_to_fwstore(parcel.rx_buffer, (void *)FWSTORE_ADDR, parcel.rx_bytes);

	return 0;
}
