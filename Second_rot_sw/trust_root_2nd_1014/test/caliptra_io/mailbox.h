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

#include <linux/module.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include "mem_utils.h"


typedef __u32 uint32_t;
typedef __u64 uint64_t;

#define CALIPTRA_MAILBOX_MAX_SIZE (128u * 1024u)

#define MBOX_SUCCESS 0x11111111
#define MBOX_FAILED  0x22222222

#define CALIPTRA_TOP_REG_MBOX_CSR_BASE_ADDR                                                         (0x20000)
#define CALIPTRA_TOP_REG_MBOX_CSR_MBOX_LOCK                                                         (0x20000)
#define MBOX_CSR_MBOX_LOCK                                                                          (0x0)
#define MBOX_CSR_MBOX_LOCK_LOCK_LOW                                                                 (0)
#define MBOX_CSR_MBOX_LOCK_LOCK_MASK                                                                (0x1)
#define MBOX_CSR_MBOX_USER                                                                          (0x4)
#define MBOX_CSR_MBOX_CMD                                                                           (0x8)
#define MBOX_CSR_MBOX_DLEN                                                                          (0xc)
#define MBOX_CSR_MBOX_DATAIN                                                                        (0x10)
#define MBOX_CSR_MBOX_DATAOUT                                                                       (0x14)
#define MBOX_CSR_MBOX_EXECUTE                                                                       (0x18)
#define MBOX_CSR_MBOX_EXECUTE_EXECUTE_LOW                                                           (0)
#define MBOX_CSR_MBOX_EXECUTE_EXECUTE_MASK                                                          (0x1)
#define MBOX_CSR_MBOX_STATUS                                                                        (0x1c)
#define MBOX_CSR_MBOX_STATUS_STATUS_LOW                                                             (0)
#define MBOX_CSR_MBOX_STATUS_STATUS_MASK                                                            (0xf)
#define MBOX_CSR_MBOX_STATUS_ECC_SINGLE_ERROR_LOW                                                   (4)
#define MBOX_CSR_MBOX_STATUS_ECC_SINGLE_ERROR_MASK                                                  (0x10)
#define MBOX_CSR_MBOX_STATUS_ECC_DOUBLE_ERROR_LOW                                                   (5)
#define MBOX_CSR_MBOX_STATUS_ECC_DOUBLE_ERROR_MASK                                                  (0x20)
#define MBOX_CSR_MBOX_STATUS_MBOX_FSM_PS_LOW                                                        (6)
#define MBOX_CSR_MBOX_STATUS_MBOX_FSM_PS_MASK                                                       (0x1c0)
#define MBOX_CSR_MBOX_STATUS_SOC_HAS_LOCK_LOW                                                       (9)
#define MBOX_CSR_MBOX_STATUS_SOC_HAS_LOCK_MASK                                                      (0x200)
#define MBOX_CSR_MBOX_STATUS_MBOX_RDPTR_LOW                                                         (10)
#define MBOX_CSR_MBOX_STATUS_MBOX_RDPTR_MASK                                                        (0x1fffc00)
#define MBOX_CSR_MBOX_UNLOCK                                                                        (0x20)
#define MBOX_CSR_MBOX_UNLOCK_UNLOCK_LOW                                                             (0)
#define MBOX_CSR_MBOX_UNLOCK_UNLOCK_MASK                                                            (0x1)

typedef uint32_t caliptra_checksum;

enum libcaliptra_error {
    NO_ERROR = 0,
    // General API
    INVALID_PARAMS              = 0x100,
    API_INTERNAL_ERROR          = 0x101,
    REG_ACCESS_ERROR            = 0x102,
    PAUSER_LOCKED               = 0x103,
    FW_LOAD_NOT_IN_PROGRESS     = 0x104,
    // Fuse
    NOT_READY_FOR_FUSES         = 0x200,
    STILL_READY_FOR_FUSES       = 0x201,
    // Mailbox
    MBX_BUSY                    = 0x300,
    MBX_NO_MSG_PENDING          = 0x301,
    MBX_COMPLETE_NOT_READY      = 0x302,
    MBX_STATUS_FAILED           = 0x303,
    MBX_STATUS_UNKNOWN          = 0x304,
    MBX_STATUS_NOT_IDLE         = 0x305,
    MBX_RESP_NO_HEADER          = 0x306,
    MBX_RESP_CHKSUM_INVALID     = 0x307,
    MBX_RESP_FIPS_NOT_APPROVED  = 0x308,

    // MFG
    IDEV_CSR_NOT_READY = 0x400,
};

typedef struct caliptra_buffer {
  const uint8_t *data; //< Pointer to a buffer with data to send/space to receive
  uintptr_t len;       //< Size of the buffer
} caliptra_buffer;

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
    OP_GET_SOC_MEASURE_VALUE 	   = 0x44C0FFF4,
    OP_GET_FMC_MEASURE_VALUE 	   = 0x44C0FFF5,
    OP_GET_RT_MEASURE_VALUE 	   = 0x44C0FFF6,
    OP_ECC_SIGN 		   = 0x44C0FFF7,
    OP_ECC_VERIFY 		   = 0x44C0FFF8,
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

bool caliptra_test_for_completion(void);
int  caliptra_complete(void);
int caliptra_check_status_get_response(struct caliptra_buffer *mbox_rx_buffer, uint32_t *bytes_read);
int pack_and_execute_command(struct parcel *parcel, bool async);
#endif


