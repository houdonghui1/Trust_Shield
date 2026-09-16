#ifndef __X509_H_
#define __X509_H_

#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include "sw/device/my_tests/attestation/sha/sha384.h"
#include "sw/device/my_tests/attestation/sha/sha256.h"
#include "sw/device/my_tests/attestation/ecdsa-p384/ecc.h"
#include "sw/device/my_tests/attestation/bls/bls_opentitan.h"

#ifndef ASN1_BOOLEAN
#define ASN1_BOOLEAN        0x01
#endif
#ifndef ASN1_INTEGER
#define ASN1_INTEGER        0x02
#endif
#ifndef ASN1_BIT_STRING
#define ASN1_BIT_STRING     0x03
#endif
#ifndef ASN1_OCTET_STRING
#define ASN1_OCTET_STRING   0x04
#endif
#ifndef ASN1_NULL
#define ASN1_NULL           0x05
#endif
#ifndef ASN1_SEQUENCE
#define ASN1_SEQUENCE       0x30
#endif
#ifndef ASN1_SET
#define ASN1_SET            0x31
#endif
#ifndef ASN1_UTF8_STRING
#define ASN1_UTF8_STRING    0x0C
#endif
#ifndef ASN1_OID
#define ASN1_OID            0x06
#endif
#ifndef ASN1_CONSTRUCTED
#define ASN1_CONSTRUCTED    0x20
#endif
#ifndef ASN1_CONTEXT_SPECIFIC
#define ASN1_CONTEXT_SPECIFIC  0x80
#endif

#define X509_KU_DIGITAL_SIGNATURE  0x01
#define X509_KU_KEY_CERT_SIGN      0x04
#define PTR_DIFF(p1, p2)    ((size_t)((uintptr_t)(p1) - (uintptr_t)(p2)))
#define MAX_BUF_LEN         1024
#define X509_BLS_ROM_EXTENSION_VALUE_SIZE \
    (2 + SHA256_DIGEST_SIZE + 2 + kOtBlsSignatureBytes)
#define X509_CLUSTER_BLS_PROTOCOL_VERSION 1U
#define X509_CLUSTER_BLS_KEY_ID_BYTES 16U

/* DER encoding of private OID 1.3.6.1.4.1.55555.1.1. */
#define X509_CLUSTER_BLS_OID_DER_BYTES \
    "\x2B\x06\x01\x04\x01\x83\xB2\x03\x01\x01"


#define LDEVID 0x1
#define FMC    0x2
#define RT     0x3

typedef enum {
    CERT_TYPE_ROOT_CA,
    CERT_TYPE_LDEVID,
    CERT_TYPE_FMC,
    CERT_TYPE_RT
} cert_type_t;

typedef struct {
    uint8_t der_data[512];
    size_t der_len;
    uint8_t type;
} cert_t;

extern cert_t tbs_der_store[4];

extern cert_t cert_store[4];

typedef struct {
    uint8_t *issuer;
    size_t issuer_len;
    uint8_t *subject;
    size_t subject_len;
    uint8_t *pubkey;
    size_t pubkey_len;
    uint8_t *signature;
    size_t signature_len;
    uint8_t *validity;
    size_t validity_len;
    uint8_t *serial;
    size_t serial_len;
} x509_cert_t;

int generate_intermediate_tbs_der(
    const uint32_t *pubkey_x,
    const uint32_t *pubkey_y,
    const char *issuer_name,
    const char *subject_name,
    uint8_t *tbs_out,
    size_t *tbs_len,
    cert_type_t cert_type
);

int add_signature_to_cert(
    const uint8_t *tbs_der,
    size_t tbs_len,
    const uint32_t *sig_r,
    const uint32_t *sig_s,
    uint8_t *cert_out,
    size_t *cert_len
);

int add_signature_to_cert_p384_sig(
    const uint8_t *tbs_der,
    size_t tbs_len,
    const uint8_t *sig_r_bytes,
    const uint8_t *sig_s_bytes,
    uint8_t *cert_out,
    size_t *cert_len
);

/*
 * Adds the ROM measurement extension to an existing certificate TBS.
 * The extension value is:
 *   SEQUENCE { OCTET STRING rom_sha256, OCTET STRING bls_signature }
 */
int add_bls_rom_extension_to_tbs(
    const uint8_t *tbs_der,
    size_t tbs_len,
    const uint8_t rom_sha256[SHA256_DIGEST_SIZE],
    const uint8_t bls_signature[kOtBlsSignatureBytes],
    uint8_t *tbs_out,
    size_t *tbs_out_len
);

/**
 * Extracts the ROM measurement and corresponding BLS signature from a certificate
 * extension encoded with the ROM BLS extension OID.
 */
int extract_bls_rom_extension_from_cert(
    const uint8_t *cert_der,
    size_t cert_len,
    uint8_t rom_sha256[SHA256_DIGEST_SIZE],
    uint8_t bls_signature[kOtBlsSignatureBytes]
);

/**
 * Verifies the ROM BLS extension against the provided BLS public key.
 */
bool verify_bls_rom_extension(
    const uint8_t *cert_der,
    size_t cert_len,
    const uint8_t bls_public_key[kOtBlsPublicKeyBytes]
);

/*
 * The cluster protocol binds a subject's BLS public key and proof of
 * possession into a non-critical X.509 extension.  Its extnValue is:
 *
 * SEQUENCE {
 *   INTEGER 1,
 *   UTF8String "BLS12381G2_XMD:SHA-256_SSWU_RO_POP_",
 *   OCTET STRING keyID (16 bytes),
 *   OCTET STRING publicKey (48 bytes),
 *   OCTET STRING proofOfPossession (96 bytes)
 * }
 */
int add_cluster_bls_binding_extension_to_tbs(
    const uint8_t *tbs_der, size_t tbs_len,
    const uint8_t key_id[X509_CLUSTER_BLS_KEY_ID_BYTES],
    const uint8_t public_key[kOtBlsPublicKeyBytes],
    const uint8_t proof_of_possession[kOtBlsSignatureBytes],
    uint8_t *tbs_out, size_t *tbs_out_len);

int extract_cluster_bls_binding_from_cert(
    const uint8_t *cert_der, size_t cert_len,
    uint8_t key_id[X509_CLUSTER_BLS_KEY_ID_BYTES],
    uint8_t public_key[kOtBlsPublicKeyBytes],
    uint8_t proof_of_possession[kOtBlsSignatureBytes]);

bool verify_cluster_bls_binding(const uint8_t *cert_der, size_t cert_len);

int verify_cert(
    const uint8_t *cert_der, 
    size_t cert_len, 
    const uint8_t public_key[ECC_BYTES + 1]
);

int x509_get_tbs_der(const uint8_t *cert_der, size_t cert_len,
                     const uint8_t **tbs_der, size_t *tbs_len);

#endif
