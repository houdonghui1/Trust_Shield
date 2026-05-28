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
#include "mailbox.h"
#include "trng.h"

#define FMC_SIZE                    (20480)
#define FMC_STORE_SECTOR_OFFSET     (2048)

#define SOC_FW_SIZE                 (8704)
#define SOC_FW_STORE_SECTOR_OFFSET  (6144)

__attribute__((section(".dccm"))) uint8_t FMC_data[FMC_SIZE] = {0};
__attribute__((section(".dccm"))) uint8_t SOC_FW_data[SOC_FW_SIZE] = {0};

__attribute__((section(".tbs_der_store"))) cert_t tbs_der_store[4] = {0};
__attribute__((section(".cert_store"))) cert_t cert_store[4] = {0};

volatile uint32_t intr_count = 0;
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

enum doe_cmd_e {
    DOE_IDLE = 0,
    DOE_UDS = 1,
    DOE_FE = 2,
    DOE_CLEAR_OBF_SECRETS = 3
};

void ldevid() {
    uint32_t status = 0;
    uint8_t digest[48];
    uint8_t tbs_der[2048] = {0};
    size_t tbs_len = sizeof(tbs_der);
    uint8_t cert_der[4096] = {0};
    size_t cert_len = sizeof(cert_der);
    //Derive CDI using IDevID CDI (Slot6) and Field Entropy (Slot1)
    hmac_io key_cdi_label = {
        .kv_intf = 1,       // 从密钥库加载
        .kv_id = 6,         // IDevID CDI 在 Slot6
        .data = {0}
    };

    hmac_io block_cdi_label = {
        .kv_intf = 0
    };
    memcpy(block_cdi_label.data, "ldevid_cdi", sizeof("ldevid_cdi"));

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
    printf("CDI diversified with label 'ldevid_cdi'.\n");

    hmac_io key_cdi_fe = {
        .kv_intf = 1,        // 从密钥库加载
        .kv_id = 6,          // 第一次 HMAC 的结果
        .data = {0}          // 无直接数据
    };

    hmac_io block_cdi_fe = {
        .kv_intf = 1,        // 从密钥库加载
        .kv_id = 1,          // Field Entropy 在 Slot1
        .data = {0}          // 无直接数据
    };

    //Field Entropy
    hmac_flow(key_cdi_fe, block_cdi_fe, lfsr_seed_default, tag_cdi_label);
    printf("CDI diversified with Field Entropy from Slot1.\n");
    printf("LDevID.CDI derived and stored in KeySlot6.\n");

    //Clear Field Entropy in Slot1
    lsu_write_32(CLP_KV_REG_KEY_CTRL_1, KV_REG_KEY_CTRL_1_CLEAR_MASK);
    while ((lsu_read_32(CLP_KV_REG_KEY_CTRL_1) & KV_REG_KEY_CTRL_1_CLEAR_MASK) != 0);
    printf("Field Entropy cleared in KeySlot1.\n");

    //Derive ECC Key Pair using CDI in Slot 6
    hmac_io key_seed = {
        .kv_intf = 1,       // 从密钥库加载
        .kv_id = 6,         // CDI 在 Slot 6
        .data = {0}
    };

    hmac_io block_seed = {
        .kv_intf = 0       // 加载标签数据
    };
    memcpy(block_seed.data, "ldevid_keygen", sizeof("ldevid_keygen"));
    
    hmac_io lfsr_seed_cdi = {
        .kv_intf = 0,
        .data = {0}
    };

    hmac_io tag_seed = {
        .kv_intf = 1,       // 写入密钥库
        .kv_id = 3,         // 存储到 Slot 3
        .data = {0}         //
    };

    //Call HMAC to generate ECC seeds
    hmac_flow(key_seed, block_seed, lfsr_seed_cdi, tag_seed);
    printf("ECC seed derived and stored in KeySlot3.\n");

    //Call the ecc_keygen_flow generate pubkey and privkey
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

    ecc_io Ldevid_privkey = {
        .kv_intf = 1,       // 写入密钥库
        .kv_id = 5,         // Ldevid_privkey存储到 Slot 5
        .data = {0}
    };

    ecc_io Ldevid_pubkey_x = {
        .kv_intf = 1,       // 直接返回pubkey_x,不校验
        .data = {0}
    };

    ecc_io Ldevid_pubkey_y = {
        .kv_intf = 1,       // 直接返回pubkey_y,不校验
        .data = {0}
    };

    ecc_keygen_flow(&seed, &nonce, &iv, &Ldevid_privkey, &Ldevid_pubkey_x, &Ldevid_pubkey_y);
    printf("ECC key pair generated: Private in Slot5, Public returned.\n");

    //kv_clear(KvSlot3)
    lsu_write_32(CLP_KV_REG_KEY_CTRL_3, KV_REG_KEY_CTRL_3_CLEAR_MASK);
    while ((lsu_read_32(CLP_KV_REG_KEY_CTRL_3) & KV_REG_KEY_CTRL_3_CLEAR_MASK) != 0);
    printf("Temporary seed cleared in KeySlot3.\n");
    
    //Store and lock (for write) the LDevID Public Key in Data Vault (48 bytes) Slot 2 and Slot 3
    store_to_datavault(Ldevid_pubkey_x.data, Ldevid_pubkey_y.data, 2, 3);

    //Generate the To Be Signed DER Blob of the LDevId Certificate
    status = generate_intermediate_tbs_der(Ldevid_pubkey_x.data, Ldevid_pubkey_y.data, "Caliptra 1.0 IDevID", "Caliptra 1.0 LDevID", tbs_der, &tbs_len, CERT_TYPE_LDEVID);
    if(!status && tbs_len <= 2048) {
        printf("cert_len = 0x%x\n", tbs_len);
        printf("LdeVID tbs der:\n");
        for(int j = 0; j < tbs_len; j++) {
            printf("%s%X", (tbs_der[j] < 0x10) ? "0" : "", tbs_der[j]); 
        }
        printf("\n");
    } else {
        printf("generate LdeVID cert der faild!\n");
        while(1);
    }

    tbs_der_store[1].der_len = tbs_len;
    tbs_der_store[1].type = CERT_TYPE_LDEVID;
    memcpy(tbs_der_store[1].der_data, tbs_der, tbs_len);

    //Sign the LDevID To Be Signed DER Blob with IDevId Private Key in Key Vault Slot 7
    sha384_digest(tbs_der, tbs_len, (uint64_t *)digest, true);

    ecc_io msg = {0};
    for (int i=0; i<6; i++) {
        uint64_t chunk;
        memcpy(&chunk, digest+i*8, 8);
        chunk = swap_64bit(chunk);
        memcpy(msg.data+i*2, &chunk, 8);
    }

    printf("der_csr.digest:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)msg.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");
    ecc_io idevid_privkey = {
        .kv_intf = 1,       // 密钥库
        .kv_id = 7,         // idevid_privkey Slot 7
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

    ecc_signing_flow(&idevid_privkey, &msg, &iv, &sign_r, &sign_s);

    printf("Signature R:\n");
    for (int i = 0; i < 12; i++) {
        printf("%08x ", (unsigned int)sign_r.data[i]);
    }
    printf("\nSignature S:\n");
    for (int i = 0; i < 12; i++) {
        printf("%08x ", (unsigned int)sign_s.data[i]);
    }
    printf("\n");

    //Clear the IDevId Private Key in Key Vault Slot 7
    lsu_write_32(CLP_KV_REG_KEY_CTRL_7, KV_REG_KEY_CTRL_7_CLEAR_MASK);
    while ((lsu_read_32(CLP_KV_REG_KEY_CTRL_7) & KV_REG_KEY_CTRL_7_CLEAR_MASK) != 0);
    printf("Temporary seed cleared in KeySlot7.\n");

    //Verify the signature of LDevID To Be Signed Blob
    ecc_io idevid_pubkey_x = {
        .data = {0}
    };

    ecc_io idevid_pubkey_y = {
        .data = {0}
    };

    read_from_datavault(idevid_pubkey_x.data, idevid_pubkey_y.data, 8, 9);

    printf("idevid_pubkey_x.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)idevid_pubkey_x.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    printf("idevid_pubkey_y.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)idevid_pubkey_y.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    status = ecc_verifying_flow(msg, idevid_pubkey_x, idevid_pubkey_y, sign_r, sign_s);
    if(!status) {
        printf("Signature verification successful!\n");
    } else {
        printf("Signature verification failed!\n");
        while(1);
    }
    //Store and lock (for write) the LDevID Certificate Signature in the sticky Data Vault (48 bytes) Slot 0 & Slot 1
    store_to_datavault(sign_r.data, sign_s.data, 0, 1);

    status = add_signature_to_cert(tbs_der, tbs_len, sign_r.data, sign_s.data, cert_der, &cert_len);
    if(!status && cert_len <= 4096) {
        printf("cert_len = 0x%x\n", cert_len);
        printf("LdeVID cert:\n");
        for(int j = 0; j < cert_len; j++) {
            printf("%s%X", (cert_der[j] < 0x10) ? "0" : "", cert_der[j]); 
        }
        printf("\n");
    } else {
        printf("generate LdeVID cert der faild!\n");
        while(1);
    }
    cert_store[1].der_len = cert_len;
    cert_store[1].type = CERT_TYPE_LDEVID;
    memcpy(cert_store[1].der_data, cert_der, cert_len);
}

void idevid() {
    uint32_t status;
    uint8_t tbs_der[2048] = {0};
    size_t tbs_len = sizeof(tbs_der);
    uint8_t cert_der[4096] = {0};
    size_t cert_len = sizeof(cert_der);
    uint8_t digest[48];

    //Derive CDI using UDS in Slot 0 and store in Slot 6
    hmac_io key_cdi = {
        .kv_intf = 1,       // 从密钥库加载
        .kv_id = 0,         // UDS 在 Slot 0
        .data = {0}
    };

    hmac_io block_cdi = {
        .kv_intf = 0       // 加载标签数据
    };
    memcpy(block_cdi.data, "idevid_cdi", sizeof("idevid_cdi"));

    printf("block_cdi.data:\n");
    for(int j = 0; j < 32; j++) {
        printf("0x%08x ", (unsigned int)block_cdi.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    hmac_io lfsr_seed_cdi = {
        .kv_intf = 0,
        .data = {0}
    };

    hmac_io tag_cdi = {
        .kv_intf = 1,       // 写入密钥库
        .kv_id = 6,         // 存储到 Slot 6
        .data = {0}
    };

    hmac_flow(key_cdi, block_cdi, lfsr_seed_cdi, tag_cdi);
    printf("IDevID.CDI derived and stored in KeySlot6.\n");

    //Clear UDS in Slot 0
    lsu_write_32(CLP_KV_REG_KEY_CTRL_0, KV_REG_KEY_CTRL_0_CLEAR_MASK);
    while ((lsu_read_32(CLP_KV_REG_KEY_CTRL_0) & KV_REG_KEY_CTRL_0_CLEAR_MASK) != 0);
    printf("UDS cleared in KeySlot0.\n");

    //Derive ECC Key Pair using CDI in Key Vault Slot6 and store the generated private key in KeySlot7
    hmac_io key_seed = {
        .kv_intf = 1,       // 从密钥库加载
        .kv_id = 6,         // CDI 在 Slot 6
        .data = {0}
    };

    hmac_io block_seed = {
        .kv_intf = 0       // 加载标签数据
    };
    memcpy(block_seed.data, "idevid_keygen", sizeof("idevid_keygen"));
    
    printf("block_seed.data:\n");
    for(int j = 0; j < 32; j++) {
        printf("0x%08x ", (unsigned int)block_seed.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    hmac_io tag_seed = {
        .kv_intf = 1,       // 写入密钥库
        .kv_id = 3,         // 存储到 Slot 3
        .data = {0}         //
    };

    //Call HMAC to generate ECC seeds
    hmac_flow(key_seed, block_seed, lfsr_seed_cdi, tag_seed);
    printf("ECC seed derived and stored in KeySlot3.\n");

    //Call the ecc_keygen_flow generate pubkey and privkey
    ecc_io seed = {
        .kv_intf = 1,       // 从密钥库加载
        .kv_id = 3,         // seed在 Slot 3
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

    ecc_io idevid_privkey = {
        .kv_intf = 1,       // 写入密钥库
        .kv_id = 7,         // idevid_privkey存储到 Slot 7
        .data = {0}
    };

    ecc_io pubkey_x = {
        .kv_intf = 1,       // 直接返回pubkey_x,不校验
        .data = {0}
    };

    ecc_io pubkey_y = {
        .kv_intf = 1,       // 直接返回pubkey_y,不校验
        .data = {0}
    };

    ecc_keygen_flow(&seed, &nonce, &iv, &idevid_privkey, &pubkey_x, &pubkey_y);
    printf("ECC key pair generated: Private in Slot7, Public returned.\n");

    printf("pubkey_x.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)pubkey_x.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    printf("pubkey_y.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)pubkey_y.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    //kv_clear(KvSlot3)
    lsu_write_32(CLP_KV_REG_KEY_CTRL_3, KV_REG_KEY_CTRL_3_CLEAR_MASK);
    while ((lsu_read_32(CLP_KV_REG_KEY_CTRL_3) & KV_REG_KEY_CTRL_3_CLEAR_MASK) != 0);
    printf("Temporary seed cleared in KeySlot3.\n");

    //Generate the To Be Signed DER Blob of the IDevId CSR
    status = generate_intermediate_tbs_der(pubkey_x.data, pubkey_y.data, "Caliptra 1.0 IDevID", "Caliptra 1.0 IDevID", tbs_der, &tbs_len, CERT_TYPE_ROOT_CA);
    if(!status && tbs_len <= 2048) {
        printf("cert_len = 0x%x\n", tbs_len);
        printf("IdeVID tbs der:\n");
        for(int j = 0; j < tbs_len; j++) {
           printf("%s%X", (tbs_der[j] < 0x10) ? "0" : "", tbs_der[j]); 
        }
        printf("\n");
    } else {
        printf("generate IdeVID cert der faild!\n");
        while(1);
    }

    tbs_der_store[0].der_len = tbs_len;
    tbs_der_store[0].type = CERT_TYPE_ROOT_CA;
    memcpy(tbs_der_store[0].der_data, tbs_der, tbs_len);

    //Sign the IDevID To Be Signed DER Blob with IDevId Private Key in Key Vault Slot 7
    sha384_digest(tbs_der, tbs_len, (uint64_t*)digest, true);

    ecc_io msg = {0};
    for (int i=0; i<6; i++) {
        uint64_t chunk;
        memcpy(&chunk, digest+i*8, 8);
        chunk = swap_64bit(chunk);
        memcpy(msg.data+i*2, &chunk, 8);
    }

    printf("der_csr.digest:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)msg.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    ecc_io sign_r = {
        .kv_intf = 1,       // 直接返回sign_r,不校验
        .data = {0}
    };

    ecc_io sign_s = {
        .kv_intf = 1,       // 直接返回sign_s,不校验
        .data = {0}
    };

    ecc_signing_flow(&idevid_privkey, &msg, &iv, &sign_r, &sign_s);

    printf("Signature R:\n");
    for (int i = 0; i < 12; i++) {
        printf("%08x ", (unsigned int)sign_r.data[i]);
    }
    printf("\nSignature S:\n");
    for (int i = 0; i < 12; i++) {
        printf("%08x ", (unsigned int)sign_s.data[i]);
    }
    printf("\n");

    //Verify the signature of IDevID To Be Signed Blob
    status = ecc_verifying_flow(msg, pubkey_x, pubkey_y, sign_r, sign_s);
    if(!status) {
        printf("Signature verification successful!\n");
    } else {
        printf("Signature verification failed!\n");
        while(1);
    }
    //Store and lock (for write) the IDevID pubkey in the sticky Data Vault (48 bytes) Slot 8 & Slot 9
    store_to_datavault(pubkey_x.data, pubkey_y.data, 8, 9);

    //Generate root ca（Local registration or external registration）

    status = add_signature_to_cert(tbs_der, tbs_len, sign_r.data, sign_s.data, cert_der, &cert_len);
    if(!status && cert_len <= 4096) {
        printf("cert_len = 0x%x\n", cert_len);
        printf("IdeVID cert:\n");
        for(int j = 0; j < cert_len; j++) {
            printf("%s%X", (cert_der[j] < 0x10) ? "0" : "", cert_der[j]); 
        }
        printf("\n");
    } else {
        printf("generate IdeVID cert der faild!\n");
        while(1);
    }
    cert_store[0].der_len = cert_len;
    cert_store[0].type = CERT_TYPE_ROOT_CA;
    memcpy(cert_store[0].der_data, cert_der, cert_len);
}

void init_doe() {
    uint8_t offset;
    volatile uint32_t* reg_ptr;
    uint32_t iv_data_uds[] = {0x2eb94297,
                              0x77285196,
                              0x3dd39a1e,
                              0xb95d438f};
    uint32_t iv_data_fe[] = {0x14451624,
                             0x6a752c32,
                             0x9056d884,
                             0xdaf3c89d};

    // Write IV for UDS
    reg_ptr = (uint32_t*) CLP_DOE_REG_DOE_IV_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_DOE_REG_DOE_IV_3) {
        *reg_ptr++ = iv_data_uds[offset++];
    }

    //start UDS and store in KV0
    lsu_write_32(CLP_DOE_REG_DOE_CTRL, DOE_UDS);

    // Check that UDS flow is done
    while((lsu_read_32(CLP_DOE_REG_DOE_STATUS) & DOE_REG_DOE_STATUS_VALID_MASK) == 0);

    // Write IV for Field Entropy
    reg_ptr = (uint32_t*) CLP_DOE_REG_DOE_IV_0;
    offset = 0;
    while (reg_ptr <= (uint32_t*) CLP_DOE_REG_DOE_IV_3) {
        *reg_ptr++ = iv_data_fe[offset++];
    }

    //Start FE and store in KV1
    lsu_write_32(CLP_DOE_REG_DOE_CTRL, DOE_FE | (0x1 << DOE_REG_DOE_CTRL_DEST_LOW));

    // Check that FE flow is done
    while((lsu_read_32(CLP_DOE_REG_DOE_STATUS) & DOE_REG_DOE_STATUS_VALID_MASK) == 0);

    // Clear Secrets
    lsu_write_32(CLP_DOE_REG_DOE_CTRL, DOE_CLEAR_OBF_SECRETS);

}

void main() {
    uint32_t init_ok = 0;
    uint8_t status;
    uint8_t recv_data[BUFFER_SIZE];
    //uint8_t test_data[129];

    //memset(test_data, 0x5a, 129);
    init_uart();
    init_qspi();

    printf("------------------------------------\n");
    printf("            Caliptra ROM...         \n");
    printf("------------------------------------\n");
    printf("Compiled on: %s at %s\n", __DATE__, __TIME__);

    init_doe();
    
    idevid();
    
    ldevid();

    if(init_sd_card() == 0) {
        printf("FMC firmwaire:\n");
        for(int i = 0; i < FMC_SIZE/BUFFER_SIZE; i++) {
            memset(recv_data, 0xFF, BUFFER_SIZE);
            status = read_sd_card(FMC_STORE_SECTOR_OFFSET+i, recv_data, 0, 0);
            if(i == 0) {
                printf("%d:\n", i);
                for(int j = 0; j < BUFFER_SIZE; j++) {
                    printf("0x%02x ", recv_data[j]);
                    if (j % 16 == 15) {
                        printf("\n");
                    }
                }
            }
            memcpy(FMC_data + i * BUFFER_SIZE, recv_data, BUFFER_SIZE);
        }
        printf("\n");
        if(!status) {
            printf("Measure FMC start:\n");
            status = measure_fmc(FMC_data, FMC_SIZE);
            if(!status) {
                memcpy_fw_to_iccm(FMC_data, (void *)RV_ICCM_SADR, FMC_SIZE);
                init_ok = 1;
            }
        }
        printf("SOC firmwaire:\n");
        for(int i = 0; i < SOC_FW_SIZE/BUFFER_SIZE; i++) {
            memset(recv_data, 0xFF, BUFFER_SIZE);
            status = read_sd_card(SOC_FW_STORE_SECTOR_OFFSET+i, recv_data, 0, 0);
                printf("%d:\n", i);
                for(int j = 0; j < BUFFER_SIZE; j++) {
                    printf("0x%02x ", recv_data[j]);
                    if (j % 16 == 15) {
                        printf("\n");
                    }
                }

            memcpy(SOC_FW_data + i * BUFFER_SIZE, recv_data, BUFFER_SIZE);
        }
        printf("\n");
        if(!status) {
            printf("Measure SOC start:\n");
            status = measure_soc(SOC_FW_data, SOC_FW_SIZE);
            if(!status) {
                mailbox_send_data((uint32_t *)SOC_FW_data, SOC_FW_SIZE);
                init_ok = 1;
            }
        }
    }

    if (init_ok) {
        printf("Jump to FMC...\n");
        void (* fmc_entry) (void) = (void*) (RV_ICCM_SADR);
        fmc_entry();
        //asm volatile("li a0, 0x40000000; jr a0");
    } 
    else {
        printf("FMC firmwaire2:\n");
        for(int i = 0; i < FMC_SIZE/BUFFER_SIZE; i++) {
            memset(recv_data, 0xFF, BUFFER_SIZE);
            status = read_sd_card(FMC_STORE_SECTOR_OFFSET+i, recv_data, 0, 0);
            if(i == 0) {
                printf("%d:\n", i);
                for(int j = 0; j < BUFFER_SIZE; j++) {
                    printf("0x%02x ", recv_data[j]);
                    if (j % 16 == 15) {
                        printf("\n");
                    }
                }
            }
            memcpy(FMC_data + i * BUFFER_SIZE, recv_data, BUFFER_SIZE);
        }
        printf("\n");
        if(!status) {
            printf("Measure FMC start2:\n");
            status = measure_fmc(FMC_data, FMC_SIZE);
            if(!status) {
                memcpy_fw_to_iccm(FMC_data, (void *)RV_ICCM_SADR, FMC_SIZE);
                init_ok = 1;
            }
        }

        printf("SOC firmwaire2:\n");
        for(int i = 0; i < SOC_FW_SIZE/BUFFER_SIZE; i++) {
            memset(recv_data, 0xFF, BUFFER_SIZE);
            status = read_sd_card(SOC_FW_STORE_SECTOR_OFFSET+i, recv_data, 0, 0);
            if(i == 0) {
                printf("%d:\n", i);
                for(int j = 0; j < BUFFER_SIZE; j++) {
                    printf("0x%02x ", recv_data[j]);
                    if (j % 16 == 15) {
                        printf("\n");
                    }
                }
            }
            memcpy(SOC_FW_data + i * BUFFER_SIZE, recv_data, BUFFER_SIZE);
        }
        printf("\n");
        if(!status) {
            printf("Measure SOC start2:\n");
            status = measure_soc(SOC_FW_data, SOC_FW_SIZE);
            if(!status) {
                mailbox_send_data((uint32_t *)SOC_FW_data, SOC_FW_SIZE);
                init_ok = 1;
            }
        }
        if (init_ok) {
            printf("Jump to FMC...\n");
            void (* fmc_entry) (void) = (void*) (RV_ICCM_SADR);
            fmc_entry();
            //asm volatile("li a0, 0x40000000; jr a0");
        } 
    }

    printf("------------------------------------\n");
    printf(" Reached end of ROM FW unexpectedly!\n");
    printf("------------------------------------\n");
    while(1);
}



/* void main() {
    mbox_op_s op;
    int num_randoms = 32;
    uint8_t randoms[num_randoms];

    init_uart();
    enable_csrng();

    printf("------------------------------------\n");
    printf("            Caliptra ROM...         \n");
    printf("------------------------------------\n");
    printf("Compiled on: %s at %s\n", __DATE__, __TIME__);


    printf("---------------------------\n");
    printf(" TRNG Smoke Test \n");
    printf("---------------------------\n");


    while(1) {
        op = soc_ifc_read_mbox_cmd();
        if (op.cmd & MBOX_CMD_FIELD_RESP_MASK) {
            printf("Received mailbox command (expecting RESP) from SOC! Got 0x%x\n", op.cmd);
            if (op.cmd == MBOX_CMD_GET_TRNG) {
                if (generate_random_numbers(num_randoms, randoms) == 0) {
                    printf("Get randoms:\n");
                    for (int i = 0; i < num_randoms; i++) {
                        printf("%02x ", randoms[i]);
                    }
                    mailbox_send_data((uint32_t *)randoms, num_randoms);
                }
            }
        }
    }



    printf("\n");
    printf("------------------------------------\n");
    printf(" Reached end of ROM FW unexpectedly!\n");
    printf("------------------------------------\n");
    while(1);
} */
