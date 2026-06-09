#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "sw/device/lib/runtime/log.h"

#include "sw/device/my_tests/base/base.h"
#include "sw/device/my_tests/sm3/sm3.h"


unsigned int *SM3_CTRL_SIGNALS_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM3_BASE_ADDR+SM3_CTRL_SIGNALS_REG_OFFSET);
unsigned int *SM3_STATE_SIGNALS_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM3_BASE_ADDR+SM3_STATE_SIGNALS_REG_OFFSET);

unsigned int *SM3_MESSAGE_IN_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM3_BASE_ADDR+SM3_MESSAGE_IN_REG_OFFSET);

unsigned int *SM3_RESULT_OUT_0_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM3_BASE_ADDR+SM3_RESULT_OUT_0_REG_OFFSET);
unsigned int *SM3_RESULT_OUT_1_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM3_BASE_ADDR+SM3_RESULT_OUT_1_REG_OFFSET);
unsigned int *SM3_RESULT_OUT_2_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM3_BASE_ADDR+SM3_RESULT_OUT_2_REG_OFFSET);
unsigned int *SM3_RESULT_OUT_3_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM3_BASE_ADDR+SM3_RESULT_OUT_3_REG_OFFSET);
unsigned int *SM3_RESULT_OUT_4_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM3_BASE_ADDR+SM3_RESULT_OUT_4_REG_OFFSET);
unsigned int *SM3_RESULT_OUT_5_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM3_BASE_ADDR+SM3_RESULT_OUT_5_REG_OFFSET);
unsigned int *SM3_RESULT_OUT_6_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM3_BASE_ADDR+SM3_RESULT_OUT_6_REG_OFFSET);
unsigned int *SM3_RESULT_OUT_7_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM3_BASE_ADDR+SM3_RESULT_OUT_7_REG_OFFSET);

void SM3_hash_function(unsigned int message[],unsigned int message_long,uint8_t last_msg_type,unsigned int hash_result[8])
{
    set_msg_vld_byte(4);//消息主体全字有效
    //输入消息的主体
    for (unsigned int i = 0; i < message_long-1; i++)
    {
        base_wait_for_BIT(SM3_STATE_SIGNALS_REG_ADDR,SM3_STATE_SIGNALS_MSG_INPT_RDY_BIT);
        *SM3_MESSAGE_IN_REG_ADDR =message[i];
    }
    set_msg_vld_byte(last_msg_type);//设置最后消息的有效位
    asm volatile("" ::: "memory");
    set_the_last_message_flag(1);
    *SM3_MESSAGE_IN_REG_ADDR =message[message_long-1];//输入最后的消息
    
    //将输出数据u保存到数组
    base_wait_for_BIT(SM3_STATE_SIGNALS_REG_ADDR,SM3_STATE_SIGNALS_MSG_INPT_RDY_BIT);
    hash_result[0] =*SM3_RESULT_OUT_7_REG_ADDR;
    hash_result[1] =*SM3_RESULT_OUT_6_REG_ADDR;
    hash_result[2] =*SM3_RESULT_OUT_5_REG_ADDR;
    hash_result[3] =*SM3_RESULT_OUT_4_REG_ADDR;
    hash_result[4] =*SM3_RESULT_OUT_3_REG_ADDR;
    hash_result[5] =*SM3_RESULT_OUT_2_REG_ADDR;
    hash_result[6] =*SM3_RESULT_OUT_1_REG_ADDR;
    hash_result[7] =*SM3_RESULT_OUT_0_REG_ADDR;
    set_the_last_message_flag(0);
}

//计算一个字（32位）的哈希
void SM3_hash_one_word(unsigned int message_word,unsigned int hash_result[8])
{
    set_msg_vld_byte(4);//消息全字有效
    asm volatile("" ::: "memory");
    set_the_last_message_flag(1);
    *SM3_MESSAGE_IN_REG_ADDR =message_word;
    
    base_wait_for_BIT(SM3_STATE_SIGNALS_REG_ADDR,SM3_STATE_SIGNALS_MSG_INPT_RDY_BIT);
    hash_result[0] =*SM3_RESULT_OUT_7_REG_ADDR;
    hash_result[1] =*SM3_RESULT_OUT_6_REG_ADDR;
    hash_result[2] =*SM3_RESULT_OUT_5_REG_ADDR;
    hash_result[3] =*SM3_RESULT_OUT_4_REG_ADDR;
    hash_result[4] =*SM3_RESULT_OUT_3_REG_ADDR;
    hash_result[5] =*SM3_RESULT_OUT_2_REG_ADDR;
    hash_result[6] =*SM3_RESULT_OUT_1_REG_ADDR;
    hash_result[7] =*SM3_RESULT_OUT_0_REG_ADDR;
}


//等待输出数据有效位的变化
void wait_for_dataout(void)
{
  while (!base_checkBit(SM3_STATE_SIGNALS_REG_ADDR,SM3_STATE_SIGNALS_CMPRSS_OTPT_VLD_BIT))//应该问red!!!
  {
    LOG_INFO("The SM3 unit is calculating!!!");/* code */
  }
  LOG_INFO("SM3 unit calculation completed!!!");
  
}

//等待rdy
void wait_for_RDY_BIT(void)
{ 
  while (!base_checkBit(SM3_STATE_SIGNALS_REG_ADDR,SM3_STATE_SIGNALS_MSG_INPT_RDY_BIT))//应该问red!!!
  {
    asm volatile("" ::: "memory");
  }
    
}

//设置消息有效字节位
void set_msg_vld_byte(uint8_t mask)//从高位开始对齐，从高位往下数字节数。
{
    switch (mask)
    {
    case 1:
        *SM3_CTRL_SIGNALS_REG_ADDR =0x10;
        break;
    case 2:
        *SM3_CTRL_SIGNALS_REG_ADDR =0x18;
        break;
    case 3:
        *SM3_CTRL_SIGNALS_REG_ADDR =0x1c;
        break;
    case 4:
        *SM3_CTRL_SIGNALS_REG_ADDR =0x1e;
        break;    
    default:
        *SM3_CTRL_SIGNALS_REG_ADDR =0x1e;
        break;
    }
    
}

//设置最后的消息标志位
void set_the_last_message_flag(uint8_t flag)
{
    if(flag)
    *SM3_CTRL_SIGNALS_REG_ADDR |=(1<<SM3_CTRL_SIGNALS_MSG_INPT_LST_BIT);
    else *SM3_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<SM3_CTRL_SIGNALS_MSG_INPT_LST_BIT);
}
