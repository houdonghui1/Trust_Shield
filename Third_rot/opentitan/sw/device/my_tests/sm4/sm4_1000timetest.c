#include "sw/device/my_tests/sm4/sm4_reg.h"
#include "sw/device/lib/runtime/log.h"

#include "sw/device/lib/testing/test_framework/ottf_main.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

//#include <stdio.h>


unsigned int out_data[4];//定义数组来接收输出数据



OTTF_DEFINE_TEST_CONFIG();



bool test_main(void) {

  LOG_INFO("********************************************");
  LOG_INFO("Now proceed with testing the SM4 1000 times.");
  for (size_t i = 0; i < 1000; i++)
  {
    SM4_ON();
    LOG_INFO(" ");
    LOG_INFO("-------------------------------------------");
    LOG_INFO("The first step is the encryption process.");
    operate_mode(enc_mode);
  
    input_key128(key_enc);
    LOG_INFO("INPUT KEY_ENC IS:");
    LOG_INFO("%08x%08x%08x%08x",key_enc[3],key_enc[2],key_enc[1],key_enc[0]);
  
    encdec_enable(ENABLE_encdec);
    LOG_INFO("Enable encryption");
  
    input_data(data_in_enc);
    LOG_INFO("Load data <128'h0123456789abcdeffedcba9876543210> and start encryption");
  
    LOG_INFO("Wait for dataout");
  
    LOG_INFO("Expected encryption result: 128'h681edf34d206965e86b3e94f536e4246");
    LOG_INFO("Actual encryption result:");
    
    readout_data(out_data);//读到数组中
    LOG_INFO("%08x%08x%08x%08x",out_data[3],out_data[2],out_data[1],out_data[0]);//将数组中的值显示
    
    SM4_OFF();
    LOG_INFO(" ");
    LOG_INFO("------------------------------------------");
/*接下来是解密过程*/
    LOG_INFO("The second step is the decryption process.");
    SM4_ON();
    
    operate_mode(dec_mode);
  
    input_key128(key_dec);
    LOG_INFO("INPUT KEY IS:");
    LOG_INFO("%08x%08x%08x%08x",key_dec[3],key_dec[2],key_dec[1],key_dec[0]);
    
    encdec_enable(ENABLE_encdec);
    LOG_INFO("Enable decryption");
  
    input_data(data_in_dec);
    LOG_INFO("Load data <128'h681edf34d206965e86b3e94f536e4246> and start decryption");
  
    LOG_INFO("Wait for dataout");
    
    readout_data(out_data);//读到数组中
  
    LOG_INFO("Expected decryption result: 128'h0123456789abcdeffedcba9876543210");
    LOG_INFO("Actual encryption result:");
  
    LOG_INFO("%08x%08x%08x%08x",out_data[3],out_data[2],out_data[1],out_data[0]);//将数组中的值显示
    SM4_OFF();
  
  }
  
  LOG_INFO(" ");
  LOG_INFO("The process takes 2015.22us");
  LOG_INFO(" ");
  LOG_INFO("********************************************");
  return true;
}
