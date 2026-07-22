#include <stdint.h>
#include <string.h>
#include "caliptra_reg.h"
#include "caliptra_isr.h"
#include "riscv_hw_if.h"
#include "defines.h"
#include "uart.h"
#include "qspi.h"
#include "printf.h"
#include "mailbox.h"
#include "trng.h"
#include "hmac.h"
#include "ecc.h"
#include "sha384.h"
#include "x509.h"
#include "ecdsa-p384.h"

enum doe_cmd_e {
    DOE_IDLE = 0,
    DOE_UDS = 1,
    DOE_FE = 2,
    DOE_CLEAR_OBF_SECRETS = 3
};

cert_t cert_store[4] = {0};
static uint8_t tbs_der[2048] = {0};
static size_t tbs_len = sizeof(tbs_der);
static uint8_t cert_der[4096] = {0};
static size_t cert_len = sizeof(cert_der);
static uint8_t public_key[ECC_BYTES + 1];
static uint8_t private_key[ECC_BYTES];
static uint8_t signature[ECC_BYTES * 2] = {0};

void generate_2nd_cert() {
    uint32_t status;
    uint8_t pub_x[ECC_BYTES];
    uint8_t pub_y[ECC_BYTES];
    uint32_t pubkey_x[12];
    uint32_t pubkey_y[12];
    EccPoint l_public;

    if (!ecc_make_key(public_key, private_key)) {
        printf("ecc_make_key failed!\n");
        while(1);
    }

    ecc_point_decompress(&l_public, public_key);
    ecc_native2bytes(pub_x, l_public.x);
    ecc_native2bytes(pub_y, l_public.y);

    for (int i = 0; i < 12; i++) {
        const uint8_t *p = pub_x + i * 4;
        pubkey_x[i] = ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) | ((uint32_t)p[2] << 8) | p[3];
    }
    for (int i = 0; i < 12; i++) {
        const uint8_t *p = pub_y + i * 4;
        pubkey_y[i] = ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) | ((uint32_t)p[2] << 8) | p[3];
    }

    printf("pubkey_x:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)pubkey_x[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    printf("pubkey_y:\n");
    for(int j = 0; j < 12; j++) {
        printf("0x%08x ", (unsigned int)pubkey_y[j]);
        if (j % 16 == 15) {
            printf("\n");
        }
    }
    printf("\n");

    status = generate_intermediate_tbs_der(pubkey_x, pubkey_y, "L2_Trust_Root", "L2_Trust_Root", tbs_der, &tbs_len, CERT_TYPE_ROOT_CA);
    if(!status && tbs_len <= 2048) {
        printf("cert_len = 0x%x\n", tbs_len);
        printf("2nd tbs der:\n");
        for(int j = 0; j < tbs_len; j++) {
           printf("%s%X", (tbs_der[j] < 0x10) ? "0" : "", tbs_der[j]);
        }
        printf("\n");
    } else {
        printf("generate 2nd cert der faild!\n");
        while(1);
    }

    cert_store[0].der_len = tbs_len;
    cert_store[0].type = CERT_TYPE_ROOT_CA;
    memcpy(cert_store[0].der_data, tbs_der, tbs_len);
}

void sign_1st_cert() {
    uint8_t digest[48];

    sha384_digest(tbs_der, tbs_len, (uint64_t *)digest, true);
    printf("digest:\n");
    for(int j = 0; j < 48; j++) {
        printf("%02x", digest[j]);
    }
    printf("\n");

    int ret = ecdsa_sign(private_key, digest, signature);
    if (ret != 1) {
        printf("ECDSA-P384 sign failed! ret = %d\n", ret);
        return;
    }
    printf("signature:\n");
    for(int j = 0; j < sizeof(signature); j++) {
        printf("%02x", signature[j]);
    }
    printf("\n");

    const uint8_t *sig_r = &signature[0];
    const uint8_t *sig_s = &signature[ECC_BYTES];

    printf("sig_r_words:\n");
    for(int j = 0; j < 48; j++) {
        printf("%02x", sig_r[j]);
    }
    printf("\n");

    printf("sig_s_words:\n");
    for(int j = 0; j < 48; j++) {
        printf("%02x", sig_s[j]);
    }
    printf("\n");

    ret = ecdsa_verify(public_key, digest, signature);
    if (ret != 1) {
        printf("ECDSA-P384 verify failed! ret=%d\n", ret);
    } else {
        printf("ECDSA-P384 verify success!\n");
    }

    add_signature_to_cert(tbs_der, tbs_len, sig_r, sig_s, cert_der, &cert_len);
}

void main() {
    mbox_op_s op;
    uint32_t data;
    uint32_t off = 0;
    int ret = 0;

    init_uart();
    enable_csrng();

    printf("------------------------------------\n");
    printf("            Caliptra ROM...         \n");
    printf("------------------------------------\n");
    printf("Compiled on: %s at %s\n", __DATE__, __TIME__);

    generate_2nd_cert();

    while(1) {
        op = soc_ifc_read_mbox_cmd();
        if (op.cmd & MBOX_CMD_FIELD_RESP_MASK) {
            printf("Received mailbox command (expecting RESP) from SOC! Got 0x%x\n", op.cmd);
            if (op.cmd == MBOX_CMD_GET_TRNG) {
                int num_randoms = 32;
                uint8_t randoms[num_randoms];
                if (generate_random_numbers(num_randoms, randoms) == 0) {
                    printf("Get randoms:\n");
                    for (int i = 0; i < num_randoms; i++) {
                        printf("%02x ", randoms[i]);
                    }
                    printf("\n");
                    mailbox_send_data((uint32_t *)randoms, num_randoms);
                }
            } 
            else if (op.cmd == MBOX_CMD_GENERATE_2ND_CERT) {
                memset(tbs_der, 0x0, tbs_len);
                memset(cert_der, 0x0, cert_len);
                mailbox_send_data((uint32_t *)cert_store[0].der_data, tbs_len);
            } 
            else if (op.cmd == MBOX_CMD_SIGN_1ST_CTX) {
                memset(tbs_der, 0x0, tbs_len);
                memset(cert_der, 0x0, cert_len);
                for (uint16_t slp = 0; slp < 333; slp++);
                printf("FW: Reading %08d bytes from mailbox\n", (unsigned int )op.dlen);
                if (op.dlen < 200) {
                    printf("Invalid cert length\n");
                    off = 0;
                    op.cmd = 0;
                    continue;
                }
                tbs_len = op.dlen;
                while(op.dlen) {
                    data = soc_ifc_mbox_read_dataout_single();
                    printf("  dataout: 0x%08x\n", (unsigned int )data);
                    uint32_t cur_len = op.dlen < 4 ? op.dlen : 4;
                    for (uint32_t i = 0; i < cur_len; i++) {
                        tbs_der[off + i] = (data >> (i * 8)) & 0xFF;
                    }
                    off += cur_len;
                    if (op.dlen < 4) {
                        op.dlen=0;
                    } else {
                        op.dlen-=4;
                    }
                }
                if (tbs_der[0] == 0x30 && tbs_der[1] == 0x82) {
                    uint16_t content_len = ((uint16_t)tbs_der[2] << 8) | tbs_der[3];
                    tbs_len = 4 + content_len;
                } else {
                    tbs_len = off;
                }
                printf("1st tbs(tbs_len = 0x%x):\n", tbs_len);
                for(uint32_t i = 0; i < tbs_len; i++) {
                    printf("%02x", tbs_der[i]);
                }
                printf("\n");

                sign_1st_cert();
                printf("1st cert(cert_len = 0x%x):\n", cert_len);
                for(uint32_t i = 0; i < cert_len; i++) {
                    printf("%02x", cert_der[i]);
                }
                printf("\n");
                ret = verify_cert(cert_der, cert_len, public_key);
                if (ret == 1) {
                    printf("1st cert verify success\n");
                } else {
                    printf("1st cert verify failed, ret = %d\n", ret);
                }
                mailbox_send_data((uint32_t *)cert_der, cert_len);
            } 
            else if (op.cmd == MBOX_CMD_SAVE_2ND_CERT) {
                memset(cert_der, 0x0, cert_len);
                for (uint16_t slp = 0; slp < 333; slp++);
                printf("FW: Reading %08d bytes from mailbox\n", (unsigned int )op.dlen);
                if (op.dlen < 300) {
                    printf("Invalid cert length\n");
                    off = 0;
                    op.cmd = 0;
                    continue;
                }
                cert_len = op.dlen;
                while(op.dlen) {
                    data = soc_ifc_mbox_read_dataout_single();
                    printf("  dataout: 0x%08x\n", (unsigned int )data);
                    uint32_t cur_len = op.dlen < 4 ? op.dlen : 4;
                    for (uint32_t i = 0; i < cur_len; i++) {
                        cert_der[off + i] = (data >> (i * 8)) & 0xFF;
                    }
                    off += cur_len;
                    if (op.dlen < 4) {
                        op.dlen=0;
                    } else {
                        op.dlen-=4;//sizeof(uint32_t);
                    }
                }
                if (cert_der[0] == 0x30 && cert_der[1] == 0x82) {
                    uint16_t content_len = ((uint16_t)cert_der[2] << 8) | cert_der[3];
                    cert_len = 4 + content_len;
                } else {
                    cert_len = off;
                }
                printf("2nd cert(cert_len = 0x%x):\n", cert_len);
                for(uint32_t i = 0; i < cert_len; i++) {
                    printf("%02x", cert_der[i]);
                }
                printf("\n");

                cert_store[1].der_len = cert_len;
                cert_store[1].type = CERT_TYPE_ROOT_CA;
                memcpy(cert_store[1].der_data, cert_der, cert_len);

                printf("2nd cert save success\n");
                mailbox_send_data((uint32_t *)ret, 0x1);

            }
            else if (op.cmd == MBOX_CMD_GET_2ND_CERT) {
                printf("2nd cert(cert_len = 0x%x):\n", cert_store[1].der_len);
                for(uint32_t i = 0; i < cert_store[1].der_len; i++) {
                    printf("%02x", cert_store[1].der_data[i]);
                }
                printf("\n");
                mailbox_send_data((uint32_t *)cert_store[1].der_data, cert_store[1].der_len);

            } 
            else if (op.cmd == MBOX_CMD_VERIFY_1ST_CTX) {
                memset(cert_der, 0x0, cert_len);
                for (uint16_t slp = 0; slp < 333; slp++);
                printf("FW: Reading %08d bytes from mailbox\n", (unsigned int )op.dlen);
                if (op.dlen < 400) {
                    printf("Invalid cert length\n");
                    off = 0;
                    op.cmd = 0;
                    continue;
                }
                cert_len = op.dlen;

                while(op.dlen) {
                    data = soc_ifc_mbox_read_dataout_single();
                    printf("  dataout: 0x%08x\n", (unsigned int )data);
                    uint32_t cur_len = op.dlen < 4 ? op.dlen : 4;
                    for (uint32_t i = 0; i < cur_len; i++) {
                        cert_der[off + i] = (data >> (i * 8)) & 0xFF;
                    }
                    off += cur_len;
                    if (op.dlen < 4) {
                        op.dlen=0;
                    } else {
                        op.dlen-=4;//sizeof(uint32_t);
                    }
                }
                
                printf("1st cert(cert_len = 0x%x):\n", cert_len);
                for(uint32_t i = 0; i < cert_len; i++) {
                    printf("%02x", cert_der[i]);
                }
                printf("\n");
                ret = verify_cert(cert_der, cert_len, public_key);
                if (ret == 1) {
                    printf("1st cert verify success\n");
                    mailbox_send_data((uint32_t *)ret, 0x4);
                } else {
                    printf("1st cert verify failed, ret = %d\n", ret);
                    mailbox_send_data((uint32_t *)ret, 0x4);
                }
            }
            off = 0x0;
            op.cmd = 0x0;
        }
    }



    printf("\n");
    printf("------------------------------------\n");
    printf(" Reached end of ROM FW unexpectedly!\n");
    printf("------------------------------------\n");
    while(1);
}
