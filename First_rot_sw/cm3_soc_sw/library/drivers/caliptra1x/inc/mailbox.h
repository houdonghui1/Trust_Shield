//===============================================
//
//	File: mailbox.h
//	Author: afterGlow,4ever
//	Group: Fall For Laboratory
//	Date: 12272023
//	Version: v1.0
//
// 	This is header file for mailbox driver.
//
//===============================================

#ifndef __MAIL_BOX_H_
#define __MAIL_BOX_H_

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <caliptra_top_reg.h>
#include "drv_caliptra1x.h"
#include "caliptra_enums.h"
#include "caliptra_types.h"

#define CALIPTRA_MAILBOX_MAX_SIZE (128u * 1024u)

#define MBOX_SUCCESS 0x11111111
#define MBOX_FAILED  0x22222222

typedef enum
{
    CMD_BUSY = 0,
	DATA_READY,
	CMD_COMPLETE,
    CMD_FAILURE
}mbox_status_reg;

typedef struct {
    uint8_t *indata;
    uint32_t inlen;
    uint8_t *outdata;
    uint32_t outlen;
} data_comm;

enum caliptra_mailbox_status {
    CALIPTRA_MBOX_STATUS_BUSY         = 0,
    CALIPTRA_MBOX_STATUS_DATA_READY   = 1,
    CALIPTRA_MBOX_STATUS_CMD_COMPLETE = 2,
    CALIPTRA_MBOX_STATUS_CMD_FAILURE  = 3,
};

enum caliptra_mailbox_fsm_states {
    CALIPTRA_MBOX_STATUS_FSM_IDLE           = 0,
    CALIPTRA_MBOX_STATUS_FSM_READY_FOR_CMD  = 1,
    CALIPTRA_MBOX_STATUS_FSM_READY_FOR_DATA = 2,
    CALIPTRA_MBOX_STATUS_FSM_READY_FOR_DLEN = 3,
    CALIPTRA_MBOX_STATUS_FSM_EXECUTE_SOC    = 4,
    CALIPTRA_MBOX_STATUS_FSM_EXECUTE_UC     = 6,
};

enum mailbox_command {
    OP_CALIPTRA_FW_LOAD            = 0x46574C44, // "FWLD"
    OP_GET_IDEV_CERT               = 0x49444543, // "IDEC"
    OP_GET_IDEV_INFO               = 0x49444549, // "IDEI"
    OP_POPULATE_IDEV_CERT          = 0x49444550, // "IDEP"
    OP_GET_LDEV_CERT               = 0x4C444556, // "LDEV"
    OP_GET_FMC_ALIAS_CERT          = 0x43455246, // "CERF"
    OP_GET_RT_ALIAS_CERT           = 0x43455252, // "CERR"
    OP_ECDSA384_VERIFY             = 0x53494756, // "SIGV"
    OP_LMS_VERIFY                  = 0x4C4D5356, // "LMSV"
    OP_STASH_MEASUREMENT           = 0x4D454153, // "MEAS"
    OP_INVOKE_DPE_COMMAND          = 0x44504543, // "DPEC"
    OP_DISABLE_ATTESTATION         = 0x4453424C, // "DSBL"
    OP_FW_INFO                     = 0x494E464F, // "INFO"
    OP_DPE_TAG_TCI                 = 0x54514754, // "TAGT"
    OP_DPE_GET_TAGGED_TCI          = 0x47544744, // "GTGD"
    OP_INCREMENT_PCR_RESET_COUNTER = 0x50435252, // "PCRR"
    OP_QUOTE_PCRS                  = 0x50435251, // "PCRQ"
    OP_EXTEND_PCR                  = 0x50435245, // "PCRE"
    OP_ADD_SUBJECT_ALT_NAME        = 0x414C544E, // "ALTN"
    OP_CERTIFY_KEY_EXTENDED        = 0x434B4558, // "CKEX"
    OP_FIPS_VERSION                = 0x46505652, // "FPVR"
    OP_SELF_TEST_START             = 0x46504C54, // "FPST"
    OP_SELF_TEST_GET_RESULTS       = 0x46504C67, // "FPGR"
    OP_SHUTDOWN                    = 0x46505344, // "FPSD"
    OP_CAPABILITIES                = 0x43415053, // "CAPS"
    OP_CMD_VERIFY_CERT             = 0x44C0FFEE,
    OP_GET_CA_CERT                 = 0x44C0FFEF,
    OP_GET_LDEVID_CERT             = 0x44C0FFF0,
    OP_GET_FMC_CERT                = 0x44C0FFF1,
    OP_GET_RT_CERT                 = 0x44C0FFF2,
    OP_GET_TRNG                    = 0x44C0FFF3,
    OP_GET_SOC_MEASURE_VALUE       = 0x44C0FFF4,
    OP_GET_FMC_MEASURE_VALUE       = 0x44C0FFF5,
    OP_GET_RT_MEASURE_VALUE        = 0x44C0FFF6,
    OP_GET_ECC_SIGN                = 0x44C0FFF7,
    OP_GET_ECC_VERIFY              = 0x44C0FFF8,
    OP_GET_ROM_MEASURE_VALUE       = 0x44C0FFF9,
    OP_SEND_INITIATE               = 0x44C0FFFA,
    OP_RECV_CLP_CSR                = 0x44C0FFFB,
    OP_RECV_CLP_CTX                = 0x44C0FFFC,
    OP_RECV_SOC_FW                 = 0x1A2B3C4D,
};

struct parcel {
    enum mailbox_command  command;
    uint8_t              *tx_buffer;
    size_t                tx_bytes;
    uint8_t              *rx_buffer;
    size_t                rx_bytes;
};

enum mailbox_results {
    SUCCESS        = 0x00000000,
    BAD_VENDOR_SIG = 0x56534947, // "VSIG"
    BAD_OWNER_SIG  = 0x4F534947, // "OSIG"
    BAD_SIG        = 0x42534947, // "BSIG"
    BAD_IMAGE      = 0x42494D47, // "BIMG"
    BAD_CHKSUM     = 0x4243484B, // "BCHK"
};

static inline void delay_ms(unsigned int milliseconds) {
    while (milliseconds != 0) {
        milliseconds--;
    }
}

static inline void caliptra_mbox_write(uint32_t offset, uint32_t data)
{
    writereg32((offset + CALIPTRA_TOP_REG_MBOX_CSR_BASE_ADDR), data);
}

static inline uint32_t caliptra_mbox_read(uint32_t offset)
{
    uint32_t data;
    data = readreg32(offset + CALIPTRA_TOP_REG_MBOX_CSR_BASE_ADDR);
    return data;
}

static inline bool caliptra_mbox_is_lock()
{
    return (caliptra_mbox_read(MBOX_CSR_MBOX_LOCK) & MBOX_CSR_MBOX_LOCK_LOCK_MASK);
}

static inline void caliptra_mbox_write_cmd(uint32_t cmd)
{
    caliptra_mbox_write(MBOX_CSR_MBOX_CMD, cmd);
}

static inline uint32_t caliptra_mbox_read_execute()
{
    return caliptra_mbox_read(MBOX_CSR_MBOX_EXECUTE);
}

static inline void caliptra_mbox_write_execute(bool ex)
{
    caliptra_mbox_write(MBOX_CSR_MBOX_EXECUTE, ex);
}

static inline uint8_t caliptra_mbox_write_execute_busy_wait(bool ex)
{
    caliptra_mbox_write(MBOX_CSR_MBOX_EXECUTE, ex);
    uint8_t status;
    while((status = (uint8_t)(caliptra_mbox_read(MBOX_CSR_MBOX_STATUS) & MBOX_CSR_MBOX_STATUS_STATUS_MASK)) == CALIPTRA_MBOX_STATUS_BUSY)
    {
       delay_ms(10);
    }

    return status;
}

static inline uint8_t caliptra_mbox_read_status(void)
{
    return (uint8_t)(caliptra_mbox_read(MBOX_CSR_MBOX_STATUS) & MBOX_CSR_MBOX_STATUS_STATUS_MASK);
}

static inline bool caliptra_mbox_is_busy(void)
{
    return caliptra_mbox_read_status() == CALIPTRA_MBOX_STATUS_BUSY;
}

static inline uint8_t caliptra_mbox_read_status_fsm(void)
{
    return (uint8_t)(caliptra_mbox_read(MBOX_CSR_MBOX_STATUS) & MBOX_CSR_MBOX_STATUS_MBOX_FSM_PS_MASK) >> MBOX_CSR_MBOX_STATUS_MBOX_FSM_PS_LOW;
}

static inline uint32_t caliptra_mbox_read_dlen(void)
{
    return caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
}

static inline void caliptra_mbox_write_dlen(uint32_t dlen)
{
    caliptra_mbox_write(MBOX_CSR_MBOX_DLEN, dlen);
}

bool caliptra_test_for_completion();
int  caliptra_complete();
int caliptra_check_status_get_response(struct caliptra_buffer *mbox_rx_buffer, uint32_t *bytes_read);
int pack_and_execute_command(struct parcel *parcel, bool async);
#endif

