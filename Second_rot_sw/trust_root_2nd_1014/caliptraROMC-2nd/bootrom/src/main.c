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
#include "cluster_bls_l2.h"
#include "cluster_bls_scale_test.h"
#include "cluster_bls_x509.h"
#include "ecdsa_scale_caliptra.h"
#define MBOX_CMD_ECDSA_SCALE_SIGN 0x44C0FFE6U
#define MBOX_CMD_ECDSA_CERT_VERIFY 0x44C0FFE7U
#if CLUSTER_BLS_SCALE_TEST_ENABLE
extern uint64_t get_mcycle(void);
#endif

#ifndef CLUSTER_BLS_L2_NODE_ID
#define CLUSTER_BLS_L2_NODE_ID "L2-001"
#endif

#ifndef CLUSTER_BLS_L3_NODE_ID
#define CLUSTER_BLS_L3_NODE_ID "L3-001"
#endif

enum {
    kL2CertificateInstallMagicBytes = 4,
    kL3CompressedPublicKeyBytes = ECC_BYTES + 1,
    kL2CertificateInstallHeaderBytes =
        kL2CertificateInstallMagicBytes + kL3CompressedPublicKeyBytes,
    kL2CertificateErrorBlsInit = 0x4c320001,
    kL2CertificateErrorArgument = 0x4c320002,
    kL2CertificateErrorTbs = 0x4c320003,
    kL2CertificateErrorRegistration = 0x4c320004,
    kL2CertificateErrorBindingDecode = 0x4c320005,
    kL2CertificateErrorBindingMismatch = 0x4c320006,
    kL2CertificateErrorSignature = 0x4c320007,
    kL1CertificateErrorBlsInit = 0x4c310001,
    kL1CertificateErrorRequest = 0x4c310002,
    kL1CertificateErrorBinding = 0x4c310003,
    kL1CertificateErrorSigning = 0x4c310004,
    kL1CertificateErrorRegistration = 0x4c310005,
    kL1CertificateErrorMailbox = 0x4c310006,
    kL1CertificateErrorHeader = 0x4c310007,
    kL1CertificateErrorBlsRegistration = 0x4c310008,
};

static const uint8_t kL2CertificateInstallMagic[4] = {'L', '2', 'C', '1'};

enum doe_cmd_e {
    DOE_IDLE = 0,
    DOE_UDS = 1,
    DOE_FE = 2,
    DOE_CLEAR_OBF_SECRETS = 3
};

__attribute__((section(".cert_store"))) cert_t cert_store[4] = {0};
static uint8_t tbs_der[4096] = {0};
static size_t tbs_len = sizeof(tbs_der);
static uint8_t cert_der[4096] = {0};
static size_t cert_len = sizeof(cert_der);
static uint8_t public_key[ECC_BYTES + 1];
static uint8_t private_key[ECC_BYTES];
static uint8_t signature[ECC_BYTES * 2] = {0};
static bool read_mailbox_exact(mbox_op_s *op, uint8_t *out,
                               size_t expected_len);
static bool cluster_bls_send_consumed(const uint8_t *data, size_t length);
/* Keep the L2 signer and its authenticated L1 child list in the linker-owned
 * BLS state range instead of allowing ordinary .bss growth to overlap it. */
__attribute__((section(".cluster_bls_state")))
static cluster_bls_l2_service_t cluster_bls_l2;
static bool cluster_bls_l2_ready = false;
static uint8_t cluster_bls_child_signatures[
    kClusterBlsL2MaxDirectChildren * kOtBlsSignatureBytes] = {0};
static uint8_t cluster_bls_certificate_request[
    kClusterBlsCertificateRequestHeaderBytes +
    kClusterBlsRegistrationWireBytes + sizeof(tbs_der)] = {0};

#if CLUSTER_BLS_SCALE_TEST_ENABLE
enum {
    kClusterBlsScaleCachedL2Keys = 10,
    kClusterBlsScaleWorkBytes =
        40U + (CLUSTER_BLS_SCALE_CHILDREN + 1U) * kOtBlsSignatureBytes,
    kClusterBlsScaleCacheDigestOffset = kClusterBlsScaleWorkBytes + 4U,
    kClusterBlsScaleCacheMaskOffset =
        kClusterBlsScaleCacheDigestOffset + kClusterBlsDigestBytes,
    kClusterBlsScaleCacheSignaturesOffset =
        kClusterBlsScaleCacheMaskOffset + 4U,
    kClusterBlsScaleCacheBytes =
        kClusterBlsScaleCacheSignaturesOffset +
        kClusterBlsScaleCachedL2Keys * kOtBlsSignatureBytes,
};

typedef char cluster_bls_scale_request_capacity_check[
    sizeof(cluster_bls_certificate_request) >=
        kClusterBlsScaleCacheBytes ? 1 : -1];

static const uint8_t
    kClusterBlsScaleL2SecretKeys[kClusterBlsScaleCachedL2Keys]
                               [kOtBlsSecretKeyBytes] = {
    {0x69,0x61,0x22,0x99,0x62,0x53,0x36,0x5b,0x29,0xd4,0x93,0xd7,0x43,0x77,0xfd,0xe3,
     0xfe,0x3d,0x27,0x0d,0x95,0x2f,0x0c,0xff,0x52,0x7c,0x53,0xe6,0x05,0x1d,0x05,0x74},
    {0x34,0x57,0xad,0x7e,0x06,0x5a,0xe2,0x0a,0x75,0x67,0x59,0x22,0x0f,0x4e,0x14,0xda,
     0x43,0x09,0x1b,0xee,0xf5,0x8c,0xc9,0x34,0x81,0xfb,0xf6,0xb4,0x5b,0x79,0xef,0x1f},
    {0x17,0xef,0x1b,0xc9,0x2d,0x36,0xfc,0xb2,0xfd,0x5c,0xb6,0x0b,0x22,0x42,0x61,0xf0,
     0xff,0x52,0xa1,0xe9,0x53,0x4c,0x9d,0xd6,0x80,0x53,0xe8,0x25,0x06,0x67,0xe8,0xee},
    {0x50,0x31,0x1f,0x00,0x1f,0xaa,0xbc,0xa0,0x3b,0xa7,0x5b,0x2d,0x59,0xcc,0xc6,0xba,
     0x53,0x9a,0x1c,0x4d,0x69,0x27,0x2e,0xc2,0x38,0x8e,0x58,0xca,0xa6,0x55,0x69,0xe4},
    {0x4f,0x81,0x7a,0xa0,0xf0,0xda,0x04,0xfd,0xd4,0x4a,0xbb,0x55,0x56,0x82,0x5b,0x95,
     0xee,0xd2,0x69,0x63,0xae,0xd2,0x27,0x17,0x96,0x96,0xa4,0xa9,0x2a,0xf9,0x7b,0x60},
    {0x26,0x87,0x99,0x72,0xd8,0x93,0xe7,0x0f,0x0b,0xb7,0x79,0x80,0xf2,0xa1,0x39,0xe0,
     0x1d,0xee,0x14,0x1c,0x87,0xe0,0xb9,0x34,0x33,0x68,0xa2,0x39,0x94,0xee,0x51,0x78},
    {0x59,0xae,0x0e,0xee,0x25,0xfe,0x04,0x9a,0x16,0x5c,0x89,0x29,0x27,0x52,0x45,0xb4,
     0xda,0xf2,0x7b,0xb7,0x01,0x77,0x6b,0x5d,0x8e,0x85,0x5a,0xc0,0x3d,0x13,0xd3,0xa8},
    {0x0c,0xc5,0x4e,0x91,0xbb,0xea,0x1e,0xee,0x1f,0xc9,0x98,0x7e,0x11,0x9b,0xc3,0x9f,
     0x3d,0x10,0xfe,0x09,0x00,0x58,0x89,0x26,0x58,0xd9,0xa8,0x39,0x6c,0x68,0xa9,0x55},
    {0x49,0x55,0xc8,0x0e,0xd3,0xa8,0x68,0x02,0xe1,0xb8,0xb1,0x53,0x58,0xa4,0x4b,0x00,
     0x26,0xf4,0x2c,0xd6,0x60,0x30,0xcd,0x14,0xbc,0xa6,0x3e,0x42,0x7e,0xcd,0xf9,0x8d},
    {0x45,0x5d,0x5a,0x07,0xdb,0x77,0xcd,0x5d,0x70,0x67,0x54,0xc8,0x90,0xfe,0xe1,0x05,
     0xe1,0x89,0x99,0x22,0x1c,0x75,0x2c,0x5e,0x6d,0xc1,0x9e,0xb2,0xe3,0x92,0x43,0x6c},
};
#endif

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

    status = generate_intermediate_tbs_der(pubkey_x, pubkey_y,
                                           CLUSTER_BLS_L3_NODE_ID,
                                           CLUSTER_BLS_L2_NODE_ID, tbs_der,
                                           &tbs_len, CERT_TYPE_ROOT_CA);
    if(!status && tbs_len <= sizeof(tbs_der) &&
       tbs_len <= sizeof(cert_store[0].der_data)) {
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

static void sha384_canonical(const uint8_t *data, size_t data_len,
                             uint8_t digest[48]) {
    uint64_t words[6] = {0};
    sha384_digest((uint8_t *)data, data_len, words, true);
    for (size_t i = 0; i < 6; ++i) {
        for (size_t j = 0; j < 8; ++j) {
            digest[i * 8 + j] = (uint8_t)(words[i] >> (56 - j * 8));
        }
    }
    memset(words, 0, sizeof(words));
}

static bool ecdsa_verify_der_length(const uint8_t **cursor,
                                    const uint8_t *end,
                                    size_t *length) {
    size_t value = 0U;
    uint8_t first;
    size_t count;

    if (cursor == NULL || *cursor == NULL || end == NULL || length == NULL ||
        *cursor >= end) {
        return false;
    }
    first = *(*cursor)++;
    if ((first & 0x80U) == 0U) {
        value = first;
    } else {
        count = first & 0x7fU;
        if (count == 0U || count > sizeof(size_t) ||
            (size_t)(end - *cursor) < count || (*cursor)[0] == 0U) {
            return false;
        }
        while (count-- != 0U) {
            value = (value << 8U) | *(*cursor)++;
        }
        if (value < 128U) {
            return false;
        }
    }
    if (value > (size_t)(end - *cursor)) {
        return false;
    }
    *length = value;
    return true;
}

static bool ecdsa_verify_der_integer(const uint8_t **cursor,
                                     const uint8_t *end,
                                     uint8_t value[ECC_BYTES]) {
    size_t length;

    if (cursor == NULL || *cursor == NULL || *cursor >= end ||
        *(*cursor)++ != 0x02U ||
        !ecdsa_verify_der_length(cursor, end, &length) || length == 0U) {
        return false;
    }
    if (length > 1U && **cursor == 0U) {
        ++*cursor;
        --length;
    }
    if (length > ECC_BYTES || length > (size_t)(end - *cursor)) {
        return false;
    }
    memset(value, 0, ECC_BYTES);
    memcpy(value + ECC_BYTES - length, *cursor, length);
    *cursor += length;
    return true;
}

static bool ecdsa_prepare_certificate_verify(
    const uint8_t *certificate, size_t certificate_len,
    const uint8_t **tbs, size_t *tbs_length,
    uint8_t signature[ECC_BYTES * 2U]) {
    static const uint8_t kSignatureAlgorithm[] = {
        0x30, 0x0a, 0x06, 0x08, 0x2a, 0x86,
        0x48, 0xce, 0x3d, 0x04, 0x03, 0x03,
    };
    const uint8_t *cursor;
    const uint8_t *end;
    const uint8_t *bit_string_end;
    const uint8_t *sequence_end;
    size_t length;

    if (certificate == NULL || tbs == NULL || tbs_length == NULL ||
        signature == NULL ||
        x509_get_tbs_der(certificate, certificate_len, tbs, tbs_length) != 0) {
        return false;
    }
    end = certificate + certificate_len;
    cursor = *tbs + *tbs_length;
    if ((size_t)(end - cursor) < sizeof(kSignatureAlgorithm) ||
        memcmp(cursor, kSignatureAlgorithm, sizeof(kSignatureAlgorithm)) != 0) {
        return false;
    }
    cursor += sizeof(kSignatureAlgorithm);
    if (cursor >= end || *cursor++ != 0x03U ||
        !ecdsa_verify_der_length(&cursor, end, &length) || length < 1U) {
        return false;
    }
    bit_string_end = cursor + length;
    if (*cursor++ != 0U || cursor >= bit_string_end || *cursor++ != 0x30U ||
        !ecdsa_verify_der_length(&cursor, bit_string_end, &length)) {
        return false;
    }
    sequence_end = cursor + length;
    if (sequence_end != bit_string_end ||
        !ecdsa_verify_der_integer(&cursor, sequence_end, signature) ||
        !ecdsa_verify_der_integer(&cursor, sequence_end,
                                  signature + ECC_BYTES) ||
        cursor != sequence_end) {
        return false;
    }
    return true;
}

static void ecdsa_verify_put_u32(uint8_t out[4], uint32_t value) {
    out[0] = (uint8_t)(value >> 24U);
    out[1] = (uint8_t)(value >> 16U);
    out[2] = (uint8_t)(value >> 8U);
    out[3] = (uint8_t)value;
}

static void ecdsa_verify_put_u64(uint8_t out[8], uint64_t value) {
    for (size_t i = 0U; i < 8U; ++i) {
        out[7U - i] = (uint8_t)value;
        value >>= 8U;
    }
}

static void ecdsa_verify_l1_certificates(mbox_op_s *op) {
    uint8_t request[4];
    uint8_t response[24] = {0};
    uint8_t digest[ECC_BYTES];
    uint8_t certificate_signature[ECC_BYTES * 2U];
    const uint8_t *tbs = NULL;
    size_t tbs_length = 0U;
    uint32_t requested = 0U;
    uint32_t completed = 0U;
    uint32_t status = 1U;
    uint64_t start = 0U;
    uint64_t elapsed = 0U;

    memcpy(response, "EVR2", 4U);
    if (read_mailbox_exact(op, request, sizeof(request))) {
        requested = ((uint32_t)request[0] << 24U) |
                    ((uint32_t)request[1] << 16U) |
                    ((uint32_t)request[2] << 8U) | request[3];
        if ((requested == 10U || requested == 100U ||
             requested == 1000U || requested == 10000U) &&
            cert_store[2].der_len != 0U &&
            cert_store[2].der_len <= sizeof(cert_store[2].der_data) &&
            ecdsa_prepare_certificate_verify(
                cert_store[2].der_data, cert_store[2].der_len, &tbs,
                &tbs_length, certificate_signature)) {
            status = 0U;
            start = get_mcycle();
            while (completed < requested) {
                uint64_t words[6] = {0};
                sha384_digest((uint8_t *)tbs, tbs_length, words, false);
                for (size_t i = 0U; i < 6U; ++i) {
                    for (size_t j = 0U; j < 8U; ++j) {
                        digest[i * 8U + j] =
                            (uint8_t)(words[i] >> (56U - j * 8U));
                    }
                }
                if (ecdsa_verify(public_key, digest,
                                 certificate_signature) != 1) {
                    status = 2U;
                    break;
                }
                ++completed;
            }
            elapsed = get_mcycle() - start;
        }
    }
    ecdsa_verify_put_u32(response + 4U, status);
    ecdsa_verify_put_u32(response + 8U, requested);
    ecdsa_verify_put_u32(response + 12U, completed);
    ecdsa_verify_put_u64(response + 16U, elapsed);
    cluster_bls_send_consumed(response, sizeof(response));
}

int sign_1st_cert() {
    uint8_t digest[48];

    sha384_canonical(tbs_der, tbs_len, digest);
    printf("digest:\n");
    for(int j = 0; j < 48; j++) {
        printf("%02x", digest[j]);
    }
    printf("\n");

    int ret = ecdsa_sign(private_key, digest, signature);
    if (ret != 1) {
        printf("ECDSA-P384 sign failed! ret = %d\n", ret);
        return 0;
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

    ret = add_signature_to_cert(tbs_der, tbs_len, sig_r, sig_s, cert_der,
                                &cert_len);
    return ret == 0;
}

#if defined(__GNUC__) || defined(__clang__)
#define CLUSTER_BLS_WEAK __attribute__((weak))
#else
#define CLUSTER_BLS_WEAK
#endif

CLUSTER_BLS_WEAK bool cluster_bls_platform_derive_l2_ikm(
    uint8_t out[kOtBlsMinIkmBytes]) {
    /* Demo only: this fixed IKM matches the verifier's pre-provisioned L2
     * public key. Restore the CDI derivation after the demo. */
    static const uint8_t kL2DemoIkm[kOtBlsMinIkmBytes] = {
        0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
        0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f,
        0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
        0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
    };

    if (out == NULL) {
        return false;
    }
    memcpy(out, kL2DemoIkm, sizeof(kL2DemoIkm));
    return true;
}

static bool cluster_bls_l2_initialize(void) {
    static const uint8_t kL2DemoSecretKey[kOtBlsSecretKeyBytes] = {
        0x35, 0xc6, 0x4f, 0xa4, 0xea, 0x10, 0x24, 0x40,
        0xbd, 0x88, 0x3e, 0x00, 0x85, 0xa9, 0x4a, 0xe2,
        0x4b, 0xbf, 0xe9, 0xa7, 0x56, 0xfc, 0xe8, 0x55,
        0x8e, 0xaf, 0x40, 0x22, 0x06, 0x44, 0xeb, 0xb2,
    };
    static const uint8_t kL2DemoPublicKey[kOtBlsPublicKeyBytes] = {
        0x93, 0x93, 0x6c, 0xe6, 0xa8, 0xe8, 0x67, 0x87,
        0xfd, 0x90, 0x38, 0xf2, 0x0a, 0xbf, 0x65, 0x07,
        0x5a, 0xaf, 0x4c, 0x52, 0x20, 0x9a, 0xfb, 0xa0,
        0xec, 0x69, 0x83, 0x3d, 0x3d, 0x37, 0xdc, 0x26,
        0x3d, 0xb8, 0x74, 0x14, 0x6c, 0x85, 0xca, 0x47,
        0x5c, 0x4b, 0x2d, 0x17, 0xab, 0x87, 0x72, 0xed,
    };
    static const uint8_t kL2DemoProof[kOtBlsSignatureBytes] = {
        0x87, 0x7b, 0x18, 0x73, 0x09, 0x73, 0x0d, 0x5f,
        0xc7, 0x86, 0x39, 0xee, 0x60, 0x08, 0x3a, 0xd2,
        0x42, 0xec, 0x72, 0xb9, 0xb5, 0x5d, 0x8f, 0x18,
        0x4a, 0xc0, 0x85, 0x3e, 0x1a, 0xa8, 0x25, 0x74,
        0xdc, 0x29, 0xb9, 0xa7, 0xcc, 0xf6, 0xbb, 0xbd,
        0xa0, 0x67, 0xc2, 0xda, 0xfd, 0x91, 0x77, 0x42,
        0x11, 0x3d, 0xb0, 0xcc, 0xd0, 0x91, 0x96, 0x71,
        0x4c, 0xd3, 0x31, 0x39, 0xda, 0x6a, 0x7a, 0x91,
        0x5f, 0xde, 0x65, 0xd5, 0xc5, 0xca, 0x53, 0x01,
        0xbd, 0x53, 0x6d, 0xe2, 0x08, 0x07, 0x35, 0x48,
        0x25, 0x89, 0xc2, 0x0b, 0xb7, 0x76, 0x09, 0x32,
        0x5f, 0xc8, 0xd0, 0x18, 0x76, 0x39, 0x54, 0xa2,
    };
    static const uint8_t kL2DemoKeyId[kClusterBlsKeyIdBytes] = {
        0x35, 0xf9, 0x6c, 0x8a, 0xf6, 0x70, 0x6c, 0xee,
        0x22, 0x36, 0x95, 0x40, 0xcb, 0x0d, 0x9c, 0x3a,
    };
    cluster_bls_signer_t *signer = &cluster_bls_l2.signer;

    /* Demo mode uses pre-provisioned key material.  Do not run the expensive
     * BLS12-381 key-generation and PoP calculation before the legacy mailbox
     * loop starts. */
    memset(&cluster_bls_l2, 0, sizeof(cluster_bls_l2));
    memcpy(signer->secret_key, kL2DemoSecretKey, sizeof(kL2DemoSecretKey));
    memcpy(signer->public_key, kL2DemoPublicKey, sizeof(kL2DemoPublicKey));
    memcpy(signer->proof_of_possession, kL2DemoProof, sizeof(kL2DemoProof));
    memcpy(signer->key_id, kL2DemoKeyId, sizeof(kL2DemoKeyId));
    signer->initialized = true;
    printf("WARNING: L2 BLS uses a fixed insecure demo key\n");
    return true;
}

/* Keep BLS completely off the original certificate/mailbox path.  The fixed
 * demo signer is initialized only after a dedicated BLS command arrives. */
static bool cluster_bls_l2_ensure_ready(void) {
    if (!cluster_bls_l2_ready) {
        cluster_bls_l2_ready = cluster_bls_l2_initialize();
    }
    return cluster_bls_l2_ready;
}

static bool cluster_bls_registration_equal(
    const cluster_bls_registration_t *left,
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

static uint32_t validate_l2_certificate_from_l3(
    const uint8_t *certificate, size_t certificate_len,
    const uint8_t l3_public_key[ECC_BYTES + 1]) {
    const uint8_t *certificate_tbs = NULL;
    size_t certificate_tbs_len = 0;
    cluster_bls_registration_t expected;
    cluster_bls_registration_t embedded;

    if (certificate == NULL || l3_public_key == NULL) {
        return kL2CertificateErrorArgument;
    }
    if (!cluster_bls_l2_ensure_ready()) {
        return kL2CertificateErrorBlsInit;
    }
    if (x509_get_tbs_der(certificate, certificate_len, &certificate_tbs,
                         &certificate_tbs_len) != 0) {
        return kL2CertificateErrorTbs;
    }
    if (!cluster_bls_l2_registration(&cluster_bls_l2, &expected)) {
        return kL2CertificateErrorRegistration;
    }
    if (!cluster_bls_certificate_binding_decode(
            certificate_tbs, certificate_tbs_len, &embedded)) {
        return kL2CertificateErrorBindingDecode;
    }
    if (!cluster_bls_registration_equal(&expected, &embedded)) {
        return kL2CertificateErrorBindingMismatch;
    }
    if (verify_cert(certificate, certificate_len, l3_public_key) != 1) {
        return kL2CertificateErrorSignature;
    }
    return MBOX_SUCCESS;
}

static bool read_mailbox_bytes(mbox_op_s *op, uint8_t *out, size_t byte_count) {
    size_t offset = 0;
    uint32_t word;

    if (op == NULL || out == NULL || op->dlen < byte_count) {
        return false;
    }
    while (offset < byte_count) {
        size_t chunk = byte_count - offset;
        word = soc_ifc_mbox_read_dataout_single();
        if (chunk > sizeof(word)) {
            chunk = sizeof(word);
        }
        for (size_t i = 0; i < chunk; ++i) {
            out[offset + i] = (uint8_t)(word >> (8 * i));
        }
        offset += chunk;
    }
    op->dlen -= byte_count;
    return true;
}

static bool read_mailbox_exact(mbox_op_s *op, uint8_t *out, size_t expected_len) {
    return op != NULL && op->dlen == expected_len &&
           read_mailbox_bytes(op, out, expected_len);
}

static bool cluster_bls_send_consumed(const uint8_t *data, size_t length) {
    if (data == NULL || length == 0U || length > UINT32_MAX) {
        return false;
    }
    lsu_write_32(CLP_MBOX_CSR_MBOX_CMD, MBOX_CMD_RECV_SOC_FW);
    lsu_write_32(CLP_MBOX_CSR_MBOX_DLEN, (uint32_t)length);
    for (size_t offset = 0U; offset < length; offset += sizeof(uint32_t)) {
        uint32_t word = 0U;
        size_t chunk = length - offset;
        if (chunk > sizeof(word)) {
            chunk = sizeof(word);
        }
        for (size_t i = 0U; i < chunk; ++i) {
            word |= (uint32_t)data[offset + i] << (8U * i);
        }
        lsu_write_32(CLP_MBOX_CSR_MBOX_DATAIN, word);
    }
    soc_ifc_set_mbox_status_field(DATA_READY);
    return true;
}

static bool read_bls_aggregate_request(mbox_op_s *op,
                                       uint8_t challenge_digest[kClusterBlsDigestBytes],
                                       uint8_t *child_signatures,
                                       size_t *child_signature_count) {
    size_t total_len;
    size_t child_len;

    if (op == NULL || challenge_digest == NULL || child_signatures == NULL ||
        child_signature_count == NULL || op->dlen < kClusterBlsDigestBytes) {
        return false;
    }
    total_len = op->dlen;
    child_len = total_len - kClusterBlsDigestBytes;
    if (child_len % kOtBlsSignatureBytes != 0 ||
        child_len / kOtBlsSignatureBytes > kClusterBlsL2MaxDirectChildren) {
        return false;
    }
    if (!read_mailbox_bytes(op, challenge_digest, kClusterBlsDigestBytes)) {
        return false;
    }
    /* The mailbox reader consumes one command payload in sequence.  Copy the
     * signatures manually because the initial digest has already been read. */
    if (!read_mailbox_exact(op, child_signatures, child_len)) {
        return false;
    }
    *child_signature_count = child_len / kOtBlsSignatureBytes;
    return true;
}

#if CLUSTER_BLS_SCALE_TEST_ENABLE
static void cluster_bls_scale_put_u64(uint8_t out[8], uint64_t value) {
    for (size_t i = 0U; i < 8U; ++i) {
        out[7U - i] = (uint8_t)value;
        value >>= 8;
    }
}

static uint32_t cluster_bls_l2_scale_aggregate(mbox_op_s *op,
                                             bool *request_consumed) {
    uint8_t *request = cluster_bls_certificate_request;
    uint8_t *signatures = request + 40U;
    uint8_t *cache_digest =
        request + kClusterBlsScaleCacheDigestOffset;
    uint8_t *cache_mask = request + kClusterBlsScaleCacheMaskOffset;
    uint8_t *cache_signatures =
        request + kClusterBlsScaleCacheSignaturesOffset;
    uint8_t reply[CLUSTER_BLS_SCALE_RESPONSE_BYTES] = {0};
    uint32_t group;
    uint32_t slot;
    uint32_t mask;
    uint64_t start;
    bool ok;

    if (!cluster_bls_l2_ensure_ready()) {
        return kClusterBlsL2AggregateErrorInit;
    }
    *request_consumed = read_mailbox_exact(
        op, request, CLUSTER_BLS_SCALE_REQUEST_BYTES);
    if (!*request_consumed || memcmp(request, "SCA2", 4U) != 0) {
        return kClusterBlsL2AggregateErrorRequest;
    }
    group = ((uint32_t)request[4] << 24) |
            ((uint32_t)request[5] << 16) |
            ((uint32_t)request[6] << 8) | request[7];
    if (group == 0U || group > CLUSTER_BLS_SCALE_MAX_GROUPS) {
        return kClusterBlsL2AggregateErrorArgument;
    }
    slot = (group - 1U) % kClusterBlsScaleCachedL2Keys;
    if (memcmp(request + kClusterBlsScaleWorkBytes, "SC2C", 4U) != 0 ||
        memcmp(cache_digest, request + 8U, kClusterBlsDigestBytes) != 0) {
        memcpy(request + kClusterBlsScaleWorkBytes, "SC2C", 4U);
        memcpy(cache_digest, request + 8U, kClusterBlsDigestBytes);
        memset(cache_mask, 0, 4U);
    }
    mask = ((uint32_t)cache_mask[0] << 24) |
           ((uint32_t)cache_mask[1] << 16) |
           ((uint32_t)cache_mask[2] << 8) | cache_mask[3];
    memcpy(reply, request + 4U, 4U);
    cluster_bls_scale_put_u64(reply + 4U, 0U);
    if ((mask & (1U << slot)) != 0U) {
        memcpy(signatures + CLUSTER_BLS_SCALE_CHILDREN *
                            kOtBlsSignatureBytes,
               cache_signatures + slot * kOtBlsSignatureBytes,
               kOtBlsSignatureBytes);
    } else {
        start = get_mcycle();
        ok = ot_bls_pop_sign(kClusterBlsScaleL2SecretKeys[slot],
                             request + 8U, kClusterBlsDigestBytes,
                             signatures + CLUSTER_BLS_SCALE_CHILDREN *
                                          kOtBlsSignatureBytes);
        cluster_bls_scale_put_u64(reply + 12U, get_mcycle() - start);
        if (!ok) {
            return kClusterBlsL2AggregateErrorSigning;
        }
        memcpy(cache_signatures + slot * kOtBlsSignatureBytes,
               signatures + CLUSTER_BLS_SCALE_CHILDREN *
                            kOtBlsSignatureBytes,
               kOtBlsSignatureBytes);
        mask |= 1U << slot;
        cache_mask[0] = (uint8_t)(mask >> 24);
        cache_mask[1] = (uint8_t)(mask >> 16);
        cache_mask[2] = (uint8_t)(mask >> 8);
        cache_mask[3] = (uint8_t)mask;
    }
    start = get_mcycle();
    ok = cluster_bls_aggregate(signatures, CLUSTER_BLS_SCALE_CHILDREN + 1U,
                               reply + 28U);
    cluster_bls_scale_put_u64(reply + 20U, get_mcycle() - start);
    if (!ok) {
        return kClusterBlsL2AggregateErrorCombinedPoint;
    }
    if (!cluster_bls_send_consumed(reply, sizeof(reply))) {
        return kClusterBlsL2AggregateErrorRequest;
    }
    return kClusterBlsL2AggregateOk;
}
#endif

static uint32_t sign_l1_certificate_with_bls_binding(
    mbox_op_s *op, bool *request_consumed) {
    cluster_bls_registration_t registration;
    const uint8_t *l1_tbs_der;
    size_t l1_tbs_len;
    size_t signed_tbs_len = sizeof(tbs_der);
    size_t request_len;
    size_t tbs_offset = kClusterBlsCertificateRequestHeaderBytes +
                        kClusterBlsRegistrationWireBytes;

    if (request_consumed != NULL) {
        *request_consumed = false;
    }
    if (op == NULL || request_consumed == NULL ||
        !cluster_bls_l2_ensure_ready()) {
        return kL1CertificateErrorBlsInit;
    }
    request_len = op->dlen;
    printf("BLS L1 CBR1 mailbox dlen=0x%x, min=0x%x, max=0x%x\n",
           (unsigned int)request_len, (unsigned int)tbs_offset,
           (unsigned int)sizeof(cluster_bls_certificate_request));
    if (request_len < tbs_offset ||
        request_len > sizeof(cluster_bls_certificate_request)) {
        return kL1CertificateErrorRequest;
    }
    if (!read_mailbox_exact(op, cluster_bls_certificate_request,
                            request_len)) {
        return kL1CertificateErrorMailbox;
    }
    *request_consumed = true;
    l1_tbs_len = ((size_t)cluster_bls_certificate_request[5] << 8) |
                 cluster_bls_certificate_request[6];
    if (memcmp(cluster_bls_certificate_request, "CBR1", 4) != 0 ||
        cluster_bls_certificate_request[4] != kClusterBlsProtocolVersion ||
        l1_tbs_len == 0 || request_len != tbs_offset + l1_tbs_len) {
        return kL1CertificateErrorHeader;
    }
    if (!cluster_bls_registration_decode(
            cluster_bls_certificate_request +
                kClusterBlsCertificateRequestHeaderBytes,
            &registration)) {
        return kL1CertificateErrorBlsRegistration;
    }
    l1_tbs_der = cluster_bls_certificate_request + tbs_offset;
    /* Decode succeeds only after PoP verification.  Add the key to the
     * active child set only after certificate construction succeeds. */
    if (!cluster_bls_x509_append_binding(l1_tbs_der, l1_tbs_len, &registration,
                                         tbs_der, &signed_tbs_len)) {
        return kL1CertificateErrorBinding;
    }
    tbs_len = signed_tbs_len;
    cert_len = sizeof(cert_der);
    memset(cert_der, 0, sizeof(cert_der));
    if (!sign_1st_cert() || cert_len == 0 || cert_len > sizeof(cert_der) ||
        cert_len > sizeof(cert_store[2].der_data)) {
        return kL1CertificateErrorSigning;
    }
    if (!cluster_bls_l2_register_l1(&cluster_bls_l2, &registration)) {
        return kL1CertificateErrorRegistration;
    }
    cert_store[2].der_len = cert_len;
    cert_store[2].type = CERT_TYPE_LDEVID;
    memcpy(cert_store[2].der_data, cert_der, cert_len);
    mailbox_send_data((uint32_t *)cert_der, cert_len);
    return MBOX_SUCCESS;
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
        while ((lsu_read_32(CLP_MBOX_CSR_MBOX_EXECUTE) &
                MBOX_CSR_MBOX_EXECUTE_EXECUTE_MASK) !=
               MBOX_CSR_MBOX_EXECUTE_EXECUTE_MASK);
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
            else if (op.cmd == MBOX_CMD_ECDSA_SCALE_SIGN) {
                uint8_t request[ECDSA_SCALE_REQUEST_BYTES];
                uint32_t response_words[
                    ECDSA_SCALE_RESPONSE_BYTES / sizeof(uint32_t)] = {0};
                uint32_t result = MBOX_FAILED;
                bool request_consumed = read_mailbox_exact(
                    &op, request, sizeof(request));
                if (request_consumed &&
                    ecdsa_scale_caliptra_sign(
                        2U, request, sizeof(request),
                        (uint8_t *)response_words)) {
                    cluster_bls_send_consumed(
                        (const uint8_t *)response_words,
                        sizeof(response_words));
                } else if (request_consumed) {
                    cluster_bls_send_consumed((const uint8_t *)&result,
                                              sizeof(result));
                } else {
                    mailbox_send_data(&result, sizeof(result));
                }
            }
            else if (op.cmd == MBOX_CMD_ECDSA_CERT_VERIFY) {
                ecdsa_verify_l1_certificates(&op);
            }
            else if (op.cmd == MBOX_CMD_BLS_GET_REGISTRATION) {
                cluster_bls_registration_t registration;
                uint8_t registration_wire[kClusterBlsRegistrationWireBytes];
                if (op.dlen != 0 || !cluster_bls_l2_ensure_ready() ||
                    !cluster_bls_l2_registration(&cluster_bls_l2, &registration) ||
                    !cluster_bls_registration_encode(&registration,
                                                     registration_wire)) {
                    uint32_t result = MBOX_FAILED;
                    printf("BLS L2 registration request rejected\n");
                    mailbox_send_data(&result, sizeof(result));
                } else {
                    mailbox_send_data((uint32_t *)registration_wire,
                                      sizeof(registration_wire));
                }
            }
            else if (op.cmd == MBOX_CMD_BLS_REGISTER_L1) {
                uint8_t registration_wire[kClusterBlsRegistrationWireBytes];
                cluster_bls_registration_t registration;
                uint32_t result = MBOX_FAILED;
                bool request_consumed = false;
                if (cluster_bls_l2_ensure_ready()) {
                    request_consumed = read_mailbox_exact(
                        &op, registration_wire, sizeof(registration_wire));
                    if (request_consumed &&
                        cluster_bls_registration_decode(registration_wire,
                                                        &registration) &&
                        cluster_bls_l2_register_l1(&cluster_bls_l2,
                                                   &registration)) {
                        result = MBOX_SUCCESS;
                    }
                }
                if (request_consumed) {
                    mailbox_send_data(&result, sizeof(result));
                } else {
                    mailbox_send_data(&result, sizeof(result));
                }
            }
            else if (op.cmd == MBOX_CMD_BLS_REVOKE_L1) {
                uint8_t key_id[kClusterBlsKeyIdBytes];
                uint32_t result = MBOX_FAILED;
                bool request_consumed = false;
                if (cluster_bls_l2_ensure_ready()) {
                    request_consumed = read_mailbox_exact(
                        &op, key_id, sizeof(key_id));
                    if (request_consumed &&
                        cluster_bls_l2_revoke_l1(&cluster_bls_l2, key_id)) {
                        result = MBOX_SUCCESS;
                    }
                }
                if (request_consumed) {
                    mailbox_send_data(&result, sizeof(result));
                } else {
                    mailbox_send_data(&result, sizeof(result));
                }
            }
            else if (op.cmd == MBOX_CMD_BLS_SIGN_CHALLENGE) {
                uint8_t challenge_digest[kClusterBlsDigestBytes];
                uint8_t signature_out[kOtBlsSignatureBytes];
                bool request_consumed = false;
                if (cluster_bls_l2_ensure_ready()) {
                    request_consumed = read_mailbox_exact(
                        &op, challenge_digest, sizeof(challenge_digest));
                }
                if (request_consumed &&
                    cluster_bls_l2_sign_challenge(&cluster_bls_l2,
                                                  challenge_digest,
                                                  signature_out)) {
                    mailbox_send_data((uint32_t *)signature_out,
                                      sizeof(signature_out));
                } else {
                    uint32_t result = MBOX_FAILED;
                    printf("BLS L2 challenge rejected\n");
                    if (request_consumed) {
                        mailbox_send_data(&result, sizeof(result));
                    } else {
                        mailbox_send_data(&result, sizeof(result));
                    }
                }
            }
            else if (op.cmd == MBOX_CMD_BLS_AGGREGATE_CHALLENGE) {
                uint8_t challenge_digest[kClusterBlsDigestBytes];
                uint8_t aggregate_signature[kOtBlsSignatureBytes];
                size_t child_signature_count = 0;
                bool request_consumed = false;
                bool response_sent = false;
                uint32_t result = kClusterBlsL2AggregateErrorInit;
#if CLUSTER_BLS_SCALE_TEST_ENABLE
                if (op.dlen == CLUSTER_BLS_SCALE_REQUEST_BYTES) {
                    result = cluster_bls_l2_scale_aggregate(
                        &op, &request_consumed);
                    response_sent = result == kClusterBlsL2AggregateOk;
                } else
#endif
                if (cluster_bls_l2_ensure_ready()) {
                    result = kClusterBlsL2AggregateErrorRequest;
                    request_consumed = read_bls_aggregate_request(
                        &op, challenge_digest,
                        cluster_bls_child_signatures,
                        &child_signature_count);
                    if (request_consumed) {
                        result = cluster_bls_l2_aggregate_challenge(
                            &cluster_bls_l2, challenge_digest,
                            cluster_bls_child_signatures,
                            child_signature_count,
                            aggregate_signature);
                    }
                }
                if (result == kClusterBlsL2AggregateOk) {
                    if (!response_sent) {
                        cluster_bls_send_consumed(aggregate_signature,
                                                  sizeof(aggregate_signature));
                    }
                } else {
                    printf("BLS L2 aggregate challenge rejected: 0x%08x\n",
                           (unsigned int)result);
                    if (request_consumed) {
                        cluster_bls_send_consumed((const uint8_t *)&result,
                                                  sizeof(result));
                    } else {
                        mailbox_send_data(&result, sizeof(result));
                    }
                }
            }
            else if (op.cmd == MBOX_CMD_BLS_SIGN_L1_CERT) {
                bool request_consumed = false;
                uint32_t result = sign_l1_certificate_with_bls_binding(
                    &op, &request_consumed);
                if (result != MBOX_SUCCESS) {
                    printf("BLS L1 certificate request rejected: 0x%08x\n",
                           (unsigned int)result);
                    if (request_consumed) {
                        mailbox_send_data(&result, sizeof(result));
                    } else {
                        mailbox_send_data(&result, sizeof(result));
                    }
                }
            }
            else if (op.cmd == MBOX_CMD_GENERATE_2ND_CERT) {
                memset(tbs_der, 0x0, tbs_len);
                memset(cert_der, 0x0, cert_len);
                mailbox_send_data((uint32_t *)cert_store[0].der_data, tbs_len);
            } 
            else if (op.cmd == MBOX_CMD_SIGN_1ST_CTX) {
                memset(tbs_der, 0x0, sizeof(tbs_der));
                memset(cert_der, 0x0, sizeof(cert_der));
                for (uint16_t slp = 0; slp < 333; slp++);
                printf("FW: Reading %08d bytes from mailbox\n", (unsigned int )op.dlen);
                if (op.dlen < 200 || op.dlen > sizeof(tbs_der)) {
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
                uint8_t *install = cluster_bls_certificate_request;
                uint8_t *l3_public_key =
                    install + kL2CertificateInstallMagicBytes;
                size_t install_len = op.dlen;

                memset(cert_der, 0, sizeof(cert_der));
                printf("FW: Reading %08d-byte authenticated L2 certificate install package\n",
                       (unsigned int)install_len);
                if (install_len <= kL2CertificateInstallHeaderBytes ||
                    install_len > sizeof(cluster_bls_certificate_request)) {
                    uint32_t result = MBOX_FAILED;
                    printf("Invalid L2 certificate install package\n");
                    mailbox_send_data(&result, sizeof(result));
                    continue;
                }
                if (!read_mailbox_exact(&op, install, install_len)) {
                    uint32_t result = MBOX_FAILED;
                    mailbox_send_data(&result, sizeof(result));
                    continue;
                }
                if (memcmp(install, kL2CertificateInstallMagic,
                           sizeof(kL2CertificateInstallMagic)) != 0) {
                    uint32_t result = MBOX_FAILED;
                    printf("Invalid L2 certificate install package\n");
                    mailbox_send_data(&result, sizeof(result));
                    continue;
                }
                cert_len = install_len - kL2CertificateInstallHeaderBytes;
                if (cert_len > sizeof(cert_der)) {
                    uint32_t result = MBOX_FAILED;
                    mailbox_send_data(&result, sizeof(result));
                    continue;
                }
                memcpy(cert_der, install + kL2CertificateInstallHeaderBytes,
                       cert_len);
                printf("2nd cert(cert_len = 0x%x):\n", cert_len);
                for(uint32_t i = 0; i < cert_len; i++) {
                    printf("%02x", cert_der[i]);
                }
                printf("\n");

                {
                    uint32_t result = validate_l2_certificate_from_l3(
                        cert_der, cert_len, l3_public_key);
                    if (result == MBOX_SUCCESS) {
                        cert_store[1].der_len = cert_len;
                        cert_store[1].type = CERT_TYPE_ROOT_CA;
                        memcpy(cert_store[1].der_data, cert_der, cert_len);
                        printf("2nd cert signature and BLS binding verified; save success\n");
                    } else {
                        printf("Rejected 2nd cert: status=0x%08x\n",
                               (unsigned int)result);
                    }
                    mailbox_send_data(&result, sizeof(result));
                }

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
                memset(cert_der, 0x0, sizeof(cert_der));
                for (uint16_t slp = 0; slp < 333; slp++);
                printf("FW: Reading %08d bytes from mailbox\n", (unsigned int )op.dlen);
                if (op.dlen < 400 || op.dlen > sizeof(cert_der)) {
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
