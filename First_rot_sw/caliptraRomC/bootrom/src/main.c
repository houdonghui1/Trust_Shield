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
#include "cluster_bls_l1.h"

#define FMC_SIZE                    (20480)
#define FMC_STORE_SECTOR_OFFSET     (2048)

#define SOC_FW_SIZE                 (9728)
#define SOC_FW_STORE_SECTOR_OFFSET  (6144)

/*
 * These buffers are needed only while ROM receives and authenticates the next
 * images.  Put them in the lower 64KiB DCCM staging bank; keeping them in the
 * upper bank would make the 16KiB ROM stack collide with the persistent
 * certificate and BLS state stored at the top of that bank.
 */
__attribute__((section(".fw_staging"))) uint8_t FMC_data[FMC_SIZE] = {0};
__attribute__((section(".fw_staging"))) uint8_t SOC_FW_data[SOC_FW_SIZE] = {0};

__attribute__((section(".tbs_der_store"))) cert_t tbs_der_store[4] = {0};
__attribute__((section(".cert_store"))) cert_t cert_store[4] = {0};
/* Shared with RT through a fixed NOLOAD DCCM reservation; do not put this
 * CDI-derived BLS secret in the normal image BSS. */
__attribute__((section(".cluster_bls_state")))
static cluster_bls_l1_persistent_state_t g_cluster_bls_l1_state;

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
    .sha512_error     = 0,
    .sha512_notif     = 0,
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

#ifndef CLUSTER_BLS_L1_NODE_ID
#define CLUSTER_BLS_L1_NODE_ID "L1-001"
#endif

#ifndef CLUSTER_BLS_L2_NODE_ID
#define CLUSTER_BLS_L2_NODE_ID "L2-001"
#endif

enum {
    kL1CertificateInstallMagicBytes = 4,
    kL2RawPublicKeyBytes = 96,
    kL1CertificateInstallHeaderBytes =
        kL1CertificateInstallMagicBytes + kL2RawPublicKeyBytes,
};

static const uint8_t kL1CertificateInstallMagic[4] = {'L', '1', 'C', '1'};

static bool l1_der_length(const uint8_t **cursor, const uint8_t *end,
                          size_t *length) {
    size_t count;
    size_t value = 0;
    uint8_t first;
    if (cursor == NULL || *cursor == NULL || end == NULL || length == NULL ||
        *cursor >= end) {
        return false;
    }
    first = *(*cursor)++;
    if ((first & 0x80) == 0) {
        value = first;
    } else {
        count = first & 0x7f;
        if (count == 0 || count > sizeof(size_t) ||
            (size_t)(end - *cursor) < count || (*cursor)[0] == 0) {
            return false;
        }
        for (size_t i = 0; i < count; ++i) {
            value = (value << 8) | *(*cursor)++;
        }
        if (value < 128) {
            return false;
        }
    }
    if (value > (size_t)(end - *cursor)) {
        return false;
    }
    *length = value;
    return true;
}

static bool l1_der_field(uint8_t tag, const uint8_t **cursor,
                         const uint8_t *end, const uint8_t **value,
                         size_t *value_len) {
    if (cursor == NULL || *cursor == NULL || *cursor >= end ||
        *(*cursor)++ != tag || !l1_der_length(cursor, end, value_len)) {
        return false;
    }
    *value = *cursor;
    *cursor += *value_len;
    return true;
}

static bool l1_integer_to_ecc_words(const uint8_t *integer,
                                    size_t integer_len, ecc_io *value) {
    uint8_t normalized[48] = {0};
    size_t offset = 0;
    if (integer == NULL || value == NULL || integer_len == 0 ||
        integer_len > 49 || (integer[0] & 0x80) != 0) {
        return false;
    }
    if (integer_len == 49) {
        if (integer[0] != 0) {
            return false;
        }
        integer++;
        integer_len--;
    }
    offset = sizeof(normalized) - integer_len;
    memcpy(normalized + offset, integer, integer_len);
    memset(value, 0, sizeof(*value));
    for (size_t i = 0; i < 12; ++i) {
        value->data[i] = ((uint32_t)normalized[i * 4] << 24) |
                         ((uint32_t)normalized[i * 4 + 1] << 16) |
                         ((uint32_t)normalized[i * 4 + 2] << 8) |
                         normalized[i * 4 + 3];
    }
    return true;
}

static void l1_bytes_to_ecc_words(const uint8_t bytes[48], ecc_io *value) {
    memset(value, 0, sizeof(*value));
    for (size_t i = 0; i < 12; ++i) {
        value->data[i] = ((uint32_t)bytes[i * 4] << 24) |
                         ((uint32_t)bytes[i * 4 + 1] << 16) |
                         ((uint32_t)bytes[i * 4 + 2] << 8) |
                         bytes[i * 4 + 3];
    }
}

static bool l1_verify_parent_signature(const uint8_t *certificate,
                                       size_t certificate_len,
                                       const uint8_t parent_public_key[96]) {
    const uint8_t *tbs;
    size_t tbs_len;
    const uint8_t *cursor;
    const uint8_t *end = certificate + certificate_len;
    const uint8_t *field;
    const uint8_t *signature_sequence;
    size_t field_len;
    size_t signature_sequence_len;
    const uint8_t *r;
    const uint8_t *s;
    size_t r_len;
    size_t s_len;
    uint64_t digest_words[6] = {0};
    uint8_t digest[48] = {0};
    ecc_io msg;
    ecc_io pubkey_x;
    ecc_io pubkey_y;
    ecc_io sign_r;
    ecc_io sign_s;

    if (x509_get_tbs_der(certificate, certificate_len, &tbs, &tbs_len) != 0) {
        return false;
    }
    cursor = tbs + tbs_len;
    if (!l1_der_field(0x30, &cursor, end, &field, &field_len) ||
        !l1_der_field(0x03, &cursor, end, &field, &field_len) ||
        cursor != end || field_len < 2 || field[0] != 0) {
        return false;
    }
    cursor = field + 1;
    if (!l1_der_field(0x30, &cursor, field + field_len,
                      &signature_sequence, &signature_sequence_len) ||
        cursor != field + field_len) {
        return false;
    }
    cursor = signature_sequence;
    if (!l1_der_field(0x02, &cursor,
                      signature_sequence + signature_sequence_len,
                      &r, &r_len) ||
        !l1_der_field(0x02, &cursor,
                      signature_sequence + signature_sequence_len,
                      &s, &s_len) ||
        cursor != signature_sequence + signature_sequence_len ||
        !l1_integer_to_ecc_words(r, r_len, &sign_r) ||
        !l1_integer_to_ecc_words(s, s_len, &sign_s)) {
        return false;
    }
    sha384_digest((uint8_t *)tbs, tbs_len, digest_words, true);
    for (size_t i = 0; i < 6; ++i) {
        for (size_t j = 0; j < 8; ++j) {
            digest[i * 8 + j] =
                (uint8_t)(digest_words[i] >> (56 - j * 8));
        }
    }
    l1_bytes_to_ecc_words(digest, &msg);
    l1_bytes_to_ecc_words(parent_public_key, &pubkey_x);
    l1_bytes_to_ecc_words(parent_public_key + 48, &pubkey_y);
    bool valid = ecc_verifying_flow(msg, pubkey_x, pubkey_y, sign_r, sign_s) == 0;
    memset(digest_words, 0, sizeof(digest_words));
    memset(digest, 0, sizeof(digest));
    return valid;
}

static bool l1_registration_equal(const cluster_bls_registration_t *left,
                                  const cluster_bls_registration_t *right) {
    return left != NULL && right != NULL &&
           left->protocol_version == right->protocol_version &&
           left->ciphersuite == right->ciphersuite &&
           memcmp(left->key_id, right->key_id, sizeof(left->key_id)) == 0 &&
           memcmp(left->public_key, right->public_key,
                  sizeof(left->public_key)) == 0 &&
           memcmp(left->proof_of_possession, right->proof_of_possession,
                  sizeof(left->proof_of_possession)) == 0;
}

static bool validate_l1_certificate_from_l2(
    const uint8_t *certificate, size_t certificate_len,
    const uint8_t parent_public_key[96]) {
    const uint8_t *certificate_tbs = NULL;
    size_t certificate_tbs_len = 0;
    cluster_bls_registration_t expected;
    cluster_bls_registration_t embedded;
    bool valid;

    valid = cluster_bls_l1_persistent_state_valid(&g_cluster_bls_l1_state) &&
            certificate != NULL && parent_public_key != NULL &&
            x509_get_tbs_der(certificate, certificate_len, &certificate_tbs,
                             &certificate_tbs_len) == 0 &&
            cluster_bls_l1_registration(&g_cluster_bls_l1_state.service,
                                        &expected) &&
            cluster_bls_certificate_binding_decode(
                certificate_tbs, certificate_tbs_len, &embedded) &&
            l1_registration_equal(&expected, &embedded) &&
            l1_verify_parent_signature(certificate, certificate_len,
                                       parent_public_key);
    return valid;
}

/* Demo only: fixed key material keeps the verifier public key stable and keeps
 * key generation/PoP generation out of the 48KiB hardware ROM.  Replace this
 * with CDI-derived initialization after the demo. */
static bool cluster_bls_l1_initialize_demo(void) {
    static const uint8_t kL1DemoSecretKey[kOtBlsSecretKeyBytes] = {
        0x4b, 0xc7, 0x5e, 0x75, 0xd1, 0xe8, 0x71, 0x84,
        0x6b, 0xaf, 0xda, 0x82, 0x95, 0x70, 0xe8, 0xf3,
        0x4e, 0x55, 0x17, 0x14, 0xa1, 0x42, 0x9e, 0x76,
        0x49, 0x29, 0x23, 0x07, 0xcd, 0xd6, 0xe9, 0x3d,
    };
    static const uint8_t kL1DemoPublicKey[kOtBlsPublicKeyBytes] = {
        0xb8, 0xbc, 0x7d, 0x92, 0x42, 0xc9, 0x95, 0xeb,
        0xd2, 0xa5, 0xaf, 0x60, 0x27, 0x54, 0x06, 0xa5,
        0xaf, 0x07, 0x01, 0x6f, 0xfd, 0xe6, 0xa9, 0xe4,
        0xe7, 0x17, 0x77, 0xc0, 0x32, 0xd1, 0xba, 0xc9,
        0x58, 0x2c, 0xe2, 0x80, 0xea, 0x74, 0x7f, 0xe7,
        0x0a, 0xc8, 0x97, 0x84, 0x24, 0xa5, 0xe9, 0x35,
    };
    static const uint8_t kL1DemoProof[kOtBlsSignatureBytes] = {
        0xa4, 0x0d, 0xb6, 0x64, 0xb7, 0x6d, 0x0d, 0x6e,
        0xa5, 0x20, 0xa1, 0x95, 0x1c, 0x72, 0x7b, 0xa0,
        0xf4, 0x5c, 0x30, 0xe7, 0x98, 0x51, 0xaf, 0x61,
        0xb3, 0xda, 0x61, 0x24, 0x07, 0x16, 0x68, 0x2d,
        0x08, 0x18, 0x63, 0x1f, 0xbe, 0x4c, 0xd0, 0xc5,
        0x95, 0x05, 0xba, 0xd8, 0x72, 0x45, 0xb2, 0xbd,
        0x0b, 0x79, 0x92, 0xb7, 0x9d, 0xcd, 0x53, 0x71,
        0xdd, 0x57, 0xa7, 0x58, 0x0b, 0xa4, 0xd1, 0x7b,
        0x5a, 0x02, 0xc9, 0x7f, 0x14, 0x07, 0x95, 0x30,
        0x9b, 0x29, 0xb2, 0x0a, 0xde, 0xe3, 0xfd, 0x17,
        0xb9, 0x46, 0xf7, 0xa5, 0x88, 0x4c, 0x16, 0x02,
        0xeb, 0x77, 0x6c, 0xaa, 0x0f, 0xb5, 0x44, 0xf0,
    };
    static const uint8_t kL1DemoKeyId[kClusterBlsKeyIdBytes] = {
        0xd3, 0x85, 0xd9, 0xd4, 0x20, 0xc0, 0x3a, 0x45,
        0x95, 0x4a, 0x3a, 0x6a, 0xd9, 0x19, 0x03, 0xc0,
    };
    cluster_bls_signer_t *signer = &g_cluster_bls_l1_state.service.signer;

    memset(&g_cluster_bls_l1_state, 0, sizeof(g_cluster_bls_l1_state));
    memcpy(signer->secret_key, kL1DemoSecretKey, sizeof(kL1DemoSecretKey));
    memcpy(signer->public_key, kL1DemoPublicKey, sizeof(kL1DemoPublicKey));
    memcpy(signer->proof_of_possession, kL1DemoProof, sizeof(kL1DemoProof));
    memcpy(signer->key_id, kL1DemoKeyId, sizeof(kL1DemoKeyId));
    signer->initialized = true;
    g_cluster_bls_l1_state.magic = kClusterBlsL1PersistentStateMagic;
    printf("WARNING: L1 BLS uses a fixed insecure demo key\n");
    return true;
}

static bool cluster_bls_l1_read_mailbox_exact(mbox_op_s *op, uint8_t *out,
                                               size_t expected_len) {
    size_t offset = 0;
    if (op == NULL || out == NULL || op->dlen != expected_len) {
        return false;
    }
    while (offset < expected_len) {
        uint32_t word = soc_ifc_mbox_read_dataout_single();
        size_t chunk = expected_len - offset;
        if (chunk > sizeof(word)) {
            chunk = sizeof(word);
        }
        for (size_t i = 0; i < chunk; ++i) {
            out[offset + i] = (uint8_t)(word >> (8 * i));
        }
        offset += chunk;
    }
    op->dlen = 0;
    return true;
}

/* Hook for the runtime mailbox dispatcher once the L1 certificate is present. */
static bool cluster_bls_l1_handle_proof_command(mbox_op_s *op) {
    uint8_t digest[kClusterBlsDigestBytes];
    uint8_t signature[kOtBlsSignatureBytes];
    cluster_bls_registration_t registration;
    uint8_t registration_wire[kClusterBlsRegistrationWireBytes];

    if (op == NULL ||
        !cluster_bls_l1_persistent_state_valid(&g_cluster_bls_l1_state)) {
        return false;
    }
    if (op->cmd == MBOX_CMD_BLS_GET_REGISTRATION) {
        if (op->dlen != 0 || !cluster_bls_l1_registration(
                                  &g_cluster_bls_l1_state.service,
                                  &registration) ||
            !cluster_bls_registration_encode(&registration, registration_wire)) {
            return false;
        }
        mailbox_send_data((uint32_t *)registration_wire, sizeof(registration_wire));
        return true;
    }
    if (op->cmd != MBOX_CMD_BLS_SIGN_CHALLENGE ||
        !g_cluster_bls_l1_state.certificate_installed ||
        !cluster_bls_l1_read_mailbox_exact(op, digest, sizeof(digest)) ||
        !cluster_bls_l1_sign_challenge(&g_cluster_bls_l1_state.service, digest,
                                       signature)) {
        return false;
    }
    mailbox_send_data((uint32_t *)signature, sizeof(signature));
    return true;
}

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
    if(!status && tbs_len <= sizeof(tbs_der_store[1].der_data)) {
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
    if(!status && cert_len <= sizeof(cert_store[1].der_data)) {
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
    uint8_t cluster_bls_csr[2048 + kClusterBlsCertificateRequestHeaderBytes +
                            kClusterBlsRegistrationWireBytes] = {0};
    size_t cluster_bls_csr_len = sizeof(cluster_bls_csr);
    mbox_op_s op;
    uint32_t ret = MBOX_SUCCESS;
    uint8_t parent_public_key[kL2RawPublicKeyBytes] = {0};

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

    if (!cluster_bls_l1_initialize_demo()) {
        printf("Cannot initialize the L1 BLS demo key\n");
        while (1) {
        }
    }

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
    status = generate_intermediate_tbs_der(
        pubkey_x.data, pubkey_y.data, CLUSTER_BLS_L2_NODE_ID,
        CLUSTER_BLS_L1_NODE_ID, tbs_der, &tbs_len, CERT_TYPE_LDEVID);
    if(!status && tbs_len <= sizeof(tbs_der_store[0].der_data)) {
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

    if (tbs_len > sizeof(tbs_der_store[0].der_data) ||
        !cluster_bls_l1_build_certificate_request(&g_cluster_bls_l1_state.service,
                                                  tbs_der, tbs_len,
                                                  cluster_bls_csr,
                                                  &cluster_bls_csr_len)) {
        printf("Failed to build bounded CBR1 request for L2\n");
        while (1) {
        }
    }
    tbs_der_store[0].der_len = tbs_len;
    tbs_der_store[0].type = CERT_TYPE_LDEVID;
    memcpy(tbs_der_store[0].der_data, tbs_der, tbs_len);

#if 1 //CA signed
    while(1) {
        op = soc_ifc_read_mbox_cmd();
        if (cluster_bls_l1_handle_proof_command(&op)) {
            continue;
        }
        if (op.cmd == MBOX_CMD_RECV_CLP_CSR) {
            printf("Send idevid CSR command\n");

            /* L2 validates the embedded PoP, inserts the BLS X.509 binding,
             * and then signs this TBS.  It must not accept bare DER here. */
            mailbox_send_data((uint32_t *)cluster_bls_csr, cluster_bls_csr_len);
            break;
        }
    }

    while(1) {
        op = soc_ifc_read_mbox_cmd();
        if (op.cmd == MBOX_CMD_RECV_CLP_CTX) {
            uint8_t install_header[kL1CertificateInstallHeaderBytes];
            size_t install_len = op.dlen;
            size_t install_offset = 0;

            printf("FW: Reading %08d-byte authenticated L1 certificate install package\n",
                   (unsigned int)install_len);

            if (install_len <= sizeof(install_header) ||
                install_len - sizeof(install_header) > sizeof(cert_der)) {
                printf("Rejected malformed L1 certificate install package\n");
                ret = MBOX_FAILED;
                mailbox_send_data(&ret, sizeof(ret));
                while (1) {
                }
            }
            cert_len = install_len - sizeof(install_header);

            while (install_offset < install_len) {
                uint32_t data = soc_ifc_mbox_read_dataout_single();
                size_t chunk = install_len - install_offset;
                if (chunk > sizeof(data)) {
                    chunk = sizeof(data);
                }
                for (size_t i = 0; i < chunk; ++i) {
                    size_t target = install_offset + i;
                    uint8_t byte = (uint8_t)(data >> (i * 8));
                    if (target < sizeof(install_header)) {
                        install_header[target] = byte;
                    } else {
                        cert_der[target - sizeof(install_header)] = byte;
                    }
                }
                install_offset += chunk;
            }
            if (memcmp(install_header, kL1CertificateInstallMagic,
                       sizeof(kL1CertificateInstallMagic)) != 0) {
                printf("Rejected unauthenticated L1 certificate install package\n");
                ret = MBOX_FAILED;
                mailbox_send_data(&ret, sizeof(ret));
                while (1) {
                }
            }

            memcpy(parent_public_key,
                   install_header + kL1CertificateInstallMagicBytes,
                   sizeof(parent_public_key));
            break;
        }
    }
    store_to_datavault(pubkey_x.data, pubkey_y.data, 8, 9);

    printf("cert_len = 0x%x\n", cert_len);
    printf("IdeVID cert:\n");
    for(int j = 0; j < cert_len; j++) {
        printf("%s%X", (cert_der[j] < 0x10) ? "0" : "", cert_der[j]); 
    }
    printf("\n");
    if (cert_len > sizeof(cert_store[0].der_data)) {
        printf("L1 certificate exceeds persistent certificate store\n");
        while (1) {
        }
    }
    if (!validate_l1_certificate_from_l2(cert_der, cert_len,
                                         parent_public_key)) {
        ret = MBOX_FAILED;
        printf("Rejected L1 certificate: untrusted L2 signature or BLS binding\n");
        mailbox_send_data(&ret, sizeof(ret));
        while (1) {
        }
    }
    cert_store[0].der_len = cert_len;
    cert_store[0].type = CERT_TYPE_LDEVID;
    memcpy(cert_store[0].der_data, cert_der, cert_len);
    g_cluster_bls_l1_state.certificate_installed = true;
    memset(parent_public_key, 0, sizeof(parent_public_key));
    mailbox_send_data(&ret, sizeof(ret));
#else //self signed
    uint8_t digest[48];
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
    if(!status && cert_len <= sizeof(cert_store[0].der_data)) {
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
#endif
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
    mbox_op_s op;
    uint32_t init_ok = 0;
    uint8_t status;
    uint8_t recv_data[BUFFER_SIZE];
    uint32_t FMC_sha512_digest[16];
    uint32_t SOC_sha512_digest[16];
    uint8_t ROM_median[128];
    uint32_t ROM_sha512_digest[16];

    //uint8_t test_data[129];

    //memset(test_data, 0x5a, 129);
    init_uart();
    init_qspi();

    printf("------------------------------------\n");
    printf("            Caliptra ROM...         \n");
    printf("------------------------------------\n");
    printf("Compiled on: %s at %s\n", __DATE__, __TIME__);

    sha512_flow_produce((uint8_t *)FMC_expected_digest, sizeof(FMC_expected_digest), FMC_sha512_digest);
    printf("FMC measure value:\n");
    for(int j = 0; j < 16; j++) {
        printf("%08x", (unsigned int)FMC_sha512_digest[j]); 
    }
    printf("\n");

    sha512_flow_produce((uint8_t *)SOC_expected_digest, sizeof(SOC_expected_digest), SOC_sha512_digest);
    printf("SOC measure value:\n");
    for(int j = 0; j < 16; j++) {
        printf("%08x", (unsigned int)SOC_sha512_digest[j]); 
    }
    printf("\n");

    memcpy(ROM_median, SOC_sha512_digest, sizeof(SOC_sha512_digest));
    memcpy(ROM_median + sizeof(SOC_sha512_digest), FMC_sha512_digest, sizeof(FMC_sha512_digest));
    sha512_flow_produce(ROM_median, sizeof(ROM_median), ROM_sha512_digest);
    printf("ROM measure value:\n");
    for(int j = 0; j < 16; j++) {
        printf("%08x", (unsigned int)ROM_sha512_digest[j]); 
    }
    printf("\n");

    while(1) {
        op = soc_ifc_read_mbox_cmd();
        if (op.cmd == MBOX_CMD_GET_ROM_MEASURE_VALUE) {
            printf("Obtain get ROM value command\n");

            mailbox_send_data(ROM_sha512_digest, sizeof(ROM_sha512_digest));
            break;
        }
    }

    while(1) {
        op = soc_ifc_read_mbox_cmd();
        if (op.cmd == MBOX_CMD_INITIATE) {
            printf("The measurement has passed, starting\n");
            uint32_t value = MBOX_SUCCESS;
            uint32_t *send_status = &value;
            mailbox_send_data(send_status, 0x4);
            break;
        }
    }

    init_doe();
    
    idevid();
    
    ldevid();

    while (init_sd_card() != 0) {
        delay_ms(100);
    }
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
                while(1) {
                    op = soc_ifc_read_mbox_cmd();
                    if (cluster_bls_l1_handle_proof_command(&op)) {
                        continue;
                    }
                    if (op.cmd == MBOX_CMD_RECV_SOC_FW) {
                        mailbox_send_data((uint32_t *)SOC_FW_data, SOC_FW_SIZE);
                        break;
                    }
                }
            }
        }

    if (init_ok) {
        printf("Jump to FMC...\n");
        void (* fmc_entry) (void) = (void*) (RV_ICCM_SADR);
        fmc_entry();
    } 
    /* else {
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
            }
        }
        if (init_ok) {
            printf("Jump to FMC...\n");
            void (* fmc_entry) (void) = (void*) (RV_ICCM_SADR);
            fmc_entry();
        } 
    } */

    printf("------------------------------------\n");
    printf(" Reached end of ROM FW unexpectedly!\n");
    printf("------------------------------------\n");
    while(1);
}
