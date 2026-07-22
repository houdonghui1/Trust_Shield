//===============================================
//
//	File: drv_uart_ex.c
//	Author: afterGlow,4ever
//	Group: Fall For Laboratory
//	Date: 01062024
//	Version: v1.0
//
// 	This is source file for uart extented driver.
//
//===============================================

#include "drv_uart.h"
#include "drv_uart_ex.h"

#ifdef UART_EX_DRIVER

extern UART_HandleTypeDef PRINTF_HUART;
static char buffer[128];

//===============================================
// uart printf
//===============================================

int vprintf(const char *fmt, va_list argp)
{
	char string[64];
	if(vsprintf(string, fmt, argp) > 0)
	{
		drv_uart_putchars(&PRINTF_HUART, (uint8_t *)string, strlen(string));
	}
	return strlen(string);
}

void drv_uart_printf(const char *fmt, ...)
{
	va_list argp;
    
    va_start(argp, fmt);
    vsnprintf(buffer, sizeof(buffer), fmt, argp);
    va_end(argp);

    char *pos = buffer;
    while ((pos = strchr(pos, '\n')) != NULL)
    {
        memmove(pos + 1, pos, strlen(pos) + 1);
        *pos = '\r';
        pos += 2;
    }

    drv_uart_putchars(&PRINTF_HUART, (uint8_t *)buffer, strlen(buffer));
}

#endif

