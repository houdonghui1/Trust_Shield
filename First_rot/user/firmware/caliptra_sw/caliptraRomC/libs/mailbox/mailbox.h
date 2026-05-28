#ifndef __MAIL_BOX_H_
#define __MAIL_BOX_H_

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "caliptra_reg.h"
#include "riscv_hw_if.h"
#include "soc_ifc.h"
#include "printf.h"

#define MAX_MAILBOX_LEN (128 * 1024)

#define MBOX_SUCCESS 0x11111111
#define MBOX_FAILED  0x22222222

// Mailbox status enumeration
typedef enum {
    MBOX_STATUS_CMD_BUSY,
    MBOX_STATUS_DATA_READY,
    MBOX_STATUS_CMD_COMPLETE,
    MBOX_STATUS_CMD_FAILURE,
    MBOX_STATUS_INVALID
} MboxStatusE;

// Mailbox operation states
typedef enum {
    MBOX_OP_STATE_IDLE,
    MBOX_OP_STATE_RDY_FOR_CMD,
    MBOX_OP_STATE_RDY_FOR_DATA,
    MBOX_OP_STATE_RDY_FOR_DLEN,
    MBOX_OP_MBOX_EXECUTE_SOC,
    MBOX_OP_STATE_EXECUTE,
    MBOX_OP_EXECUTE_UC,
    MBOX_OP_MBOX_ERROR
} MailboxOpState;

// Mailbox register structure
typedef struct {
    volatile uint32_t *base_addr;
} Mailbox;

// Mailbox send transaction
typedef struct {
    MailboxOpState state;
    Mailbox *mbox;
} MailboxSendTxn;

// Mailbox receive transaction
typedef struct {
    MailboxOpState state;
    Mailbox *mbox;
} MailboxRecvTxn;

// Function prototypes
Mailbox mailbox_new(uintptr_t base_addr);
MailboxSendTxn mailbox_try_start_send_txn(Mailbox *mbox);
MailboxSendTxn mailbox_wait_until_start_send_txn(Mailbox *mbox);
MailboxRecvTxn mailbox_try_start_recv_txn(Mailbox *mbox);
void mailbox_abort_pending_soc_to_uc_transactions(void);

// Send transaction methods
int mailbox_send_write_cmd(MailboxSendTxn *txn, uint32_t cmd);
int mailbox_send_write_dlen(MailboxSendTxn *txn, uint32_t dlen);
int mailbox_send_copy_request(MailboxSendTxn *txn, uint32_t cmd, const uint8_t *data, size_t len);
int mailbox_send_execute_request(MailboxSendTxn *txn);
int mailbox_send_send_request(MailboxSendTxn *txn, uint32_t cmd, const uint8_t *data, size_t len);
bool mailbox_send_is_response_ready(const MailboxSendTxn *txn);
MboxStatusE mailbox_send_status(const MailboxSendTxn *txn);
int mailbox_send_complete(MailboxSendTxn *txn);

// Receive transaction methods
uint32_t mailbox_recv_cmd(const MailboxRecvTxn *txn);
uint32_t mailbox_recv_dlen(const MailboxRecvTxn *txn);
const uint8_t* mailbox_recv_raw_contents(const MailboxRecvTxn *txn);
int mailbox_recv_drop_words(MailboxRecvTxn *txn, size_t count);
int mailbox_recv_copy_request(MailboxRecvTxn *txn, uint8_t *data, size_t len);
int mailbox_recv_recv_request(MailboxRecvTxn *txn, uint8_t *data, size_t len);
int mailbox_recv_send_response(MailboxRecvTxn *txn, const uint8_t *data, size_t len);
int mailbox_recv_complete(MailboxRecvTxn *txn, bool success);

uint32_t mailbox_send_data(uint32_t *mbox_data, uint32_t data_size);
#endif