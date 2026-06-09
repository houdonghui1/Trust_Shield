#include "sw/device/lib/runtime/log.h"
#include "sw/device/my_tests/rs_encode/rs_encode.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "sw/device/my_tests/base/base.h"
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

unsigned int *RS_ENCODE_CTRL_SIGNALS_REG_ADDR =(unsigned int *)(TOP_EARLGREY_RS_ENCODE_BASE_ADDR+RS_ENCODE_CTRL_SIGNALS_REG_OFFSET);

unsigned int *RS_ENCODE_STATE_SIGNALS_REG_ADDR =(unsigned int *)(TOP_EARLGREY_RS_ENCODE_BASE_ADDR+RS_ENCODE_STATE_SIGNALS_REG_OFFSET);



void rs_encode_function(unsigned int data_input[],unsigned int encoded_output[])
{
    unsigned int *data_in_addr =(unsigned int *)(TOP_EARLGREY_RS_ENCODE_BASE_ADDR+RS_ENCODE_DATA_IN_41_REG_OFFSET);
    unsigned int *data_out_addr =(unsigned int *)(TOP_EARLGREY_RS_ENCODE_BASE_ADDR+RS_ENCODE_ENCODED_DATA_OUT_49_REG_OFFSET);
    unsigned int temp1 = (unsigned int)data_in_addr;
    //LOG_INFO("temp1=%08x",temp1);
    unsigned int temp2 = (unsigned int)data_out_addr;
    //LOG_INFO("temp2=%08x",temp2);
    
    *RS_ENCODE_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<RS_ENCODE_CTRL_SIGNALS_CLRN_BIT);//运算前进行模块清零
    asm volatile("" ::: "memory");
    *RS_ENCODE_CTRL_SIGNALS_REG_ADDR |=(1<<RS_ENCODE_CTRL_SIGNALS_CLRN_BIT);
    
    for (uint8_t i = 0; i < 42; i++)
    {
        data_in_addr =(unsigned int *)temp1;
        *data_in_addr = data_input[i];
        //LOG_INFO("i=%08x",i);
        //LOG_INFO("data_in_addr=%08x",data_in_addr);
        temp1 = (unsigned int)(data_in_addr) - 0x4;//一种操作指针的方法
    }
    /*
    for (uint8_t i = 0; i < 42; i++)
    {
        *data_in_addr = data_input[i];
        //LOG_INFO("i=%08x",i);
        LOG_INFO("data_in_addr=%08x",data_in_addr);
        data_in_addr =(unsigned int *)(RS_ENCODE_DATA_IN_41_REG_ADDR - (i+1) * (0x1u));
    }
    */
    *RS_ENCODE_CTRL_SIGNALS_REG_ADDR |=(1<<RS_ENCODE_CTRL_SIGNALS_ENCODE_EN_BIT);
    asm volatile("" ::: "memory");
    *RS_ENCODE_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<RS_ENCODE_CTRL_SIGNALS_ENCODE_EN_BIT);
    
    //wait_for_RDY_BIT_rs_encode();
    base_wait_for_BIT(RS_ENCODE_STATE_SIGNALS_REG_ADDR,RS_ENCODE_STATE_SIGNALS_READY_BIT_BIT);//等待ready位拉高
    
    for (uint8_t j = 0; j < 50; j++)
    {
        data_out_addr =(unsigned int *)temp2;
        encoded_output[j] = *data_out_addr;
        //LOG_INFO("j=%08x",j);
        //LOG_INFO("data_out_addr=%08x",data_out_addr);
        temp2 = (unsigned int)(data_out_addr) - 0x4;
    }

    *RS_ENCODE_CTRL_SIGNALS_REG_ADDR &=~(unsigned int)(1<<RS_ENCODE_CTRL_SIGNALS_CLRN_BIT);//读数完成后进行模块清零
    asm volatile("" ::: "memory");
    *RS_ENCODE_CTRL_SIGNALS_REG_ADDR |=(1<<RS_ENCODE_CTRL_SIGNALS_CLRN_BIT);
    /*
    for (uint8_t j = 0; j < 50; j++)
    {
        encoded_output[j] = *data_out_addr;
        //LOG_INFO("j=%08x",j);
        LOG_INFO("data_out_addr=%08x",data_out_addr);
        data_out_addr =(unsigned int *)(RS_ENCODE_ENCODED_DATA_OUT_49_REG_ADDR - (j+1) * (0x1u));//将output_data移到数组中
    }
    */
}
