#include "x509.h"
#include <stdint.h>
#include <string.h>
#include <stddef.h>


#define PTR_DIFF(p1, p2)    ((size_t)((uintptr_t)(p1) - (uintptr_t)(p2)))

size_t strlen(const char *s) {
    size_t len = 0;
    while (s[len] != '\0') len++;
    return len;
}

static void asn1_write_length(uint8_t **p, size_t length) {
    if (length <= 0x7F) {
        *(*p)++ = (uint8_t)length;
    } else if (length <= 0xFF) {
        *(*p)++ = 0x81;
        *(*p)++ = (uint8_t)length;
    } else {
        *(*p)++ = 0x82;
        *(*p)++ = (uint8_t)((length >> 8) & 0xFF);
        *(*p)++ = (uint8_t)(length & 0xFF);
    }
}

static void asn1_write_tag(uint8_t **p, uint8_t tag, const uint8_t *value, size_t len) {
    *(*p)++ = tag;
    asn1_write_length(p, len);
    if (len > 0 && value != NULL) {
        memcpy(*p, value, len);
        *p += len;
    }
}

static void encode_dn(uint8_t **p, const char *name) {
    uint8_t attr_seq[128];
    uint8_t *attr_seq_p = attr_seq;

    uint8_t oid_cn[] = {0x55, 0x04, 0x03}; 
    asn1_write_tag(&attr_seq_p, ASN1_OID, oid_cn, sizeof(oid_cn));

    size_t name_len = strlen(name);
    asn1_write_tag(&attr_seq_p, ASN1_UTF8_STRING, (const uint8_t*)name, name_len);

    uint8_t attr_wrapper[128];
    uint8_t *attr_wrapper_p = attr_wrapper;
    asn1_write_tag(&attr_wrapper_p, ASN1_SEQUENCE, attr_seq, PTR_DIFF(attr_seq_p, attr_seq));

    uint8_t rdn_set[128];
    uint8_t *rdn_set_p = rdn_set;
    asn1_write_tag(&rdn_set_p, ASN1_SET, attr_wrapper, PTR_DIFF(attr_wrapper_p, attr_wrapper));

    asn1_write_tag(p, ASN1_SEQUENCE, rdn_set, PTR_DIFF(rdn_set_p, rdn_set));
}

void convert_le32_to_be_bytes(uint8_t *out, const uint32_t *in, size_t word_count) {
    if (out == NULL || in == NULL || word_count != 8) return;
    uint8_t temp[32];
    for (size_t i = 0; i < 8; i++) {
        temp[i*4]   = (in[i] >> 24) & 0xFF;
        temp[i*4+1] = (in[i] >> 16) & 0xFF;
        temp[i*4+2] = (in[i] >> 8) & 0xFF;
        temp[i*4+3] = in[i] & 0xFF;
    }
    for (size_t i = 0; i < 8; i++) {
        memcpy(out + i*4, &temp[(7 - i)*4], 4);
    }
}


static void build_x509_extension(uint8_t **ext_p, const uint8_t *extnID, size_t oid_len, 
                                 int critical, const uint8_t *value, size_t val_len) {
    uint8_t ext_seq[128];
    uint8_t *p = ext_seq;

    asn1_write_tag(&p, ASN1_OID, extnID, oid_len);
    uint8_t crit_flag = critical ? 0xFF : 0x00;
    asn1_write_tag(&p, ASN1_BOOLEAN, &crit_flag, 1);
    asn1_write_tag(&p, ASN1_OCTET_STRING, value, val_len);

    asn1_write_tag(ext_p, ASN1_SEQUENCE, ext_seq, PTR_DIFF(p, ext_seq));
}

static size_t build_key_usage_der(uint8_t *out, cert_type_t cert_type) {
    uint8_t *p = out;
    uint8_t key_usage_byte = 0x00;

    switch (cert_type) {
        case CERT_TYPE_ROOT_CA:    key_usage_byte = X509_KU_KEY_CERT_SIGN; break;
        case CERT_TYPE_LDEVID:     key_usage_byte = X509_KU_DIGITAL_SIGNATURE; break;
        case CERT_TYPE_FMC:        key_usage_byte = X509_KU_DIGITAL_SIGNATURE; break;
        case CERT_TYPE_RT:         key_usage_byte = X509_KU_DIGITAL_SIGNATURE; break;
        default:                   key_usage_byte = X509_KU_DIGITAL_SIGNATURE; break;
    }

    asn1_write_tag(&p, ASN1_BIT_STRING, &key_usage_byte, 1);
    return PTR_DIFF(p, out);
}

int generate_intermediate_tbs_der(
    const uint32_t *pubkey_x_words,
    const uint32_t *pubkey_y_words,
    const char *issuer_name,
    const char *subject_name,
    uint8_t *tbs_out,
    size_t *tbs_len,
    cert_type_t cert_type
) {
    if (!pubkey_x_words || !pubkey_y_words || !issuer_name || !subject_name || 
        !tbs_out || !tbs_len || *tbs_len < 512) {
        return -2;
    }

    uint8_t *p = tbs_out;
    uint8_t pubkey_x[32], pubkey_y[32];
    const uint8_t version[] = {0xA0, 0x03, 0x02, 0x01, 0x02};
    const uint8_t sig_alg[] = {0x30, 0x0A, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x02};
    const uint8_t validity[] = {
        0x30, 0x22,
        0x18, 0x0F, '2','0','2','6','0','1','0','1','0','0','0','0','0','0','Z',
        0x18, 0x0F, '2','0','2','8','0','1','0','1','0','0','0','0','0','0','Z'
    };
    const uint8_t serial_der[] = {0x02, 0x04, 0x12, 0x34, 0x56, 0x78};
    const uint8_t ec_oid[] = {0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01}; // id-ecPublicKey 纯OID（无标签/长度）
    const uint8_t oid_key_usage[] = {0x55, 0x1D, 0x0F};
    const uint8_t oid_basic_constraints[] = {0x55, 0x1D, 0x13};

    convert_le32_to_be_bytes(pubkey_x, pubkey_x_words, 8);
    convert_le32_to_be_bytes(pubkey_y, pubkey_y_words, 8);

    if (memcmp(pubkey_x, "\x00\x00\x00\x00", 4) == 0 || memcmp(pubkey_y, "\x00\x00\x00\x00", 4) == 0) {
        return -1;
    }

    uint8_t public_key_uncompressed[65];
    public_key_uncompressed[0] = 0x04;
    memcpy(public_key_uncompressed + 1, pubkey_x, 32);
    memcpy(public_key_uncompressed + 33, pubkey_y, 32);

    uint8_t pubkey_bitstring[66];
    pubkey_bitstring[0] = 0x00;
    memcpy(pubkey_bitstring + 1, public_key_uncompressed, 65);

    const uint8_t ec_p256_oid[] = {0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, 0x07};
    uint8_t algorithm_identifier[32];
    uint8_t *alg_p = algorithm_identifier;
    *alg_p++ = ASN1_SEQUENCE;          
    uint8_t *alg_len_pos = alg_p++;    
    asn1_write_tag(&alg_p, ASN1_OID, ec_oid, sizeof(ec_oid));
    asn1_write_tag(&alg_p, ASN1_OID, ec_p256_oid, sizeof(ec_p256_oid));
    *alg_len_pos = (uint8_t)(PTR_DIFF(alg_p, algorithm_identifier) - 2);
    size_t alg_len = PTR_DIFF(alg_p, algorithm_identifier);

    uint8_t subject_public_key_info[128];
    uint8_t *spki_p = subject_public_key_info;
    *spki_p++ = ASN1_SEQUENCE;         
    uint8_t *spki_len_pos = spki_p++;  
    memcpy(spki_p, algorithm_identifier, alg_len);
    spki_p += alg_len;
    asn1_write_tag(&spki_p, ASN1_BIT_STRING, pubkey_bitstring, 66);
    *spki_len_pos = (uint8_t)(PTR_DIFF(spki_p, subject_public_key_info) - 2);
    size_t spki_len = PTR_DIFF(spki_p, subject_public_key_info);

    uint8_t v3_ext_list[128];
    uint8_t *ext_list_p = v3_ext_list;
    *ext_list_p++ = ASN1_SEQUENCE;
    uint8_t *ext_len_pos = ext_list_p++;

    uint8_t ku_der[16];
    size_t ku_len = build_key_usage_der(ku_der, cert_type);
    build_x509_extension(&ext_list_p, oid_key_usage, sizeof(oid_key_usage), 1, ku_der, ku_len);

    uint8_t bc_der[16], *bc_p = bc_der;
    *bc_p++ = ASN1_SEQUENCE;
    uint8_t *bc_len_pos = bc_p++;
    uint8_t ca_flag = (cert_type == CERT_TYPE_ROOT_CA) ? 0xFF : 0x00;
    asn1_write_tag(&bc_p, ASN1_BOOLEAN, &ca_flag, 1);
    if (cert_type == CERT_TYPE_ROOT_CA) {
        asn1_write_tag(&bc_p, ASN1_INTEGER, (uint8_t[]){0x00}, 1);
    }
    *bc_len_pos = (uint8_t)(PTR_DIFF(bc_p, bc_der) - 2);
    size_t bc_der_len = PTR_DIFF(bc_p, bc_der);
    build_x509_extension(&ext_list_p, oid_basic_constraints, sizeof(oid_basic_constraints), 1, bc_der, bc_der_len);
    *ext_len_pos = (uint8_t)(PTR_DIFF(ext_list_p, v3_ext_list) - 2);
    size_t ext_list_len = PTR_DIFF(ext_list_p, v3_ext_list);

    memcpy(p, version, sizeof(version));  p += sizeof(version);
    memcpy(p, serial_der, sizeof(serial_der));  p += sizeof(serial_der);
    memcpy(p, sig_alg, sizeof(sig_alg));  p += sizeof(sig_alg);
    encode_dn(&p, issuer_name);
    memcpy(p, validity, sizeof(validity));  p += sizeof(validity);
    encode_dn(&p, subject_name);
    memcpy(p, subject_public_key_info, spki_len);  p += spki_len;

    asn1_write_tag(&p, ASN1_CONTEXT_SPECIFIC | ASN1_CONSTRUCTED | 0x03, v3_ext_list, ext_list_len);

    size_t tbs_inner_len = PTR_DIFF(p, tbs_out);
    uint8_t tbs_wrapper[512];
    uint8_t *wrapper_p = tbs_wrapper;
    asn1_write_tag(&wrapper_p, ASN1_SEQUENCE, tbs_out, tbs_inner_len);
    size_t tbs_total_len = PTR_DIFF(wrapper_p, tbs_wrapper);
    if (tbs_total_len > *tbs_len) {
        return -3;
    }
    memcpy(tbs_out, tbs_wrapper, tbs_total_len);
    *tbs_len = tbs_total_len;

    return 0;
}

int add_signature_to_cert(
    const uint8_t *tbs_der,
    size_t tbs_len,
    const uint32_t *sig_r_words,
    const uint32_t *sig_s_words,
    uint8_t *cert_out,
    size_t *cert_len)
{
    if (!tbs_der || !sig_r_words || !sig_s_words || !cert_out || !cert_len || *cert_len < 512) {
        return -1;
    }

    uint8_t *p = cert_out;
    uint8_t sig_r[32], sig_s[32];
    convert_le32_to_be_bytes(sig_r, sig_r_words, 8);
    convert_le32_to_be_bytes(sig_s, sig_s_words, 8);

    uint8_t sig_der[128], *sig_p = sig_der;
    *sig_p++ = ASN1_SEQUENCE;
    uint8_t *sig_len_pos = sig_p++;
    size_t r_len = 32;
    while (r_len > 1 && sig_r[32 - r_len] == 0) r_len--;
    asn1_write_tag(&sig_p, ASN1_INTEGER, sig_r + (32 - r_len), r_len);
    size_t s_len = 32;
    while (s_len > 1 && sig_s[32 - s_len] == 0) s_len--;
    asn1_write_tag(&sig_p, ASN1_INTEGER, sig_s + (32 - s_len), s_len);
    *sig_len_pos = (uint8_t)(PTR_DIFF(sig_p, sig_der) - 2);
    size_t sig_der_len = PTR_DIFF(sig_p, sig_der);

    uint8_t cert_temp[512], *temp_p = cert_temp;
    const uint8_t sig_alg[] = {0x30, 0x0A, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x02};
    memcpy(temp_p, tbs_der, tbs_len);
    temp_p += tbs_len;
    memcpy(temp_p, sig_alg, sizeof(sig_alg));
    temp_p += sizeof(sig_alg);
    uint8_t sig_bitstring[1 + sig_der_len];
    sig_bitstring[0] = 0x00;
    memcpy(sig_bitstring + 1, sig_der, sig_der_len);
    asn1_write_tag(&temp_p, ASN1_BIT_STRING, sig_bitstring, sizeof(sig_bitstring));
    asn1_write_tag(&p, ASN1_SEQUENCE, cert_temp, PTR_DIFF(temp_p, cert_temp));

    *cert_len = PTR_DIFF(p, cert_out);
    return 0;
}
