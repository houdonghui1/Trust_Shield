#ifndef __X509_H_
#define __X509_H_

#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <printf.h>
#include "sha384.h"
#include "ecdsa-p384.h"

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
    const uint8_t *tbs_der, size_t tbs_len,
    const uint8_t *sig_r,
    const uint8_t *sig_s,
    uint8_t *cert_out, size_t *cert_len
);

int verify_cert(
    const uint8_t *cert_der, 
    size_t cert_len, 
    const uint8_t public_key[ECC_BYTES + 1]
);

#endif