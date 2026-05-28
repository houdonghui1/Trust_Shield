#include "mailbox.h"

// ----------------- Send Transaction Functions -----------------

MailboxSendTxn mailbox_try_start_send_txn(Mailbox *mbox) {
  MailboxSendTxn txn = {
      .state = MBOX_OP_STATE_RDY_FOR_CMD,
      .mbox = mbox
  };
  
  if ((lsu_read_32(CLP_MBOX_CSR_MBOX_LOCK) & MBOX_CSR_MBOX_LOCK_LOCK_MASK) == 1 ) {
      txn.state = MBOX_OP_STATE_IDLE; // Indicate failure
  }
  return txn;
}

MailboxSendTxn mailbox_wait_until_start_send_txn(Mailbox *mbox) {
  while ((lsu_read_32(CLP_MBOX_CSR_MBOX_LOCK) & MBOX_CSR_MBOX_LOCK_LOCK_MASK) == 1 );
  
  MailboxSendTxn txn = {
      .state = MBOX_OP_STATE_RDY_FOR_CMD,
      .mbox = mbox
  };
  return txn;
}

int mailbox_send_write_cmd(MailboxSendTxn *txn, uint32_t cmd) {
  if (txn->state != MBOX_OP_STATE_RDY_FOR_CMD) {
      return -1; // Error code
  }
  
  lsu_write_32(CLP_MBOX_CSR_MBOX_CMD, cmd);
  txn->state = MBOX_OP_STATE_RDY_FOR_DLEN;
  return 0;
}

int mailbox_send_write_dlen(MailboxSendTxn *txn, uint32_t dlen) {
  if (txn->state != MBOX_OP_STATE_RDY_FOR_DLEN || dlen > MAX_MAILBOX_LEN) {
      return -1;
  }
  lsu_write_32(CLP_MBOX_CSR_MBOX_DLEN, dlen);
  txn->state = MBOX_OP_STATE_RDY_FOR_DATA;
  return 0;
}

int mailbox_send_copy_request(MailboxSendTxn *txn, uint32_t cmd, const uint8_t *data, size_t len) {
  if (txn->state != MBOX_OP_STATE_RDY_FOR_CMD) {
      return -1;
  }
  
  if (mailbox_send_write_cmd(txn, cmd) != 0) {
      return -1;
  }
  
  if (mailbox_send_write_dlen(txn, len) != 0) {
      return -1;
  }
  
  // Copy data to mailbox (simplified)
  for (size_t i = 0; i < len; i += 4) {
      uint32_t word;
      memcpy(&word, data + i, sizeof(uint32_t));
      lsu_write_32(CLP_MBOX_CSR_MBOX_DATAOUT, word);
  }
  
  txn->state = MBOX_OP_STATE_RDY_FOR_DATA;
  return 0;
}

int mailbox_send_execute_request(MailboxSendTxn *txn) {
  if (txn->state != MBOX_OP_STATE_RDY_FOR_DATA) {
      return -1;
  }
  lsu_write_32(CLP_MBOX_CSR_MBOX_EXECUTE, MBOX_CSR_MBOX_EXECUTE_EXECUTE_MASK);
  txn->state = MBOX_OP_STATE_EXECUTE;
  return 0;
}

int mailbox_send_send_request(MailboxSendTxn *txn, uint32_t cmd, const uint8_t *data, size_t len) {
  if (mailbox_send_copy_request(txn, cmd, data, len) != 0) {
      return -1;
  }
  return mailbox_send_execute_request(txn);
}

bool mailbox_send_is_response_ready(const MailboxSendTxn *txn) {

  uint32_t reg_val = lsu_read_32((CLP_MBOX_CSR_MBOX_LOCK));
  uint32_t status = reg_val & 0x3;
  return (status == MBOX_STATUS_CMD_COMPLETE) || (status == MBOX_STATUS_CMD_FAILURE);
}

MboxStatusE mailbox_send_status(const MailboxSendTxn *txn) {
  uint32_t reg_val = lsu_read_32((CLP_MBOX_CSR_MBOX_LOCK));
  uint32_t status = reg_val & 0x3;
  return (MboxStatusE)status;
}

int mailbox_send_complete(MailboxSendTxn *txn) {
  if (txn->state != MBOX_OP_STATE_EXECUTE) {
      return -1;
  }

  lsu_write_32(CLP_MBOX_CSR_MBOX_EXECUTE, MBOX_CSR_MBOX_EXECUTE_EXECUTE_LOW);
  txn->state = MBOX_OP_STATE_IDLE;
  return 0;
}

// ----------------- Receive Transaction Functions -----------------

MailboxRecvTxn mailbox_try_start_recv_txn(Mailbox *mbox) {
  
  MailboxRecvTxn txn = {
      .state = lsu_read_32((CLP_MBOX_CSR_MBOX_STATUS) & 0x10) ? 
               MBOX_OP_STATE_EXECUTE : MBOX_OP_STATE_IDLE,
      .mbox = mbox
  };
  return txn;
}

MailboxRecvPeek mailbox_recv(Mailbox *mbox) {
  MailboxRecvPeek peek = { .mbox = mbox };
  return peek;
}

uint32_t mailbox_recv_cmd(const MailboxRecvPeek *peek) {
  return lsu_read_32(CLP_MBOX_CSR_MBOX_CMD);
}

uint32_t mailbox_recv_user(const MailboxRecvPeek *peek) {
  return lsu_read_32(CLP_MBOX_CSR_MBOX_USER);
}

uint32_t mailbox_recv_dlen(const MailboxRecvPeek *peek) {
  return lsu_read_32(CLP_MBOX_CSR_MBOX_DLEN);
}

MailboxRecvTxn mailbox_recv_peek_start_txn(MailboxRecvPeek *peek) {
  MailboxRecvTxn txn = {
      .state = MBOX_OP_STATE_EXECUTE,
      .mbox = peek->mbox
  };
  return txn;
}

// ... Additional receive functions following same pattern ...

void mailbox_abort_pending_soc_to_uc_transactions(void) {
  // Implementation would access hardware registers directly
  // Similar to the Rust version but with C syntax
}