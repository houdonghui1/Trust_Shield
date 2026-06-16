#include "x509.h"

static void asn1_write_length(uint8_t **p, size_t length) {
    if (length <= 0x7F) {
        *(*p)++ = (uint8_t)length;
    } else {
        *(*p)++ = 0x82;
        *(*p)++ = (length >> 8) & 0xFF;
        *(*p)++ = length & 0xFF;
    }
}

static void asn1_write_tag(uint8_t **p, uint8_t tag, const uint8_t *value, size_t len) {
    //printf("Writing tag 0x%02X, length 0x%x\n", tag, len);
    *(*p)++ = tag;
    asn1_write_length(p, len);
    memcpy(*p, value, len);
    *p += len;
}

static void encode_dn(uint8_t **p, const char *name) {
    uint8_t attr_seq[128];
    uint8_t *attr_seq_p = attr_seq;

    uint8_t oid_cn[] = {0x55, 0x04, 0x03}; 
    asn1_write_tag(&attr_seq_p, ASN1_OID, oid_cn, sizeof(oid_cn));

    asn1_write_tag(&attr_seq_p, ASN1_UTF8_STRING, (uint8_t*)name, strlen(name));

    uint8_t attr_wrapper[128];
    uint8_t *attr_wrapper_p = attr_wrapper;
    asn1_write_tag(&attr_wrapper_p, ASN1_SEQUENCE, attr_seq, attr_seq_p - attr_seq);

    uint8_t rdn_set[128];
    uint8_t *rdn_set_p = rdn_set;
    asn1_write_tag(&rdn_set_p, ASN1_SET, attr_wrapper, attr_wrapper_p - attr_wrapper);

    asn1_write_tag(p, ASN1_SEQUENCE, rdn_set, rdn_set_p - rdn_set);
}


void convert_le32_to_be_bytes(uint8_t *out, const uint32_t *in, size_t word_count) {
    for (size_t i = 0; i < word_count; i++) {
        uint32_t word = in[i];
        out[i*4]   = (word >> 24) & 0xFF;
        out[i*4+1] = (word >> 16) & 0xFF;
        out[i*4+2] = (word >> 8)  & 0xFF;
        out[i*4+3] = word & 0xFF;
    }
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
    uint8_t tbs_wrapper[2048] = {0};
    uint8_t pubkey_x[48], pubkey_y[48];
    uint8_t version[] = {0xA0, 0x03, 0x02, 0x01, 0x02};
    uint8_t sig_alg[] = {0x30, 0x0A, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x03};
    uint8_t validity[] = {
        0x30, 0x22,
        0x18, 0x0F, '2','0','2','5','0','1','0','1','0','0','0','0','0','0','Z',
        0x18, 0x0F, '2','0','2','7','0','1','0','1','0','0','0','0','0','0','Z'
    };
    uint8_t pubkey_bitstring[98] = {0x0, 0x04};
    const uint8_t ec_oid[] = {0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01};
    const uint8_t ec_params[] = {0x2B, 0x81, 0x04, 0x00, 0x22};
    uint8_t alg_id[32] = {0};
    uint8_t pubkey_seq[256] = {0};
    sha256_io sha256_block = {.data = {0}};
    sha256_io sha256_digest = {.data = {0}};
    uint8_t serial_bytes[4] = {0};
    uint8_t serial_der[6] = {0x02, 0x04, 0x00, 0x00, 0x00, 0x00};
    uint8_t v3_extensions[] = {
        0x30, 0x26,

        0x30, 0x10,
        0x06, 0x03, 0x55, 0x1D, 0x0F,
        0x01, 0x01, 0xFF,
        0x04, 0x06,
        0x03, 0x04,
        0x04,
        0x06, 0x00, 0x00,
    
        0x30, 0x12,
        0x06, 0x03, 0x55, 0x1D, 0x13, 
        0x01, 0x01, 0xFF, 
        0x04, 0x08, 0x30, 0x06, 
        0x01, 0x01, 0xFF, 0x02, 0x01, 0x00
    };

/*     uint8_t ext_with_pathlen[] = {
            0x30, 0x14,
            0x30, 0x12,
            0x06, 0x03, 0x55, 0x1D, 0x13, 
            0x01, 0x01, 0xFF, 
            0x04, 0x08, 0x30, 0x06, 
            0x01, 0x01, 0xFF, 0x02, 0x01, 0x00
        };
    uint8_t ext_key_usage[] = {
        0x30, 0x0D,
        0x30, 0x0B,
        0x06, 0x03, 0x55, 0x1D, 0x0F,
        0x04, 0x04,
        0x03, 0x02,
        0x05, 0xC0
    }; */

    if (!pubkey_x_words || !pubkey_y_words || !issuer_name || !subject_name || !tbs_out || !tbs_len || *tbs_len < 2048) {
        printf("Invalid parameters\n");
        return -1;
    }

    convert_le32_to_be_bytes(pubkey_x, pubkey_x_words, 12);
    convert_le32_to_be_bytes(pubkey_y, pubkey_y_words, 12);

    memcpy(pubkey_bitstring + 2, pubkey_x, 48);
    memcpy(pubkey_bitstring + 50, pubkey_y, 48);

    uint8_t *alg_p = alg_id;
    asn1_write_tag(&alg_p, ASN1_OID, ec_oid, sizeof(ec_oid));
    asn1_write_tag(&alg_p, ASN1_OID, ec_params, sizeof(ec_params));

    uint8_t *pk_p = pubkey_seq;
    asn1_write_tag(&pk_p, ASN1_SEQUENCE, alg_id, alg_p - alg_id);
    asn1_write_tag(&pk_p, ASN1_BIT_STRING, pubkey_bitstring, sizeof(pubkey_bitstring));

    memcpy(sha256_block.data, pubkey_seq, pk_p - pubkey_seq);
    sha256_flow_produce(sha256_block, SHA256_MODE_SHA_256, sha256_digest);
    memcpy(serial_bytes, sha256_digest.data, 4);
    memcpy(&serial_der[2], serial_bytes, 4);

    memset(tbs_out, 0, *tbs_len);
    uint8_t *p = tbs_out;

    memcpy(p, version, sizeof(version));
    p += sizeof(version);

    memcpy(p, serial_der, sizeof(serial_der));
    p += sizeof(serial_der);

    memcpy(p, sig_alg, sizeof(sig_alg));
    p += sizeof(sig_alg);

    encode_dn(&p, issuer_name);

    memcpy(p, validity, sizeof(validity));
    p += sizeof(validity);

    encode_dn(&p, subject_name);

    asn1_write_tag(&p, ASN1_SEQUENCE, pubkey_seq, pk_p - pubkey_seq);

    if(cert_type == CERT_TYPE_ROOT_CA) {
        v3_extensions[39] = 0x05;
    } else if(cert_type == CERT_TYPE_LDEVID) {
        v3_extensions[39] = 0x04;
    } else if(cert_type == CERT_TYPE_FMC) {
        v3_extensions[39] = 0x03;
    } else if(cert_type == CERT_TYPE_RT) {
        v3_extensions[39] = 0x02;
    }
    asn1_write_tag(&p, ASN1_CONTEXT_SPECIFIC | 0x3, v3_extensions, sizeof(v3_extensions));

    // 10. 最终封装
    *tbs_len = p - tbs_out;
    uint8_t *wrapper_p = tbs_wrapper;
    asn1_write_tag(&wrapper_p, ASN1_SEQUENCE, tbs_out, *tbs_len);
    memcpy(tbs_out, tbs_wrapper, wrapper_p - tbs_wrapper);
    *tbs_len = wrapper_p - tbs_wrapper;

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
    uint8_t *p = cert_out;
    uint8_t sig_r[48], sig_s[48];
    convert_le32_to_be_bytes(sig_r, sig_r_words, 48);
    convert_le32_to_be_bytes(sig_s, sig_s_words, 48);
    *p++ = 0x30;
    size_t len_pos = p - cert_out;
    p += 3;
    
    memcpy(p, tbs_der, tbs_len);
    p += tbs_len;
    
    const uint8_t sig_alg[] = {0x30, 0x0A, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x03};
    memcpy(p, sig_alg, sizeof(sig_alg));
    p += sizeof(sig_alg);
    
    uint8_t sig_der[200];
    uint8_t *sig_p = sig_der;
    
    *sig_p++ = 0x30;
    size_t seq_len_pos = sig_p - sig_der;
    *sig_p++ = 0x00;
    
    *sig_p++ = 0x02;
    if (sig_r[0] & 0x80) {
        *sig_p++ = 49;
        *sig_p++ = 0x00;
        memcpy(sig_p, sig_r, 48);
        sig_p += 48;
    } else {
        *sig_p++ = 48;
        memcpy(sig_p, sig_r, 48);
        sig_p += 48;
    }
    
    *sig_p++ = 0x02;
    if (sig_s[0] & 0x80) {
        *sig_p++ = 49;
        *sig_p++ = 0x00;
        memcpy(sig_p, sig_s, 48);
        sig_p += 48;
    } else {
        *sig_p++ = 48;
        memcpy(sig_p, sig_s, 48);
        sig_p += 48;
    }
    
    size_t seq_len = sig_p - sig_der - seq_len_pos - 1;
    if (seq_len <= 0x7F) {
        sig_der[seq_len_pos] = seq_len;
    } else {
        sig_der[seq_len_pos] = 0x81;
        sig_der[seq_len_pos + 1] = seq_len;
        memmove(sig_der + seq_len_pos + 2, sig_der + seq_len_pos + 1, seq_len);
        sig_p++;
    }
    
    *p++ = 0x03;
    size_t bitstring_len = sig_p - sig_der + 1;
    if (bitstring_len <= 0x7F) {
        *p++ = bitstring_len;
    } else {
        *p++ = 0x81;
        *p++ = bitstring_len;
    }
    *p++ = 0x00;
    memcpy(p, sig_der, sig_p - sig_der);
    p += (sig_p - sig_der);
    
    size_t total_len = p - cert_out - len_pos - 3;
    if (total_len <= 0x7F) {
        cert_out[len_pos] = total_len;
        memmove(cert_out + len_pos + 1, cert_out + len_pos + 3, total_len);
        p -= 2;
    } else if (total_len <= 0xFF) {
        cert_out[len_pos] = 0x81;
        cert_out[len_pos + 1] = total_len;
    } else {
        cert_out[len_pos] = 0x82;
        cert_out[len_pos + 1] = (total_len >> 8) & 0xFF;
        cert_out[len_pos + 2] = total_len & 0xFF;
    }
    
    *cert_len = p - cert_out;
    return 0;
}

static size_t asn1_read_length(const uint8_t **p) {
    if ((**p) < 0x80) {
        return *(*p)++;
    } else {
        uint8_t len_bytes = *(*p)++ & 0x7F;
        size_t length = 0;
        for (int i = 0; i < len_bytes; i++) {
            length = (length << 8) | *(*p)++;
        }
        return length;
    }
}

static void asn1_skip_tag(const uint8_t **p, uint8_t expected_tag) {
    if (*(*p)++ != expected_tag) {
        printf("Unexpected tag: expected 0x%02X\n", expected_tag);
        return;
    }
    size_t len = asn1_read_length(p);
    *p += len;
}
int parse_x509_cert(const uint8_t *der_data, size_t der_len, x509_cert_t *cert, bool parse_full) {
    const uint8_t *p = NULL;
    const uint8_t *cert_end = NULL;
    const uint8_t *tbs_end = NULL;
    size_t cert_len = 0;
    size_t tbs_len = 0;
    uint8_t issuer_tag = 0;
    size_t sig_alg_len = 0;
    size_t alg_id_len = 0;
    
    if (!der_data || der_len == 0 || !cert) {
        printf("Invalid input parameters\n");
        return -1;
    }

    p = der_data;
    
    if (*p++ != ASN1_SEQUENCE) {
        printf("Expected SEQUENCE(0x30), got 0x%02X\n", *(p-1));
        return -1;
    }
    cert_len = asn1_read_length(&p);
    cert_end = p + cert_len;
    printf("Certificate total length: 0x%x bytes\n", cert_len);

    if (*p++ != ASN1_SEQUENCE) {
        printf("Expected TBSCertificate SEQUENCE\n");
        return -1;
    }
    tbs_len = asn1_read_length(&p);
    tbs_end = p + tbs_len;
    printf("TBSCertificate length: 0x%x bytes\n", tbs_len);

    if (*p == (ASN1_CONTEXT_SPECIFIC | 0x00)) {
        printf("Found version field\n");
        p++;
        size_t version_wrapper_len = asn1_read_length(&p);
        const uint8_t *version_wrapper_end = p + version_wrapper_len;

        if (*p++ != ASN1_INTEGER) {
            printf("Expected version INTEGER\n");
            return -1;
        }
        size_t version_len = asn1_read_length(&p);
        if (version_len != 1 || *p != 0x02) {
            printf("Expected version=2, got 0x%x\n", *p);
            return -1;
        }
        p += version_len;
        
        if (p != version_wrapper_end) {
            printf("Version field length mismatch\n");
            return -1;
        }
    }

    if (*p++ != ASN1_INTEGER) {
        printf("Expected serial number INTEGER\n");
        return -1;
    }
    cert->serial_len = asn1_read_length(&p);
    cert->serial = (uint8_t *)p;
    p += cert->serial_len;
    printf("Serial number length: 0x%x\n", cert->serial_len);

    if (*p++ != ASN1_SEQUENCE) {
        printf("Expected signature algorithm SEQUENCE\n");
        return -1;
    }
    sig_alg_len = asn1_read_length(&p);
    p += sig_alg_len;
    printf("Skipped signature algorithm 0x%x bytes\n", sig_alg_len);

    issuer_tag = *p;
    if (issuer_tag != ASN1_SEQUENCE && issuer_tag != ASN1_SET) {
        printf("Expected issuer SEQUENCE/SET, got 0x%02X\n", issuer_tag);
        return -1;
    }
    p++;
    cert->issuer_len = asn1_read_length(&p);
    cert->issuer = (uint8_t *)p;
    p += cert->issuer_len;
    printf("Issuer length: 0x%x bytes\n", cert->issuer_len);

    if (*p++ != ASN1_SEQUENCE) {
        printf("Expected validity SEQUENCE\n");
        return -1;
    }
    cert->validity_len = asn1_read_length(&p);
    cert->validity = (uint8_t *)p;
    p += cert->validity_len;
    printf("Validity length: 0x%x bytes\n", cert->validity_len);

    if (*p++ != ASN1_SEQUENCE) {
        printf("Expected subject SEQUENCE\n");
        return -1;
    }
    cert->subject_len = asn1_read_length(&p);
    cert->subject = (uint8_t *)p;
    p += cert->subject_len;
    printf("Subject length: 0x%x bytes\n", cert->subject_len);

    printf("Public key starts at offset 0x%x\n", (unsigned)(p - der_data));
    if (*p++ != ASN1_SEQUENCE) {
        printf("Expected public key SEQUENCE\n");
        return -1;
    }

    if (*p++ != ASN1_SEQUENCE) {
        printf("Expected algorithm identifier SEQUENCE\n");
        return -1;
    }
    alg_id_len = asn1_read_length(&p);
    p += alg_id_len;

    if (*p != ASN1_BIT_STRING) {
        printf("Expected BIT STRING(0x03), got 0x%02X\n", *p);
        return -1;
    }
    p++;
    cert->pubkey_len = asn1_read_length(&p) - 1;
    p += 1;
    cert->pubkey = (uint8_t *)p;
    p += cert->pubkey_len;
    printf("Public key length: 0x%x bytes:\n", cert->pubkey_len);
    for (uint32_t i = 0; i < cert->pubkey_len; i++) {
        printf("%02X ", cert->pubkey[i]);
        if ((i + 1) % 16 == 0) printf("\n");
    }
    printf("\n");

    if (p < tbs_end && *p == (ASN1_CONTEXT_SPECIFIC | 0x03)) {
        printf("Found extensions field\n");
        asn1_skip_tag(&p, ASN1_CONTEXT_SPECIFIC | 0x03);
    }

    if (parse_full) {
        while (p < cert_end && (*p == (ASN1_CONTEXT_SPECIFIC | 0x03) || *p == (ASN1_CONTEXT_SPECIFIC | 0x04))) {
            uint8_t ext_tag = *p;
            p++;
            size_t ext_len = asn1_read_length(&p);
            p += ext_len;
            printf("Skipped extension 0x%02X (0x%x bytes)\n", ext_tag, ext_len);
        }
        printf("[DEBUG] Before signature algorithm at offset 0x%x, got 0x%02X\n", (unsigned int)(p - der_data), *p);
        if (*p++ != ASN1_SEQUENCE) {
             printf("[ERROR] Expected signature algorithm SEQUENCE(0x30), got 0x%02X\n", *(p-1));
            return -1;
        }
        size_t sig_alg_len = asn1_read_length(&p);
        p += sig_alg_len;

        printf("[DEBUG] Before signature value at offset 0x%x, got 0x%02X\n",(unsigned int)(p - der_data), *p);
        if (*p++ != ASN1_BIT_STRING) {
            printf("Expected signature BIT STRING\n");
            return -1;
        }
        cert->signature_len = asn1_read_length(&p) - 1;
        p += 1;
        cert->signature = (uint8_t *)p;
        p += cert->signature_len;
        printf("Signature length: 0x%x bytes:\n", cert->signature_len);
        for (uint32_t i = 0; i < cert->signature_len; i++) {
            printf("%02X ", cert->signature[i]);
            if ((i + 1) % 16 == 0) printf("\n");
        }
        printf("\n");
    }

    if (p != cert_end) {
        printf("[WARN] Extra data at end: 0x%x bytes\n", (unsigned int)(cert_end - p));
    }

    printf("Parsing completed successfully\n");
    return 0;
}

void print_cert_info(const x509_cert_t *cert) {
    printf("Issuer: %.*s\n", (int)cert->issuer_len, cert->issuer);
    printf("Subject: %.*s\n", (int)cert->subject_len, cert->subject);
    printf("Serial: ");
    for (size_t i = 0; i < cert->serial_len; i++) {
        printf("%02X", cert->serial[i]);
    }
    printf("\n");
    printf("Validity: %.*s\n", (int)cert->validity_len, cert->validity);
    printf("Public Key: ");
    for (size_t i = 0; i < cert->pubkey_len; i++) {
        printf("%02X", cert->pubkey[i]);
    }
    printf("\n");
    printf("Signature: ");
    for (size_t i = 0; i < cert->signature_len; i++) {
        printf("%02X", cert->signature[i]);
    }
    printf("\n");
}

int parse_and_print_certificates() {

    x509_cert_t ldevid_cert;
    if (parse_x509_cert(tbs_der_store[1].der_data, tbs_der_store[1].der_len, &ldevid_cert, false) == 0) {
        printf("=== LDEVID (TBSCertificate) ===\n");
        print_cert_info(&ldevid_cert);
    }

    x509_cert_t fmc_cert;
    if (parse_x509_cert(tbs_der_store[2].der_data, tbs_der_store[2].der_len, &fmc_cert, false) == 0) {
        printf("=== FMC (TBSCertificate) ===\n");
        print_cert_info(&fmc_cert);
    }

    x509_cert_t rt_cert;
    if (parse_x509_cert(tbs_der_store[3].der_data, tbs_der_store[3].der_len, &rt_cert, true) == 0) {
        printf("=== RT (Full Certificate) ===\n");
        print_cert_info(&rt_cert);
    }

    return 0;
}