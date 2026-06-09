// Generated register defines for sm4

// Copyright information found in source file:
// Copyright lowRISC contributors.

// Licensing information found in source file:
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef _SM4_REG_DEFS_
#define _SM4_REG_DEFS_
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
//void SM4_ON();

//void SM4_OFF();

static const char kSendData[] = "Smoke test!";

//128'h0123456789abcdeffedcba9876543210
static unsigned int key_enc[4] ={0x76543210,0xfedcba98,0x89abcdef,0x01234567};

//128'h0123456789abcdeffedcba9876543210
static unsigned int key_dec[4] ={0x76543210,0xfedcba98,0x89abcdef,0x01234567};

//128'h0123456789abcdeffedcba9876543210
static unsigned int data_in_enc[4] ={0x76543210,0xfedcba98,0x89abcdef,0x01234567};

//128'h681edf34d206965e86b3e94f536e4246
static unsigned int data_in_dec[4] ={0x536e4246,0x86b3e94f,0xd206965e,0x681edf34};

void SM4_ON(void);

void operate_mode(unsigned int enc_dec);

void input_key128(unsigned int key[4]);

void encdec_enable(unsigned int flag);

void input_data(unsigned int data_in[4]);

void wait_for_dataout(void);

void readout_data(unsigned int out_data[]);

void SM4_OFF(void);

#define enc_mode 0

#define dec_mode 1

#define ENABLE_encdec 1

#define DISABLE_encdec 0


// Number registers for input and output data
#define SM4_PARAM_NUM_REGS_DATA 4

// Number registers Key
#define SM4_PARAM_NUM_REGS_KEY 4

// Register width
#define SM4_PARAM_REG_WIDTH 32

// Control
#define SM4_CTRL_SIGNALS_REG_OFFSET 0x0
#define SM4_CTRL_SIGNALS_REG_RESVAL 0x0u
#define SM4_CTRL_SIGNALS_SM4_ENABLE_IN_BIT 0
#define SM4_CTRL_SIGNALS_ENCDEC_SEL_IN_BIT 1
#define SM4_CTRL_SIGNALS_ENABLE_KEY_EXP_IN_BIT 2
#define SM4_CTRL_SIGNALS_USER_KEY_VALID_IN_BIT 3
#define SM4_CTRL_SIGNALS_ENCDEC_ENABLE_IN_BIT 4
#define SM4_CTRL_SIGNALS_VALID_IN_BIT 5

// The sm4 states
#define SM4_STATE_SIGNALS_REG_OFFSET 0x4
#define SM4_STATE_SIGNALS_REG_RESVAL 0x0u
#define SM4_STATE_SIGNALS_KEY_EXP_READY_OUT_BIT 0
#define SM4_STATE_SIGNALS_VALID_OUT_BIT 1

// Initial Key Registers  (common parameters)
#define SM4_KEY_KEY_FIELD_WIDTH 32
#define SM4_KEY_MULTIREG_COUNT 4

// Initial Key Registers
#define SM4_KEY_0_REG_OFFSET 0x8
#define SM4_KEY_0_REG_RESVAL 0x0u

// Initial Key Registers
#define SM4_KEY_1_REG_OFFSET 0xc
#define SM4_KEY_1_REG_RESVAL 0x0u

// Initial Key Registers
#define SM4_KEY_2_REG_OFFSET 0x10
#define SM4_KEY_2_REG_RESVAL 0x0u

// Initial Key Registers
#define SM4_KEY_3_REG_OFFSET 0x14
#define SM4_KEY_3_REG_RESVAL 0x0u

// data input  (common parameters)
#define SM4_DATA_IN_DATA_IN_FIELD_WIDTH 32
#define SM4_DATA_IN_MULTIREG_COUNT 4

// data input
#define SM4_DATA_IN_0_REG_OFFSET 0x18
#define SM4_DATA_IN_0_REG_RESVAL 0x0u

// data input
#define SM4_DATA_IN_1_REG_OFFSET 0x1c
#define SM4_DATA_IN_1_REG_RESVAL 0x0u

// data input
#define SM4_DATA_IN_2_REG_OFFSET 0x20
#define SM4_DATA_IN_2_REG_RESVAL 0x0u

// data input
#define SM4_DATA_IN_3_REG_OFFSET 0x24
#define SM4_DATA_IN_3_REG_RESVAL 0x0u

// result output (common parameters)
#define SM4_RESULT_OUT_RESULT_OUT_FIELD_WIDTH 32
#define SM4_RESULT_OUT_MULTIREG_COUNT 4

// result output
#define SM4_RESULT_OUT_0_REG_OFFSET 0x28
#define SM4_RESULT_OUT_0_REG_RESVAL 0x0u

// result output
#define SM4_RESULT_OUT_1_REG_OFFSET 0x2c
#define SM4_RESULT_OUT_1_REG_RESVAL 0x0u

// result output
#define SM4_RESULT_OUT_2_REG_OFFSET 0x30
#define SM4_RESULT_OUT_2_REG_RESVAL 0x0u

// result output
#define SM4_RESULT_OUT_3_REG_OFFSET 0x34
#define SM4_RESULT_OUT_3_REG_RESVAL 0x0u


#endif  // _SM4_REG_DEFS_
// End generated register defines for sm4