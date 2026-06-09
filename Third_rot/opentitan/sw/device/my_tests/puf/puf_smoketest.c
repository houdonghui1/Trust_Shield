#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "sw/device/lib/runtime/log.h"

#include "sw/device/my_tests/puf/puf.h"
#include "sw/device/my_tests/rs_encode/rs_encode.h"
#include "sw/device/my_tests/rs_decode/rs_decode.h"

//#define PUF_no_RS
#define PUF_and_RSCODE
//#define PUF_RNG_MODE

OTTF_DEFINE_TEST_CONFIG();

unsigned int challenge_xing[4] = {0,0,0,0};
unsigned int result_buf[8] = {0,0,0,0,0,0,0,0};
unsigned int result_buf_xing[8] = {0,0,0,0,0,0,0,0};

unsigned int false_cnt = 0;

unsigned int rsencode_data_in_buf[42];
unsigned int rsencode_encoded_data[50];
unsigned int start32bytes_of_encoded_data1[8];
unsigned int end32bytes_of_encoded_data1[8];

unsigned int encoded_data_xing[50];
unsigned int error_pos_xing[50];
unsigned int rs_response[8];


#ifdef PUF_and_RSCODE
//PUF结合RSCODE的测试，测试rscode对response的纠错能力。

bool test_main(void) {
/*    
    PUF_ON();
    LOG_INFO("first Load c_challenge, wait response");
    
    LOG_INFO("R1 :");
    puf_get_res_of_a_cha(c_challenge,result_buf);
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",result_buf[0],result_buf[1],result_buf[2],result_buf[3],result_buf[4],result_buf[5],result_buf[6],result_buf[7]);
    add_0_to_buf(result_buf,8,rsencode_data_in_buf,42);//为R1补0
    //LOG_INFO("R1_add0 :");
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x",rsencode_data_in_buf[0],rsencode_data_in_buf[1],rsencode_data_in_buf[2],rsencode_data_in_buf[3],rsencode_data_in_buf[4],rsencode_data_in_buf[5],rsencode_data_in_buf[6],rsencode_data_in_buf[7],rsencode_data_in_buf[8],rsencode_data_in_buf[9]);

    rs_encode_function(rsencode_data_in_buf,rsencode_encoded_data);//对R1补0后的数据编码
    LOG_INFO("encoded_data of R1 :");
    for (size_t p = 0; p < 50; p++)
      {
        LOG_INFO("%08x",rsencode_encoded_data[p]);
      }
    //将编码后的数搞错几位
    for (size_t i = 0; i < 16; i++)
    {
      rsencode_encoded_data[i] = rsencode_encoded_data[i] ^ err_pos_16words[i];
    }
    
    LOG_INFO("encoded_data_with_error of R1 :");
    for (size_t p = 0; p < 50; p++)
      {
        LOG_INFO("%08x",rsencode_encoded_data[p]);
      }
      
    rs_decode_function(rsencode_encoded_data,error_pos_xing);//对encoded_data_xing解码运算,找错位
    LOG_INFO("error_pos_xing :");
    for (size_t k = 0; k < 50; k++)
      {
        LOG_INFO("%08x",error_pos_xing[k]);
      }
    two_buf_yihuo_and_remove0(rsencode_encoded_data,error_pos_xing,rs_response);//异或纠错
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",rs_response[0],rs_response[1],rs_response[2],rs_response[3],rs_response[4],rs_response[5],rs_response[6],rs_response[7]);
*/

    LOG_INFO("Now, PUF_and_RSCODE (puf mode) test!");
    PUF_ON();
    LOG_INFO("first Load challenge1, wait response");
    
    LOG_INFO("R1 :");
    puf_get_res_of_a_cha(c_challenge,result_buf);
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",result_buf[0],result_buf[1],result_buf[2],result_buf[3],result_buf[4],result_buf[5],result_buf[6],result_buf[7]);
    
    add_0_to_buf(result_buf,8,rsencode_data_in_buf,42);//为R1补零
    
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x",rsencode_data_in_buf[0],rsencode_data_in_buf[1],rsencode_data_in_buf[2],rsencode_data_in_buf[3],rsencode_data_in_buf[4],rsencode_data_in_buf[5],rsencode_data_in_buf[6],rsencode_data_in_buf[7],rsencode_data_in_buf[8],rsencode_data_in_buf[9]);

    rs_encode_function(rsencode_data_in_buf,rsencode_encoded_data);//对R1补零后的数据编码
    LOG_INFO("encoded_data of R1 :");
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x",rsencode_encoded_data[0],rsencode_encoded_data[1],rsencode_encoded_data[2],rsencode_encoded_data[3],rsencode_encoded_data[4],rsencode_encoded_data[5],rsencode_encoded_data[6],rsencode_encoded_data[7],rsencode_encoded_data[8],rsencode_encoded_data[9]);
    
    save_start_32bytes_of_encoded_data1(rsencode_encoded_data,start32bytes_of_encoded_data1);//存encoded_data1开始的32 bytes
    
    LOG_INFO("start 8word of encoded_data of R1 :");
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",start32bytes_of_encoded_data1[0],start32bytes_of_encoded_data1[1],start32bytes_of_encoded_data1[2],start32bytes_of_encoded_data1[3],start32bytes_of_encoded_data1[4],start32bytes_of_encoded_data1[5],start32bytes_of_encoded_data1[6],start32bytes_of_encoded_data1[7]);
    
    LOG_INFO("Finsh first R1's encode. ");

    for (unsigned int i = 0; i < 20000; i++)//20000000
    {
      puf_get_res_of_a_cha(c_challenge,result_buf_xing);//C_R运算得到R星
      //LOG_INFO("new response :");
      //LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",result_buf_xing[0],result_buf_xing[1],result_buf_xing[2],result_buf_xing[3],result_buf_xing[4],result_buf_xing[5],result_buf_xing[6],result_buf_xing[7]);
      
      B1_pin_Rxing_add0(start32bytes_of_encoded_data1,result_buf_xing,encoded_data_xing);
      /*
      LOG_INFO("encoded_data_xing (word by word) :");
      for (size_t p = 0; p < 50; p++)
      {
        LOG_INFO("%08x",encoded_data_xing[p]);
      }
      */
      
      
      rs_decode_function(encoded_data_xing,error_pos_xing);//对encoded_data_xing解码运算,找错位
      /*
      LOG_INFO("error_pos_xing :");
      for (size_t k = 0; k < 50; k++)
      {
        LOG_INFO("%08x",error_pos_xing[k]);
      }
      */
      two_buf_yihuo_and_remove0(encoded_data_xing,error_pos_xing,rs_response);//异或纠错
      
      if (rs_response[0]==result_buf[0] &&
          rs_response[1]==result_buf[1] &&
          rs_response[2]==result_buf[2] &&
          rs_response[3]==result_buf[3] &&
          rs_response[4]==result_buf[4] &&
          rs_response[5]==result_buf[5] &&
          rs_response[6]==result_buf[6] &&
          rs_response[7]==result_buf[7])
      {
        //LOG_INFO("Find error success!!!");
        ;
      }                 
      else
      {
        LOG_INFO("error rs_response :");
        LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",rs_response[0],rs_response[1],rs_response[2],rs_response[3],rs_response[4],rs_response[5],rs_response[6],rs_response[7]);
        false_cnt = false_cnt + 1;
      }
    }

    LOG_INFO("false RS_response number:");
    
    LOG_INFO("%d",false_cnt);

    return true;
}


#endif


#ifdef PUF_no_RS


bool test_main(void) {

    LOG_INFO("Now, PUF unit (puf mode) test!");
    PUF_ON();
    LOG_INFO("Load challenge, wait response");
    for (size_t i = 0; i < 1000; i++)
    {
      for (size_t j = 0; j < 4; j++)
      {
        challenge_xing[j] = challenge_bufrng1000[i][j];
      }
      //LOG_INFO("challenge :");
      //LOG_INFO("%08x%08x%08x%08x",challenge_xing[0],challenge_xing[1],challenge_xing[2],challenge_xing[3]);
      //LOG_INFO("response :");
      puf_get_res_of_a_cha(challenge_xing,result_buf);//puf_get_res_of_a_cha(c_challenge,result_buf);
      LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",result_buf[0],result_buf[1],result_buf[2],result_buf[3],result_buf[4],result_buf[5],result_buf[6],result_buf[7]);
      //LOG_INFO(" ");
    }
    
    return true;
}


/*
bool test_main(void) {

    //base_printf("Now,");
    LOG_INFO("Now, PUF unit (puf mode) test, 1000 times!");
    PUF_ON();
    LOG_INFO("Load challenge, and check response, if false display it ");
    LOG_INFO("false response:");
    for (size_t i = 0; i < 1000; i++)
    {
      puf_get_res_of_a_cha(d_challenge,result_buf);
      //LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",result_buf[0],result_buf[1],result_buf[2],result_buf[3],result_buf[4],result_buf[5],result_buf[6],result_buf[7]);
      //a_challenge的response: 30f0cfcf 00400f3c 0f30cf04 c00f3c0f 30cf04c0 0f3c0f30 cf04c00f 3c0f30c3
      //b_challenge的response: 330c003f 3c0f30c3 300f4f00 0f3c0f30 cc0cf004 c00f3c0f 370c3ccf 00400f3c
      //c_challenge的response: c303d030 30343c0c 30c1c31f c0cf00cf 0c33c030 dccf3003 0c001f7f c0fc0c30 [发生误码概率大]
      //fc3033c0 7347000c f75cdc33 c30cf35d 0fcfc303 0fc040f4 0c005ccc 43f070fc
      if (result_buf[0]==0xfc3033c0 &&
          result_buf[1]==0x7347000c &&
          result_buf[2]==0xf75cdc33 &&
          result_buf[3]==0xc30cf35d &&
          result_buf[4]==0x0fcfc303 &&
          result_buf[5]==0x0fc040f4 &&
          result_buf[6]==0x0c005ccc &&
          result_buf[7]==0x43f070fc)
      {
        ;
      }                 
      else
      {
        LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",result_buf[0],result_buf[1],result_buf[2],result_buf[3],result_buf[4],result_buf[5],result_buf[6],result_buf[7]);
        //LOG_INFO("false");
        false_cnt = false_cnt + 1;
      }
    }
    LOG_INFO("false response number:");
    //base_printf("%d",false_cnt);
    LOG_INFO("%d",false_cnt);
    return true;
}
*/
#endif











#ifdef PUF_RNG_MODE

bool test_main(void) {

    LOG_INFO("Now, PUF unit (puf mode) test!");
    PUF_ON();
    LOG_INFO("Load challenge, wait response");
    result_buf[0] = * (unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_0_REG_OFFSET);
    result_buf[1] = * (unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_1_REG_OFFSET);
    result_buf[2] = * (unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_2_REG_OFFSET);
    result_buf[3] = * (unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_3_REG_OFFSET);
    result_buf[4] = * (unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_4_REG_OFFSET);
    result_buf[5] = * (unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_5_REG_OFFSET);
    result_buf[6] = * (unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_6_REG_OFFSET);
    result_buf[7] = * (unsigned int *)(TOP_EARLGREY_PUF_BASE_ADDR+PUF_RESPONSE_7_REG_OFFSET);
      LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",result_buf[0],result_buf[1],result_buf[2],result_buf[3],result_buf[4],result_buf[5],result_buf[6],result_buf[7]);
      //LOG_INFO(" ");
    
    
    return true;
}

#endif