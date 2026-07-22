// SPDX-License-Identifier: Apache-2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#include "caliptra_defines.h"
#include "riscv_hw_if.h"
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include "printf.h"
#include "ecc.h"
#include "caliptra_isr.h"
#include "hmac.h"

extern volatile caliptra_intr_received_s cptra_intr_rcv;

void wait_for_ecc_intr(){
    printf("ECC flow in progress...\n");
    while((cptra_intr_rcv.ecc_error == 0) & (cptra_intr_rcv.ecc_notif == 0)){
        __asm__ volatile ("wfi"); // "Wait for interrupt"
        // Sleep during ECC operation to allow ISR to execute and show idle time in sims
        for (uint16_t slp = 0; slp < 100; slp++) {
            __asm__ volatile ("nop"); // Sleep loop as "nop"
        }
    };
    //printf("Received ECC error intr with status = %d\n", cptra_intr_rcv.ecc_error);
    printf("Received ECC notif/ err intr with status = %08x/ %08x\n", (unsigned int)cptra_intr_rcv.ecc_notif, (unsigned int)cptra_intr_rcv.ecc_error);
}

void ecc_zeroize(){
    printf("ECC zeroize flow.\n");
    lsu_write_32(CLP_ECC_REG_ECC_CTRL, (1 << ECC_REG_ECC_CTRL_ZEROIZE_LOW) & ECC_REG_ECC_CTRL_ZEROIZE_MASK);
}

void ecc_keygen_flow(ecc_io* seed, ecc_io* nonce, ecc_io* iv, ecc_io* privkey, ecc_io* pubkey_x, ecc_io* pubkey_y){
    uint8_t offset;
    volatile uint32_t * reg_ptr;
    uint8_t fail_cmd = 0x1;

    uint32_t ecc_privkey  [12];
    uint32_t ecc_pubkey_x [12];
    uint32_t ecc_pubkey_y [12];
    printf("func: %s, line: %d\n", __func__, __LINE__);
    // wait for ECC to be ready
    while((lsu_read_32(CLP_ECC_REG_ECC_STATUS) & ECC_REG_ECC_STATUS_READY_MASK) == 0);

    if(seed->kv_intf){
        printf("func: %s, line: %d\n", __func__, __LINE__);
        // Program ECC_SEED Read with 12 dwords from seed_kv_id
        lsu_write_32(CLP_ECC_REG_ECC_KV_RD_SEED_CTRL, (ECC_REG_ECC_KV_RD_SEED_CTRL_READ_EN_MASK |
                                                    ((seed->kv_id << ECC_REG_ECC_KV_RD_SEED_CTRL_READ_ENTRY_LOW) & ECC_REG_ECC_KV_RD_SEED_CTRL_READ_ENTRY_MASK)));

        // Check that ECC SEED is loaded
        while((lsu_read_32(CLP_ECC_REG_ECC_KV_RD_SEED_STATUS) & ECC_REG_ECC_KV_RD_SEED_STATUS_VALID_MASK) == 0);
    }
    else{
        printf("func: %s, line: %d\n", __func__, __LINE__);
        reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_SEED_0;
        offset = 0;
        while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_SEED_11) {
            *reg_ptr++ = seed->data[offset++];
        }
    }

    if (privkey->kv_intf){
        printf("func: %s, line: %d\n", __func__, __LINE__);
        // set privkey DEST to write
        lsu_write_32(CLP_ECC_REG_ECC_KV_WR_PKEY_CTRL, (ECC_REG_ECC_KV_WR_PKEY_CTRL_WRITE_EN_MASK |
                                                    ECC_REG_ECC_KV_WR_PKEY_CTRL_ECC_PKEY_DEST_VALID_MASK |
                                                    ((privkey->kv_id << ECC_REG_ECC_KV_WR_PKEY_CTRL_WRITE_ENTRY_LOW) & ECC_REG_ECC_KV_WR_PKEY_CTRL_WRITE_ENTRY_MASK)));
    }
    
    // Write ECC nonce
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_NONCE_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_NONCE_11) {
        *reg_ptr++ = nonce->data[offset++];
    }

    // Write ECC IV
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_IV_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_IV_11) {
        *reg_ptr++ = iv->data[offset++];
    }

    printf("\nECC KEYGEN\n");
    // Enable ECC KEYGEN core
    lsu_write_32(CLP_ECC_REG_ECC_CTRL, ECC_CMD_KEYGEN);

    // wait for ECC KEYGEN process to be done
    while((lsu_read_32(CLP_ECC_REG_ECC_STATUS) & ECC_REG_ECC_STATUS_VALID_MASK) == 0);
    
    if (privkey->kv_intf){
        printf("Wait for KV write\n");
        // check dest done
        while((lsu_read_32(CLP_ECC_REG_ECC_KV_WR_PKEY_STATUS) & ECC_REG_ECC_KV_WR_PKEY_STATUS_VALID_MASK) == 0);
    }
    else{
        // Read the data back from ECC register
        printf("Load PRIVKEY data from ECC\n");
        reg_ptr = (uint32_t *) CLP_ECC_REG_ECC_PRIVKEY_OUT_0;
        offset = 0;
        while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_PRIVKEY_OUT_11) {
            ecc_privkey[offset] = *reg_ptr;
            if (ecc_privkey[offset] != privkey->data[offset]) {
                printf("At offset [%d], ecc_privkey data mismatch!\n", offset);
                printf("Actual   data: 0x%lx\n", ecc_privkey[offset]);
                printf("Expected data: 0x%lx\n", privkey->data[offset]);
                printf("%c", fail_cmd);
                while(1);
            }
            reg_ptr++;
            offset++;
        }
    }

    // Read the data back from ECC register
    printf("Load PUBKEY_X data from ECC\n");
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_PUBKEY_X_0;
    offset = 0;
    if(pubkey_x->kv_intf) {
        while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_PUBKEY_X_11) {
            pubkey_x->data[offset] = *reg_ptr;
            reg_ptr++;
            offset++;
        }
    } else {
        while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_PUBKEY_X_11) {
            ecc_pubkey_x[offset] = *reg_ptr;
            if (ecc_pubkey_x[offset] != pubkey_x->data[offset]) {
                printf("At offset [%d], ecc_pubkey_x data mismatch!\n", offset);
                printf("Actual   data: 0x%lx\n", ecc_pubkey_x[offset]);
                printf("Expected data: 0x%lx\n", pubkey_x->data[offset]);
                printf("%c", fail_cmd);
                while(1);
            } 
            reg_ptr++;
            offset++;
        }
    }

    printf("Load PUBKEY_Y data from ECC\n");
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_PUBKEY_Y_0;
    offset = 0;
    if(pubkey_y->kv_intf) {
        while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_PUBKEY_Y_11) {
            pubkey_y->data[offset] = *reg_ptr;
            reg_ptr++;
            offset++;
        }
    } else {
        while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_PUBKEY_Y_11) {
            ecc_pubkey_y[offset] = *reg_ptr;
            if (ecc_pubkey_y[offset] != pubkey_y->data[offset]) {
                printf("At offset [%d], ecc_pubkey_y data mismatch!\n", offset);
                printf("Actual   data: 0x%lx\n", ecc_pubkey_y[offset]);
                printf("Expected data: 0x%lx\n", pubkey_y->data[offset]);
                printf("%c", fail_cmd);
                while(1);
            }
            reg_ptr++;
            offset++;
        }
    }
}


void ecc_signing_flow(ecc_io* privkey, ecc_io* msg, ecc_io* iv, ecc_io* sign_r, ecc_io* sign_s){
    uint8_t offset;
    volatile uint32_t * reg_ptr;
    uint8_t fail_cmd = 0x1;

    uint32_t ecc_sign_r [12];
    uint32_t ecc_sign_s [12];

    // wait for ECC to be ready
    while((lsu_read_32(CLP_ECC_REG_ECC_STATUS) & ECC_REG_ECC_STATUS_READY_MASK) == 0);

    if (privkey->kv_intf){
        //inject privkey to kv key reg
        //suppose privkey is stored by ecc_keygen
        printf("Inject PRIVKEY from kv to ECC\n");
        
        // Program ECC_PRIVKEY Read with 12 dwords from privkey_kv_id
        lsu_write_32(CLP_ECC_REG_ECC_KV_RD_PKEY_CTRL, (ECC_REG_ECC_KV_RD_PKEY_CTRL_READ_EN_MASK |
                                                    ((privkey->kv_id << ECC_REG_ECC_KV_RD_PKEY_CTRL_READ_ENTRY_LOW) & ECC_REG_ECC_KV_RD_PKEY_CTRL_READ_ENTRY_MASK)));

        // Check that ECC PRIVKEY is loaded
        while((lsu_read_32(CLP_ECC_REG_ECC_KV_RD_PKEY_STATUS) & ECC_REG_ECC_KV_RD_PKEY_STATUS_VALID_MASK) == 0);
    }
    else{
        // Program ECC PRIVKEY
        reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_PRIVKEY_IN_0;
        offset = 0;
        while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_PRIVKEY_IN_11) {
            *reg_ptr++ = privkey->data[offset++];
        }
    }
    

    // Program ECC MSG
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_MSG_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_MSG_11) {
        *reg_ptr++ = msg->data[offset++];
    }

    // Program ECC IV
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_IV_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_IV_11) {
        *reg_ptr++ = iv->data[offset++];
    }

    // Enable ECC SIGNING core
    printf("\nECC SIGNING\n");
    lsu_write_32(CLP_ECC_REG_ECC_CTRL, ECC_CMD_SIGNING);
    
    // wait for ECC SIGNING process to be done
    while((lsu_read_32(CLP_ECC_REG_ECC_STATUS) & ECC_REG_ECC_STATUS_VALID_MASK) == 0);
    
    // Read the data back from ECC register
    printf("Load SIGN_R data from ECC\n");
    reg_ptr = (uint32_t *) CLP_ECC_REG_ECC_SIGN_R_0;
    offset = 0;
    if (sign_r->kv_intf) {
        while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_SIGN_R_11) {
            sign_r->data[offset] = *reg_ptr;
            reg_ptr++;
            offset++;
        }
    } else {
        while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_SIGN_R_11) {
            ecc_sign_r[offset] = *reg_ptr;
            if (ecc_sign_r[offset] != sign_r->data[offset]) {
                printf("At offset [%d], ecc_sign_r data mismatch!\n", offset);
                printf("Actual   data: 0x%08lx\n", (uint32_t)ecc_sign_r[offset]);
                printf("Expected data: 0x%08lx\n", (uint32_t)sign_r->data[offset]);
                printf("%c", fail_cmd);
                while(1);
            }
            reg_ptr++;
            offset++;
        }
    }


    printf("Load SIGN_S data from ECC\n");
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_SIGN_S_0;
    offset = 0;
    if (sign_s->kv_intf) {
        while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_SIGN_S_11) {
            sign_s->data[offset] = *reg_ptr;
            reg_ptr++;
            offset++;
        }
    } else {
        while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_SIGN_S_11) {
            ecc_sign_s[offset] = *reg_ptr;
            if (ecc_sign_s[offset] != sign_s->data[offset]) {
                printf("At offset [%d], ecc_sign_s data mismatch!\n", offset);
                printf("Actual   data: 0x%lx\n", ecc_sign_s[offset]);
                printf("Expected data: 0x%lx\n", sign_s->data[offset]);
                printf("%c", fail_cmd);
                while(1);
            } 
            reg_ptr++;
            offset++;
        }
    }
}

int ecc_verifying_flow(ecc_io msg, ecc_io pubkey_x, ecc_io pubkey_y, ecc_io sign_r, ecc_io sign_s){
    uint8_t offset;
    volatile uint32_t * reg_ptr;
    uint8_t fail_cmd = 0x1;
    uint32_t ecc_verify_r [12];
    uint32_t i = 0;

    // wait for ECC to be ready
    while((lsu_read_32(CLP_ECC_REG_ECC_STATUS) & ECC_REG_ECC_STATUS_READY_MASK) == 0);
    
    // Program ECC MSG
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_MSG_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_MSG_11) {
        *reg_ptr++ = msg.data[offset++];
    }

    // Program ECC PUBKEY_X
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_PUBKEY_X_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_PUBKEY_X_11) {
        *reg_ptr++ = pubkey_x.data[offset++];
    }

    // Program ECC PUBKEY_Y
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_PUBKEY_Y_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_PUBKEY_Y_11) {
        *reg_ptr++ = pubkey_y.data[offset++];
    }

    // Program ECC SIGN_R
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_SIGN_R_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_SIGN_R_11) {
        *reg_ptr++ = sign_r.data[offset++];
    }

    // Program ECC SIGN_S
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_SIGN_S_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_SIGN_S_11) {
        *reg_ptr++ = sign_s.data[offset++];
    }

    // Enable ECC VERIFYING core
    printf("\nECC VERIFYING\n");
    lsu_write_32(CLP_ECC_REG_ECC_CTRL, ECC_CMD_VERIFYING);
    
    // wait for ECC VERIFYING process to be done
    while((lsu_read_32(CLP_ECC_REG_ECC_STATUS) & ECC_REG_ECC_STATUS_VALID_MASK) == 0){
        i += 1;
        if(i > 1000) {
            return -1;
        }
        delay_ms(10);
    };
    
    reg_ptr = (uint32_t *) CLP_ECC_REG_ECC_VERIFY_R_0;
    // Read the data back from ECC register
    printf("Load VERIFY_R data from ECC\n");
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_VERIFY_R_11) {
        ecc_verify_r[offset] = *reg_ptr;
        if (ecc_verify_r[offset] != sign_r.data[offset]) {
            printf("At offset [%d], ecc_verify_r data mismatch!\n", offset);
            printf("Actual   data: 0x%8x\n", (unsigned int)ecc_verify_r[offset]);
            printf("Expected data: 0x%8x\n", (unsigned int)sign_r.data[offset]);
            printf("%c", fail_cmd);
            return -1;
        }
        reg_ptr++;
        offset++;
    }
    return 0;
}

void ecc_pcr_signing_flow(ecc_io iv, ecc_io sign_r, ecc_io sign_s){
    uint8_t offset;
    volatile uint32_t * reg_ptr;
    uint8_t fail_cmd = 0x1;

    uint32_t ecc_sign_r [12];
    uint32_t ecc_sign_s [12];

    // wait for ECC to be ready
    while((lsu_read_32(CLP_ECC_REG_ECC_STATUS) & ECC_REG_ECC_STATUS_READY_MASK) == 0);

    // Program ECC IV
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_IV_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_IV_11) {
        *reg_ptr++ = iv.data[offset++];
    }

    // Enable ECC PCR SIGNING core
    printf("\nECC PCR SIGNING\n");
    lsu_write_32(CLP_ECC_REG_ECC_CTRL, ECC_CMD_SIGNING | 
                ((1 << ECC_REG_ECC_CTRL_PCR_SIGN_LOW) & ECC_REG_ECC_CTRL_PCR_SIGN_MASK));
    
    // wait for ECC SIGNING process to be done
    while((lsu_read_32(CLP_ECC_REG_ECC_STATUS) & ECC_REG_ECC_STATUS_VALID_MASK) == 0);
    
    // Read the data back from ECC register
    printf("Load SIGN_R data from ECC\n");
    reg_ptr = (uint32_t *) CLP_ECC_REG_ECC_SIGN_R_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_SIGN_R_11) {
        ecc_sign_r[offset] = *reg_ptr;
        if (ecc_sign_r[offset] != sign_r.data[offset]) {
            printf("At offset [%d], ecc_sign_r data mismatch!\n", offset);
            printf("Actual   data: 0x%lx\n", ecc_sign_r[offset]);
            printf("Expected data: 0x%lx\n", sign_r.data[offset]);
            printf("%c", fail_cmd);
            while(1);
        }
        reg_ptr++;
        offset++;
    }

    printf("Load SIGN_S data from ECC\n");
    reg_ptr = (uint32_t*) CLP_ECC_REG_ECC_SIGN_S_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_ECC_REG_ECC_SIGN_S_11) {
        ecc_sign_s[offset] = *reg_ptr;
        if (ecc_sign_s[offset] != sign_s.data[offset]) {
            printf("At offset [%d], ecc_sign_s data mismatch!\n", offset);
            printf("Actual   data: 0x%lx\n", ecc_sign_s[offset]);
            printf("Expected data: 0x%lx\n", sign_s.data[offset]);
            printf("%c", fail_cmd);
            while(1);
        } 
        reg_ptr++;
        offset++;
    }

}

void ecc_sigh_test(uint8_t *data_to_sign, uint8_t *pk_and_sg_value) {
    uint32_t key_data[] = {0x0b0b0b0b,
                           0x0b0b0b0b,
                           0x0b0b0b0b,
                           0x0b0b0b0b,
                           0x0b0b0b0b,
                           0x0b0b0b0b,
                           0x0b0b0b0b,
                           0x0b0b0b0b,
                           0x0b0b0b0b,
                           0x0b0b0b0b,
                           0x0b0b0b0b,
                           0x0b0b0b0b};
    uint32_t block_data[] = {0x48692054,
                             0x68657265,
                             0x80000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000000,
                             0x00000440};
    uint32_t expected_tag[] = {0xb6a8d563,
                                0x6f5c6a72,
                                0x24f9977d,
                                0xcf7ee6c7,
                                0xfb6d0c48,
                                0xcbdee973,
                                0x7a959796,
                                0x489bddbc,
                                0x4c5df61d,
                                0x5b3297b4,
                                0xfb68dab9,
                                0xf1b582c2};
    //this is a random lfsr_seed 160-bit
    uint32_t lfsr_seed_data[] = {0xC8F518D4,
                                 0xF3AA1BD4,
                                 0x6ED56C1C,
                                 0x3C9E16FB,
                                 0x800AF504};
    hmac_io hmac_key;
    hmac_io hmac_block;
    hmac_io hmac_lfsr_seed;
    hmac_io hmac_tag;
    ecc_io seed;
    ecc_io nonce;
    ecc_io iv;
    ecc_io privkey;
    ecc_io pubkey_x;
    ecc_io pubkey_y;
    ecc_io sign_r;
    ecc_io sign_s;
    ecc_io msg;

    hmac_key.kv_intf = FALSE;
    hmac_key.data_size = 12;
    for (int i = 0; i < hmac_key.data_size; i++)
        hmac_key.data[i] = key_data[i];

    hmac_block.kv_intf = FALSE;
    hmac_block.data_size = 32;
    for (int i = 0; i < hmac_block.data_size; i++)
        hmac_block.data[i] = block_data[i];

    hmac_lfsr_seed.kv_intf = FALSE;
    hmac_lfsr_seed.data_size = 5;
    for (int i = 0; i < hmac_lfsr_seed.data_size; i++)
        hmac_lfsr_seed.data[i] = lfsr_seed_data[i];

    hmac_tag.kv_intf = FALSE;
    hmac_tag.kv_id = 3;
    hmac_tag.data_size = 12;
    for (int i = 0; i < hmac_tag.data_size; i++)
        hmac_tag.data[i] = expected_tag[i];
        
    hmac_flow(hmac_key, hmac_block, hmac_lfsr_seed, hmac_tag);

    seed.kv_intf = 1;
    seed.kv_id = 3;//store keyvault 3
    memset(seed.data, 0, sizeof(seed.data));

    nonce.kv_intf = 0;
    memset(nonce.data, 0, sizeof(nonce.data));

    iv.kv_intf = 0;
    memset(iv.data, 0, sizeof(iv.data));

    privkey.kv_intf = 1;
    privkey.kv_id = 4;//store keyvault 4
    memset(privkey.data, 0, sizeof(privkey.data));

    pubkey_x.kv_intf = 1;
    memset(pubkey_x.data, 0, sizeof(pubkey_x.data));
    
    pubkey_y.kv_intf = 1;
    memset(pubkey_y.data, 0, sizeof(pubkey_y.data));

    ecc_keygen_flow(&seed, &nonce, &iv, &privkey, &pubkey_x, &pubkey_y);

    printf("pubkey_x.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)pubkey_x.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");
    memcpy(pk_and_sg_value, pubkey_x.data, sizeof(pubkey_x.data));

    printf("pubkey_y.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)pubkey_y.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");
    memcpy(pk_and_sg_value + 48, pubkey_y.data, sizeof(pubkey_y.data));
    
    sign_r.kv_intf = 1;
    memset(sign_r.data, 0, sizeof(sign_r.data));

    sign_s.kv_intf = 1;
    memset(sign_s.data, 0, sizeof(sign_s.data));

    memcpy(msg.data, data_to_sign, 48);

    ecc_signing_flow(&privkey, &msg, &iv, &sign_r, &sign_s);

    printf("sign_r.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)sign_r.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");
    memcpy(pk_and_sg_value + 96, sign_r.data, sizeof(sign_r.data));

    printf("sign_s.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)sign_s.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");
    memcpy(pk_and_sg_value + 144, sign_s.data, sizeof(sign_s.data));

    //kv_clear(KvSlot3)
    lsu_write_32(CLP_KV_REG_KEY_CTRL_3, KV_REG_KEY_CTRL_3_CLEAR_MASK);
    while ((lsu_read_32(CLP_KV_REG_KEY_CTRL_3) & KV_REG_KEY_CTRL_3_CLEAR_MASK) != 0);
    printf("Temporary seed cleared in KeySlot3.\n");
}

int ecc_verify_test(uint8_t *data_to_verify, uint8_t *pk_and_sg_value) {
    int status = 1;
    ecc_io pubkey_x;
    ecc_io pubkey_y;
    ecc_io sign_r;
    ecc_io sign_s;
    ecc_io msg;

    memcpy(msg.data, data_to_verify, 48);

    memcpy(pubkey_x.data, pk_and_sg_value, 48);
    printf("pubkey_x.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)pubkey_x.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");
    
    memcpy(pubkey_y.data, pk_and_sg_value + 48, 48);
    printf("pubkey_y.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)pubkey_y.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");


    memcpy(sign_r.data, pk_and_sg_value + 96, 48);
    printf("sign_r.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)sign_r.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    memcpy(sign_s.data, pk_and_sg_value + 144, sizeof(sign_s.data));
    printf("sign_s.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)sign_s.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");


    status = ecc_verifying_flow(msg, pubkey_x, pubkey_y, sign_r, sign_s);

    if(!status) {
        printf("Signature verification successful!\n");
    } else {
        printf("Signature verification failed!\n");
    }

    return status;
}