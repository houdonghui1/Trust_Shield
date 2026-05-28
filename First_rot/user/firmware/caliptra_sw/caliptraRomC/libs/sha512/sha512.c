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

#include <string.h>
#include <stdbool.h>
#include "caliptra_defines.h"
#include "sha512.h"
#include "printf.h"
#include "riscv_hw_if.h"
#include "caliptra_isr.h"
#include "keyvault.h"
#include "sm3.h"

extern volatile caliptra_intr_received_s cptra_intr_rcv;

void wait_for_sha512_intr(){
    printf("SHA512 flow in progress...\n");
    while((cptra_intr_rcv.sha512_error == 0) & (cptra_intr_rcv.sha512_notif == 0)){
        __asm__ volatile ("wfi"); // "Wait for interrupt"
        // Sleep during SHA512 operation to allow ISR to execute and show idle time in sims
        for (uint16_t slp = 0; slp < 100; slp++) {
            __asm__ volatile ("nop"); // Sleep loop as "nop"
        }
    };
    //printf("Received SHA512 error intr with status = %d\n", cptra_intr_rcv.sha512_error);
    printf("Received SHA512 notif intr with status = %ld\n", cptra_intr_rcv.sha512_notif);
}

void sha_init(enum sha512_mode_e mode) {
    printf("SHA512: Set mode: 0x%x and init\n", mode);
    uint32_t reg;
    reg = ((1 << SHA512_REG_SHA512_CTRL_INIT_LOW) & SHA512_REG_SHA512_CTRL_INIT_MASK) |
          ((mode << SHA512_REG_SHA512_CTRL_MODE_LOW) & SHA512_REG_SHA512_CTRL_MODE_MASK);
    lsu_write_32(CLP_SHA512_REG_SHA512_CTRL,reg);
}

void sha_next(enum sha512_mode_e mode) {
    printf("SHA512: Set mode: 0x%x and next\n", mode);
    uint32_t reg;
    reg = ((1 << SHA512_REG_SHA512_CTRL_NEXT_LOW) & SHA512_REG_SHA512_CTRL_NEXT_MASK) |
          ((mode << SHA512_REG_SHA512_CTRL_MODE_LOW) & SHA512_REG_SHA512_CTRL_MODE_MASK);
    lsu_write_32(CLP_SHA512_REG_SHA512_CTRL,reg);
}

void sha_init_last(enum sha512_mode_e mode) {
    printf("SHA512: Set mode: 0x%x and init with last\n", mode);
    uint32_t reg;
    reg = ((1 << SHA512_REG_SHA512_CTRL_INIT_LOW) & SHA512_REG_SHA512_CTRL_INIT_MASK) |
          ((mode << SHA512_REG_SHA512_CTRL_MODE_LOW) & SHA512_REG_SHA512_CTRL_MODE_MASK) |
          SHA512_REG_SHA512_CTRL_LAST_MASK;
    lsu_write_32(CLP_SHA512_REG_SHA512_CTRL,reg);
}

void sha_next_last(enum sha512_mode_e mode) {
    printf("SHA512: Set mode: 0x%x and next with last\n", mode);
    uint32_t reg;
    reg = ((1 << SHA512_REG_SHA512_CTRL_NEXT_LOW) & SHA512_REG_SHA512_CTRL_NEXT_MASK) |
          ((mode << SHA512_REG_SHA512_CTRL_MODE_LOW) & SHA512_REG_SHA512_CTRL_MODE_MASK) |
          SHA512_REG_SHA512_CTRL_LAST_MASK;
    lsu_write_32(CLP_SHA512_REG_SHA512_CTRL,reg);
}

void sha_gen_hash_start() {
    printf("SHA512: Set START for gen hash func\n");
    uint32_t reg;
    reg = SHA512_REG_SHA512_GEN_PCR_HASH_CTRL_START_MASK;
    lsu_write_32(CLP_SHA512_REG_SHA512_GEN_PCR_HASH_CTRL,reg);
}

void sha384_kvflow(uint8_t sha_kv_id, uint8_t store_to_kv, uint8_t digest_kv_id, uint32_t expected_digest[12]){
    uint8_t block_inject_cmd;
    volatile uint32_t * reg_ptr;
    uint8_t offset;
    uint8_t fail_cmd = 0x1;

    uint32_t sha_digest [12];

    //inject sha block to kv key reg (in RTL)
    block_inject_cmd = 0xc0 + (sha_kv_id & 0x7);
    printf("%c", block_inject_cmd);

    // wait for SHA to be ready
    while((lsu_read_32(CLP_SHA512_REG_SHA512_STATUS) & SHA512_REG_SHA512_STATUS_READY_MASK) == 0);


    // Program block Read with 12 dwords from sha_kv_id
    lsu_write_32(CLP_SHA512_REG_SHA512_VAULT_RD_CTRL, SHA512_REG_SHA512_VAULT_RD_CTRL_READ_EN_MASK |
                                                   ((sha_kv_id << SHA512_REG_SHA512_VAULT_RD_CTRL_READ_ENTRY_LOW) & SHA512_REG_SHA512_VAULT_RD_CTRL_READ_ENTRY_MASK));

    // Check that SHA BLOCK is loaded
    while((lsu_read_32(CLP_SHA512_REG_SHA512_VAULT_RD_STATUS) & SHA512_REG_SHA512_VAULT_RD_STATUS_VALID_MASK) == 0);

    // if we want to store the results into kv 
    if (store_to_kv) {
        // set digest DEST to write
        lsu_write_32(CLP_SHA512_REG_SHA512_KV_WR_CTRL,  SHA512_REG_SHA512_KV_WR_CTRL_WRITE_EN_MASK |
                                                        SHA512_REG_SHA512_KV_WR_CTRL_HMAC_KEY_DEST_VALID_MASK  |
                                                        SHA512_REG_SHA512_KV_WR_CTRL_HMAC_BLOCK_DEST_VALID_MASK|
                                                        SHA512_REG_SHA512_KV_WR_CTRL_SHA_BLOCK_DEST_VALID_MASK |
                                                        SHA512_REG_SHA512_KV_WR_CTRL_ECC_PKEY_DEST_VALID_MASK  |
                                                        SHA512_REG_SHA512_KV_WR_CTRL_ECC_SEED_DEST_VALID_MASK  |
                                                        ((digest_kv_id << SHA512_REG_SHA512_KV_WR_CTRL_WRITE_ENTRY_LOW) & SHA512_REG_SHA512_KV_WR_CTRL_WRITE_ENTRY_MASK));
    }    


    // Enable SHA core in SHA512 MODE
    lsu_write_32(CLP_SHA512_REG_SHA512_CTRL, SHA512_REG_SHA512_CTRL_INIT_MASK | 
                                            (0x2 << SHA512_REG_SHA512_CTRL_MODE_LOW) |
                                             SHA512_REG_SHA512_CTRL_LAST_MASK);

    // wait for SHA to be valid
    wait_for_sha512_intr();

    // if we want to store the results into kv
    printf("check digest\n");
    if (store_to_kv) {
        // wait for SHA process - check dest done
        while((lsu_read_32(CLP_SHA512_REG_SHA512_KV_WR_STATUS) & SHA512_REG_SHA512_KV_WR_STATUS_VALID_MASK) == 0);
    }
    else{
        reg_ptr = (uint32_t *) CLP_SHA512_REG_SHA512_DIGEST_0;
        printf("Load DIGEST data from SHA512\n");
        offset = 0;
        while (reg_ptr <= (uint32_t*) CLP_SHA512_REG_SHA512_DIGEST_11) {
            sha_digest[offset] = *reg_ptr;
            if (sha_digest[offset] != expected_digest[offset]) {
                printf("At offset [%d], sha_digest data mismatch!\n", offset);
                printf("Actual   data: 0x%lx\n", sha_digest[offset]);
                printf("Expected data: 0x%lx\n", expected_digest[offset]);
                printf("%c", fail_cmd);
                while(1);
            }
            reg_ptr++;
            offset++;
        }
    }

}

void sha512_zeroize(){
    printf("SHA512 zeroize flow.\n");
    lsu_write_32(CLP_SHA512_REG_SHA512_CTRL, (1 << SHA512_REG_SHA512_CTRL_ZEROIZE_LOW) & SHA512_REG_SHA512_CTRL_ZEROIZE_MASK);
}

void sha512_flow(sha512_io block, uint8_t mode, sha512_io digest){
    volatile uint32_t * reg_ptr;
    uint8_t offset;
    uint8_t fail_cmd = 0x1;
    uint32_t sha512_digest [16];

    // wait for SHA to be ready
    while((lsu_read_32(CLP_SHA512_REG_SHA512_STATUS) & SHA512_REG_SHA512_STATUS_READY_MASK) == 0);

    // Write SHA512 block
    reg_ptr = (uint32_t*) CLP_SHA512_REG_SHA512_BLOCK_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_SHA512_REG_SHA512_BLOCK_31) {
        *reg_ptr++ = block.data[offset++];
    }

    // Enable SHA512 core 
    printf("Enable SHA512\n");
    lsu_write_32(CLP_SHA512_REG_SHA512_CTRL, (SHA512_REG_SHA512_CTRL_INIT_MASK | (mode << SHA512_REG_SHA512_CTRL_MODE_LOW)) & SHA512_REG_SHA512_CTRL_MODE_MASK);
    
    // wait for SHA to be valid
    wait_for_sha512_intr();

    reg_ptr = (uint32_t *) CLP_SHA512_REG_SHA512_DIGEST_0;
    printf("Load DIGEST data from SHA512\n");
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_SHA512_REG_SHA512_DIGEST_15) {
        sha512_digest[offset] = *reg_ptr;
        if (sha512_digest[offset] != digest.data[offset]) {
            printf("At offset [%d], sha_digest data mismatch!\n", offset);
            printf("Actual   data: 0x%lx\n", sha512_digest[offset]);
            printf("Expected data: 0x%lx\n", digest.data[offset]);
            printf("%c", fail_cmd);
            while(1);
        }
        reg_ptr++;
        offset++;
    }

}

uint32_t measure_soc(const uint8_t *recv_data, uint32_t recv_data_len) {
    uint32_t SOC_expected_digest[16] =  {0x6D1D644B,
                                        0x6AD742E5,
                                        0x271F3BD0,
                                        0xA4C2D052,
                                        0xE717CA61,
                                        0x2B8493E,
                                        0x804A0D47,
                                        0xF4DD1150,
                                        0x2B7E9A31,
                                        0xB0396FDB,
                                        0x521AC969,
                                        0xD6FC6CC7,
                                        0xC3918A53,
                                        0xB6C7208F,
                                        0xCF02FA92,
                                        0xBA212AFD};
    uint64_t bit_len;
    uint8_t length_bytes[16] = {0};
    uint32_t remaining_data;
    uint32_t padded_len;
    uint32_t copy_len;
    uint32_t processed_len = 0;
    uint8_t block[SHA512_BLOCK_SIZE] = {0};
    volatile uint32_t *block_ptr;
    bool match = true, Filled = false;
    uint32_t measure_value[16] = {0};
    volatile uint32_t* reg_ptr = (uint32_t *) CLP_SHA512_REG_SHA512_DIGEST_0;
    uint32_t i = 0;
    printf("func: %s, line: %d\n", __func__, __LINE__);

    bit_len = (uint64_t)recv_data_len * 8;
    for (int i = 0; i < 8; i++) {
        length_bytes[15 - i] = (bit_len >> (i * 8)) & 0xFF;
    }
    
    padded_len = ((recv_data_len + 1 + 16 + SHA512_BLOCK_SIZE - 1) / SHA512_BLOCK_SIZE) * SHA512_BLOCK_SIZE;

    while ((lsu_read_32(CLP_SHA512_REG_SHA512_STATUS) & SHA512_REG_SHA512_STATUS_READY_MASK) == 0);

    sha_init(SHA512_512_MODE);

    while (processed_len < padded_len) {
        memset(block, 0, SHA512_BLOCK_SIZE);
        
        remaining_data = recv_data_len - processed_len;
        if(remaining_data > recv_data_len) { 
            break;
        }
        if (remaining_data > 0) {
            copy_len = (remaining_data > SHA512_BLOCK_SIZE) ? SHA512_BLOCK_SIZE : remaining_data;
            memcpy(block, recv_data + processed_len, copy_len);
            processed_len += copy_len;
            if (remaining_data < SHA512_BLOCK_SIZE) {
                block[copy_len] = 0x80;
                Filled = true;
                if (SHA512_BLOCK_SIZE - copy_len - 1 >= 16) {
                    memcpy(block + SHA512_BLOCK_SIZE - 16, length_bytes, 16);
                    processed_len += SHA512_BLOCK_SIZE;
                }
                
            }
        } else {
            if (((processed_len == recv_data_len) && (Filled == false)) || (recv_data_len == SHA512_BLOCK_SIZE)) {
                block[0] = 0x80;
            }
            memcpy(block + SHA512_BLOCK_SIZE - 16, length_bytes, 16);
            processed_len += SHA512_BLOCK_SIZE;
        }

/*         for(int i = 0 ; i < SHA512_BLOCK_SIZE; i++) {
            printf("0x%02x ", block[i]);
            if (i % 16 == 15) {
                printf("\n");
            }
        }
 */
        block_ptr = (uint32_t*)CLP_SHA512_REG_SHA512_BLOCK_0;
        for (int i = 0; i < SHA512_BLOCK_SIZE / 4; i++) {
            *block_ptr++ = *(uint32_t*)(block + i * 4);
        }

        if (i == 0) {
            sha_init(SHA512_512_MODE);
        } else if (processed_len < padded_len) {
            sha_next(SHA512_512_MODE);
        } else {
            sha_next_last(SHA512_512_MODE);
        }
        i+=1;
        while((lsu_read_32(CLP_SHA512_REG_SHA512_STATUS) & SHA512_REG_SHA512_STATUS_VALID_MASK) == 0);
    }

    delay_second(1);

    for (int i = 0; i < 16; i++) {
        measure_value[i] = *reg_ptr++;
    }

    printf("measureSOC measure value:\n");
    for (int i = 0; i < 16; i++) {
        int val = measure_value[i];
        printf("0x%08x ", val);
    }
    printf("\n");

    printf("measureSOC expect_value:\n");
    for (int i = 0; i < 16; i++) {
        printf("0x%08x ", (unsigned int )SOC_expected_digest[i]);
    }
    printf("\n");

    printf("Comparing SHA512 digest...\n");
    for (int i = 0; i < 16; i++) {
        if (measure_value[i] != SOC_expected_digest[i]) {
            printf("Mismatch at word %d: Measurement value 0x%08x, Expected 0x%08x\n", i, (unsigned int )measure_value[i], (unsigned int )SOC_expected_digest[i]);
            match = false;
        }
    }

    if (match) {
        printf("Measurement success!\n");
        return 0;
    } else {
        printf("Measurement failed!\n");
    }

    return -1;
}

uint32_t measure_rt(const uint8_t *recv_data, uint32_t recv_data_len) {
    uint32_t RT_expected_digest[16] =   {0xC803E1E2,
                                        0xED62527,
                                        0x8412C191,
                                        0x97376662,
                                        0x93EFDE01,
                                        0x2064C338,
                                        0xFC3199A0,
                                        0x84DD6046,
                                        0x3B35F24C,
                                        0x95201DB1,
                                        0xCA846B73,
                                        0x1B81DF01,
                                        0xF1DD167D,
                                        0x5A24BC73,
                                        0xA4ECE127,
                                        0x14BC5A37};
    uint64_t bit_len;
    uint8_t length_bytes[16] = {0};
    uint32_t remaining_data;
    uint32_t padded_len;
    uint32_t copy_len;
    uint32_t processed_len = 0;
    uint8_t block[SHA512_BLOCK_SIZE] = {0};
    volatile uint32_t *block_ptr;
    bool match = true, Filled = false;
    uint32_t measure_value[16] = {0};
    volatile uint32_t* reg_ptr = (uint32_t *) CLP_SHA512_REG_SHA512_DIGEST_0;
    uint32_t i = 0;
    printf("func: %s, line: %d\n", __func__, __LINE__);

    bit_len = (uint64_t)recv_data_len * 8;
    for (int i = 0; i < 8; i++) {
        length_bytes[15 - i] = (bit_len >> (i * 8)) & 0xFF;
    }
    
    padded_len = ((recv_data_len + 1 + 16 + SHA512_BLOCK_SIZE - 1) / SHA512_BLOCK_SIZE) * SHA512_BLOCK_SIZE;

    while ((lsu_read_32(CLP_SHA512_REG_SHA512_STATUS) & SHA512_REG_SHA512_STATUS_READY_MASK) == 0);

    sha_init(SHA512_512_MODE);

    while (processed_len < padded_len) {
        memset(block, 0, SHA512_BLOCK_SIZE);
        
        remaining_data = recv_data_len - processed_len;
        if(remaining_data > recv_data_len) { 
            break;
        }
        if (remaining_data > 0) {
            copy_len = (remaining_data > SHA512_BLOCK_SIZE) ? SHA512_BLOCK_SIZE : remaining_data;
            memcpy(block, recv_data + processed_len, copy_len);
            processed_len += copy_len;
            if (remaining_data < SHA512_BLOCK_SIZE) {
                block[copy_len] = 0x80;
                Filled = true;
                if (SHA512_BLOCK_SIZE - copy_len - 1 >= 16) {
                    memcpy(block + SHA512_BLOCK_SIZE - 16, length_bytes, 16);
                    processed_len += SHA512_BLOCK_SIZE;
                }
                
            }
        } else {
            if (((processed_len == recv_data_len) && (Filled == false)) || (recv_data_len == SHA512_BLOCK_SIZE)) {
                block[0] = 0x80;
            }
            memcpy(block + SHA512_BLOCK_SIZE - 16, length_bytes, 16);
            processed_len += SHA512_BLOCK_SIZE;
        }

/*         for(int i = 0 ; i < SHA512_BLOCK_SIZE; i++) {
            printf("0x%02x ", block[i]);
            if (i % 16 == 15) {
                printf("\n");
            }
        } */

        block_ptr = (uint32_t*)CLP_SHA512_REG_SHA512_BLOCK_0;
        for (int i = 0; i < SHA512_BLOCK_SIZE / 4; i++) {
            *block_ptr++ = *(uint32_t*)(block + i * 4);
        }

        if (i == 0) {
            sha_init(SHA512_512_MODE);
        } else if (processed_len < padded_len) {
            sha_next(SHA512_512_MODE);
        } else {
            sha_next_last(SHA512_512_MODE);
        }
        i+=1;
        while((lsu_read_32(CLP_SHA512_REG_SHA512_STATUS) & SHA512_REG_SHA512_STATUS_VALID_MASK) == 0);
    }

    delay_second(1);

    for (int i = 0; i < 16; i++) {
        measure_value[i] = *reg_ptr++;
    }

    printf("measureRT measure value:\n");
    for (int i = 0; i < 16; i++) {
        int val = measure_value[i];
        printf("0x%08x ", val);
    }
    printf("\n");

    printf("measureRT expect_value:\n");
    for (int i = 0; i < 16; i++) {
        printf("0x%08x ", (unsigned int )RT_expected_digest[i]);
    }
    printf("\n");

    printf("Comparing SHA512 digest...\n");
    for (int i = 0; i < 16; i++) {
        if (measure_value[i] != RT_expected_digest[i]) {
            printf("Mismatch at word %d: Measurement value 0x%08x, Expected 0x%08x\n", i, (unsigned int )measure_value[i], (unsigned int )RT_expected_digest[i]);
            match = false;
        }
    }

    if (match) {
        printf("Measurement success!\n");
        return 0;
    } else {
        printf("Measurement failed!\n");
    }

    return -1;
}

uint32_t measure_fmc(const uint8_t *recv_data, uint32_t recv_data_len) {
    uint32_t FMC_expected_digest[16] =  {0x99468215,
                                    0xA4AF32CE,
                                    0x8F510FD7,
                                    0x389DA5E7,
                                    0xA5FED6E2,
                                    0xBC88D5C,
                                    0x6795A3F6,
                                    0x1A3681A4,
                                    0x9E64A514,
                                    0xDD34D7E2,
                                    0xBC745EAB,
                                    0x4BBA90EC,
                                    0x4A43DBE3,
                                    0xC5816316,
                                    0xADB2FEE1,
                                    0x7942EC94};
    uint64_t bit_len;
    uint8_t length_bytes[16] = {0};
    uint32_t remaining_data;
    uint32_t padded_len;
    uint32_t copy_len;
    uint32_t processed_len = 0;
    uint8_t block[SHA512_BLOCK_SIZE] = {0};
    volatile uint32_t *block_ptr;
    bool match = true, Filled = false;
    uint32_t measure_value[16] = {0};
    volatile uint32_t* reg_ptr = (uint32_t *) CLP_SHA512_REG_SHA512_DIGEST_0;
    uint32_t i = 0;
    printf("func: %s, line: %d\n", __func__, __LINE__);

    bit_len = (uint64_t)recv_data_len * 8;
    for (int i = 0; i < 8; i++) {
        length_bytes[15 - i] = (bit_len >> (i * 8)) & 0xFF;
    }
    
    padded_len = ((recv_data_len + 1 + 16 + SHA512_BLOCK_SIZE - 1) / SHA512_BLOCK_SIZE) * SHA512_BLOCK_SIZE;

    while ((lsu_read_32(CLP_SHA512_REG_SHA512_STATUS) & SHA512_REG_SHA512_STATUS_READY_MASK) == 0);

    while (processed_len < padded_len) {
        memset(block, 0, SHA512_BLOCK_SIZE);
        
        remaining_data = recv_data_len - processed_len;
        if(remaining_data > recv_data_len) { 
            break;
        }
        if (remaining_data > 0) {
            copy_len = (remaining_data > SHA512_BLOCK_SIZE) ? SHA512_BLOCK_SIZE : remaining_data;
            memcpy(block, recv_data + processed_len, copy_len);
            processed_len += copy_len;
            if (remaining_data < SHA512_BLOCK_SIZE) {
                block[copy_len] = 0x80;
                Filled = true;
                if (SHA512_BLOCK_SIZE - copy_len - 1 >= 16) {
                    memcpy(block + SHA512_BLOCK_SIZE - 16, length_bytes, 16);
                    processed_len += SHA512_BLOCK_SIZE;
                }
                
            }
        } else {
            if (((processed_len == recv_data_len) && (Filled == false)) || (recv_data_len == SHA512_BLOCK_SIZE)) {
                block[0] = 0x80;
            }
            memcpy(block + SHA512_BLOCK_SIZE - 16, length_bytes, 16);
            processed_len += SHA512_BLOCK_SIZE;
        }

/*         for(int i = 0 ; i < SHA512_BLOCK_SIZE; i++) {
            printf("0x%02x ", block[i]);
            if (i % 16 == 15) {
                printf("\n");
            }
        } */

        block_ptr = (uint32_t*)CLP_SHA512_REG_SHA512_BLOCK_0;
        for (int i = 0; i < SHA512_BLOCK_SIZE / 4; i++) {
            *block_ptr++ = *(uint32_t*)(block + i * 4);
        }
        
        if (i == 0) {
            sha_init(SHA512_512_MODE);
        } else if (processed_len < padded_len) {
            sha_next(SHA512_512_MODE);
        } else {
            sha_next_last(SHA512_512_MODE);
        }
        i+=1;
        while((lsu_read_32(CLP_SHA512_REG_SHA512_STATUS) & SHA512_REG_SHA512_STATUS_VALID_MASK) == 0);
    }

    delay_second(1);

    for (int i = 0; i < 16; i++) {
        measure_value[i] = *reg_ptr++;
    }

    printf("measureFMC measure value:\n");
    for (int i = 0; i < 16; i++) {
        int val = measure_value[i];
        printf("0x%08x ", val);
    }
    printf("\n");

    printf("measureFMC expect_value:\n");
    for (int i = 0; i < 16; i++) {
        printf("0x%08x ", (unsigned int )FMC_expected_digest[i]);
    }
    printf("\n");

    printf("Comparing SHA512 digest...\n");
    for (int i = 0; i < 16; i++) {
        if (measure_value[i] != FMC_expected_digest[i]) {
            printf("Mismatch at word %d: Measurement value 0x%08x, Expected 0x%08x\n", i, (unsigned int )measure_value[i], (unsigned int )FMC_expected_digest[i]);
            match = false;
        }
    }

    if (match) {
        printf("Measurement success!\n");
        return 0;
    } else {
        printf("Measurement failed!\n");
    }

    return -1;
}