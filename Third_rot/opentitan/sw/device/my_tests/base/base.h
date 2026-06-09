
#ifndef _OPENTITAN_MY_BASE_DEFS_
#define _OPENTITAN_MY_BASE_DEFS_

#ifdef __cplusplus
extern "C" {
#endif


uint8_t base_checkBit(unsigned int* registerAddress, unsigned int bit);

void base_wait_for_BIT(unsigned int* RegisterAddr, unsigned int Bit);

void delay_clock(unsigned int number);

#ifdef __cplusplus
}  // extern "C"
#endif
#endif
