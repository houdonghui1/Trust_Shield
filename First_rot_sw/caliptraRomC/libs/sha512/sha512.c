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

uint32_t FMC_expected_digest[16] __attribute__((section(".rodata"))) = {
    0xC5A6B5B6,0x983A78BF,0x4BAA4D8C,0x3A3B8F33,
    0x1540BF1B,0xADA3EB68,0xEC7B10CE,0xFD29130F,
    0xA3E1C2F3,0x584E0B9E,0x766D530B,0xCC0C520C,
    0xF2B6808C,0x68D6169A,0xE1F4CF3B,0x546C3A27
};

uint32_t RT_expected_digest[16] __attribute__((section(".rodata"))) = {
    0x82BC4F10,0x26344F1F,0x16F5AB89,0x1E9D8D68,
    0x2E144808,0x8EB52A20,0x4A700E9,0xEE8F1BDC,
    0xAC683FC2,0x601D32D9,0xDE45A3AF,0xC25C76B2,
    0x45D9BC3D,0xC9CA5B74,0x9AC59709,0xB2718732
};

uint32_t SOC_expected_digest[16] __attribute__((section(".rodata")))= {
    0xA343CA21,0x68DCB3E0,0x21098F9D,0xA0592D35,
    0xA0B67420,0x5AC6FBD3,0xCD43813D,0x7B43286D,
    0xD30D3E07,0xE042B6CE,0x4C5392CC,0x441D8254,
    0x6129973D,0x62E7ADE8,0x7543633E,0xFBFA81BD
};

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
    while((lsu_read_32(CLP_SHA256_REG_SHA256_STATUS) & SHA256_REG_SHA256_STATUS_VALID_MASK) == 0);

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

void sha512_flow_produce(const uint8_t *data, uint32_t data_len, uint32_t *measure_value){
    uint64_t bit_len;
    uint8_t length_bytes[16] = {0};
    uint32_t remaining_data;
    uint32_t padded_len;
    uint32_t copy_len;
    uint32_t processed_len = 0;
    uint8_t block[SHA512_BLOCK_SIZE] = {0};
    volatile uint32_t *block_ptr;
    //bool match = true;
    bool Filled = false;
    volatile uint32_t* reg_ptr = (uint32_t *) CLP_SHA512_REG_SHA512_DIGEST_0;
    uint32_t i = 0;
    //printf("func: %s, line: %d\n", __func__, __LINE__);

    bit_len = (uint64_t)data_len * 8;
    for (int i = 0; i < 8; i++) {
        length_bytes[15 - i] = (bit_len >> (i * 8)) & 0xFF;
    }
    
    padded_len = ((data_len + 1 + 16 + SHA512_BLOCK_SIZE - 1) / SHA512_BLOCK_SIZE) * SHA512_BLOCK_SIZE;

    while ((lsu_read_32(CLP_SHA512_REG_SHA512_STATUS) & SHA512_REG_SHA512_STATUS_READY_MASK) == 0);

    sha_init(SHA512_512_MODE);

    while (processed_len < padded_len) {
        memset(block, 0, SHA512_BLOCK_SIZE);
        
        remaining_data = data_len - processed_len;
        if(remaining_data > data_len) { 
            break;
        }
        if (remaining_data > 0) {
            copy_len = (remaining_data > SHA512_BLOCK_SIZE) ? SHA512_BLOCK_SIZE : remaining_data;
            memcpy(block, data + processed_len, copy_len);
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
            if (((processed_len == data_len) && (Filled == false)) || (data_len == SHA512_BLOCK_SIZE)) {
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

}

uint32_t measure_soc(const uint8_t *recv_data, uint32_t recv_data_len) {

    uint64_t bit_len;
    uint8_t length_bytes[16] = {0};
    uint32_t remaining_data;
    uint32_t padded_len;
    uint32_t copy_len;
    uint32_t processed_len = 0;
    uint8_t block[SHA512_BLOCK_SIZE] = {0};
    volatile uint32_t *block_ptr;
    bool match = true;
    bool Filled = false;
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

    uint64_t bit_len;
    uint8_t length_bytes[16] = {0};
    uint32_t remaining_data;
    uint32_t padded_len;
    uint32_t copy_len;
    uint32_t processed_len = 0;
    uint8_t block[SHA512_BLOCK_SIZE] = {0};
    volatile uint32_t *block_ptr;
    bool match = true;
    bool Filled = false;
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