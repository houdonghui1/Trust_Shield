//===============================================
//
//	File: mailbox.c
//	Author: afterGlow,4ever
//	Group: Fall For Laboratory
//	Date: 12272023
//	Version: v1.0
//
// 	This is source file for mailbox driver.
//
//===============================================

#include "mailbox.h"

#define CALIPTRA_API_GLOBAL_SECTION_ATTRIBUTE
static struct caliptra_buffer g_caliptra_mbox_pending_rx_buffer CALIPTRA_API_GLOBAL_SECTION_ATTRIBUTE;

static int caliptra_mailbox_write_fifo(const struct caliptra_buffer *buffer)
{
    // Check if buffer is not null.
    if (buffer == NULL)
    {
        return INVALID_PARAMS;
    }

    // TODO: Should we enforce we don't exceed the previously written mbox_write_dlen value?

    if (buffer->len == 0)
    {
        // We can return early, there is no payload.
        return 0;
    }

    // We have data to write, better check if have a place to read it
    // from.
    if (buffer->data == NULL)
    {
        return INVALID_PARAMS;
    }

    uint32_t remaining_len = buffer->len;
    uint32_t *data_dw = (uint32_t *)buffer->data;

    // Copy DWord multiples
    while (remaining_len > sizeof(uint32_t))
    {
        caliptra_mbox_write(MBOX_CSR_MBOX_DATAIN, *data_dw++);
        remaining_len -= sizeof(uint32_t);
    }

    // if un-aligned dword remainder...
    if (remaining_len)
    {
        uint32_t data = 0;
        memcpy(&data, data_dw, remaining_len);
        caliptra_mbox_write(MBOX_CSR_MBOX_DATAIN, data);
    }

    return 0;
}


static int caliptra_mailbox_read_fifo(struct caliptra_buffer *buffer, uint32_t *bytes_read)
{

    uint32_t remaining_len = caliptra_mbox_read_dlen();
    
    // Check that the buffer is not null
    if (buffer == NULL) {
        return INVALID_PARAMS;
    }

    if (bytes_read) {
        *bytes_read = 0;
    }
    // Check we have enough room in the buffer
    if (buffer->len < remaining_len || !buffer->data) {
        return INVALID_PARAMS;
    }
    uint32_t *data_dw = (uint32_t *)buffer->data;
    // Copy DWord multiples
    while (remaining_len >= sizeof(uint32_t))
    {
        *data_dw++ = caliptra_mbox_read(MBOX_CSR_MBOX_DATAOUT);
        remaining_len -= sizeof(uint32_t);
        if (bytes_read) {
            *bytes_read += 4;
        }
    }
    // if un-aligned dword reminder...
    if (remaining_len)
    {

        uint32_t data = caliptra_mbox_read(MBOX_CSR_MBOX_DATAOUT);
        memcpy(data_dw, &data, remaining_len);
        if (bytes_read) {
            *bytes_read += remaining_len;
        }
    }
    return 0;
}

/**
 * caliptra1x_mailbox_comm
 * Mailbox communication, including the logic for sending and receiving data
 *
 * @param[in] cmd 32 bit command identifier to be sent to caliptra
 * @param[in] data caliptra_buffer struct containing the pointer and length of the send/receive buffer
 * @param[in] async If true, return after sending command. If false, wait for command to complete and handle response
 *
 * @return 0 for success, non-zero for failure (see enum libcaliptra_error)
 */
/* uint32_t caliptra1x_mailbox_comm(uint32_t cmd, data_comm* data, bool async) 
{
	uint32_t	comm_status;
	uint32_t	mbox_status;

	comm_status = caliptra1x_mailbox_tx(cmd, data);
	if(!comm_status) {
        writereg8(CALIPTRA_TOP_REG_MBOX_CSR_MBOX_EXECUTE, MBOX_CSR_MBOX_EXECUTE_EXECUTE_MASK);
        if (async) {
            goto CommEnd;
        }
		do {
			//Read mailbox status
			mbox_status = readreg32(CALIPTRA_TOP_REG_MBOX_CSR_MBOX_STATUS);
			switch (mbox_status)
			{
				case DATA_READY:
				 	comm_status = caliptra1x_mailbox_rx(data);
					break;
				case CMD_COMPLETE:
					break;
				case CMD_FAILURE:
					comm_status = MBX_STATUS_FAILED;
					break;
				case CMD_BUSY:
					break;
				default:
					comm_status = MBX_STATUS_FAILED;
					break;
			}
		} while(mbox_status == CMD_BUSY);
	}

CommEnd:
	//Clear lock
	writereg8(CALIPTRA_TOP_REG_MBOX_CSR_MBOX_EXECUTE, MBOX_CSR_MBOX_EXECUTE_EXECUTE_LOW);

    if(data->indata != NULL) {
        free(data->indata);
    }
    
	return comm_status;
} */



/**
 * caliptra_check_status_get_response
 *
 * HELPER - Checks the HW mailbox status for "complete" or "data ready" and populates the response
 * buffer with a response if applicable
 *
 * @param[out] mbox_rx_buffer Buffer for the response, NULL if no response is expected
 * @param[out] bytes_read Pointer to dword to update with the number of bytes read
 *
 * @return 0 for success, non-zero for failure (see enum libcaliptra_error)
 */
int caliptra_check_status_get_response(struct caliptra_buffer *mbox_rx_buffer, uint32_t *bytes_read)
{
    // Only called internally, should always have a valid pointer
    if (bytes_read == NULL) {
        return API_INTERNAL_ERROR;
    }
    // Check the Mailbox Status
    uint8_t mbx_status = caliptra_mbox_read_status();
    if (mbx_status == CALIPTRA_MBOX_STATUS_CMD_FAILURE)
    {
        caliptra_mbox_write_execute(false);
        return MBX_STATUS_FAILED;
    }
    else if (mbx_status == CALIPTRA_MBOX_STATUS_CMD_COMPLETE)
    {
        caliptra_mbox_write_execute(false);
        return 0;
    }
    else if (mbx_status == CALIPTRA_MBOX_STATUS_BUSY)
    {
        return MBX_STATUS_UNKNOWN;
    }
    // Read Buffer
    int status = caliptra_mailbox_read_fifo(mbox_rx_buffer, bytes_read);
    // Execute False
    caliptra_mbox_write_execute(false);
    // Wait (HW model is halted whenever we aren't calling wait())
    delay_ms(1000);
    if (caliptra_mbox_read_status_fsm() != CALIPTRA_MBOX_STATUS_FSM_IDLE)
        return MBX_STATUS_NOT_IDLE;

    return status;
}

/**
 * calculate_caliptra_checksum
 *
 * This generates a checksum based on a sum of the command and the buffer, then
 * subtracted from zero.
 *
 * @param[in] cmd The command being sent to the caliptra device
 * @param[in] buffer A pointer, if applicable, to the buffer being sent
 * @param[in] len The size of the buffer
 *
 * @return Checksum value
 */
static uint32_t calculate_caliptra_checksum(uint32_t cmd, const uint8_t *buffer, uint32_t len)
{
    uint32_t i, sum = 0;

    if ((buffer == NULL) && (len != 0))
    {
        // Don't respect bad parameters
        return 0;
    }

    for (i = 0; i < sizeof(uint32_t); i++)
    {
        sum += ((uint8_t*)(&cmd))[i];
    }

    for (i = 0; i < len; i++)
    {
        sum += buffer[i];
    }

    return (0 - sum);
}

/**
 * check_command_response
 *
 * HELPER - Verifies the checksum and checks that the FIPS status is approved for the message response
 *
 * @param[in] buffer Buffer for the full response
 * @param[in] response_size Size of the full response in bytes
 *
 * @return 0 for success, non-zero for failure (see enum libcaliptra_error)
 */
static inline int check_command_response(const uint8_t *buffer, const size_t response_size)
{
    if (response_size < sizeof(struct caliptra_resp_header)) {
        return MBX_RESP_NO_HEADER;
    }
    struct caliptra_resp_header *resp_hdr = (struct caliptra_resp_header*)buffer;

    uint32_t calc_checksum = calculate_caliptra_checksum(0, buffer + sizeof(uint32_t), response_size - sizeof(uint32_t));

    bool checksum_valid = !(resp_hdr->chksum - calc_checksum);
    bool fips_approved  = (resp_hdr->fips_status == FIPS_STATUS_APPROVED);

    if (checksum_valid == false) {
        return MBX_RESP_CHKSUM_INVALID;
    }
    if (fips_approved == false) {
        return MBX_RESP_FIPS_NOT_APPROVED;
    }

    return 0;
}

/**
 * caliptra_mailbox_send_start
 *
 * HELPER - Send the message to caliptra
 *
 * @param[in] cmd Caliptra command opcode
 * @param[in] data_size Number of bytes to be sent in the request (does not include command)
 *
 * @return 0 for success, non-zero for failure (see enum libcaliptra_error)
 */
int caliptra_mailbox_send_start(uint32_t cmd, uint32_t data_size)
{
    if (data_size > CALIPTRA_MAILBOX_MAX_SIZE)
    {
        return INVALID_PARAMS;
    }

    // Get mailbox lock, return error if already locked
    if (caliptra_mbox_is_lock())
    {
        return MBX_BUSY;
    }

    // Write Cmd
    caliptra_mbox_write_cmd(cmd);

    // Write DLEN to transition to the next state (needed even if it is zero)
    caliptra_mbox_write_dlen(data_size);

    return 0;
};

/**
 * caliptra_mailbox_send_data
 *
 * HELPER - Send the data portion of the message to caliptra
 *          Can be called multiple times
 *
 * @param[in] mbox_tx_buffer Transmit buffer
 *
 * @return 0 for success, non-zero for failure (see enum libcaliptra_error)
 */
int caliptra_mailbox_send_data(const struct caliptra_buffer *mbox_tx_buffer)
{
    // Write Tx Buffer
    return caliptra_mailbox_write_fifo(mbox_tx_buffer);
};

/**
 * caliptra_mailbox_send_complete
 *
 * HELPER - Set execute to indicate Calipta should now process the message
 *          Set the rx_buffer for the pending message if applicable
 *          Wait for the result if async is true
 *
 * @param[out] mbox_rx_buffer caliptra_buffer struct containing the pointer and length of the receive buffer
 * @param[in] async If true, return after sending command. If false, wait for command to complete and handle response
 *
 * @return 0 for success, non-zero for failure (see enum libcaliptra_error)
 */
int caliptra_mailbox_send_complete(struct caliptra_buffer *mbox_rx_buffer, bool async)
{
    // Store buffer info or init to zero
    if (mbox_rx_buffer != NULL) {
        g_caliptra_mbox_pending_rx_buffer = *mbox_rx_buffer;
    } else {
        g_caliptra_mbox_pending_rx_buffer = (struct caliptra_buffer){NULL, 0};
    }
    // Set Execute bit
    caliptra_mbox_write_execute(true);
    // Stop here if this is async (user will poll and complete)
    if (async) {
        return 0;
    }
    // Wait indefinitely for completion
    while (!caliptra_test_for_completion()){
        delay_ms(10);
    }
    return caliptra_complete();
};

/**
 * caliptra_mailbox_execute
 * Send the command. If async is false, wait for completion and call caliptra_complete to get result
 *
 * @param[in] cmd 32 bit command identifier to be sent to caliptra
 * @param[in] mbox_tx_buffer caliptra_buffer struct containing the pointer and length of the send buffer
 * @param[out] mbox_rx_buffer caliptra_buffer struct containing the pointer and length of the receive buffer
 * @param[in] async If true, return after sending command. If false, wait for command to complete and handle response
 *
 * @return 0 for success, non-zero for failure (see enum libcaliptra_error)
 */
int caliptra_mailbox_execute(uint32_t cmd, const struct caliptra_buffer *mbox_tx_buffer, struct caliptra_buffer *mbox_rx_buffer, bool async)
{
    // Mailbox send start
    int status = caliptra_mailbox_send_start(cmd, mbox_tx_buffer->len);
    if (status) {
        return status;
    }
    // Mailbox send data
    status = caliptra_mailbox_send_data(mbox_tx_buffer);
    if (status) {
        return status;
    }
    // Mailbox send complete
    return caliptra_mailbox_send_complete(mbox_rx_buffer, async);
}

/**
 * pack_and_execute_command
 *
 * HELPER - Create the caliptra buffer structs and call caliptra_mailbox_send
 *
 * @param[in] parcel struct with tx and rx buffers for the transactions
 * @param[in] async If true, return after sending command. If false, wait for command to complete and handle response
 *
 * @return 0 for success, non-zero for failure (see enum libcaliptra_error)
 */
int pack_and_execute_command(struct parcel *parcel, bool async)
{
    if (parcel == NULL)
    {
        return INVALID_PARAMS;
    }

    // Parcels will always have, at a minimum:
    //  > 4 byte tx buffer, for the checksum
    //  > 8 byte rx buffer, for the checksum and FIPS status
    if (!parcel->tx_buffer || !parcel->rx_buffer)
    {
        return INVALID_PARAMS;
    }

    struct caliptra_buffer tx_buf = {
        .data = parcel->tx_buffer,
        .len  = parcel->tx_bytes,
    };

    struct caliptra_buffer rx_buf = {
        .data = parcel->rx_buffer,
        .len  = parcel->rx_bytes,
    };

    // Calculate and populate the checksum field
    // Clear the checksum field before calculating
/*     *((caliptra_checksum*)tx_buf.data) = 0x0;
    *((caliptra_checksum*)tx_buf.data) = calculate_caliptra_checksum(parcel->command, tx_buf.data, tx_buf.len);
 */
    return caliptra_mailbox_execute(parcel->command, &tx_buf, &rx_buf, async);
}

/**
 * caliptra_test_for_completion
 *
 * Checks if there is an active command being processed by caliptra FW
 *
 * @return True if no command is pending, false if a command is pending
 */
bool caliptra_test_for_completion()
{
    return !caliptra_mbox_is_busy();
}

/**
 * caliptra_complete
 *
 * Check result, read back the response to the rx_buffer originally provided if necessary
 * Complete transaction with mbx HW by clearing execute
 *
 * @return 0 for success, non-zero for failure (see enum libcaliptra_error)
 */
int caliptra_complete()
{
    // Return an error if no message is pending (execute is not set)
    if (caliptra_mbox_read_execute() == 0) {
        return MBX_NO_MSG_PENDING;
    }

    // Make sure the request is complete
    if (!caliptra_test_for_completion()) {
        return MBX_BUSY;
    }
    // Store the buffer locally and clear the global var
    // The global should never be set when we don't have the mbx HW lock
    // (HW lock protects this from race conditions)
    struct caliptra_buffer rx_buffer = g_caliptra_mbox_pending_rx_buffer;
    g_caliptra_mbox_pending_rx_buffer = (struct caliptra_buffer){NULL, 0};
    // Complete the transaction and read back a response if applicable
    uint32_t bytes_read = 0;
    int status = caliptra_check_status_get_response(&rx_buffer, &bytes_read);
    if (status)
    {
        return status;
    }
    // Verify the header data from the response
    if (rx_buffer.data != NULL) {
        //return check_command_response(rx_buffer.data, bytes_read);
    }

    return 0;
}
/**
 * caliptra_upload_fw
 *
 * Upload firmware to the Caliptra device. Requires entire FW as fw_buffer
 *
 * @param[in] fw_buffer Buffer containing Caliptra firmware
 * @param[in] async If true, return after sending command. If false, wait for command to complete and handle response
 *
 * @return 0 for success, non-zero for failure (see enum libcaliptra_error)
 */
int caliptra_upload_fw(const struct caliptra_buffer *fw_buffer, bool async)
{
    // Parameter check
    if (fw_buffer == NULL)
        return INVALID_PARAMS;

    return caliptra_mailbox_execute(OP_CALIPTRA_FW_LOAD, fw_buffer, NULL, async);
}
