#include "sw/device/my_tests/sm4/sm4_reg.h"
#include "sw/device/lib/runtime/log.h"

#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "sw/device/my_tests/base/base.h"
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

unsigned int *SM4_CTRL_SIGNALS_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_CTRL_SIGNALS_REG_OFFSET);
unsigned int *SM4_STATE_SIGNALS_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_STATE_SIGNALS_REG_OFFSET);
unsigned int *SM4_KEY_0_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_KEY_0_REG_OFFSET);
unsigned int *SM4_KEY_1_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_KEY_1_REG_OFFSET);
unsigned int *SM4_KEY_2_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_KEY_2_REG_OFFSET);
unsigned int *SM4_KEY_3_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_KEY_3_REG_OFFSET);
unsigned int *SM4_DATA_IN_0_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_DATA_IN_0_REG_OFFSET);
unsigned int *SM4_DATA_IN_1_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_DATA_IN_1_REG_OFFSET);
unsigned int *SM4_DATA_IN_2_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_DATA_IN_2_REG_OFFSET);
unsigned int *SM4_DATA_IN_3_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_DATA_IN_3_REG_OFFSET);
unsigned int *SM4_RESULT_OUT_0_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_RESULT_OUT_0_REG_OFFSET);
unsigned int *SM4_RESULT_OUT_1_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_RESULT_OUT_1_REG_OFFSET);
unsigned int *SM4_RESULT_OUT_2_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_RESULT_OUT_2_REG_OFFSET);
unsigned int *SM4_RESULT_OUT_3_REG_ADDR =(unsigned int *)(TOP_EARLGREY_SM4_BASE_ADDR+SM4_RESULT_OUT_3_REG_OFFSET);



void SM4_ON(void)
{
  *SM4_CTRL_SIGNALS_REG_ADDR |=(1<<SM4_CTRL_SIGNALS_SM4_ENABLE_IN_BIT);
  *SM4_CTRL_SIGNALS_REG_ADDR |=(1<<SM4_CTRL_SIGNALS_ENABLE_KEY_EXP_IN_BIT);
}

void operate_mode(unsigned int enc_dec)
{
  if(!enc_dec)
    *SM4_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<SM4_CTRL_SIGNALS_ENCDEC_SEL_IN_BIT);
  else *SM4_CTRL_SIGNALS_REG_ADDR |=(1<<SM4_CTRL_SIGNALS_ENCDEC_SEL_IN_BIT);    
}

void input_key128(unsigned int key[4])
{
  *SM4_KEY_0_REG_ADDR=key[0];
  *SM4_KEY_1_REG_ADDR=key[1];
  *SM4_KEY_2_REG_ADDR=key[2];
  *SM4_KEY_3_REG_ADDR=key[3];
  *SM4_CTRL_SIGNALS_REG_ADDR |=(1<<SM4_CTRL_SIGNALS_USER_KEY_VALID_IN_BIT);
}

void encdec_enable(unsigned int flag)
{
  if(flag)
    *SM4_CTRL_SIGNALS_REG_ADDR |=(1<<SM4_CTRL_SIGNALS_ENCDEC_ENABLE_IN_BIT);
  else *SM4_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<SM4_CTRL_SIGNALS_ENCDEC_ENABLE_IN_BIT);

}

void input_data(unsigned int data_in[4])
{
  *SM4_DATA_IN_0_REG_ADDR=data_in[0];
  *SM4_DATA_IN_1_REG_ADDR=data_in[1];
  *SM4_DATA_IN_2_REG_ADDR=data_in[2];
  *SM4_DATA_IN_3_REG_ADDR=data_in[3];
  *SM4_CTRL_SIGNALS_REG_ADDR |=(1<<SM4_CTRL_SIGNALS_VALID_IN_BIT);
}

//等待输出数据有效位的变化
void wait_for_dataout(void)
{
  while (!base_checkBit(SM4_STATE_SIGNALS_REG_ADDR,SM4_STATE_SIGNALS_VALID_OUT_BIT))
  {
    LOG_INFO("The SM4 unit is calculating!!!");/* code */
  }
  LOG_INFO("SM4 unit calculation completed!!!");
  
}

//将数据读取到out_data数组，如果此时数据无效则将out_data赋0值
void readout_data(unsigned int out_data[])      
{
  uint8_t valid_out_bit = 0;
  valid_out_bit =(*SM4_STATE_SIGNALS_REG_ADDR >> SM4_STATE_SIGNALS_VALID_OUT_BIT)&1;
  if(valid_out_bit)
  {
    out_data[0] =*SM4_RESULT_OUT_0_REG_ADDR;
    out_data[1] =*SM4_RESULT_OUT_1_REG_ADDR;
    out_data[2] =*SM4_RESULT_OUT_2_REG_ADDR;
    out_data[3] =*SM4_RESULT_OUT_3_REG_ADDR;
  }
  else
  { 
    for (uint8_t i = 0; i <4; i++)
    {
      out_data[i] =0;
    }
  }
}

void SM4_OFF(void)
{
  *SM4_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<SM4_CTRL_SIGNALS_SM4_ENABLE_IN_BIT);
  *SM4_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<SM4_CTRL_SIGNALS_ENABLE_KEY_EXP_IN_BIT);
  encdec_enable(DISABLE_encdec);  
  *SM4_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<SM4_CTRL_SIGNALS_USER_KEY_VALID_IN_BIT);
  *SM4_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<SM4_CTRL_SIGNALS_VALID_IN_BIT);
}

