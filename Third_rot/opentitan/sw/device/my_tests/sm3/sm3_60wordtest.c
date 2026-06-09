#include "sw/device/lib/runtime/log.h"
#include "sw/device/my_tests/sm3/sm3.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "sw/device/lib/dif/dif_rv_timer.h"
#include "sw/device/lib/runtime/hart.h"
#include "sw/device/lib/runtime/ibex.h"
#include "sw/device/lib/testing/test_framework/check.h"



#define pure_sm3
//#define sm3_and_timer

OTTF_DEFINE_TEST_CONFIG();

unsigned int result_buf1[8] ={0,0,0,0,0,0,0,0};
unsigned int result_buf2[8] ={0,0,0,0,0,0,0,0};

unsigned int state =0;

uint64_t clock = 250000;

static dif_rv_timer_t timer;

uint64_t timer_counter = 0;

uint64_t tick1 = 0;
uint64_t tick2 = 0;

enum {
  kHart = 0,
  kComparator = 0,
  kReferenceTimeMillis = 5,
};



void set_timer(uint64_t tick_hz) {
  LOG_INFO("%s: tick_hz = %u", __func__, tick_hz);

  dif_rv_timer_tick_params_t tick_params;
  state = dif_rv_timer_approximate_tick_params(clock, tick_hz,
                                           &tick_params);
  LOG_INFO("approximate_tick_params OK");

  //state = tick_params.prescale;
  LOG_INFO("prescale = %u",tick_params.prescale);
  //state = tick_params.tick_step;
  LOG_INFO("tick_step = %u",tick_params.tick_step);

  state = dif_rv_timer_set_tick_params(&timer, kHart, tick_params);
  LOG_INFO("set_timer OK");

  timer_counter = 0;

  state = dif_rv_timer_counter_write(&timer, kHart, timer_counter);
  
  state = dif_rv_timer_counter_set_enabled(&timer, kHart, kDifToggleEnabled);

  LOG_INFO("timer start");
  //busy_spin_micros(kReferenceTimeMillis * 1000);
  //state = dif_rv_timer_counter_set_enabled(&timer, kHart, kDifToggleDisabled);

}


#ifdef sm3_and_timer

bool test_main(void) {

  CHECK_DIF_OK(dif_rv_timer_init(
      mmio_region_from_addr(TOP_EARLGREY_RV_TIMER_BASE_ADDR), &timer));
  CHECK_DIF_OK(dif_rv_timer_reset(&timer));

  set_timer(250000);

  state = dif_rv_timer_counter_set_enabled(&timer, kHart, kDifToggleDisabled);
  state = dif_rv_timer_counter_read(&timer, kHart, &tick1);
  state = dif_rv_timer_counter_set_enabled(&timer, kHart, kDifToggleEnabled);

  for (size_t i = 0; i < 100; i++)
  {
    SM3_hash_function(message_60word,60,full,result_buf1);
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",result_buf1[0],result_buf1[1],result_buf1[2],result_buf1[3],result_buf1[4],result_buf1[5],result_buf1[6],result_buf1[7]);
  }
  
  state = dif_rv_timer_counter_set_enabled(&timer, kHart, kDifToggleDisabled);
  state = dif_rv_timer_counter_read(&timer, kHart, &tick2);
  state = dif_rv_timer_counter_set_enabled(&timer, kHart, kDifToggleEnabled);
  
  LOG_INFO("tick1 = %u",tick1);
  LOG_INFO("tick2 = %u",tick2);

  return true;

}


#endif





#ifdef pure_sm3
/*
bool test_main(void) {

    LOG_INFO("Now, SM3 unit test!");
    LOG_INFO("One word test,input word is 0x61626364,expected encryption result:82EC58(HEAD)");
    SM3_hash_one_word(0x61626364,result_buf);
    LOG_INFO("Actual encryption result:");
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",result_buf[0],result_buf[1],result_buf[2],result_buf[3],result_buf[4],result_buf[5],result_buf[6],result_buf[7]);
    return true;
}
*/

//计算长消息用到的main函数
bool test_main(void) {

    //test_tick(10000000);
    LOG_INFO("*******************");
    LOG_INFO("Now, SM3 unit test!");
    LOG_INFO(" ");
    LOG_INFO("-------------------");
    LOG_INFO("60 word message test");
    LOG_INFO("The expected outcome is: 64436f43048b464e5d87528db6fc2bf19ac4cfb8fb49d41ccdd93e2a3bcbdda3");
    SM3_hash_function(message_60word,60,full,result_buf1);
    LOG_INFO("The calculated result is:");
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",result_buf1[0],result_buf1[1],result_buf1[2],result_buf1[3],result_buf1[4],result_buf1[5],result_buf1[6],result_buf1[7]);
    LOG_INFO("The process takes 1.72us ");
    LOG_INFO(" ");
    LOG_INFO("*******************");
    return true;
}

#endif