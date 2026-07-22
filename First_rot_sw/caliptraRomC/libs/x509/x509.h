#ifndef __X509_H_
#define __X509_H_

#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include "printf.h"
#include "datavault.h"
#include "sha256.h"

#define ASN1_SEQUENCE       0x30
#define ASN1_INTEGER        0x02
#define ASN1_BIT_STRING     0x03
#define ASN1_OCTET_STRING   0x04
#define ASN1_OID            0x06
#define ASN1_UTF8_STRING    0x0C
#define ASN1_SET            0x31
#define ASN1_CONTEXT_SPECIFIC 0xA0

#define X509_EXT_BASIC_CONSTRAINTS_CA   0x01
#define X509_EXT_KEY_USAGE_DIGITAL_SIGN 0x02

#define LDEVID 0x1
#define FMC    0x2
#define RT     0x3

typedef enum {
    CERT_TYPE_ROOT_CA,
    CERT_TYPE_LDEVID,
    CERT_TYPE_FMC,
    CERT_TYPE_RT
} cert_type_t;

// 证书结构体
typedef struct {
    uint8_t der_data[512]; // 证书 DER 数据
    size_t der_len;         // 证书长度
    uint8_t type;           // 证书类型 (CA,LDEVID, FMC, RT)
} cert_t;

extern cert_t tbs_der_store[4];

extern cert_t cert_store[4];

// 证书关键字段结构体
typedef struct {
    uint8_t *issuer;        // 颁发者名称
    size_t issuer_len;
    uint8_t *subject;       // 主题名称
    size_t subject_len;
    uint8_t *pubkey;        // 公钥
    size_t pubkey_len;
    uint8_t *signature;     // 签名
    size_t signature_len;
    uint8_t *validity;      // 有效期
    size_t validity_len;
    uint8_t *serial;        // 序列号
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

int parse_tbs_certificate(const uint8_t **p, x509_cert_t *cert);

int parse_x509_cert(const uint8_t *der_data, size_t der_len, x509_cert_t *cert, bool parse_full);

#endif