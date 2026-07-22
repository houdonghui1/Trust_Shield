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

int main_fw(void)
{
	uint8_t ch;
    uint32_t status;
    uint8_t tx_buffer[4] = {0};
    uint8_t rx_buffer[4] = {0};
    uint8_t cert_buffer[1024] = {0};
    uint32_t value = 0;
    uint8_t input_buffer[32] = {0};
    uint32_t input_len = 0;

	huart0.regs = UART0;
	drv_uart_default_config(&huart0);
	drv_uart_init(&huart0);

    drv_uart_printf("------------------------------------\n");
    drv_uart_printf("             SOC firmware...        \n");
    drv_uart_printf("------------------------------------\n");
    drv_uart_printf("Compiled on: %s at %s\n", __DATE__, __TIME__);
    drv_uart_printf("\n");
    delay_ms(500000);
    drv_uart_printf("---------------------------------------------\n");
    drv_uart_printf("(1) start certificate chain verification\n");
    drv_uart_printf("(2) get CA certificate\n");
    drv_uart_printf("(3) get LdevID certificate\n");
    drv_uart_printf("(4) get FMC certificate\n");
    drv_uart_printf("(5) get RT certificate\n");
    drv_uart_printf("(6) get SOC measure value\n");
    drv_uart_printf("(7) get FMC measure value\n");
    drv_uart_printf("(8) get RT measure value\n");
    drv_uart_printf("---------------------------------------------\n");
    
    struct parcel parcel = {
        .command = 0,
        .tx_buffer = NULL,
        .tx_bytes = 0,
        .rx_buffer = NULL,
        .rx_bytes = 0
    };


	while(1)
	{
        memset(input_buffer, 0, sizeof(input_buffer));
        input_len = 0;
        while (input_len < sizeof(input_buffer) - 1)
        {
            if (drv_uart_getchar(&huart0, &input_buffer[input_len]) != 0)
                break;
            if (input_buffer[input_len] == '\r' || input_buffer[input_len] == '\n')
                break;
            input_len++;
        }

        if (input_len != 1)
        {
            drv_uart_printf("[ERROR] Invalid input: Please enter a single character (1-8).\n");
            drv_uart_printf("---------------------------------------------\n");
            drv_uart_printf("(1) start certificate chain verification\n");
            drv_uart_printf("(2) get CA certificate\n");
            drv_uart_printf("(3) get LdevID certificate\n");
            drv_uart_printf("(4) get FMC certificate\n");
            drv_uart_printf("(5) get RT certificate\n");
            drv_uart_printf("(6) get SOC measure value\n");
            drv_uart_printf("(7) get FMC measure value\n");
            drv_uart_printf("(8) get RT measure value\n");
            drv_uart_printf("---------------------------------------------\n");
            continue;
        }
        ch = input_buffer[0];
        switch (ch)
        {
            case '1': 
                parcel.command = OP_CMD_VERIFY_CERT;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = rx_buffer;
                parcel.rx_bytes = sizeof(rx_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                memcpy(&value, parcel.rx_buffer, sizeof(value));
                if(value == MBOX_SUCCESS) {
                    drv_uart_printf("[SUCCESS] Certificate chain verification passed.\n");
                    drv_uart_printf("All certificates in the chain are valid and trusted.\n");
                } else {
                    drv_uart_printf("[ERROR] Certificate chain verification failed.\n");
                    drv_uart_printf("Reason: Invalid or untrusted certificate detected.\n");
                }
                break;
            case '2': 
                parcel.command = OP_GET_CA_CERT;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                drv_uart_printf("CA certificate:\n\n");
                for(uint32_t j = 0; j < value; j++) {
                    drv_uart_printf("%02x", parcel.rx_buffer[j]);
                }
                drv_uart_printf("\n");
                break;
            case '3': 
                parcel.command = OP_GET_LDEVID_CERT;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                drv_uart_printf("LdevID certificate:\n\n");
                for(uint32_t j = 0; j < value; j++) {
                    drv_uart_printf("%02x", parcel.rx_buffer[j]);
                }
                drv_uart_printf("\n");
                break;
            case '4': 
                parcel.command = OP_GET_FMC_CERT;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                drv_uart_printf("FMC certificate:\n\n");
                for(uint32_t j = 0; j < value; j++) {
                    drv_uart_printf("%02x", parcel.rx_buffer[j]);
                }
                drv_uart_printf("\n");
                break;
            case '5': 
                parcel.command = OP_GET_RT_CERT;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                drv_uart_printf("RT certificate:\n\n");
                for(uint32_t j = 0; j < value; j++) {
                    drv_uart_printf("%02x", parcel.rx_buffer[j]);
                }
                drv_uart_printf("\n");
                break;
            case '6': 
                parcel.command = OP_GET_SOC_MEASURE_VALUE;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                drv_uart_printf("SOC measure value:\n\n");
                for (uint32_t j = 0; j < value; j += 4) {
                    uint32_t *ptr = (uint32_t *)&parcel.rx_buffer[j];
                    *ptr = __builtin_bswap32(*ptr);
                }
                for(uint32_t j = 0; j < value; j++) {
                    drv_uart_printf("%02x", parcel.rx_buffer[j]);
                }
                drv_uart_printf("\n");
                break;
            case '7': 
                parcel.command = OP_GET_FMC_MEASURE_VALUE;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                drv_uart_printf("FMC measure value:\n\n");
                for (uint32_t j = 0; j < value; j += 4) {
                    uint32_t *ptr = (uint32_t *)&parcel.rx_buffer[j];
                    *ptr = __builtin_bswap32(*ptr);
                }
                for(uint32_t j = 0; j < value; j++) {
                    drv_uart_printf("%02x", parcel.rx_buffer[j]);
                }
                drv_uart_printf("\n");
                break;
            case '8': 
                parcel.command = OP_GET_RT_MEASURE_VALUE;
                parcel.tx_buffer = tx_buffer;
                parcel.tx_bytes = sizeof(tx_buffer);
                parcel.rx_buffer = cert_buffer;
                parcel.rx_bytes = sizeof(cert_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
                drv_uart_printf("RT measure value:\n\n");
                for (uint32_t j = 0; j < value; j += 4) {
                    uint32_t *ptr = (uint32_t *)&parcel.rx_buffer[j];
                    *ptr = __builtin_bswap32(*ptr);
                }
                for(uint32_t j = 0; j < value; j++) {
                    drv_uart_printf("%02x", parcel.rx_buffer[j]);
                }
                drv_uart_printf("\n");
                break;
            default:
                drv_uart_printf("[ERROR] Invalid input: Please enter a single character (1-8).\n");
                drv_uart_printf("---------------------------------------------\n");
                drv_uart_printf("(1) start certificate chain verification\n");
                drv_uart_printf("(2) get CA certificate\n");
                drv_uart_printf("(3) get LdevID certificate\n");
                drv_uart_printf("(4) get FMC certificate\n");
                drv_uart_printf("(5) get RT certificate\n");
                drv_uart_printf("(6) get SOC measure value\n");
                drv_uart_printf("(7) get FMC measure value\n");
                drv_uart_printf("(8) get RT measure value\n");
                drv_uart_printf("---------------------------------------------\n");
                break;
        }

	}
}