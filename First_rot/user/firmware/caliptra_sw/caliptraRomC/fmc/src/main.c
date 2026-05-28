#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "caliptra_reg.h"
#include "caliptra_isr.h"
#include "riscv_hw_if.h"
#include "defines.h"
#include "uart.h"
#include "qspi.h"
#include "printf.h"
#include "hmac.h"
#include "ecc.h"
#include "sha384.h"
#include "sha512.h"
#include "keyvault.h"
#include "datavault.h"
#include "x509.h"

#define RT_SIZE                (20480)
#define RT_STORE_SECTOR_OFFSET (4096)

__attribute__((section(".dccm"))) uint8_t RT_data[RT_SIZE];

__attribute__((section(".tbs_der_store"))) cert_t tbs_der_store[4];
__attribute__((section(".cert_store"))) cert_t cert_store[4];

volatile caliptra_intr_received_s cptra_intr_rcv = {
    .doe_error        = 0,
    .doe_notif        = 0,
    .ecc_error        = 0,
    .ecc_notif        = 0,
    .hmac_error       = 0,
    .hmac_notif       = 0,
    .kv_error         = 0,
    .kv_notif         = 0,
    .sha512_error     = 0,
    .sha512_notif     = 0,
    .sha256_error     = 0,
    .sha256_notif     = 0,
    .qspi_error       = 0,
    .qspi_notif       = 0,
    .uart_error       = 0,
    .uart_notif       = 0,
    .i3c_error        = 0,
    .i3c_notif        = 0,
    .soc_ifc_error    = 0,
    .soc_ifc_notif    = 0,
    .sha512_acc_error = 0,
    .sha512_acc_notif = 0,
};

void alias_fmc() {
    uint32_t status = 0;
    uint8_t digest[48];
    uint8_t tbs_der[2048] = {0};
    size_t tbs_len = sizeof(tbs_der);
    uint8_t cert_der[4096] = {0};
    size_t cert_len = sizeof(cert_der);
    uint32_t FMC_expected_digest[16] =  {0xD155317D,
                                    0xC424B020,
                                    0x3017B143,
                                    0xF55D1722,
                                    0x92E15EE1,
                                    0xB1F0CB01,
                                    0xAAE6FFE7,
                                    0x74345F16,
                                    0xEDB49FB8,
                                    0x159E4F3E,
                                    0x18C8F4E4,
                                    0x63D78260,
                                    0x734451C2,
                                    0xA88A134D,
                                    0x23BC6A9D,
                                    0xF910CD65};


    //Derive CDI using LDevID CDI (Slot6) and fmc measure value
    hmac_io key_cdi_label = {
        .kv_intf = 1,       // 从密钥库加载
        .kv_id = 6,         // LDevID CDI 在 Slot6
        .data = {0}
    };

    hmac_io block_cdi_label = {
        .kv_intf = 0
    };
    memcpy(block_cdi_label.data, "fmc_alias_cdi", sizeof("fmc_alias_cdi"));

    hmac_io lfsr_seed_default = {
        .kv_intf = 0,
        .data = {0}
    };

    hmac_io tag_cdi_label = {
        .kv_intf = 1,        // 写入密钥库
        .kv_id = 6,          // 覆盖 Slot6
        .data = {0}
    };

    //label
    hmac_flow(key_cdi_label, block_cdi_label, lfsr_seed_default, tag_cdi_label);
    printf("CDI diversified with label 'fmc_alias_cdi'.\n");

    hmac_io key_cdi_pcr = {
        .kv_intf = 1,        // 从密钥库加载
        .kv_id = 6,          // 第一次 HMAC 的结果
        .data = {0}          // 无直接数据
    };

    hmac_io block_cdi_pcr = {
        .data = {0}
    };
    memcpy(block_cdi_pcr.data, FMC_expected_digest, 64);

    hmac_flow(key_cdi_pcr, block_cdi_pcr, lfsr_seed_default, tag_cdi_label);
    printf("Alias FMC CDI derived and stored in KeySlot6.\n");

    // Step 2: Derive ECC Key Pair using CDI in Slot 6
    hmac_io key_seed = {
        .kv_intf = 1,       // 从密钥库加载
        .kv_id = 6,         // CDI 在 Slot 6
        .data = {0}
    };

    hmac_io block_seed = {
        .kv_intf = 0       // 加载标签数据
    };
    memcpy(block_seed.data, "fmc_alias_keygen", sizeof("fmc_alias_keygen"));
    
    hmac_io lfsr_seed_cdi = {
        .kv_intf = 0,
        .data = {0}
    };

    hmac_io tag_seed = {
        .kv_intf = 1,       // 写入密钥库
        .kv_id = 3,         // 存储到 Slot 3
        .data = {0}         //
    };

    // Call HMAC to generate ECC seeds
    hmac_flow(key_seed, block_seed, lfsr_seed_cdi, tag_seed);
    printf("ECC seed derived and stored in KeySlot3.\n");

    // Call the ecc_keygen_flow generate pubkey and privkey
    ecc_io seed = {
        .kv_intf = 1,       // 从密钥库加载
        .kv_id = 3,         // 种子在 Slot 3
        .data = {0}
    };

    ecc_io nonce = {
        .kv_intf = 0,
        .data = {0}
    };

    ecc_io iv = {
        .kv_intf = 0,
        .data = {0}
    };

    ecc_io alisafmc_privkey = {
        .kv_intf = 1,       // 写入密钥库
        .kv_id = 7,         // fmc_privkey存储到 Slot 7
        .data = {0}
    };

    ecc_io alisafmc_pubkey_x = {
        .kv_intf = 1,       // 直接返回pubkey_x,不校验
        .data = {0}
    };

    ecc_io alisafmc_pubkey_y = {
        .kv_intf = 1,       // 直接返回pubkey_y,不校验
        .data = {0}
    };

    ecc_keygen_flow(&seed, &nonce, &iv, &alisafmc_privkey, &alisafmc_pubkey_x, &alisafmc_pubkey_y);
    printf("ECC key pair generated: Private in keySlot7, Public returned.\n");

    printf("alisafmc_pubkey_x.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)alisafmc_pubkey_x.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    printf("alisafmc_pubkey_y.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)alisafmc_pubkey_y.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    //kv_clear(KvSlot3)
    lsu_write_32(CLP_KV_REG_KEY_CTRL_3, KV_REG_KEY_CTRL_3_CLEAR_MASK);
    while ((lsu_read_32(CLP_KV_REG_KEY_CTRL_3) & KV_REG_KEY_CTRL_3_CLEAR_MASK) != 0);
    printf("Temporary seed cleared in KeySlot3.\n");
    
    //Store and lock (for write) the FMC Public Key in Data Vault (48 bytes) Slot 6 and Slot 7
    store_to_datavault(alisafmc_pubkey_x.data, alisafmc_pubkey_y.data, 6, 7);

    //Generate the To Be Signed DER Blob of the  Alias FMC  Certificate
    status = generate_intermediate_tbs_der(alisafmc_pubkey_x.data, alisafmc_pubkey_y.data, "Caliptra 1.0 LDevID", "Caliptra 1.0 FMC Alias", tbs_der, &tbs_len, CERT_TYPE_FMC);
    if(!status && tbs_len <= 2048) {
        printf("cert_len = 0x%x\n", tbs_len);
        printf("AliasFMC tbs der:\n");
        for(int j = 0; j < tbs_len; j++) {
            printf("%02x", tbs_der[j]);
        }
        printf("\n");
    } else {
        printf("generate AliasFMC cert der faild!\n");
        while(1);
    }

    tbs_der_store[2].der_len = tbs_len;
    tbs_der_store[2].type = CERT_TYPE_FMC;
    memcpy(tbs_der_store[2].der_data, tbs_der, tbs_len);

    //Sign the Alias FMC To Be Signed DER Blob with LDevId Private Key in Key Vault Slot 5
    sha384_digest(tbs_der, tbs_len, (uint64_t *)digest, true);

    ecc_io msg = {0};
    for (int i=0; i<6; i++) {
        uint64_t chunk;
        memcpy(&chunk, digest+i*8, 8);
        chunk = swap_64bit(chunk);
        memcpy(msg.data+i*2, &chunk, 8);
    }

    ecc_io ldevid_privkey = {
        .kv_intf = 1,       // 密钥库
        .kv_id = 5,         // LDevId_privkey Slot 5
        .data = {0}
    };

    ecc_io sign_r = {
        .kv_intf = 1,       // 直接返回sign_r,不校验
        .data = {0}
    };

    ecc_io sign_s = {
        .kv_intf = 1,       // 直接返回sign_s,不校验
        .data = {0}
    };

    ecc_signing_flow(&ldevid_privkey, &msg, &iv, &sign_r, &sign_s);

    printf("Signature R:\n");
    for (int i = 0; i < 12; i++) {
        printf("%08x ", (unsigned int)sign_r.data[i]);
    }
    printf("\nSignature S:\n");
    for (int i = 0; i < 12; i++) {
        printf("%08x ", (unsigned int)sign_s.data[i]);
    }
    printf("\n");

    //Clear the LDevId Private Key in Key Vault Slot 5
    lsu_write_32(CLP_KV_REG_KEY_CTRL_5, KV_REG_KEY_CTRL_5_CLEAR_MASK);
    while ((lsu_read_32(CLP_KV_REG_KEY_CTRL_5) & KV_REG_KEY_CTRL_5_CLEAR_MASK) != 0);
    printf("Temporary seed cleared in KeySlot5.\n");

    //Verify the signature of Alias FMC To Be Signed Blob
    ecc_io ldevid_pubkey_x = {
        .data = {0}
    };

    ecc_io ldevid_pubkey_y = {
        .data = {0}
    };

    read_from_datavault(ldevid_pubkey_x.data, ldevid_pubkey_y.data, 2, 3);
    printf("ldevid_pubkey_x.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)ldevid_pubkey_x.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    printf("ldevid_pubkey_y.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)ldevid_pubkey_y.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    status = ecc_verifying_flow(msg, ldevid_pubkey_x, ldevid_pubkey_y, sign_r, sign_s);
    if(!status) {
        printf("Signature verification successful!\n");
    } else {
        printf("Signature verification failed!\n");
        while(1);
    }
    //Store and lock (for write) the Alias FMC Certificate Signature in the sticky Data Vault (48 bytes) Slot 4 & Slot 5
    store_to_datavault(sign_r.data, sign_s.data, 4, 5);
        //Write the signature into the certificate

    status = add_signature_to_cert(tbs_der, tbs_len, sign_r.data, sign_s.data, cert_der, &cert_len);
    if(!status && cert_len <= 4096) {
        printf("cert_len = 0x%x\n", cert_len);
        printf("AliasFMC cert:\n");
        for(int j = 0; j < cert_len; j++) {
            printf("%s%X", (cert_der[j] < 0x10) ? "0" : "", cert_der[j]); 
        }
        printf("\n");
    } else {
        printf("generate AliasFMC cert der faild!\n");
        while(1);
    }

    cert_store[2].der_len = cert_len;
    cert_store[2].type = CERT_TYPE_FMC;
    memcpy(cert_store[2].der_data, cert_der, cert_len);
}

inline void soc_ifc_set_iccm_lock() {
    lsu_write_32((CLP_SOC_IFC_REG_INTERNAL_ICCM_LOCK), SOC_IFC_REG_INTERNAL_ICCM_LOCK_LOCK_MASK);
}

void caliptra_fmc() {
    uint32_t init_ok = 0;
    uint8_t recv_data[BUFFER_SIZE] = {0};
    uint8_t status;

    init_uart();
    init_qspi();

    printf("------------------------------------\n");
    printf("            Caliptra FMC!!          \n");
    printf("------------------------------------\n");
    printf("Compiled on: %s at %s\n", __DATE__, __TIME__);
    delay_second(1);
    
    alias_fmc();
    
    for(int i = 0; i < RT_SIZE/BUFFER_SIZE; i++) {
        memset(recv_data, 0xFF, BUFFER_SIZE);
        status = read_sd_card(RT_STORE_SECTOR_OFFSET+i, recv_data, 0, 0);
        if(i == 0) {
            printf("%d:\n", i);
            for(int j = 0; j < BUFFER_SIZE; j++) {
                printf("0x%02x ", recv_data[j]);
                if (j % 16 == 15) {
                    printf("\n");
                }
            }
        }
        memcpy(RT_data + i * BUFFER_SIZE, recv_data, BUFFER_SIZE);
    }
    printf("\n");
        
    if(!status) {
        printf("Measure runtime start:\n");
        status = measure_rt(RT_data, RT_SIZE);
        if(!status) {
            memcpy_fw_to_iccm(RT_data, (void *)RV_ICCM_SADR + 0x10000, RT_SIZE);
            init_ok = 1;
        }
    }

    if (init_ok) {
        printf("Jump to runtime...\n");
        void (* rt_entry) (void) = (void*) (RV_ICCM_SADR + 0x10000);
        rt_entry();
        //asm volatile("li a0, 0x40000000; jr a0");
    }

    printf("------------------------------------\n");
    printf(" Reached end of FMC FW unexpectedly!\n");
    printf("------------------------------------\n");
    while(1);
}