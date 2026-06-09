#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "sw/device/lib/runtime/log.h"

#include "sw/device/my_tests/rs_decode/rs_decode.h"

//#define ADD_CHECK_WITH_ERROR

OTTF_DEFINE_TEST_CONFIG();

unsigned int result_buf1[50];
unsigned int result_buf2[50];
unsigned int result_buf3[50];
unsigned int encoded_data_err_input_bufC_error[50];


#ifdef ADD_CHECK_WITH_ERROR

bool test_main(void) {

  LOG_INFO("Now, rs_decode unit test!");
  
  test_ask_with_error();

  return true;
}

#else

bool test_main(void) {

    /*
    LOG_INFO("Now, rs_decode unit test!");
    //LOG_INFO("Load data,expected error_pos result:00d00605(HEAD)");
    LOG_INFO("encoded_data_err_input_bufC :");
    
    for (size_t i = 0; i < 16; i++)
    {
      encoded_data_err_input_bufC_error[i] = encoded_data_err_input_bufC[i] ^ ref_err_pos_16words[i];
    }
    
    for (size_t k = 16; k < 50; k++)
      {
        encoded_data_err_input_bufC[k] = 0;
        //LOG_INFO("%08x",encoded_data_err_input_bufC[k]);
      }
    for (size_t k = 0; k < 50; k++)
      {
        //encoded_data_err_input_bufC[k] = 0xffffffff;
        LOG_INFO("%08x",encoded_data_err_input_bufC[k]);
      }
    */
    LOG_INFO("Load data,wait error_pos.");
    rs_decode_function(encoded_data_err_input_bufC,result_buf1);
    LOG_INFO("Actual result");
    for (size_t k = 0; k < 50; k++)
      {
        //encoded_data_err_input_bufC[k] = 0xffffffff;
        LOG_INFO("%08x",result_buf1[k]);
      }
    //LOG_INFO("%08x",result_buf1[0]);

    rs_decode_function(encoded_data_err_input_bufA,result_buf3);
    LOG_INFO("Actual result");
    LOG_INFO("%08x%08x",result_buf3[0],result_buf3[1]);

    return true;
}

#endif
