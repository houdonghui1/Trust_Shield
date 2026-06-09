// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
#include <string.h>
#include "sw/device/lib/arch/device.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_uart.h"
#include "sw/device/lib/dif/dif_pinmux.h"
#include "sw/device/lib/runtime/hart.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "sw/device/lib/runtime/hart.h"
#include "sw/device/lib/testing/pinmux_testutils.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

OTTF_DEFINE_TEST_CONFIG();

void sleep_ms(unsigned int milliseconds) {
    busy_spin_micros(milliseconds * 1000);
}

bool test_main(void) {
  dif_uart_t uart;
  uint8_t buffer[32];
  size_t bytes_read;
  size_t bytes_written;
  const char *message = "ABCD!\n";
  static dif_pinmux_t pinmux;

  OT_DISCARD(dif_pinmux_init(
      mmio_region_from_addr(TOP_EARLGREY_PINMUX_AON_BASE_ADDR), &pinmux));

  pinmux_testutils_init(&pinmux);

  CHECK_DIF_OK(dif_uart_init(
      mmio_region_from_addr(TOP_EARLGREY_UART1_BASE_ADDR), &uart));

  CHECK_DIF_OK(dif_pinmux_input_select(&pinmux,
                                       kTopEarlgreyPinmuxPeripheralInUart1Rx,
                                       kTopEarlgreyPinmuxInselIoa4));
  CHECK_DIF_OK(dif_pinmux_output_select(&pinmux, kTopEarlgreyPinmuxMioOutIoa4,
                                        kTopEarlgreyPinmuxOutselConstantHighZ));
  CHECK_DIF_OK(dif_pinmux_output_select(&pinmux, kTopEarlgreyPinmuxMioOutIoa5,
                                        kTopEarlgreyPinmuxOutselUart1Tx));

  CHECK(kUartBaudrate <= UINT32_MAX, "kUartBaudrate must fit in uint32_t");
  CHECK(kClockFreqPeripheralHz <= UINT32_MAX,
        "kClockFreqPeripheralHz must fit in uint32_t");
  CHECK_DIF_OK(dif_uart_configure(
        &uart, (dif_uart_config_t){
                    .baudrate = (uint32_t)kUartBaudrate,
                    .clk_freq_hz = (uint32_t)kClockFreqPeripheralHz,
                    .parity_enable = kDifToggleDisabled,
                    .parity = kDifUartParityEven,
                    .tx_enable = kDifToggleEnabled,
                    .rx_enable = kDifToggleEnabled,
                }));


  CHECK_DIF_OK(dif_uart_bytes_send(&uart, (const uint8_t *)message, 5, &bytes_written));

  while(1) {
    memset(buffer, 0x0, sizeof(buffer));
    CHECK_DIF_OK(dif_uart_bytes_receive(&uart, sizeof(buffer), buffer, &bytes_read));
    sleep_ms(1000); 
    if (bytes_read > 0) {
      LOG_INFO("Received %d bytes: %s", bytes_read, buffer);
    }
    
  }

  return true;
}
