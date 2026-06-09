// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/base/macros.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_entropy_src.h"
#include "sw/device/lib/dif/dif_csrng.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/entropy_testutils.h"
#include "sw/device/lib/testing/csrng_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"


#define ENTROPY_SRC_USE_trng //poor quality

#define CSRNG_USE_prng

OTTF_DEFINE_TEST_CONFIG();

enum {
  kExpectedOutputLen = 16,
};

uint32_t got[kExpectedOutputLen];

uint32_t entropy_seed [12];

dif_csrng_seed_material_t kEntropyInput = {
      .seed_material = {0x73bec010, 0x9262474c, 0x16a30f76, 0x531b51de,
                        0x2ee494e5, 0xdfec9db3, 0xcb7a879d, 0x5600419c,
                        0xca79b0b0, 0xdda33b5c, 0xa468649e, 0xdf5d73fa},
      .seed_material_len = 12,
};

status_t state;

dif_result_t state1;

status_t setup_csrng_instance(const dif_csrng_t *csrng) {
  CHECK_DIF_OK(dif_csrng_uninstantiate(csrng));


  TRY(csrng_testutils_cmd_ready_wait(csrng));
  CHECK_DIF_OK(dif_csrng_instantiate(csrng, kDifCsrngEntropySrcToggleDisable,
                                     &kEntropyInput));

  return OK_STATUS();
}

  

bool test_main(void) {


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

  for (size_t i = 0; i < 20000; i++)
  {
    state = csrng_testutils_cmd_generate_run(&csrng, got, kExpectedOutputLen);
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",got[0],got[1],got[2],got[3],got[4],got[5],got[6],got[7]);
  }
  
  
/*  
  state1 = dif_csrng_update(&csrng,&kEntropyInput);

  for (size_t i = 0; i < 10; i++)
  {
    state = csrng_testutils_cmd_generate_run(&csrng, got, kExpectedOutputLen);
    LOG_INFO("%08x%08x%08x%08x%08x%08x%08x%08x",got[0],got[1],got[2],got[3],got[4],got[5],got[6],got[7]);
  }

*/


  return true;
}
