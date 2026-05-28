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

UART_HandleTypeDef huart0;

typedef struct {
    uint32_t* initial_sp;
    void (*fwstore)(void);
} FWstore_t;

int Validate_TargetBootloader(uint32_t target_base) 
{
    FWstore_t *vt = (FWstore_t*)target_base;

    // 1. 检查栈指针是否指向有效 RAM 区域
    if ((uint32_t)vt->initial_sp < 0x0 || 
        (uint32_t)vt->initial_sp > 0x6FFFF) {
        return 1;  // 栈指针非法
    }

    // 2. 检查复位函数指针是否指向 Flash 区域
    if ((uint32_t)vt->fwstore < 0x0 || 
        (uint32_t)vt->fwstore > 0x6FFFF) {
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

    // 此处代码不会执行
    while(1);
}

int main(void)
{
	uint8_t ch;

	huart0.regs = UART0;
	drv_uart_default_config(&huart0);
	drv_uart_init(&huart0);
	drv_uart_printf("B CA.\r\n");//仿真时输出ASCII码，需要手动转换。

	writereg32(0x40000000, 0xed);

    test_info info = {
        .rom = NULL,
        .image_bundle = NULL,
        .fuses = {{0}},
    };

	//=====================================================
	set_fuses(&info);

	drv_caliptra1x_init(&info,false);

	//Get FMC （Using SPI to access SD）
	//if(FMC == caliptra) {
		//load to mailbox

		//send cmd: firmware loading

	//} else {
		//soc Rom measure soc FMC 

		//send cmd: store measurement

	//}
	
	//Boot soc FMC, measure next firmware

	//Verfiy DICE identity
	//=====================================================
	
/* 	if(!Validate_TargetBootloader(FWSTORE_ADDR)) {
		drv_uart_printf("func: %s, line: %d \r\n", __func__, __LINE__);
		jump_to_FWstore(FWSTORE_ADDR);
	} */

	while(1)
	{
		drv_uart_getchar(&huart0, &ch);
		drv_uart_putchar(&huart0, &ch);
	}
}
