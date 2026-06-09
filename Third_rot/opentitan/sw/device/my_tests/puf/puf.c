#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "sw/device/lib/runtime/log.h"

#include "sw/device/my_tests/puf/puf.h"
#include "sw/device/my_tests/base/base.h"


//定义寄存器
unsigned int *PUF_CTRL_SIGNALS_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_CTRL_SIGNALS_REG_OFFSET);
unsigned int *PUF_STATE_SIGNALS_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_STATE_SIGNALS_REG_OFFSET);

unsigned int *PUF_CHALLENGE_0_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_CHALLENGE_0_REG_OFFSET);
unsigned int *PUF_CHALLENGE_1_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_CHALLENGE_1_REG_OFFSET);
unsigned int *PUF_CHALLENGE_2_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_CHALLENGE_2_REG_OFFSET);
unsigned int *PUF_CHALLENGE_3_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_CHALLENGE_3_REG_OFFSET);

unsigned int *PUF_RESPONSE_0_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_0_REG_OFFSET);
unsigned int *PUF_RESPONSE_1_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_1_REG_OFFSET);
unsigned int *PUF_RESPONSE_2_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_2_REG_OFFSET);
unsigned int *PUF_RESPONSE_3_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_3_REG_OFFSET);
unsigned int *PUF_RESPONSE_4_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_4_REG_OFFSET);
unsigned int *PUF_RESPONSE_5_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_5_REG_OFFSET);
unsigned int *PUF_RESPONSE_6_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_6_REG_OFFSET);
unsigned int *PUF_RESPONSE_7_REG_ADDR =(unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_7_REG_OFFSET);



//PUF开机，默认是RNG模式
void PUF_ON(void)
{
    *PUF_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<PUF_CTRL_SIGNALS_MODE_PUF_BIT);//设为RNG模式
    asm volatile("" ::: "memory");//不优化寄存器操作
    *PUF_CTRL_SIGNALS_REG_ADDR |=(1<<PUF_CTRL_SIGNALS_ENABLE_PUF_BIT);//开机
}

//进行一次C——R的运算，先关机，设为PUF模式后开机，计算取数完成后再恢复成RNG模式。
void puf_get_res_of_a_cha(unsigned int challenge_input[],unsigned int response_output[])
{
    *PUF_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<PUF_CTRL_SIGNALS_ENABLE_PUF_BIT);//每次计算前先关机
    //asm volatile("" ::: "memory");//不优化寄存器操作
    
    *PUF_CHALLENGE_0_REG_ADDR = challenge_input[3];
    *PUF_CHALLENGE_1_REG_ADDR = challenge_input[2];
    *PUF_CHALLENGE_2_REG_ADDR = challenge_input[1];
    *PUF_CHALLENGE_3_REG_ADDR = challenge_input[0];
    
    *PUF_CTRL_SIGNALS_REG_ADDR |=(1<<PUF_CTRL_SIGNALS_MODE_PUF_BIT);//设置为PUF模式
    asm volatile("" ::: "memory");//不优化寄存器操作
    *PUF_CTRL_SIGNALS_REG_ADDR |=(1<<PUF_CTRL_SIGNALS_ENABLE_PUF_BIT);//开机
    asm volatile("" ::: "memory");//不优化寄存器操作
    *PUF_CTRL_SIGNALS_REG_ADDR |=(1<<PUF_CTRL_SIGNALS_READY_CHA_BIT);//开始计算
    asm volatile("" ::: "memory");//不优化寄存器操作
    *PUF_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<PUF_CTRL_SIGNALS_READY_CHA_BIT);//为下次计算方便，放低触发位。
    
    base_wait_for_BIT(PUF_STATE_SIGNALS_REG_ADDR,PUF_STATE_SIGNALS_RESPONSE_VALID_BIT_BIT);//等待计算完成

    response_output[0] = *PUF_RESPONSE_7_REG_ADDR;
    response_output[1] = *PUF_RESPONSE_6_REG_ADDR;
    response_output[2] = *PUF_RESPONSE_5_REG_ADDR;
    response_output[3] = *PUF_RESPONSE_4_REG_ADDR;
    response_output[4] = *PUF_RESPONSE_3_REG_ADDR;
    response_output[5] = *PUF_RESPONSE_2_REG_ADDR;
    response_output[6] = *PUF_RESPONSE_1_REG_ADDR;
    response_output[7] = *PUF_RESPONSE_0_REG_ADDR;

    *PUF_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<PUF_CTRL_SIGNALS_ENABLE_PUF_BIT);//关机
    *PUF_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<PUF_CTRL_SIGNALS_MODE_PUF_BIT);//设为RNG模式
    asm volatile("" ::: "memory");//不优化寄存器操作
    *PUF_CTRL_SIGNALS_REG_ADDR |=(1<<PUF_CTRL_SIGNALS_ENABLE_PUF_BIT);//开机
}

//将一个长 wordnumber_of_old 字的数组补零扩充到 wordnumber_of_new 长并存在一个数组中。
void add_0_to_buf(unsigned int old_buf[],uint8_t wordnumber_of_old,unsigned int new_buf[],uint8_t wordnumber_of_new)
{
  for (unsigned int i = 0; i < wordnumber_of_old; i++)
  {
    new_buf[i] = old_buf[i];
  }
  for (unsigned int j = wordnumber_of_old; j < wordnumber_of_new; j++)
  {
    new_buf[j] = 0;
  }
}

//将一个长 wordnumber_of_old 字的数组补1扩充到 wordnumber_of_new 长并存在一个数组中。
void add_1_to_buf(unsigned int old_buf[],uint8_t wordnumber_of_old,unsigned int new_buf[],uint8_t wordnumber_of_new)
{
  for (unsigned int i = 0; i < wordnumber_of_old; i++)
  {
    new_buf[i] = old_buf[i];
  }
  for (unsigned int j = wordnumber_of_old; j < wordnumber_of_new; j++)
  {
    new_buf[j] = 0xffffffff;
  }
}

//注意参数bufa需要一个50字长度的数组，将这个数组的开始8字赋给bufb
void save_start_32bytes_of_encoded_data1(unsigned int bufa[],unsigned int bufb[])
{
  for (uint8_t i = 0; i < 8; i++)
  {
    bufb[i] = bufa[i];
  }
}

////注意参数bufa需要一个50字长度的数组，将这个数组末8字赋给bufb
void save_end_32bytes_of_encoded_data1(unsigned int bufa[],unsigned int bufb[])
{
  for (uint8_t i = 0; i < 8; i++)
  {
    bufb[i] = bufa[i+42];
  }
}

//首次response编码所得的encoded_data1的8字拼接后面算得的新response再补零，得到encoded_data星。
void B1_pin_Rxing_add0(unsigned int B1[],unsigned int Rxing[],unsigned int encoded_data1xing[])
{
  for (uint8_t i = 0; i < 8; i++)
  {
    encoded_data1xing[i] = B1[i];
  }
  for (uint8_t j = 8; j < 16; j++)
  {
    encoded_data1xing[j] = Rxing[j-8];
  }
  for (uint8_t k = 16; k < 50; k++)
  {
    encoded_data1xing[k] = 0;
  }
  
}

//后面算得的新response拼接首次response编码所得的encoded_data1的8字再补零，得到encoded_data星。
void Rxing_pin_B1__add0(unsigned int Rxing[],unsigned int B1[],unsigned int encoded_data1xing[])
{
  for (uint8_t i = 0; i < 8; i++)
  {
    encoded_data1xing[i] = Rxing[i];
  }
  for (uint8_t j = 8; j < 16; j++)
  {
    encoded_data1xing[j] = B1[j-8];
  }
  for (uint8_t k = 16; k < 50; k++)
  {
    encoded_data1xing[k] = 0;
  }
  
}

//encoded_data和error_pos(都是50字)异或，并消零，得出一个8字的结果。outputbuf存中间的8个字
void two_buf_yihuo_and_remove0(unsigned int buf1[],unsigned int buf2[],unsigned int outputbuf[])
{
  unsigned int temp[50];
  for (uint8_t i = 0; i < 50; i++)
  {
    temp[i] = buf1[i] ^ buf2[i];
  }
  for (uint8_t j = 0; j < 8; j++)
  {
    outputbuf[j] = temp[j+8];
  }
  
}
