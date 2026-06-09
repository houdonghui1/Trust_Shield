#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "sw/device/lib/runtime/log.h"

#include "sw/device/my_tests/base/base.h"
#include "sw/device/my_tests/rs_decode/rs_decode.h"

unsigned int *RS_DECODE_CTRL_SIGNALS_REG_ADDR =(unsigned int *)(TOP_EARLGREY_RS_DECODE_BASE_ADDR+RS_DECODE_CTRL_SIGNALS_REG_OFFSET);
unsigned int *RS_DECODE_STATE_SIGNALS_REG_ADDR =(unsigned int *)(TOP_EARLGREY_RS_DECODE_BASE_ADDR+RS_DECODE_STATE_SIGNALS_REG_OFFSET);


void rs_decode_function(unsigned int encoded_data_err_input[],unsigned int error_pos_output[])
{
    unsigned int *data_in_addr =(unsigned int *)(TOP_EARLGREY_RS_DECODE_BASE_ADDR+RS_DECODE_ENCODED_DATA_IN_49_REG_OFFSET);
    unsigned int *data_out_addr =(unsigned int *)(TOP_EARLGREY_RS_DECODE_BASE_ADDR+RS_DECODE_ERROR_POS_OUT_49_REG_OFFSET);
    unsigned int temp1 = (unsigned int)data_in_addr;
    //LOG_INFO("temp1=%08x",temp1);
    unsigned int temp2 = (unsigned int)data_out_addr;
    //LOG_INFO("temp2=%08x",temp2);

    *RS_DECODE_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<RS_DECODE_CTRL_SIGNALS_CLRN_BIT);
    asm volatile("" ::: "memory");
    *RS_DECODE_CTRL_SIGNALS_REG_ADDR |=(1<<RS_DECODE_CTRL_SIGNALS_CLRN_BIT);
    
    for (uint8_t i = 0; i < 50; i++)
    {
        data_in_addr =(unsigned int *)temp1;
        *data_in_addr = encoded_data_err_input[i];
        //LOG_INFO("i=%08x",i);
        //LOG_INFO("data_in_addr=%08x",data_in_addr);
        temp1 = (unsigned int)(data_in_addr) - 0x4;//一种操作指针的方法
    }

    *RS_DECODE_CTRL_SIGNALS_REG_ADDR |=(1<<RS_DECODE_CTRL_SIGNALS_DECODE_EN_BIT);
    asm volatile("" ::: "memory");
    *RS_DECODE_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<RS_DECODE_CTRL_SIGNALS_DECODE_EN_BIT);  

    delay_clock(74);//延时到with_error位预定拉高时间点
    if (base_checkBit(RS_DECODE_STATE_SIGNALS_REG_ADDR,RS_DECODE_STATE_SIGNALS_WITH_ERROR_BIT_BIT))
    {
        base_wait_for_BIT(RS_DECODE_STATE_SIGNALS_REG_ADDR,RS_DECODE_STATE_SIGNALS_READY_BIT_BIT);

        for (uint8_t j = 0; j < 50; j++)
        {
            data_out_addr =(unsigned int *)temp2;
            error_pos_output[j] = *data_out_addr;
            //LOG_INFO("j=%08x",j);
            //LOG_INFO("data_out_addr=%08x",data_out_addr);
            temp2 = (unsigned int)(data_out_addr) - 0x4;
        }
    }
    else
    {
        for (uint8_t k = 0; k < 50; k++)
        {
            error_pos_output[k] = 0;
        }
    }
    

    *RS_DECODE_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<RS_DECODE_CTRL_SIGNALS_CLRN_BIT);
    asm volatile("" ::: "memory");
    *RS_DECODE_CTRL_SIGNALS_REG_ADDR |=(1<<RS_DECODE_CTRL_SIGNALS_CLRN_BIT);

}

void test_ask_with_error(void)
{
    *RS_DECODE_CTRL_SIGNALS_REG_ADDR |=(1<<RS_DECODE_CTRL_SIGNALS_DECODE_EN_BIT);
    asm volatile("" ::: "memory");
    *RS_DECODE_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<RS_DECODE_CTRL_SIGNALS_DECODE_EN_BIT);
    delay_clock(74);
    *RS_DECODE_CTRL_SIGNALS_REG_ADDR |=(1<<RS_DECODE_CTRL_SIGNALS_DECODE_EN_BIT);
    asm volatile("" ::: "memory");
    *RS_DECODE_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<RS_DECODE_CTRL_SIGNALS_DECODE_EN_BIT);
}