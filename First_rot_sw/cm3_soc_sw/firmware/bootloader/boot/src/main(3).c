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

UART_HandleTypeDef huart0;

const uint32_t test_val[8] = {
    0xaad2d921,0x940c549f,0x78c3b9ec,0xce474feb,0xa0ce0357,0x08405815,0x1b1e98c9,0xfa3d4635
}
;
enum sha_accel_mode_e {
    SHA_STREAM_384 = 0x0,
    SHA_STREAM_512 = 0x1,
    SHA_MBOX_384   = 0x2,
    SHA_MBOX_512   = 0x3,
};

//SHA Accelerator
void soc_ifc_sha_accel_acquire_lock() {
    while((readreg32(CALIPTRA_TOP_REG_SHA512_ACC_CSR_LOCK) & SHA512_ACC_CSR_LOCK_LOCK_MASK) == 1);
}

void soc_ifc_sha_accel_wr_user() {
    writereg32((CALIPTRA_TOP_REG_SHA512_ACC_CSR_USER), 0xFFFFFFFF);
}

void soc_ifc_sha_accel_wr_mode(enum sha_accel_mode_e mode) {
    uint32_t reg;
    reg = ((mode << SHA512_ACC_CSR_MODE_MODE_LOW) & SHA512_ACC_CSR_MODE_MODE_MASK) | 
            SHA512_ACC_CSR_MODE_ENDIAN_TOGGLE_MASK; //set endian toggle so we read from the mailbox as is
    writereg32(CALIPTRA_TOP_REG_SHA512_ACC_CSR_MODE,reg);
}

void soc_ifc_sha_accel_execute() {
    writereg32((CALIPTRA_TOP_REG_SHA512_ACC_CSR_EXECUTE), SHA512_ACC_CSR_EXECUTE_EXECUTE_MASK);
}

void soc_ifc_sha_accel_poll_status() {
    while((readreg32(CALIPTRA_TOP_REG_SHA512_ACC_CSR_STATUS) & SHA512_ACC_CSR_STATUS_VALID_MASK) == 0);
}

void soc_ifc_sha_accel_clr_lock() {
    //Write one to clear
    writereg32((CALIPTRA_TOP_REG_SHA512_ACC_CSR_LOCK), SHA512_ACC_CSR_LOCK_LOCK_MASK);
}

int main(void)
{
    uint32_t status;
    uint32_t reg_addr;
    uint32_t read_data;
    enum sha_accel_mode_e mode = SHA_STREAM_384;

    drv_uart_default_config(&huart0);
    drv_uart_init(&huart0);
    drv_uart_int_disable(&huart0, 0xFFFFFFFF);
    drv_uart_int_allclear(&huart0);

    test_info info = {
        .rom = {NULL},
        .image_bundle = {NULL},
        .fuses = {{0}},
    };

	set_fuses(&info);

	status = drv_caliptra1x_init(&info,false);

    soc_ifc_sha_accel_wr_user();

    soc_ifc_sha_accel_acquire_lock();
    
    soc_ifc_sha_accel_wr_mode(mode);

    writereg32((uintptr_t) (CALIPTRA_TOP_REG_SHA512_ACC_CSR_DLEN), 32);

    for (int i = 0; i < 8; i++) {
        writereg32((uintptr_t) (CALIPTRA_TOP_REG_SHA512_ACC_CSR_DATAIN), test_val[i]);
    }

    soc_ifc_sha_accel_execute();

    soc_ifc_sha_accel_poll_status();

    reg_addr = CALIPTRA_TOP_REG_SHA512_ACC_CSR_DIGEST_0;
    while (reg_addr <= ((mode == SHA_MBOX_384) ? CALIPTRA_TOP_REG_SHA512_ACC_CSR_DIGEST_11 : CALIPTRA_TOP_REG_SHA512_ACC_CSR_DIGEST_15)) {
        read_data = readreg32(reg_addr);
        reg_addr = reg_addr + 4;
    }

    soc_ifc_sha_accel_clr_lock();

/////
    soc_ifc_sha_accel_acquire_lock();
    
    soc_ifc_sha_accel_wr_mode(mode);

    writereg32((uintptr_t) (CALIPTRA_TOP_REG_SHA512_ACC_CSR_DLEN), 32);

    for (int i = 0; i < 8; i++) {
        writereg32((uintptr_t) (CALIPTRA_TOP_REG_SHA512_ACC_CSR_DATAIN), test_val[i]);
    }

    soc_ifc_sha_accel_execute();

    soc_ifc_sha_accel_poll_status();

    reg_addr = CALIPTRA_TOP_REG_SHA512_ACC_CSR_DIGEST_0;
    while (reg_addr <= ((mode == SHA_MBOX_384) ? CALIPTRA_TOP_REG_SHA512_ACC_CSR_DIGEST_11 : CALIPTRA_TOP_REG_SHA512_ACC_CSR_DIGEST_15)) {
        read_data = readreg32(reg_addr);
        reg_addr = reg_addr + 4;
    }

    soc_ifc_sha_accel_clr_lock();


    drv_uart_printf("Test completed\n");
}