#include "sw/device/lib/runtime/log.h"
#include "sw/device/my_tests/rs_encode/rs_encode.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

//定义寄存器



OTTF_DEFINE_TEST_CONFIG();

unsigned int result_buf1[50];
unsigned int result_buf2[50];
unsigned int result_buf3[50];


bool test_main(void) {

    LOG_INFO("Now, rs_encode unit test!");
    LOG_INFO("Load data,expected encoded result:d9dcbd68(HEAD)");
    rs_encode_function(data_in_bufA,result_buf1);
    LOG_INFO("Actual result");
    LOG_INFO("%08x",result_buf1[0]);

    rs_encode_function(data_in_bufB,result_buf2);
    LOG_INFO("Actual result");
    LOG_INFO("%08x",result_buf2[0]);
    
    rs_encode_function(data_in_bufA,result_buf3);
    LOG_INFO("Actual result");
    LOG_INFO("%08x",result_buf3[0]);

    return true;
}
