#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "sw/device/my_tests/base/base.h"
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

//返回寄存器的某个位的值
uint8_t base_checkBit(unsigned int* registerAddress, unsigned int bit) {  
    return (*registerAddress & (1 << bit)) != 0;  
}

//等待某个寄存器的某个位拉高
void base_wait_for_BIT(unsigned int* RegisterAddr, unsigned int Bit)
{ 
  while (!base_checkBit(RegisterAddr,Bit))//
  {
    asm volatile("" ::: "memory");
  }
    
}

//精确延时函数，延时始终周期=27+number*3
void delay_clock(unsigned int number)
{
  unsigned int i = number;
  while (i>0)
  {
    asm volatile("" ::: "memory");
    i--;
  }
  
}