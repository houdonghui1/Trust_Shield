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
      .state = lsu_read_32(CLP_MBOX_CSR_MBOX_STATUS) & 0x10? 
               MBOX_OP_STATE_EXECUTE : MBOX_OP_STATE_IDLE,
      .mbox = mbox
  };
  return txn;
}

uint32_t mailbox_recv_cmd(const MailboxRecvTxn *txn) {
  return lsu_read_32(CLP_MBOX_CSR_MBOX_CMD);
}

uint32_t mailbox_recv_user(const MailboxRecvTxn *txn) {
  return lsu_read_32(CLP_MBOX_CSR_MBOX_USER);
}

uint32_t mailbox_recv_dlen(const MailboxRecvTxn *txn) {
  return lsu_read_32(CLP_MBOX_CSR_MBOX_DLEN);
}

// ... Additional receive functions following same pattern ...

void mailbox_abort_pending_soc_to_uc_transactions(void) {
  // Implementation would access hardware registers directly
  // Similar to the Rust version but with C syntax
}

uint32_t mailbox_send_data(uint32_t *mbox_data, uint32_t data_size) {
    mbox_op_s op;
    uint32_t data;
    enum mbox_fsm_e state;
    //set ready for FW so tb will push FW
    soc_ifc_set_flow_status_field(SOC_IFC_REG_CPTRA_FLOW_STATUS_READY_FOR_FW_MASK);

    // Sleep
    for (uint16_t slp = 0; slp < 33; slp++);

    //wait for mailbox data avail
    printf("FW: Wait\n");
    while((lsu_read_32(CLP_MBOX_CSR_MBOX_EXECUTE) & MBOX_CSR_MBOX_EXECUTE_EXECUTE_MASK) != MBOX_CSR_MBOX_EXECUTE_EXECUTE_MASK);

    //read mbox command
    op = soc_ifc_read_mbox_cmd();

    //read from mbox
    printf("FW: Reading %08d bytes from mailbox\n", (unsigned int )op.dlen);
    while(op.dlen) {
        data = soc_ifc_mbox_read_dataout_single();
        printf("  dataout: 0x%08x\n", (unsigned int )data);
        if (op.dlen < 4) {
            op.dlen=0;
        } else {
            op.dlen-=4;//sizeof(uint32_t);
        }
    }

    //write command
    lsu_write_32(CLP_MBOX_CSR_MBOX_CMD,MBOX_CMD_RECV_SOC_FW);

    //write dlen
    lsu_write_32(CLP_MBOX_CSR_MBOX_DLEN,data_size);

    //push new data in like a response
    printf("FW: Writing 0x%08x bytes to mailbox\n", (unsigned int )data_size);
    for (uint32_t offset = 0; offset < data_size; offset += 4) {
        uint32_t word = 0;
        uint32_t bytes_remaining = data_size - offset;
        uint32_t bytes_to_copy = (bytes_remaining < 4) ? bytes_remaining : 4;

        for (uint32_t i = 0; i < bytes_to_copy; i++) {
            word |= ((uint32_t)((uint8_t*)mbox_data)[offset + i]) << (8 * i);
        }

        lsu_write_32(CLP_MBOX_CSR_MBOX_DATAIN, word);
    }


    //set data ready status
    printf("FW: Set data ready status\n");
    lsu_write_32(CLP_MBOX_CSR_MBOX_STATUS,DATA_READY);

    //check FSM state, should be in EXECUTE_SOC
    state = (lsu_read_32(CLP_MBOX_CSR_MBOX_STATUS) & MBOX_CSR_MBOX_STATUS_MBOX_FSM_PS_MASK) >> MBOX_CSR_MBOX_STATUS_MBOX_FSM_PS_LOW;
    if (state != MBOX_EXECUTE_SOC) {
        printf("ERROR: mailbox in unexpected state (%08x) when expecting MBOX_EXECUTE_SOC (0x%08x)\n", (unsigned int )state, (unsigned int )MBOX_EXECUTE_SOC);
        return -1;
    } else {
        printf("FW: Mailbox in expected state, MBOX_EXECUTE_SOC, ending test with success\n");
    }

    return 0;
}