#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "caliptra_reg.h"
#include "caliptra_isr.h"
#include "riscv_hw_if.h"
#include "veer-csr.h"
#include "soc_ifc.h"
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
#include "soc_ifc.h"
#include "mailbox.h"

uint8_t rt_sign_r[48];
uint8_t rt_sign_s[48];

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

#define CLEAR_INTR_FLAG_SAFELY(flag, mask) \
    csr_clr_bits_mstatus(MSTATUS_MIE_BIT_MASK); \
    flag &= mask; \
    csr_set_bits_mstatus(MSTATUS_MIE_BIT_MASK);

void nmi_handler();
void caliptra_rt();

uint32_t verify_certificate_chain() {
    uint32_t status = 0;
    uint8_t digest[48]; // SHA-384 摘要
    ecc_io pubkey_x = {0}, pubkey_y = {0};
    ecc_io sign_r = {0}, sign_s = {0};
    ecc_io msg = {0};
    printf("Start certificate chain verification:\n");

    //Verify RT
    sha384_digest(tbs_der_store[3].der_data, tbs_der_store[3].der_len, (uint64_t*)digest, false);
    for (int i=0; i<6; i++) {
        uint64_t chunk;
        memcpy(&chunk, digest+i*8, 8);
        chunk = swap_64bit(chunk);
        memcpy(msg.data+i*2, &chunk, 8);
    }
    memcpy(sign_r.data, rt_sign_r, 48);
    memcpy(sign_s.data, rt_sign_s, 48);
    read_from_datavault(pubkey_x.data, pubkey_y.data, 6, 7);
    status = ecc_verifying_flow(msg, pubkey_x, pubkey_y, sign_r, sign_s);
    if(status != 0) {
        printf("RT cert verification failed!\n");
        return -1;
    }
    printf("RT Certificate verification successful!\n\n");

    //Verify FMC
    sha384_digest(tbs_der_store[2].der_data, tbs_der_store[2].der_len, (uint64_t*)digest, false);
    for (int i=0; i<6; i++) {
        uint64_t chunk;
        memcpy(&chunk, digest+i*8, 8);
        chunk = swap_64bit(chunk);
        memcpy(msg.data+i*2, &chunk, 8);
    }
    read_from_datavault(sign_r.data, sign_s.data, 4, 5);
    read_from_datavault(pubkey_x.data, pubkey_y.data, 2, 3);
    status = ecc_verifying_flow(msg, pubkey_x, pubkey_y, sign_r, sign_s);
    if(status != 0) {
        printf("FMC cert verification failed!\n");
        return -1;
    }
    printf("FMC Certificate verification successful!\n\n");

    //Verify LDEVID
    sha384_digest(tbs_der_store[1].der_data, tbs_der_store[1].der_len, (uint64_t*)digest, false);
    for (int i=0; i<6; i++) {
        uint64_t chunk;
        memcpy(&chunk, digest+i*8, 8);
        chunk = swap_64bit(chunk);
        memcpy(msg.data+i*2, &chunk, 8);
    }
    read_from_datavault(sign_r.data, sign_s.data, 0, 1);
    read_from_datavault(pubkey_x.data, pubkey_y.data, 8, 9);
    status = ecc_verifying_flow(msg, pubkey_x, pubkey_y, sign_r, sign_s);
    if(status != 0) {
        printf("LDEVID cert verification failed!\n");
        return -1;
    }
    printf("LDEVID Certificate verification successful!\n\n");

    return 0;
}

void alias_rt() {
    uint32_t status = 0;
    uint8_t digest[48];
    uint8_t tbs_der[2048] = {0};
    size_t tbs_len = sizeof(tbs_der);
    uint8_t cert_der[4096] = {0};
    size_t cert_len = sizeof(cert_der);
    uint32_t RT_expected_digest[16] =   {0x62A46400,
                                        0x51BBE2E9,
                                        0xC7644715,
                                        0xA33B64B8,
                                        0xA1B2B8C4,
                                        0x9508C8C1,
                                        0x696BF619,
                                        0xE55B7A72,
                                        0xD0DE812A,
                                        0x89C7D9F2,
                                        0xD1BF8162,
                                        0xA66A4244,
                                        0x54550672,
                                        0x6871232D,
                                        0x1E6E29D5,
                                        0x9DA5160A};

    //Derive CDI using LDevID CDI (Slot6) and rt measure value (pcr1)
    hmac_io key_cdi_label = {
        .kv_intf = 1,       // 从密钥库加载
        .kv_id = 6,         // FMC CDI 在 Slot6
        .data = {0}
    };

    hmac_io block_cdi_label = {
        .kv_intf = 0
    };
    memcpy(block_cdi_label.data, "runtime_alias_cdi", sizeof("runtime_alias_cdi"));

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
    printf("CDI diversified with label 'runtime_alias_cdi'.\n");

    hmac_io key_cdi_pcr = {
        .kv_intf = 1,        // 从密钥库加载
        .kv_id = 6,          // 第一次 HMAC 的结果
        .data = {0}          // 无直接数据
    };

    hmac_io block_cdi_pcr = {
        .data = {0}
    };
    memcpy(block_cdi_pcr.data, RT_expected_digest, 48);

    hmac_flow(key_cdi_pcr, block_cdi_pcr, lfsr_seed_default, tag_cdi_label);
    printf("RT measure value with from pcr1.\n");
    printf("Alias RT CDI derived and stored in KeySlot6.\n");

    //Derive ECC Key Pair using CDI in Slot 6
    hmac_io key_seed = {
        .kv_intf = 1,       // 从密钥库加载
        .kv_id = 6,         // CDI 在 Slot 6
        .data = {0}
    };

    hmac_io block_seed = {
        .kv_intf = 0       // 加载标签数据
    };
    memcpy(block_seed.data, "runtime_alias_keygen", sizeof("runtime_alias_keygen"));
    
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

    ecc_io alisart_privkey = {
        .kv_intf = 1,       // 写入密钥库
        .kv_id = 9,         // rt_privkey存储到 Slot 9
        .data = {0}
    };

    ecc_io alisart_pubkey_x = {
        .kv_intf = 1,       // 直接返回pubkey_x,不校验
        .data = {0}
    };

    ecc_io alisart_pubkey_y = {
        .kv_intf = 1,       // 直接返回pubkey_y,不校验
        .data = {0}
    };

    ecc_keygen_flow(&seed, &nonce, &iv, &alisart_privkey, &alisart_pubkey_x, &alisart_pubkey_y);
    printf("ECC key pair generated: Private in keySlot7, Public returned.\n");
    printf("alisart_pubkey_x.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)alisart_pubkey_x.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    printf("alisart_pubkey_y.data:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)alisart_pubkey_y.data[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    //kv_clear(KvSlot3)
    lsu_write_32(CLP_KV_REG_KEY_CTRL_3, KV_REG_KEY_CTRL_3_CLEAR_MASK);
    while ((lsu_read_32(CLP_KV_REG_KEY_CTRL_3) & KV_REG_KEY_CTRL_3_CLEAR_MASK) != 0);
    printf("Temporary seed cleared in KeySlot3.\n");

    //Generate the To Be Signed DER Blob of the Alias RT Certificate
    status = generate_intermediate_tbs_der(alisart_pubkey_x.data, alisart_pubkey_y.data, "Caliptra 1.0 FMC Alias", "Caliptra 1.0 Rt Alias", tbs_der, &tbs_len, CERT_TYPE_RT);
    if(!status && tbs_len <= 2048) {
        printf("cert_len = 0x%x\n", tbs_len);
        printf("AliasRT tbs der:\n");
        for(int j = 0; j < tbs_len; j++) {
            printf("%02x", tbs_der[j]);
        }
        printf("\n");
    } else {
        printf("generate AliasRT tbs der faild!\n");
        while(1);
    }

    tbs_der_store[3].der_len = tbs_len;
    tbs_der_store[3].type = CERT_TYPE_RT;
    memcpy(tbs_der_store[3].der_data, tbs_der, tbs_len);

    //Sign the Alias RT To Be Signed DER Blob with alisafmc Private Key in Key Vault Slot 7
    sha384_digest(tbs_der, tbs_len, (uint64_t *)digest, true);

    ecc_io msg = {0};
    for (int i=0; i<6; i++) {
        uint64_t chunk;
        memcpy(&chunk, digest+i*8, 8);
        chunk = swap_64bit(chunk);
        memcpy(msg.data+i*2, &chunk, 8);
    }

    ecc_io alisafmc_privkey = {
        .kv_intf = 1,       // 密钥库
        .kv_id = 7,         // alisafmc_privkey Slot 7
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

    ecc_signing_flow(&alisafmc_privkey, &msg, &iv, &sign_r, &sign_s);

    printf("Signature R:\n");
    for (int i = 0; i < 12; i++) {
        printf("%08x", (unsigned int)sign_r.data[i]);
    }
    printf("\nSignature S:\n");
    for (int i = 0; i < 12; i++) {
        printf("%08x", (unsigned int)sign_s.data[i]);
    }
    printf("\n");

    memcpy(rt_sign_r, sign_r.data, 48);
    memcpy(rt_sign_s, sign_s.data, 48);

    //Clear the alisa RT Private Key in Key Vault Slot 7
    lsu_write_32(CLP_KV_REG_KEY_CTRL_7, KV_REG_KEY_CTRL_7_CLEAR_MASK);
    while ((lsu_read_32(CLP_KV_REG_KEY_CTRL_7) & KV_REG_KEY_CTRL_7_CLEAR_MASK) != 0);
    printf("Temporary seed cleared in KeySlot5.\n");

    //Verify the signature of Alias RT To Be Signed Blob
    ecc_io alisafmc_pubkey_x = {
        .data = {0}
    };

    ecc_io alisafmc_pubkey_y = {
        .data = {0}
    };

    read_from_datavault(alisafmc_pubkey_x.data, alisafmc_pubkey_y.data, 6, 7);
    status = ecc_verifying_flow(msg, alisafmc_pubkey_x, alisafmc_pubkey_y, sign_r, sign_s);
    if(!status) {
        printf("Signature verification successful!\n");
    } else {
        printf("Signature verification failed!\n");
        while(1);
    }
    ecc_zeroize();
    //Write the signature into the certificate
    status = add_signature_to_cert(tbs_der, tbs_len, sign_r.data, sign_s.data, cert_der, &cert_len);
    if(!status && cert_len <= 4096) {
        printf("cert_len = 0x%x\n", cert_len);
        printf("AliasRT cert:\n");
        for(int j = 0; j < cert_len; j++) {
            printf("%s%X", (cert_der[j] < 0x10) ? "0" : "", cert_der[j]); 
        }
        printf("\n");
    } else {
        printf("generate AliasRT cert der faild!\n");
        while(1);
    }
    cert_store[3].der_len = cert_len;
    cert_store[3].type = CERT_TYPE_RT;
    memcpy(cert_store[3].der_data, cert_der, cert_len);
}

/* --------------- Function Definitions --------------- */
void nmi_handler() {
    mbox_op_s op;
    //Confirm this was the expected
    if ((csr_read_mcause() & MCAUSE_NMI_CODE_DBUS_LOAD_VALUE) == MCAUSE_NMI_CODE_DBUS_LOAD_VALUE) {
        csr_write_mcause(0x0);
        csr_write_mdeau(0x0);
        //mailbox command should be OOB ACCESS
        op = soc_ifc_read_mbox_cmd();
        if (op.cmd == MBOX_CMD_OOB_ACCESS) {
            //Recovering from expected NMI
            soc_ifc_set_mbox_status_field(CMD_FAILURE);
            caliptra_rt();
        }
        else {
            printf("Unexpected NMI\n");
        }
    }
    else {
        printf("In NMI handler\n");
        if (lsu_read_32(CLP_SOC_IFC_REG_CPTRA_HW_ERROR_FATAL) & SOC_IFC_REG_CPTRA_HW_ERROR_FATAL_NMI_PIN_MASK)
            printf("Saw hw_error_fatal.nmi_pin assertion\n");
        while(1);
    }
}

void caliptra_rt() {
    mbox_op_s op;
    uint32_t reg_addr;
    uint32_t read_data;
    uint32_t loop_iter;
    uint32_t temp;
    uint32_t *status;
    uint32_t value;
    printf("------------------------------------\n");
    printf("            Caliptra RT!!           \n");
    printf("------------------------------------\n");
    printf("Compiled on: %s at %s\n", __DATE__, __TIME__);
    delay_second(1);
    alias_rt();
    printf("------------------------------------\n");
    printf("            Caliptra RT(DPE)!!      \n");
    printf("------------------------------------\n");
    printf("Compiled on: %s at %s\n", __DATE__, __TIME__);
    while(1) {
                //read the mbox command
                op = soc_ifc_read_mbox_cmd();
                if (op.cmd & MBOX_CMD_FIELD_FW_MASK) {
                    printf("Received mailbox firmware command from SOC! Got 0x%x\n", op.cmd);
                    if (op.cmd & MBOX_CMD_FIELD_RESP_MASK) {
                        printf("Mailbox firmware command unexpectedly has response expected field set!\n");
                    }
                    printf("Triggering FW update reset\n");
                    //Trigger firmware update reset, new fw will get copied over from ROM
                    soc_ifc_set_fw_update_reset((uint8_t) (rand() & 0xFF));
                }
                else if (op.cmd & MBOX_CMD_FIELD_RESP_MASK) {
                    printf("Received mailbox command (expecting RESP) from SOC! Got 0x%x\n", op.cmd);
                    if (op.cmd == MBOX_CMD_REG_ACCESS) {
                        for (loop_iter = 0; loop_iter<op.dlen; loop_iter+=4) {
                            reg_addr = soc_ifc_mbox_read_dataout_single();
                            printf("Reading reg addr 0x%lx from mailbox req\n", reg_addr);
                            read_data = lsu_read_32((uintptr_t) reg_addr);
                            lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DATAIN), read_data);
                        }
                        lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DLEN), op.dlen);
                    }
                    else if (op.cmd == MBOX_CMD_OOB_ACCESS) {
                        //set the ERROR FATAL register to indicate the expected error
                        lsu_write_32((uintptr_t) CLP_SOC_IFC_REG_CPTRA_FW_ERROR_FATAL, 0xF0000001);
                        //just read one address, it's going to trigger NMI by going OOB
                        reg_addr = soc_ifc_mbox_read_dataout_single();
                        printf("Reading reg addr 0x%lx from mailbox req\n", reg_addr);
                        read_data = lsu_read_32((uintptr_t) reg_addr);
                        printf("Received MBOX_CMD_OOB_ACCESS but didn't trigger NMI\n");
                         
                    }
                    else if ((op.cmd == MBOX_CMD_SHA384_REQ) | (op.cmd == MBOX_CMD_SHA512_REQ)) {
                        enum sha_accel_mode_e mode;
                        mode = (op.cmd == MBOX_CMD_SHA384_REQ) ? SHA_MBOX_384 : SHA_MBOX_512;
                        //First dword contains the start address
                        temp = soc_ifc_mbox_read_dataout_single();
                        //ignore the bytes used for start address
                        op.dlen = op.dlen - 4;
                        //Copy the KAT to the start address using direct access
                        for (loop_iter = 0; loop_iter<op.dlen; loop_iter+=4) {
                            read_data = soc_ifc_mbox_read_dataout_single();
                            soc_ifc_mbox_dir_write_single(temp+loop_iter, read_data);
                        }
                        //Acquire SHA Accel lock
                        soc_ifc_sha_accel_acquire_lock();
                        soc_ifc_sha_accel_wr_mode(mode);
                        //write start addr in bytes
                        lsu_write_32((uintptr_t) (CLP_SHA512_ACC_CSR_START_ADDRESS), temp);
                        //write dlen in bytes
                        lsu_write_32((uintptr_t) (CLP_SHA512_ACC_CSR_DLEN), op.dlen);
                        soc_ifc_sha_accel_execute();
                        soc_ifc_sha_accel_poll_status();
                        lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DLEN), (mode == SHA_MBOX_384) ? 48 : 64);
                        //read the digest and write it back to the mailbox
                        reg_addr = CLP_SHA512_ACC_CSR_DIGEST_0;
                        while (reg_addr <= ((mode == SHA_MBOX_384) ? CLP_SHA512_ACC_CSR_DIGEST_11 : CLP_SHA512_ACC_CSR_DIGEST_15)) {
                            read_data = lsu_read_32(reg_addr);
                            lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DATAIN), read_data);
                            reg_addr = reg_addr + 4;
                        }
                        soc_ifc_sha_accel_clr_lock();
                    }
                    else if ((op.cmd == MBOX_CMD_SHA384_STREAM_REQ) | (op.cmd == MBOX_CMD_SHA512_STREAM_REQ)) {
                        enum sha_accel_mode_e mode;
                        mode = (op.cmd == MBOX_CMD_SHA384_STREAM_REQ) ? SHA_STREAM_384 : SHA_STREAM_512;
                        //First dword contains the start address
                        temp = soc_ifc_mbox_read_dataout_single();
                        //ignore the bytes used for start address
                        op.dlen = op.dlen - 4;
                        //Acquire SHA Accel lock
                        soc_ifc_sha_accel_acquire_lock();
                        soc_ifc_sha_accel_wr_mode(mode);
                        //write dlen in bytes
                        lsu_write_32((uintptr_t) (CLP_SHA512_ACC_CSR_DLEN), op.dlen);
                        //Stream the KAT to the sha accelerator
                        for (loop_iter = 0; loop_iter<op.dlen; loop_iter+=4) {
                            read_data = soc_ifc_mbox_read_dataout_single();
                            lsu_write_32((uintptr_t) (CLP_SHA512_ACC_CSR_DATAIN), read_data);
                        }
                        soc_ifc_sha_accel_execute();
                        soc_ifc_sha_accel_poll_status();
                        lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DLEN), (mode == SHA_MBOX_384) ? 48 : 64);
                        //read the digest and write it back to the mailbox
                        reg_addr = CLP_SHA512_ACC_CSR_DIGEST_0;
                        while (reg_addr <= ((mode == SHA_MBOX_384) ? CLP_SHA512_ACC_CSR_DIGEST_11 : CLP_SHA512_ACC_CSR_DIGEST_15)) {
                            read_data = lsu_read_32(reg_addr);
                            lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DATAIN), read_data);
                            reg_addr = reg_addr + 4;
                        }
                        soc_ifc_sha_accel_clr_lock();
                    }
                    else if (op.cmd == MBOX_CMD_VERIFY_CERT) {
                        printf("Received verify certificate chain command\n");
                        int result = verify_certificate_chain();
                        if (result == 0) {
                            printf("Certificate chain verification succeeded!\n");
                            value = MBOX_SUCCESS;
                            status = &value;
                            mailbox_send_data(status, 0x4);
                        } else {
                            printf("Certificate chain verification failed!\n");
                            value = MBOX_FAILED;
                            status = &value;
                            mailbox_send_data(status, 0x4);
                        }
                    }
                    else if (op.cmd == MBOX_CMD_GET_CA_CERT) {
                        printf("Obtain CA certificate command\n");
                        printf("cert_len = 0x%x\n", cert_store[0].der_len);
                        printf("CA cert:\n");
                        for(int j = 0; j < cert_store[0].der_len; j++) {
                            printf("%s%X", (cert_store[0].der_data[j] < 0x10) ? "0" : "", cert_store[0].der_data[j]); 
                        }
                        printf("\n");
                        mailbox_send_data((uint32_t *)cert_store[0].der_data, cert_store[0].der_len);
                    }
                    else if (op.cmd == MBOX_CMD_GET_LDEVID_CERT) {
                        printf("Obtain LDevID certificate command\n");
                        printf("cert_len = 0x%x\n", cert_store[1].der_len);
                        printf("LDevID cert:\n");
                        for(int j = 0; j < cert_store[1].der_len; j++) {
                            printf("%s%X", (cert_store[1].der_data[j] < 0x10) ? "0" : "", cert_store[1].der_data[j]); 
                        }
                        printf("\n");
                        mailbox_send_data((uint32_t *)cert_store[1].der_data, cert_store[1].der_len);
                    }
                    else if (op.cmd == MBOX_CMD_GET_FMC_CERT) {
                        printf("Obtain FMC certificate command\n");
                        printf("cert_len = 0x%x\n", cert_store[2].der_len);
                        printf("FMC cert:\n");
                        for(int j = 0; j < cert_store[2].der_len; j++) {
                            printf("%s%X", (cert_store[2].der_data[j] < 0x10) ? "0" : "", cert_store[2].der_data[j]); 
                        }
                        printf("\n");
                        mailbox_send_data((uint32_t *)cert_store[2].der_data, cert_store[2].der_len);
                    }
                    else if (op.cmd == MBOX_CMD_GET_RT_CERT) {
                        printf("Obtain RT certificate command\n");
                        printf("cert_len = 0x%x\n", cert_store[3].der_len);
                        printf("RT cert:\n");
                        for(int j = 0; j < cert_store[3].der_len; j++) {
                            printf("%s%X", (cert_store[3].der_data[j] < 0x10) ? "0" : "", cert_store[3].der_data[j]); 
                        }
                        printf("\n");
                        mailbox_send_data((uint32_t *)cert_store[3].der_data, cert_store[3].der_len);
                    }
                    else if (op.cmd == MBOX_CMD_GET_SOC_MEASURE_VALUE) {
                        printf("Obtain get SOC measure value command\n");
                        printf("SOC measure value:\n");
                        for(int j = 0; j < 16; j++) {
                            printf("%08x", (unsigned int)SOC_expected_digest[j]); 
                        }
                        printf("\n");
                        mailbox_send_data(SOC_expected_digest, 64);
                    }
                    else if (op.cmd == MBOX_CMD_GET_FMC_MEASURE_VALUE) {
                        printf("Obtain get FMC measure value command\n");
                        printf("FMC measure value:\n");
                        for(int j = 0; j < 16; j++) {
                            printf("%08x", (unsigned int)FMC_expected_digest[j]); 
                        }
                        printf("\n");
                        mailbox_send_data(FMC_expected_digest, 64);
                    }
                    else if (op.cmd == MBOX_CMD_GET_RT_MEASURE_VALUE) {
                        printf("Obtain get RT measure value command\n");
                        printf("RT measure value:\n");
                        for(int j = 0; j < 16; j++) {
                            printf("%08x", (unsigned int)RT_expected_digest[j]); 
                        }
                        printf("\n");
                        mailbox_send_data(RT_expected_digest, 64);
                    }
                    else {
                        // Read provided data
                        read_data = soc_ifc_mbox_read_dataout_single();
                        temp      = soc_ifc_mbox_read_dataout_single(); // Capture resp dlen
                        for (loop_iter = 8; loop_iter<op.dlen; loop_iter+=4) {
                            read_data = soc_ifc_mbox_read_dataout_single();
                        }

                        // Set resp dlen
                        lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DLEN), temp);

                        // Write response data
                        // If we hit a double-bit ECC error already, skip this step
                        // (we might have gotten a huge resp dlen from the corrupted read)
                        // and fail the command
                        if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_MBOX_ECC_UNC_STS_MASK) {
                            printf("Skipping resp data wr on UNC ECC err\n");
                        } else {
                            for (loop_iter = 0; loop_iter<temp; loop_iter+=4) {
                                lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DATAIN), rand());
                            }
                        }

                    }
                }
    }

/* 
    //set NMI vector
    lsu_write_32((uintptr_t) (CLP_SOC_IFC_REG_INTERNAL_NMI_VECTOR), (uint32_t) (nmi_handler));

    // Runtime flow -- set ready for RT
    soc_ifc_set_flow_status_field(SOC_IFC_REG_CPTRA_FLOW_STATUS_READY_FOR_RUNTIME_MASK);

    // Initialization
    init_interrupts();
    lsu_write_32(CLP_SHA512_ACC_CSR_INTR_BLOCK_RF_NOTIF_INTR_EN_R, 0); // FIXME tmp workaround to UVM issue with predicting SHA accelerator interrupts

     */
#if 0
    while(1) {
        // Service received interrupts
        // Start with highest priority
        if (cptra_intr_rcv.soc_ifc_error   ) {
            printf("Intr received: soc_ifc_error\n");
            if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INTERNAL_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INTERNAL_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INV_DEV_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INV_DEV_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_CMD_FAIL_STS_MASK) {
                enum mbox_fsm_e state;
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_CMD_FAIL_STS_MASK)
                // If we entered the error state, we must use force-unlock to reset the mailbox state
                state = (lsu_read_32(CLP_MBOX_CSR_MBOX_STATUS) & MBOX_CSR_MBOX_STATUS_MBOX_FSM_PS_MASK) >> MBOX_CSR_MBOX_STATUS_MBOX_FSM_PS_LOW;
                if (state == MBOX_ERROR) {
                    // clr command interrupt to avoid attempted re-processing after force-unlock
                    if (cptra_intr_rcv.soc_ifc_notif & SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_AVAIL_STS_MASK) {
                        CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_notif, ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_AVAIL_STS_MASK)
                    }
                    lsu_write_32(CLP_MBOX_CSR_MBOX_UNLOCK, MBOX_CSR_MBOX_UNLOCK_UNLOCK_MASK);
                }
            }
            if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_BAD_FUSE_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_BAD_FUSE_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_ICCM_BLOCKED_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_ICCM_BLOCKED_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_MBOX_ECC_UNC_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_MBOX_ECC_UNC_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_WDT_TIMER1_TIMEOUT_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_WDT_TIMER1_TIMEOUT_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_WDT_TIMER2_TIMEOUT_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_WDT_TIMER2_TIMEOUT_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_error & (~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INTERNAL_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INV_DEV_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_CMD_FAIL_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_BAD_FUSE_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_ICCM_BLOCKED_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_MBOX_ECC_UNC_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_WDT_TIMER1_TIMEOUT_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_WDT_TIMER2_TIMEOUT_STS_MASK)) {
                printf("Intr received: unsupported soc_ifc_error (0x%lx)\n", cptra_intr_rcv.soc_ifc_error);
                 
                while(1);
            }
        }

        if (cptra_intr_rcv.doe_error       ) {
            printf("Intr received: doe_error\n");
        }

        if (cptra_intr_rcv.ecc_error       ) {
            printf("Intr received: ecc_error\n");
            if (cptra_intr_rcv.ecc_error & ECC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INTERNAL_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.ecc_error, ~ECC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INTERNAL_STS_MASK)
            }
            if (cptra_intr_rcv.ecc_error & ~ECC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INTERNAL_STS_MASK) {
                printf("Intr received: unsupported ecc_error (0x%lx)\n", cptra_intr_rcv.ecc_error);
                 
                while(1);
            }
        }

        if (cptra_intr_rcv.hmac_error      ) {
            printf("Intr received: hmac_error\n");
        }

        if (cptra_intr_rcv.kv_error        ) {
            printf("Intr received: kv_error\n");
        }

        if (cptra_intr_rcv.sha512_error    ) {
            printf("Intr received: sha512_error\n");
        }

        if (cptra_intr_rcv.sha256_error    ) {
            printf("Intr received: sha256_error\n");
        }

        if (cptra_intr_rcv.sha512_acc_error) {
            printf("Intr received: sha512_acc_error\n");
        }

        if (cptra_intr_rcv.qspi_error      ) {
            printf("Intr received: qspi_error\n");
        }

        if (cptra_intr_rcv.uart_error      ) {
            printf("Intr received: uart_error\n");
        }

        if (cptra_intr_rcv.i3c_error       ) {
            printf("Intr received: i3c_error\n");
        }

        if (cptra_intr_rcv.soc_ifc_notif   ) {
            uint8_t fsm_chk;
            printf("Intr received: soc_ifc_notif\n");
            if (cptra_intr_rcv.soc_ifc_notif & SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_AVAIL_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_notif, ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_AVAIL_STS_MASK)
                // Always check mbox FSM state at new command entry to detect
                // previously-handled error scenarios (FSM is IDLE) or new error
                // injection (FSM is in ERROR)
                fsm_chk = soc_ifc_chk_execute_uc();
                if (fsm_chk != 0) {
                    if (fsm_chk == 0xF) {
                        if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_CMD_FAIL_STS_MASK) {
                            CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_CMD_FAIL_STS_MASK)
                            printf("Clearing FW soc_ifc_error intr bit (cmd fail) prior to servicing\n");
                        } else {
                            printf("After finding an error requiring mailbox reset with force unlock, RT firmware has not received an soc_ifc_err_intr!\n");
                             
                            while(1);
                        }
                        lsu_write_32(CLP_MBOX_CSR_MBOX_UNLOCK, MBOX_CSR_MBOX_UNLOCK_UNLOCK_MASK);
                        // This oftens occurs alongside the cmd_fail bit in error injection tests...
                        if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INV_DEV_STS_MASK) {
                            CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INV_DEV_STS_MASK)
                            printf("Clearing FW soc_ifc_error intr bit (inv dev) after servicing\n");
                        }
                    }
                    continue;
                }
                // Clear any uncorrectable ECC error interrupts that may have held over from the previous operation
                // This can happen after the command flow is transferred back to SOC
                // if the ECC error occurred at address 0, since ending the flow triggers
                // rst_mbox_rdptr and a final read from 0. This might be missed by the above
                // soc_ifc_error handler.
                // There might also be vestigial cmd_fail/inv_dev failures held over from a previous
                // invalid reg_axs sequence... clear those too
                if (cptra_intr_rcv.soc_ifc_error & (SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_MBOX_ECC_UNC_STS_MASK |
                                                    SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_CMD_FAIL_STS_MASK |
                                                    SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INV_DEV_STS_MASK )) {
                    CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_MBOX_ECC_UNC_STS_MASK &
                                                                         ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_CMD_FAIL_STS_MASK &
                                                                         ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_INV_DEV_STS_MASK)
                    // Run the FSM check once more for late-arrival of errors
                    // that may correlate with the observed error interrupt
                    fsm_chk = soc_ifc_chk_execute_uc();
                    if (fsm_chk) {
                        if (fsm_chk == 0xF) {
                            lsu_write_32(CLP_MBOX_CSR_MBOX_UNLOCK, MBOX_CSR_MBOX_UNLOCK_UNLOCK_MASK);
                        }
                        continue;
                    }
                }
                // Any other errors that are flagged at this point are unexpected and should cause a test failure
                if (cptra_intr_rcv.soc_ifc_error) {
                    printf("Unexpected err intr 0x%lx\n", cptra_intr_rcv.soc_ifc_error);
                     
                    while(1);
                }
                //read the mbox command
                op = soc_ifc_read_mbox_cmd();
                if (op.cmd & MBOX_CMD_FIELD_FW_MASK) {
                    printf("Received mailbox firmware command from SOC! Got 0x%x\n", op.cmd);
                    if (op.cmd & MBOX_CMD_FIELD_RESP_MASK) {
                        printf("Mailbox firmware command unexpectedly has response expected field set!\n");
                    }
                    printf("Triggering FW update reset\n");
                    //Trigger firmware update reset, new fw will get copied over from ROM
                    soc_ifc_set_fw_update_reset((uint8_t) (rand() & 0xFF));
                }
                else if (op.cmd & MBOX_CMD_FIELD_RESP_MASK) {
                    printf("Received mailbox command (expecting RESP) from SOC! Got 0x%x\n", op.cmd);
                    if (op.cmd == MBOX_CMD_REG_ACCESS) {
                        for (loop_iter = 0; loop_iter<op.dlen; loop_iter+=4) {
                            reg_addr = soc_ifc_mbox_read_dataout_single();
                            printf("Reading reg addr 0x%lx from mailbox req\n", reg_addr);
                            read_data = lsu_read_32((uintptr_t) reg_addr);
                            lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DATAIN), read_data);
                        }
                        lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DLEN), op.dlen);
                    }
                    else if (op.cmd == MBOX_CMD_OOB_ACCESS) {
                        //set the ERROR FATAL register to indicate the expected error
                        lsu_write_32((uintptr_t) CLP_SOC_IFC_REG_CPTRA_FW_ERROR_FATAL, 0xF0000001);
                        //just read one address, it's going to trigger NMI by going OOB
                        reg_addr = soc_ifc_mbox_read_dataout_single();
                        printf("Reading reg addr 0x%lx from mailbox req\n", reg_addr);
                        read_data = lsu_read_32((uintptr_t) reg_addr);
                        printf("Received MBOX_CMD_OOB_ACCESS but didn't trigger NMI\n");
                         
                    }
                    else if ((op.cmd == MBOX_CMD_SHA384_REQ) | (op.cmd == MBOX_CMD_SHA512_REQ)) {
                        enum sha_accel_mode_e mode;
                        mode = (op.cmd == MBOX_CMD_SHA384_REQ) ? SHA_MBOX_384 : SHA_MBOX_512;
                        //First dword contains the start address
                        temp = soc_ifc_mbox_read_dataout_single();
                        //ignore the bytes used for start address
                        op.dlen = op.dlen - 4;
                        //Copy the KAT to the start address using direct access
                        for (loop_iter = 0; loop_iter<op.dlen; loop_iter+=4) {
                            read_data = soc_ifc_mbox_read_dataout_single();
                            soc_ifc_mbox_dir_write_single(temp+loop_iter, read_data);
                        }
                        //Acquire SHA Accel lock
                        soc_ifc_sha_accel_acquire_lock();
                        soc_ifc_sha_accel_wr_mode(mode);
                        //write start addr in bytes
                        lsu_write_32((uintptr_t) (CLP_SHA512_ACC_CSR_START_ADDRESS), temp);
                        //write dlen in bytes
                        lsu_write_32((uintptr_t) (CLP_SHA512_ACC_CSR_DLEN), op.dlen);
                        soc_ifc_sha_accel_execute();
                        soc_ifc_sha_accel_poll_status();
                        lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DLEN), (mode == SHA_MBOX_384) ? 48 : 64);
                        //read the digest and write it back to the mailbox
                        reg_addr = CLP_SHA512_ACC_CSR_DIGEST_0;
                        while (reg_addr <= ((mode == SHA_MBOX_384) ? CLP_SHA512_ACC_CSR_DIGEST_11 : CLP_SHA512_ACC_CSR_DIGEST_15)) {
                            read_data = lsu_read_32(reg_addr);
                            lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DATAIN), read_data);
                            reg_addr = reg_addr + 4;
                        }
                        soc_ifc_sha_accel_clr_lock();
                    }
                    else if ((op.cmd == MBOX_CMD_SHA384_STREAM_REQ) | (op.cmd == MBOX_CMD_SHA512_STREAM_REQ)) {
                        enum sha_accel_mode_e mode;
                        mode = (op.cmd == MBOX_CMD_SHA384_STREAM_REQ) ? SHA_STREAM_384 : SHA_STREAM_512;
                        //First dword contains the start address
                        temp = soc_ifc_mbox_read_dataout_single();
                        //ignore the bytes used for start address
                        op.dlen = op.dlen - 4;
                        //Acquire SHA Accel lock
                        soc_ifc_sha_accel_acquire_lock();
                        soc_ifc_sha_accel_wr_mode(mode);
                        //write dlen in bytes
                        lsu_write_32((uintptr_t) (CLP_SHA512_ACC_CSR_DLEN), op.dlen);
                        //Stream the KAT to the sha accelerator
                        for (loop_iter = 0; loop_iter<op.dlen; loop_iter+=4) {
                            read_data = soc_ifc_mbox_read_dataout_single();
                            lsu_write_32((uintptr_t) (CLP_SHA512_ACC_CSR_DATAIN), read_data);
                        }
                        soc_ifc_sha_accel_execute();
                        soc_ifc_sha_accel_poll_status();
                        lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DLEN), (mode == SHA_MBOX_384) ? 48 : 64);
                        //read the digest and write it back to the mailbox
                        reg_addr = CLP_SHA512_ACC_CSR_DIGEST_0;
                        while (reg_addr <= ((mode == SHA_MBOX_384) ? CLP_SHA512_ACC_CSR_DIGEST_11 : CLP_SHA512_ACC_CSR_DIGEST_15)) {
                            read_data = lsu_read_32(reg_addr);
                            lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DATAIN), read_data);
                            reg_addr = reg_addr + 4;
                        }
                        soc_ifc_sha_accel_clr_lock();
                    }
                    else if (op.cmd == MBOX_CMD_VERIFY_CERT) {
                        printf("Received verify certificate chain command\n");
                        int result = verify_certificate_chain();
                        if (result == 0) {
                            printf("Certificate chain verification succeeded!\n");
                            soc_ifc_set_mbox_status_field(CMD_COMPLETE);
                        } else {
                            printf("Certificate chain verification failed!\n");
                            soc_ifc_set_mbox_status_field(CMD_FAILURE);
                        }
                    }
                    else {
                        // Read provided data
                        read_data = soc_ifc_mbox_read_dataout_single();
                        temp      = soc_ifc_mbox_read_dataout_single(); // Capture resp dlen
                        for (loop_iter = 8; loop_iter<op.dlen; loop_iter+=4) {
                            read_data = soc_ifc_mbox_read_dataout_single();
                        }

                        // Set resp dlen
                        lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DLEN), temp);

                        // Write response data
                        // If we hit a double-bit ECC error already, skip this step
                        // (we might have gotten a huge resp dlen from the corrupted read)
                        // and fail the command
                        if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_MBOX_ECC_UNC_STS_MASK) {
                            printf("Skipping resp data wr on UNC ECC err\n");
                        } else {
                            for (loop_iter = 0; loop_iter<temp; loop_iter+=4) {
                                lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DATAIN), rand());
                            }
                        }

                    }

                    fsm_chk = soc_ifc_chk_execute_uc();
                    if (fsm_chk != 0) {
                        if (fsm_chk == 0xF) {
                            if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_CMD_FAIL_STS_MASK) {
                                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_CMD_FAIL_STS_MASK)
                                printf("Clearing FW soc_ifc_error intr bit (cmd fail) prior to servicing\n");
                            } else {
                                printf("After finding an error requiring mailbox reset with force unlock, RT firmware has not received an soc_ifc_err_intr!\n");
                                 
                                while(1);
                            }
                            lsu_write_32(CLP_MBOX_CSR_MBOX_UNLOCK, MBOX_CSR_MBOX_UNLOCK_UNLOCK_MASK);
                        }
                        continue;
                    }
                    if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_MBOX_ECC_UNC_STS_MASK) {
                        CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_MBOX_ECC_UNC_STS_MASK)
                        printf("Clearing FW soc_ifc_error intr bit (ECC unc) after servicing\n");
                        soc_ifc_set_mbox_status_field(CMD_FAILURE);
                    } else {
                        soc_ifc_set_mbox_status_field(DATA_READY);
                    }
                }
                else {
                    printf("Received mailbox command (no expected RESP) from SOC! Got 0x%x\n", op.cmd);
                    printf("Got command with DLEN 0x%lx\n", op.dlen);
                    //Command to exercise direct read path to mailbox
                    if (op.cmd == MBOX_CMD_DIR_RD) {
                        // Read provided data through direct path
                        for (loop_iter = 0; loop_iter<op.dlen; loop_iter+=4) {
                            read_data = soc_ifc_mbox_dir_read_single(loop_iter);
                        }
                    }
                    //For overrun command, read an extra dword
                    else {
                        if (op.cmd == MBOX_CMD_UC_OVERRUN) op.dlen = op.dlen + 4;
                        // Read provided data
                        for (loop_iter = 0; loop_iter<op.dlen; loop_iter+=4) {
                            read_data = soc_ifc_mbox_read_dataout_single();
                        }
                    }
                    lsu_write_32((uintptr_t) (CLP_MBOX_CSR_MBOX_DLEN), 0);
                    // Check for an error
                    fsm_chk = soc_ifc_chk_execute_uc();
                    if (fsm_chk != 0) {
                        if (fsm_chk == 0xF) {
                            if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_CMD_FAIL_STS_MASK) {
                                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_CMD_FAIL_STS_MASK)
                                printf("Clearing FW soc_ifc_error intr bit (cmd fail) prior to servicing\n");
                            } else {
                                printf("After finding an error requiring mailbox reset with force unlock, RT firmware has not received an soc_ifc_err_intr!\n");
                                 
                                while(1);
                            }
                            lsu_write_32(CLP_MBOX_CSR_MBOX_UNLOCK, MBOX_CSR_MBOX_UNLOCK_UNLOCK_MASK);
                        }
                        continue;
                    }
                    //Mark the command complete
                    if (cptra_intr_rcv.soc_ifc_error & SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_MBOX_ECC_UNC_STS_MASK) {
                        CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_error, ~SOC_IFC_REG_INTR_BLOCK_RF_ERROR_INTERNAL_INTR_R_ERROR_MBOX_ECC_UNC_STS_MASK)
                        printf("Clearing FW soc_ifc_error intr bit (ECC unc) after servicing\n");
                        soc_ifc_set_mbox_status_field(CMD_FAILURE);
                    } else {
                        soc_ifc_set_mbox_status_field(CMD_COMPLETE);
                    }
                }
            }
            if (cptra_intr_rcv.soc_ifc_notif & SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_MBOX_ECC_COR_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_notif, ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_MBOX_ECC_COR_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_notif & SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_DEBUG_LOCKED_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_notif, ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_DEBUG_LOCKED_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_notif & SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_SCAN_MODE_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_notif, ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_SCAN_MODE_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_notif & SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_SOC_REQ_LOCK_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_notif, ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_SOC_REQ_LOCK_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_notif & SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_GEN_IN_TOGGLE_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.soc_ifc_notif, ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_GEN_IN_TOGGLE_STS_MASK)
            }
            if (cptra_intr_rcv.soc_ifc_notif & (~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_AVAIL_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_MBOX_ECC_COR_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_DEBUG_LOCKED_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_SCAN_MODE_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_SOC_REQ_LOCK_STS_MASK &
                                                ~SOC_IFC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_GEN_IN_TOGGLE_STS_MASK )) {
                printf("Intr received: unsupported soc_ifc_notif (0x%lx)\n", cptra_intr_rcv.soc_ifc_notif);
                 
                while(1);
            }
        }

        if (cptra_intr_rcv.doe_notif       ) {
            printf("Intr received: doe_notif\n");
            if (cptra_intr_rcv.doe_notif & DOE_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.doe_notif, ~DOE_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)
            }
            if (cptra_intr_rcv.doe_notif & (~DOE_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)) {
                printf("Intr received: unsupported doe_notif (0x%lx)\n", cptra_intr_rcv.doe_notif);
                 
                while(1);
            }
        }

        if (cptra_intr_rcv.ecc_notif       ) {
            printf("Intr received: ecc_notif\n");
            if (cptra_intr_rcv.ecc_notif & ECC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.ecc_notif, ~ECC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)
            }
            if (cptra_intr_rcv.ecc_notif & (~ECC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)) {
                printf("Intr received: unsupported ecc_notif (0x%lx)\n", cptra_intr_rcv.ecc_notif);
                 
                while(1);
            }
        }

        if (cptra_intr_rcv.hmac_notif      ) {
            printf("Intr received: hmac_notif\n");
            if (cptra_intr_rcv.hmac_notif & HMAC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.hmac_notif, ~HMAC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)
            }
            if (cptra_intr_rcv.hmac_notif & (~HMAC_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)) {
                printf("Intr received: unsupported hmac_notif (0x%lx)\n", cptra_intr_rcv.hmac_notif);
                 
                while(1);
            }
        }

        if (cptra_intr_rcv.kv_notif        ) {
            printf("Intr received: kv_notif\n");
        }

        if (cptra_intr_rcv.sha512_notif    ) {
            printf("Intr received: sha512_notif\n");
            if (cptra_intr_rcv.sha512_notif & SHA512_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.sha512_notif, ~SHA512_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)
            }
            if (cptra_intr_rcv.sha512_notif & (~SHA512_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)) {
                printf("Intr received: unsupported sha512_notif (0x%lx)\n", cptra_intr_rcv.sha512_notif);
                 
                while(1);
            }
        }

        if (cptra_intr_rcv.sha256_notif    ) {
            printf("Intr received: sha256_notif\n");
            if (cptra_intr_rcv.sha256_notif & SHA256_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.sha256_notif, ~SHA256_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)
            }
            if (cptra_intr_rcv.sha256_notif & (~SHA256_REG_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)) {
                printf("Intr received: unsupported sha256_notif (0x%lx)\n", cptra_intr_rcv.sha256_notif);
                 
                while(1);
            }
        }

        if (cptra_intr_rcv.sha512_acc_notif) {
            printf("Intr received: sha512_acc_notif");
            if (cptra_intr_rcv.sha512_acc_notif & SHA512_ACC_CSR_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK) {
                CLEAR_INTR_FLAG_SAFELY(cptra_intr_rcv.sha512_acc_notif, ~SHA512_ACC_CSR_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)
            }
            if (cptra_intr_rcv.sha512_acc_notif & (~SHA512_ACC_CSR_INTR_BLOCK_RF_NOTIF_INTERNAL_INTR_R_NOTIF_CMD_DONE_STS_MASK)) {
                printf("Intr received: unsupported sha512_acc_notif (0x%lx)\n", cptra_intr_rcv.sha512_acc_notif);
                 
                while(1);
            }
        }

        if (cptra_intr_rcv.qspi_notif      ) {
            printf("Intr received: qspi_notif\n");
        }

        if (cptra_intr_rcv.uart_notif      ) {
            printf("Intr received: uart_notif\n");
        }

        if (cptra_intr_rcv.i3c_notif       ) {
            printf("Intr received: i3c_notif\n");
        }
    };
#endif
}