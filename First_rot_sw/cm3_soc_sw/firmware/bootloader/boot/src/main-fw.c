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
#include "cluster_bls_bridge.h"

/*
 * Production CM3 firmware is a transport endpoint, not a BLS signer.  Leave
 * the legacy UART menu reachable by default.  Dedicated unattended images
 * may set CLUSTER_BLS_RUNTIME_PROXY_AUTOSTART=1 at build time.
 */
#ifndef CLUSTER_BLS_RUNTIME_PROXY_AUTOSTART
#define CLUSTER_BLS_RUNTIME_PROXY_AUTOSTART 0
#endif

UART_HandleTypeDef huart0;
static uint8_t __attribute__((aligned(4)))
    g_fw_transfer_buffer[CLUSTER_BLS_BRIDGE_MAX_PAYLOAD];

int main_fw(void)
{
	uint8_t ch;
    uint32_t status;
    uint8_t tx_buffer[4] = {0};
    uint8_t rx_buffer[4] = {0};
    uint32_t value = 0;

	huart0.regs = UART0;
	drv_uart_default_config(&huart0);
    huart0.cfg.ignore_error = UART_ERROR_IGNORE;
	drv_uart_init(&huart0);

    drv_uart_printf("------------------------------------\n");
    drv_uart_printf("             SOC firmware...        \n");
    drv_uart_printf("------------------------------------\n");
    drv_uart_printf("Compiled on: %s at %s\n", __DATE__, __TIME__);
    drv_uart_printf("\n");

#if CLUSTER_BLS_RUNTIME_PROXY_AUTOSTART
    drv_uart_printf("Cluster-BLS L1 proxy ready\n");
    cluster_bls_bridge_serve(&huart0, g_fw_transfer_buffer,
                             sizeof(g_fw_transfer_buffer));
#endif

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
    drv_uart_printf("(9) start Cluster-BLS proxy service\n");
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
        if (drv_uart_getchar(&huart0, &ch) != 0) {
            continue;
        }
        if (ch == '\r' || ch == '\n') {
            continue;
        }
        if (ch == 'C') {
            cluster_bls_bridge_serve_prefixed(&huart0, g_fw_transfer_buffer,
                                              sizeof(g_fw_transfer_buffer));
            continue;
        }
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
                parcel.rx_buffer = g_fw_transfer_buffer;
                parcel.rx_bytes = sizeof(g_fw_transfer_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_last_response_size();
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
                parcel.rx_buffer = g_fw_transfer_buffer;
                parcel.rx_bytes = sizeof(g_fw_transfer_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_last_response_size();
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
                parcel.rx_buffer = g_fw_transfer_buffer;
                parcel.rx_bytes = sizeof(g_fw_transfer_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_last_response_size();
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
                parcel.rx_buffer = g_fw_transfer_buffer;
                parcel.rx_bytes = sizeof(g_fw_transfer_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_last_response_size();
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
                parcel.rx_buffer = g_fw_transfer_buffer;
                parcel.rx_bytes = sizeof(g_fw_transfer_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_last_response_size();
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
                parcel.rx_buffer = g_fw_transfer_buffer;
                parcel.rx_bytes = sizeof(g_fw_transfer_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_last_response_size();
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
                parcel.rx_buffer = g_fw_transfer_buffer;
                parcel.rx_bytes = sizeof(g_fw_transfer_buffer);
                status = 1;
                while(status){
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                }
                value = caliptra_mbox_last_response_size();
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
            case '9':
                drv_uart_printf("Cluster-BLS L1 proxy ready\n");
                break;
            default:
                drv_uart_printf("[ERROR] Invalid input: Please enter a single character (1-9).\n");
                drv_uart_printf("---------------------------------------------\n");
                drv_uart_printf("(1) start certificate chain verification\n");
                drv_uart_printf("(2) get CA certificate\n");
                drv_uart_printf("(3) get LdevID certificate\n");
                drv_uart_printf("(4) get FMC certificate\n");
                drv_uart_printf("(5) get RT certificate\n");
                drv_uart_printf("(6) get SOC measure value\n");
                drv_uart_printf("(7) get FMC measure value\n");
                drv_uart_printf("(8) get RT measure value\n");
                drv_uart_printf("(9) start Cluster-BLS proxy service\n");
                drv_uart_printf("---------------------------------------------\n");
                break;
        }

	}
}
