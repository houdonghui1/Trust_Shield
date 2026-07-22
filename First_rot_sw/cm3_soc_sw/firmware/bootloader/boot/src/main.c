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

#define FWSTORE_ADDR 0x00040000
#define RX_BUF_SIZE 9728

UART_HandleTypeDef huart0;

uint8_t rx_byte_buffer[256] = {0};
uint8_t __attribute__((aligned(4))) rx_buffer[RX_BUF_SIZE] = {0};

typedef struct {
    uint32_t* initial_sp;
    void (*fwstore)(void);
} FWstore_t;

static inline void memcpy_fw_to_fwstore(const void *src, void *dest, uint32_t size) {
  uint32_t *src_ptr = (uint32_t *)src;
  uint32_t *dest_ptr = (uint32_t *)dest;

  for (uint32_t i = 0; i < size / sizeof(uint32_t); i++) {
      dest_ptr[i] = src_ptr[i];
  }
}

int Validate_TargetBootloader(uint32_t target_base) 
{
    FWstore_t *vt = (FWstore_t*)target_base;

    if ((uint32_t)vt->initial_sp > 0x6FFFF) {
        return 1;
    }

    if ((uint32_t)vt->fwstore > 0x6FFFF) {
        return 1;
    }

    return 0;
}

void jump_to_FWstore(uint32_t fwstore_base) 
{
    __disable_irq();

    SCB->VTOR = fwstore_base;

    __set_MSP(*(volatile uint32_t*)fwstore_base);

    void (*target_reset)(void) = (void (*)(void))(*(volatile uint32_t*)(fwstore_base + 4));

    target_reset();

    while(1);
}
uint16_t drv_uart_rx_data_u8(UART_HandleTypeDef *uart, uint8_t data[], uint16_t max_len)
{
    uint8_t sync_buf[2] = {0};
    uint8_t len_buf[2] = {0};
    uint32_t timeout = 0;

    while ((uart->regs->fifo_sta & 0x0F) != 0)
    {
        (void)uart->regs->rx_data;
    }
    while (1)
    {
        timeout = 0;
        while ((uart->regs->fifo_sta & 0x0F) == 0)
        {
            timeout++;
            if (timeout > 10000000)
            {
                drv_uart_printf("TIMEOUT waiting for sync byte 0xAA\n");
                return 0;
            }
        }
        sync_buf[0] = (uint8_t)uart->regs->rx_data;
        
        if (sync_buf[0] != 0xAA)
        {
            continue;
        }

        timeout = 0;
        while ((uart->regs->fifo_sta & 0x0F) == 0)
        {
            timeout++;
            if (timeout > 10000000)
            {
                drv_uart_printf("TIMEOUT waiting for sync byte 0x55\n");
                return 0;
            }
        }
        sync_buf[1] = (uint8_t)uart->regs->rx_data;
        
        if (sync_buf[1] == 0x55)
        {
            break;
        }
    }

    timeout = 0;
    while ((uart->regs->fifo_sta & 0x0F) == 0)
    {
        timeout++;
        if (timeout > 10000000)
        {
            drv_uart_printf("TIMEOUT waiting for length high byte\n");
            return 0;
        }
    }
    len_buf[0] = (uint8_t)uart->regs->rx_data;

    timeout = 0;
    while ((uart->regs->fifo_sta & 0x0F) == 0)
    {
        timeout++;
        if (timeout > 10000000)
        {
            drv_uart_printf("TIMEOUT waiting for length low byte\n");
            return 0;
        }
    }
    len_buf[1] = (uint8_t)uart->regs->rx_data;

    uint16_t total_len = (len_buf[0] << 8) | len_buf[1];


    if (total_len > max_len - 1)
    {
        drv_uart_printf("ERROR: Data too long! Expected %d, max %d\n", (uint32_t)total_len, (uint32_t)max_len);
        return 0;
    }

    uint32_t my_rx_ptr = 0;
    
    while (my_rx_ptr < total_len)
    {
        while ((uart->regs->fifo_sta & 0x0F) == 0);
        data[my_rx_ptr++] = (uint8_t)uart->regs->rx_data;
    }

    return total_len;
}


int hex2bin(const uint8_t *hex, int hex_len, uint8_t *bin, int max_bin_len)
{
    int bin_len = 0;
    int i = 0;

    while (i < hex_len && bin_len < max_bin_len)
    {
        uint8_t high = hex[i];
        uint8_t low = hex[i+1];

        if(high >= 'A' && high <= 'F') high += 32;
        high = (high <= '9') ? (high - '0') : (high - 'a' + 10);

        if(low >= 'A' && low <= 'F') low += 32;
        low = (low <= '9') ? (low - '0') : (low - 'a' + 10);

        bin[bin_len++] = (high << 4) | low;
        i += 2;
    }
    return bin_len;
}

int main(void)
{
    uint32_t status;
    uint8_t tx_buffer[4] = {0};
    uint8_t input_buffer[32] = {0};
    uint32_t input_len = 0;
    uint8_t ch;
    uint32_t value = 0;
	huart0.regs = UART0;
    huart0.cfg.ignore_error = UART_ERROR_IGNORE;

    drv_uart_default_config(&huart0);
    drv_uart_init(&huart0);
    drv_uart_int_disable(&huart0, 0xFFFFFFFF);
    drv_uart_int_allclear(&huart0);

	drv_uart_printf("------------------------------------\n");
    drv_uart_printf("               SOC ROM...           \n");
    drv_uart_printf("------------------------------------\n");
    drv_uart_printf("Compiled on: %s at %s\n", __DATE__, __TIME__);

    test_info info = {
        .rom = {NULL},
        .image_bundle = {NULL},
        .fuses = {{0}},
    };

	caliptra1x_set_fuses(&info);

	status = caliptra1x_drv_init(&info,false);
	drv_uart_printf("func: %s, line: %d, status = %d\n", __func__, __LINE__, status);

    drv_uart_printf("Soc start\n");

    struct parcel parcel = {
        .command = 0,
        .tx_buffer = NULL,
        .tx_bytes = 0,
        .rx_buffer = NULL,
        .rx_bytes = 0
    };
    //Obtain the caliptra PCR value and send it to the secondary trusted root for measurement
    while(1) {
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
        ch = input_buffer[0];
        if(ch == '1') {
            parcel.command = OP_GET_ROM_MEASURE_VALUE;
            parcel.tx_buffer = tx_buffer;
            parcel.tx_bytes = sizeof(tx_buffer);
            parcel.rx_buffer = rx_byte_buffer;
            parcel.rx_bytes = sizeof(rx_byte_buffer);
            status = 1;
            while(status){
                status = pack_and_execute_command(&parcel, false);
                drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
            }
            value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
            drv_uart_printf("ROM Measure value:\n");
            for(uint32_t j = 0; j < value; j++) {
                drv_uart_printf("%02x", parcel.rx_buffer[j]);
            }
            drv_uart_printf("\n");
            break;
        }
    }   
    //The secondary trusted root returns the measurement result.success: let caliptra initialize, failure: prohibit startup
    while(1) {
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
        ch = input_buffer[0];
        if(ch == '2') {
            parcel.command = OP_SEND_INITIATE;
            parcel.tx_buffer = tx_buffer;
            parcel.tx_bytes = sizeof(tx_buffer);
            parcel.rx_buffer = rx_byte_buffer;
            parcel.rx_bytes = sizeof(rx_byte_buffer);
            status = 1;
            while(status){
                status = pack_and_execute_command(&parcel, false);
                drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
            }
            break;
        } else {
            drv_uart_printf("measure failed, do not start!\n");
            return -1;
        }
    }

    //Obtain the CSR certificate, send it to the secondary trusted root, and issue a complete certificate
    parcel.command = OP_RECV_CLP_CSR;
    parcel.tx_buffer = tx_buffer;
    parcel.tx_bytes = sizeof(tx_buffer);
    parcel.rx_buffer = rx_buffer;
    parcel.rx_bytes = sizeof(rx_buffer);

    status = 1;
    while(status){
        status = pack_and_execute_command(&parcel, false);
        drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
        if(status != 0) {
            drv_uart_printf("SOC FW measurement failed!\n");
        }
    }
    value = caliptra_mbox_read(MBOX_CSR_MBOX_DLEN);
    drv_uart_printf("CSR :\n");
    for(uint32_t j = 0; j < value; j++) {
        drv_uart_printf("%02x", parcel.rx_buffer[j]);
    }
    drv_uart_printf("\n");

    while(1) {
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
        ch = input_buffer[0];
        if(ch == '4') {
            drv_uart_printf("Received command 4, waiting for certificate...\n");
            drv_uart_printf("READY\n");
            
            uint8_t *ctx_ptr = rx_buffer;                // 偏移0：接收hex字符串，最大1024字节
            uint8_t *hex_backup_ptr = rx_buffer + 1024;  // 偏移1024：备份hex，最大2048字节
            uint8_t *cert_bin_ptr = rx_buffer + 3072;    // 偏移3072：二进制证书，最大1024字节

            uint16_t cert_len = drv_uart_rx_data_u8(&huart0, ctx_ptr, 1024);
            
            if (cert_len > 0) {
                memcpy(hex_backup_ptr, ctx_ptr, cert_len);
                drv_uart_printf("Received certificate hex string successfully\n");
                int der_len = hex2bin(hex_backup_ptr, cert_len, cert_bin_ptr, 1024);
                
                drv_uart_printf("Certificate binary length: %d bytes\n", der_len);
                drv_uart_printf("Received certificate: \n");
                for (int j = 0; j < der_len; j++) {
                    drv_uart_printf("%02x", cert_bin_ptr[j]);
                    if (j % 16 == 15) {
                        drv_uart_printf("\n");
                    }
                }
                drv_uart_printf("\n");

                parcel.command = OP_RECV_CLP_CTX;
                parcel.tx_buffer = cert_bin_ptr;
                parcel.tx_bytes = der_len;
                parcel.rx_buffer = rx_byte_buffer;
                parcel.rx_bytes = sizeof(rx_byte_buffer);

                status = 1;
                while(status){
                    drv_uart_printf("func: %s, line: %d\n", __func__, __LINE__);
                    status = pack_and_execute_command(&parcel, false);
                    drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
                    if(status != 0) {
                        drv_uart_printf("Certificate transmission error!\n");
                    }
                }
            }
        }

        if(status == 0) {
            break;
        }
    }

    //Obtain soc FW and execute the jump
    parcel.command = OP_RECV_SOC_FW;
    parcel.tx_buffer = tx_buffer;
    parcel.tx_bytes = sizeof(tx_buffer);
    parcel.rx_buffer = rx_buffer;
    parcel.rx_bytes = sizeof(rx_buffer);
    drv_uart_printf("func: %s, line: %d\n", __func__, __LINE__);
    status = 1;
    while(status){
        status = pack_and_execute_command(&parcel, false);
        drv_uart_printf("func: %s, line: %d, status = 0x%x\n", __func__, __LINE__, status);
        if(status != 0) {
            drv_uart_printf("SOC FW measurement failed!\n");
        }
    }

    drv_uart_printf("soc firmware:\n");
    for(uint32_t j = 0; j < parcel.rx_bytes; j++) {
        drv_uart_printf("0x%02x ", parcel.rx_buffer[j]);
        if (j % 16 == 15) {
            drv_uart_printf("\n");
        }
    }

    memcpy_fw_to_fwstore(parcel.rx_buffer, (void *)FWSTORE_ADDR, parcel.rx_bytes);
	if(!Validate_TargetBootloader(FWSTORE_ADDR)) {
		drv_uart_printf("func: %s, line: %d \r\n", __func__, __LINE__);
		jump_to_FWstore(FWSTORE_ADDR);
	}

	while(1)
	{
		drv_uart_getchar(&huart0, &ch);
		drv_uart_putchar(&huart0, &ch);
	}
}