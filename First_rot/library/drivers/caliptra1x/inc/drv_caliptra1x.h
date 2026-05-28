//===============================================
//
//	File: drv_caliptra1x.h
//	Author: afterGlow,4ever
//	Group: Fall For Laboratory
//	Date: 12272023
//	Version: v1.0
//
// 	This is header file for caliptra1x driver.
//
//===============================================

#ifndef __DRV_CALIPTRA1X_H_
#define __DRV_CALIPTRA1X_H_

#include "mcu_operation.h"
#include "drv_defines.h"
#include "caliptra_top_reg.h"

static const uint32_t default_uds_seed[] = {    0x00010203, 0x04050607, 0x08090a0b, 0x0c0d0e0f,
                                                0x10111213, 0x14151617, 0x18191a1b, 0x1c1d1e1f,
                                                0x20212223, 0x24252627, 0x28292a2b, 0x2c2d2e2f };

static const uint32_t default_field_entropy[] = {   0x80818283, 0x84858687, 0x88898a8b, 0x8c8d8e8f,
                                                    0x90919293, 0x94959697, 0x98999a9b, 0x9c9d9e9f };

#define ECC384_SCALAR_BYTE_SIZE 48
#define ECC384_SCALAR_WORD_SIZE 12
#define SHA384_DIGEST_BYTE_SIZE 48
#define SHA384_DIGEST_WORD_SIZE 12
#define SHA192_DIGEST_BYTE_SIZE 24
#define SHA192_DIGEST_WORD_SIZE 6
#define IMAGE_LMS_OTS_P_PARAM   51
#define IMAGE_LMS_KEY_HEIGHT    15
#define IMAGE_BYTE_SIZE         (128 * 1024)

#define CALIPTRA_ARRAY_SIZE(array) ((size_t)(sizeof(array) / sizeof(array[0])))

//===============================================
// caliptra1x comm structure
//===============================================
typedef struct {
    uint8_t *indata;
    uint32_t inlen;
    uint8_t *outdata;
    uint32_t outlen;
} data_comm;

//===============================================
// caliptra1x enum
//===============================================
typedef enum
{
	DATA_READY,
	CMD_COMPLETE,
    CMD_FAILURE,
    CMD_BUSY
}mbox_status_reg;

//===============================================
// caliptra1x handler
//===============================================
/**
 * device_lifecycle
 *
 * Device life cycle states
 */
enum device_lifecycle {
    Unprovisioned = 0,
    Manufacturing = 1,
    Reserved2 = 2,
    Production = 3,
};
/**
 * caliptra_fuses
 *
 * Fuse data to be written to Caliptra registers
 */
struct caliptra_fuses {
    uint32_t uds_seed[12];
    uint32_t field_entropy[8];
    uint32_t key_manifest_pk_hash[12];
    uint32_t key_manifest_pk_hash_mask : 4;
    uint32_t rsvd : 28;
    uint32_t owner_pk_hash[12];
    uint32_t fmc_key_manifest_svn;
    uint32_t runtime_svn[4];
    bool anti_rollback_disable;
    uint32_t idevid_cert_attr[24];
    uint32_t idevid_manuf_hsm_id[4];
    enum device_lifecycle life_cycle;
    bool lms_verify;
    uint32_t lms_revocation;
    uint16_t soc_stepping_id;
};

typedef struct caliptra_buffer {
    const uint8_t *data; //< Pointer to a buffer with data to send/space to receive
    uintptr_t len;       //< Size of the buffer
  } caliptra_buffer;

typedef struct test_info {
    struct caliptra_buffer rom;
    struct caliptra_buffer image_bundle;
    struct caliptra_fuses fuses;
  } test_info;
//===============================================
// caliptra1x inline function
//===============================================

static inline uint32_t caliptra_generic_and_fuse_read(uint32_t offset)
{
    uint32_t data;
    data = readreg32((offset + CALIPTRA_TOP_REG_GENERIC_AND_FUSE_REG_BASE_ADDR));
    return data;
}

static inline void caliptra_generic_and_fuse_write(uint32_t offset, uint32_t data) 
{
    writereg32((offset + CALIPTRA_TOP_REG_GENERIC_AND_FUSE_REG_BASE_ADDR), data);
}

static inline void caliptra_fuse_array_write(uint32_t offset, const uint32_t *data, size_t size)
{
    for (uint32_t idx = 0; idx < size; idx ++)
    {
        caliptra_generic_and_fuse_write((offset + (idx * sizeof(uint32_t))), data[idx]);
    }
}

static inline void caliptra_wdt_cfg_write(uint64_t data)
{
    caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_CPTRA_WDT_CFG_0, (uint32_t)data);
    caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_CPTRA_WDT_CFG_1, (uint32_t)(data >> 32));
}

static inline void caliptra_write_itrng_entropy_low_threshold(uint16_t data)
{
    uint32_t val = caliptra_generic_and_fuse_read(GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_0);
    val &= ~GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_0_LOW_THRESHOLD_MASK;
    val |= data & GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_0_LOW_THRESHOLD_MASK;
    caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_0, val);
}

static inline void caliptra_write_itrng_entropy_high_threshold(uint16_t data)
{
    uint32_t val = caliptra_generic_and_fuse_read(GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_0);
    val &= ~GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_0_HIGH_THRESHOLD_MASK;
    val |= (data << GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_0_HIGH_THRESHOLD_LOW)
            & GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_0_HIGH_THRESHOLD_MASK;
    caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_0, val);
}

static inline void caliptra_write_itrng_entropy_repetition_count(uint16_t data)
{
    uint32_t val = caliptra_generic_and_fuse_read(GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_1);
    val &= ~GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_1_REPETITION_COUNT_MASK;
    val |= data & GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_1_REPETITION_COUNT_MASK;
    caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_CPTRA_ITRNG_ENTROPY_CONFIG_1, val);
}

void set_fuses(test_info* info);

bool drv_caliptra1x_init(const test_info* info, bool req_idev_csr);

bool drv_caliptra1x_tx_data(data_comm* data);

bool drv_caliptra1x_rx_data(data_comm* data);

bool drv_caliptra1x_comm(data_comm* data);

//===============================================
// caliptra1x driver function header
//===============================================


#endif

