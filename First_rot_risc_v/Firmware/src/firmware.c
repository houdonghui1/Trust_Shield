#include <string.h>
#include "kprintf.h"
#include "drv_caliptra1x.h"
#include "mailbox.h"
__attribute__((section(".text.main"))) 
int main(void) {
	uint8_t ch;
    uint32_t status;
    uint8_t tx_buffer[4] = {0};
    uint8_t rx_buffer[4] = {0};
    uint8_t cert_buffer[1024] = {0};
    uint32_t value = 0;
    uint8_t input_buffer[32] = {0};
    uint32_t input_len = 0;
    char c;

	REG32(uart, UART_REG_TXCTRL) = UART_TXEN;
    REG32(uart, UART_REG_RXCTRL) = UART_RXEN;
    kprintf("------------------------------------\n");
    kprintf("             SOC firmware...        \n");
    kprintf("------------------------------------\n");
    kprintf("Compiled on: %s at %s\n", __DATE__, __TIME__);
    kprintf("\n");
/*
    kprintf("---------------------------------------------\n");
    kprintf("(1) start certificate chain verification\n");
    kprintf("(2) get CA certificate\n");
    kprintf("(3) get LdevID certificate\n");
    kprintf("(4) get FMC certificate\n");
    kprintf("(5) get RT certificate\n");
    kprintf("(6) get SOC measure value\n");
    kprintf("(7) get FMC measure value\n");
    kprintf("(8) get RT measure value\n");
    kprintf("---------------------------------------------\n");
    
    struct parcel parcel = {
        .command = 0,
        .tx_buffer = NULL,
        .tx_bytes = 0,
        .rx_buffer = NULL,
        .rx_bytes = 0
    };
while (1) {
    uint8_t ch;
    kgetchar(&ch);
    kprintf("Received: 0x%x\n", ch);
}

	while(1)
	{
        memset(input_buffer, 0, sizeof(input_buffer));
        input_len = 0;
        while (input_len < sizeof(input_buffer) - 1) {
            kprintf("func: %s, line: %d \r\n", __func__, __LINE__);
            kgetchar(&input_buffer[input_len]);
            kprintf("func: %s, line: %d ch = 0x%x\r\n", __func__, __LINE__, input_buffer[input_len]);
            if(input_buffer[input_len] != 0) {
                input_len++;
                break;
            }
            input_len++;
        }

        if (input_len != 1)
        {
            kprintf("[ERROR] Invalid input: Please enter a single character (1-8).\n");
            kprintf("---------------------------------------------\n");
            kprintf("(1) start certificate chain verification\n");
            kprintf("(2) get CA certificate\n");
            kprintf("(3) get LdevID certificate\n");
            kprintf("(4) get FMC certificate\n");
            kprintf("(5) get RT certificate\n");
            kprintf("(6) get SOC measure value\n");
            kprintf("(7) get FMC measure value\n");
            kprintf("(8) get RT measure value\n");
            kprintf("---------------------------------------------\n");
            continue;
        }
        ch = input_buffer[0];
        kprintf("func: %s, line: %d ch = 0x%x\r\n", __func__, __LINE__, ch);

        switch (ch)
        {
            case 0x1: 
                parcel.command = OP_CMD_VERIFY_CERT;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = rx_buffer;
                parcel.rx_bytes = sizeof(rx_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    kprintf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                memcpy(&value, parcel.rx_buffer, sizeof(value));
                if(value == MBOX_SUCCESS) {
                    kprintf("[SUCCESS] Certificate chain verification passed.\n");
                    kprintf("All certificates in the chain are valid and trusted.\n");
                } else {
                    kprintf("[ERROR] Certificate chain verification failed.\n");
                    kprintf("Reason: Invalid or untrusted certificate detected.\n");
                }
                break;
            case 0x2: 
                parcel.command = OP_GET_CA_CERT;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    kprintf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                kprintf("CA certificate:\n\n");
                for(uint32_t j = 0; j < value; j++) {
                    kprintf("%02x", parcel.rx_buffer[j]);
                }
                kprintf("\n");
                break;
            case 0x3: 
                parcel.command = OP_GET_LDEVID_CERT;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    kprintf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                kprintf("LdevID certificate:\n\n");
                for(uint32_t j = 0; j < value; j++) {
                    kprintf("%02x", parcel.rx_buffer[j]);
                }
                kprintf("\n");
                break;
            case 0x4: 
                parcel.command = OP_GET_FMC_CERT;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    kprintf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                kprintf("FMC certificate:\n\n");
                for(uint32_t j = 0; j < value; j++) {
                    kprintf("%02x", parcel.rx_buffer[j]);
                }
                kprintf("\n");
                break;
            case 0x5: 
                parcel.command = OP_GET_RT_CERT;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    kprintf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                kprintf("RT certificate:\n\n");
                for(uint32_t j = 0; j < value; j++) {
                    kprintf("%02x", parcel.rx_buffer[j]);
                }
                kprintf("\n");
                break;
            case 0x6: 
                parcel.command = OP_GET_SOC_MEASURE_VALUE;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    kprintf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                kprintf("SOC measure value:\n\n");
                for (uint32_t j = 0; j < value; j += 4) {
                    uint32_t *ptr = (uint32_t *)&parcel.rx_buffer[j];
                    *ptr = __builtin_bswap32(*ptr);
                }
                for(uint32_t j = 0; j < value; j++) {
                    kprintf("%02x", parcel.rx_buffer[j]);
                }
                kprintf("\n");
                break;
            case 0x7: 
                parcel.command = OP_GET_FMC_MEASURE_VALUE;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    kprintf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                kprintf("FMC measure value:\n\n");
                for (uint32_t j = 0; j < value; j += 4) {
                    uint32_t *ptr = (uint32_t *)&parcel.rx_buffer[j];
                    *ptr = __builtin_bswap32(*ptr);
                }
                for(uint32_t j = 0; j < value; j++) {
                    kprintf("%02x", parcel.rx_buffer[j]);
                }
                kprintf("\n");
                break;
            case 0x8: 
                parcel.command = OP_GET_RT_MEASURE_VALUE;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    kprintf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                kprintf("RT measure value:\n\n");
                for (uint32_t j = 0; j < value; j += 4) {
                    uint32_t *ptr = (uint32_t *)&parcel.rx_buffer[j];
                    *ptr = __builtin_bswap32(*ptr);
                }
                for(uint32_t j = 0; j < value; j++) {
                    kprintf("%02x", parcel.rx_buffer[j]);
                }
                kprintf("\n");
                break;
            default:
                kprintf("[ERROR] Invalid input: Please enter a single character (1-8).\n");
                kprintf("---------------------------------------------\n");
                kprintf("(1) start certificate chain verification\n");
                kprintf("(2) get CA certificate\n");
                kprintf("(3) get LdevID certificate\n");
                kprintf("(4) get FMC certificate\n");
                kprintf("(5) get RT certificate\n");
                kprintf("(6) get SOC measure value\n");
                kprintf("(7) get FMC measure value\n");
                kprintf("(8) get RT measure value\n");
                kprintf("---------------------------------------------\n");
                break;
        }

	}
*/
}
