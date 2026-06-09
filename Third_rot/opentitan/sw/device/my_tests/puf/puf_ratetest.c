#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "sw/device/lib/runtime/log.h"

#include "sw/device/my_tests/puf/puf.h"
#include "sw/device/my_tests/rs_encode/rs_encode.h"
#include "sw/device/my_tests/rs_decode/rs_decode.h"

#include "sw/device/lib/base/macros.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_entropy_src.h"
#include "sw/device/lib/dif/dif_csrng.h"
#include "sw/device/lib/testing/entropy_testutils.h"
#include "sw/device/lib/testing/csrng_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"

//#define PUF_no_RS
#define PUF_and_RSCODE
//#define PUF_RNG_MODE

OTTF_DEFINE_TEST_CONFIG();

unsigned int challenge_xing[4] = {0,0,0,0};
unsigned int response_first[8] = {0,0,0,0,0,0,0,0};
unsigned int result_buf_xing[8] = {0,0,0,0,0,0,0,0};

unsigned int false_cnt = 0;

unsigned int rsencode_data_in_buf[42];
unsigned int rsencode_encoded_data[50];
unsigned int start32bytes_of_encoded_data1[8];
unsigned int end32bytes_of_encoded_data1[8];

unsigned int encoded_data_xing[50];
unsigned int error_pos_xing[50];
unsigned int rs_response[8];



enum {
  kExpectedOutputLen = 4,
};

unsigned int got[kExpectedOutputLen];

status_t state;

dif_result_t state1;

uint32_t entropy_seed [12];

dif_csrng_seed_material_t kEntropyInput = {
      .seed_material = {0x73bec010, 0x9262474c, 0x16a30f76, 0x531b51de,
                        0x2ee494e5, 0xdfec9db3, 0xcb7a879d, 0x5600419c,
                        0xca79b0b0, 0xdda33b5c, 0xa468649e, 0xdf5d73fa},
      .seed_material_len = 12,
};



status_t setup_csrng_instance(const dif_csrng_t *csrng) {
  CHECK_DIF_OK(dif_csrng_uninstantiate(csrng));


  TRY(csrng_testutils_cmd_ready_wait(csrng));
  CHECK_DIF_OK(dif_csrng_instantiate(csrng, kDifCsrngEntropySrcToggleDisable,
                                     &kEntropyInput));

  return OK_STATUS();
}


bool test_main(void) {

/*****************************************RNG_PRE*******************************************/
  dif_entropy_src_t entropy_src;
  CHECK_DIF_OK(dif_entropy_src_init(
      mmio_region_from_addr(TOP_EARLGREY_ENTROPY_SRC_BASE_ADDR), &entropy_src));

  // Disable entropy for test purpose, as it has been turned on by ROM
  CHECK_DIF_OK(dif_entropy_src_set_enabled(&entropy_src, kDifToggleDisabled));

  // Setup fips grade entropy that can be read by firmware
  const dif_entropy_src_config_t config = {
      .fips_enable = true,
      .route_to_firmware = true,
      .single_bit_mode = kDifEntropySrcSingleBitModeDisabled,
      .health_test_threshold_scope = false, /*default*/
      .health_test_window_size = 0x0200,    /*default*/
      .alert_threshold = 2,                 /*default*/
  };

  // Re-enable entropy src
  CHECK_DIF_OK(
      dif_entropy_src_configure(&entropy_src, config, kDifToggleEnabled));
  CHECK_STATUS_OK(entropy_testutils_wait_for_state(
      &entropy_src, kDifEntropySrcMainFsmStateContHTRunning));
  //CHECK_DIF_OK(dif_entropy_src_set_enabled(&entropy_src, kDifToggleEnabled));

  LOG_INFO("Enable entropy_src");
  //read rng words from entropy_src

  for (size_t i = 0; i < 12; i++)
  {
    state1 = dif_entropy_src_non_blocking_read(&entropy_src,&kEntropyInput.seed_material[i]);
  }
  

  dif_csrng_t csrng;
  mmio_region_t base_addr = mmio_region_from_addr(TOP_EARLGREY_CSRNG_BASE_ADDR);
  CHECK_DIF_OK(dif_csrng_init(base_addr, &csrng));
  CHECK_DIF_OK(dif_csrng_configure(&csrng));
  CHECK_STATUS_OK(setup_csrng_instance(&csrng));
  LOG_INFO("Enable CSRNG ,seed with entropy_rng.");
  LOG_INFO("Now, PUF failure rate test! 30,000,000 times.");
  LOG_INFO(" ");
  LOG_INFO("**********************************************");



/*****************************************C_R*********************************************/
  
  PUF_ON();

  for (size_t i = 0; i < 30000000; i++)
  {
    state = csrng_testutils_cmd_generate_run(&csrng, got, kExpectedOutputLen);
    //LOG_INFO("%08x%08x%08x%08x",got[0],got[1],got[2],got[3]);

    //LOG_INFO("R_first :");
    puf_get_res_of_a_cha(got,response_first);
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",response_first[0],response_first[1],response_first[2],response_first[3],response_first[4],response_first[5],response_first[6],response_first[7]);
    
    add_0_to_buf(response_first,8,rsencode_data_in_buf,42);//为R1补零
    
    //LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x",rsencode_data_in_buf[0],rsencode_data_in_buf[1],rsencode_data_in_buf[2],rsencode_data_in_buf[3],rsencode_data_in_buf[4],rsencode_data_in_buf[5],rsencode_data_in_buf[6],rsencode_data_in_buf[7],rsencode_data_in_buf[8],rsencode_data_in_buf[9]);

    rs_encode_function(rsencode_data_in_buf,rsencode_encoded_data);//对R1补零后的数据编码
    //LOG_INFO("encoded_data of R1 :");
    //LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x",rsencode_encoded_data[0],rsencode_encoded_data[1],rsencode_encoded_data[2],rsencode_encoded_data[3],rsencode_encoded_data[4],rsencode_encoded_data[5],rsencode_encoded_data[6],rsencode_encoded_data[7],rsencode_encoded_data[8],rsencode_encoded_data[9]);
    
    save_start_32bytes_of_encoded_data1(rsencode_encoded_data,start32bytes_of_encoded_data1);//存encoded_data1开始的32 bytes
    
    //LOG_INFO("start 8word of encoded_data of R1 :");
    //LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",start32bytes_of_encoded_data1[0],start32bytes_of_encoded_data1[1],start32bytes_of_encoded_data1[2],start32bytes_of_encoded_data1[3],start32bytes_of_encoded_data1[4],start32bytes_of_encoded_data1[5],start32bytes_of_encoded_data1[6],start32bytes_of_encoded_data1[7]);
    
    //LOG_INFO("Finsh first R1's encode. ");

    /************second key generage************/

    puf_get_res_of_a_cha(got,result_buf_xing);//C_R运算得到R星

    B1_pin_Rxing_add0(start32bytes_of_encoded_data1,result_buf_xing,encoded_data_xing);

    rs_decode_function(encoded_data_xing,error_pos_xing);//对encoded_data_xing解码运算,找错位

    two_buf_yihuo_and_remove0(encoded_data_xing,error_pos_xing,rs_response);//异或纠错

    //LOG_INFO("R_second :");
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",rs_response[0],rs_response[1],rs_response[2],rs_response[3],rs_response[4],rs_response[5],rs_response[6],rs_response[7]);

    if (rs_response[0]==response_first[0] &&
        rs_response[1]==response_first[1] &&
        rs_response[2]==response_first[2] &&
        rs_response[3]==response_first[3] &&
        rs_response[4]==response_first[4] &&
        rs_response[5]==response_first[5] &&
        rs_response[6]==response_first[6] &&
        rs_response[7]==response_first[7])
      {
        //LOG_INFO("Find error success!!!");
        ;
      }                 
      else
      { 
        false_cnt = false_cnt + 1;
      }


  }

  LOG_INFO("*********************************************");
  LOG_INFO(" ");
  LOG_INFO("failure RS_response number:");
    
  LOG_INFO("%d",false_cnt);



  return true;
}
