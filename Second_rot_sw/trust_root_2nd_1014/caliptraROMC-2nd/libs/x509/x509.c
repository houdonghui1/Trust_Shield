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
    uint8_t pubkey_x[48], pubkey_y[48];
    const uint8_t version[] = {0xA0, 0x03, 0x02, 0x01, 0x02};
    const uint8_t sig_alg[] = {0x30, 0x0A, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x03};
    const uint8_t validity[] = {
        0x30, 0x22,
        0x18, 0x0F, '2','0','2','6','0','1','0','1','0','0','0','0','0','0','Z',
        0x18, 0x0F, '2','0','2','8','0','1','0','1','0','0','0','0','0','0','Z'
    };
    const uint8_t serial_der[] = {0x02, 0x04, 0x12, 0x34, 0x56, 0x78};
    const uint8_t ec_oid[] = {0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01};
    const uint8_t oid_key_usage[] = {0x55, 0x1D, 0x0F};
    const uint8_t oid_basic_constraints[] = {0x55, 0x1D, 0x13};

    convert_le32_to_be_bytes(pubkey_x, pubkey_x_words, 12);
    convert_le32_to_be_bytes(pubkey_y, pubkey_y_words, 12);

    if (memcmp(pubkey_x, "\x00\x00\x00\x00", 4) == 0 || memcmp(pubkey_y, "\x00\x00\x00\x00", 4) == 0) {
        return -1;
    }

    uint8_t public_key_uncompressed[97];
    public_key_uncompressed[0] = 0x04;
    memcpy(public_key_uncompressed + 1, pubkey_x, 48);
    memcpy(public_key_uncompressed + 49, pubkey_y, 48);

    uint8_t pubkey_bitstring[98];
    pubkey_bitstring[0] = 0x00;
    memcpy(pubkey_bitstring + 1, public_key_uncompressed, 97);
    const uint8_t ec_p384_oid[] = {0x2B, 0x81, 0x04, 0x00, 0x22};
    uint8_t algorithm_identifier[32];
    uint8_t *alg_p = algorithm_identifier;
    *alg_p++ = ASN1_SEQUENCE;          
    uint8_t *alg_len_pos = alg_p++;    
    asn1_write_tag(&alg_p, ASN1_OID, ec_oid, sizeof(ec_oid));
    asn1_write_tag(&alg_p, ASN1_OID, ec_p384_oid, sizeof(ec_p384_oid));
    *alg_len_pos = (uint8_t)(PTR_DIFF(alg_p, algorithm_identifier) - 2);
    size_t alg_len = PTR_DIFF(alg_p, algorithm_identifier);

    uint8_t subject_public_key_info[128];
    uint8_t *spki_p = subject_public_key_info;
    *spki_p++ = ASN1_SEQUENCE;         
    uint8_t *spki_len_pos = spki_p++;  
    memcpy(spki_p, algorithm_identifier, alg_len);
    spki_p += alg_len;
    asn1_write_tag(&spki_p, ASN1_BIT_STRING, pubkey_bitstring, 98);
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
    const uint8_t *tbs_der, size_t tbs_len,
    const uint8_t *sig_r,
    const uint8_t *sig_s,
    uint8_t *cert_out, size_t *cert_len)
{
    uint8_t *p = cert_out;

    uint8_t tmp[200], *tp = tmp;

    size_t r_len = 48;
    while (r_len > 1 && sig_r[48 - r_len] == 0) r_len--;
    asn1_write_tag(&tp, 0x02, sig_r + (48 - r_len), r_len);

    size_t s_len = 48;
    while (s_len > 1 && sig_s[48 - s_len] == 0) s_len--;
    asn1_write_tag(&tp, 0x02, sig_s + (48 - s_len), s_len);

    uint8_t sig_der[200], *sp = sig_der;
    asn1_write_tag(&sp, 0x30, tmp, tp - tmp);
    size_t sig_der_len = sp - sig_der;

    *p++ = 0x30;
    size_t len_pos = p - cert_out;
    p += 3;

    memcpy(p, tbs_der, tbs_len);
    p += tbs_len;

    const uint8_t sig_alg[] = {
        0x30,0x0A,0x06,0x08,0x2A,0x86,0x48,0xCE,0x3D,0x04,0x03,0x03
    };
    memcpy(p, sig_alg, sizeof(sig_alg));
    p += sizeof(sig_alg);

    *p++ = 0x03;
    size_t bitstring_content_len = sig_der_len + 1;
    if (bitstring_content_len <= 0x7F) {
        *p++ = bitstring_content_len;
    } else {
        *p++ = 0x81;
        *p++ = bitstring_content_len;
    }
    *p++ = 0x00;
    memcpy(p, sig_der, sig_der_len);
    p += sig_der_len;

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

int verify_cert(const uint8_t *cert_der, size_t cert_len,
                const uint8_t public_key[ECC_BYTES + 1])
{
    const uint8_t *end = cert_der + cert_len;

    const uint8_t *p = cert_der;
    if (*p++ != 0x30) { printf("E: outer tag\n"); return 0; }
    size_t outer_len = *p++;
    if (outer_len & 0x80) {
        size_t bytes = outer_len & 0x7F;
        while (bytes--) p++;
    }
    const uint8_t *tbs_start = p;

    if (*p++ != 0x30) { printf("E: tbs tag\n"); return 0; }
    size_t tbs_content_len = *p++;
    size_t tbs_len_len = 1;
    if (tbs_content_len & 0x80) {
        size_t bytes = tbs_content_len & 0x7F;
        tbs_len_len += bytes;
        tbs_content_len = 0;
        while (bytes--) tbs_content_len = (tbs_content_len << 8) | *p++;
    }
    size_t tbs_total_len = 1 + tbs_len_len + tbs_content_len;
    const uint8_t *tbs_data = tbs_start;

    uint8_t hash[48];
    sha384_digest((uint8_t *)tbs_data, tbs_total_len, (uint64_t *)hash, true);

    const uint8_t sig_alg_seq[] = {
        0x30, 0x0A, 0x06, 0x08,
        0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x03
    };
    const size_t sig_alg_len = sizeof(sig_alg_seq);

    const uint8_t *oid_pos = NULL;
    size_t search_start = (cert_len > 256) ? (cert_len - 256) : 0;
    for (const uint8_t *s = cert_der + search_start; s + sig_alg_len <= end; s++) {
        if (memcmp(s, sig_alg_seq, sig_alg_len) == 0) {
            oid_pos = s;
            break;
        }
    }
    if (!oid_pos) {
        printf("ERROR: signature algorithm OID not found!\n");
        return 0;
    }
    printf("Found sig alg at offset %ld\n", (long)(oid_pos - cert_der));

    p = oid_pos + sig_alg_len;

    if (p >= end || *p++ != 0x03) {
        printf("ERROR: BIT STRING tag missing\n");
        return 0;
    }

    size_t bitstring_len;
    if (p >= end) { printf("ERROR: BIT STRING len missing\n"); return 0; }
    if (*p < 0x80) {
        bitstring_len = *p++;
    } else if (*p == 0x81) {
        p++;
        if (p >= end) { printf("ERROR: BIT STRING long len\n"); return 0; }
        bitstring_len = *p++;
    } else {
        printf("ERROR: BIT STRING len too long\n");
        return 0;
    }
    printf("BIT STRING length = 0x%x\n", bitstring_len);

    if (p >= end || *p++ != 0x00) {
        printf("ERROR: BIT STRING unused bits not 0\n");
        return 0;
    }

    size_t content_len = bitstring_len - 1;
    if (p + content_len > end) {
        printf("ERROR: BIT STRING content overflow\n");
        return 0;
    }

    const uint8_t *seq = p;
    if (*seq++ != 0x30) { printf("E: inner SEQUENCE\n"); return 0; }
    size_t seq_len;
    if (seq >= end) { printf("E: SEQUENCE len\n"); return 0; }
    if (*seq < 0x80) {
        seq_len = *seq++;
    } else if (*seq == 0x81) {
        seq++;
        if (seq >= end) return 0;
        seq_len = *seq++;
    } else {
        printf("E: SEQUENCE long len\n"); return 0;
    }
    const uint8_t *seq_end = seq + seq_len;
    if (seq_end > end) { printf("E: SEQUENCE overflow\n"); return 0; }

    /* r */
    if (seq >= seq_end || *seq++ != 0x02) { printf("E: r tag\n"); return 0; }
    size_t r_len;
    if (seq >= seq_end) return 0;
    if (*seq < 0x80) {
        r_len = *seq++;
    } else if (*seq == 0x81) {
        seq++;
        if (seq >= seq_end) return 0;
        r_len = *seq++;
    } else { printf("E: r len\n"); return 0; }
    const uint8_t *r_val = seq;
    if (r_len > 0 && *r_val == 0x00) { r_val++; r_len--; }  // 去前导零
    if (r_len > 48 || r_val + r_len > seq_end) { printf("E: r len invalid\n"); return 0; }
    seq = r_val + r_len;

    /* s */
    if (seq >= seq_end || *seq++ != 0x02) { printf("E: s tag\n"); return 0; }
    size_t s_len;
    if (seq >= seq_end) return 0;
    if (*seq < 0x80) {
        s_len = *seq++;
    } else if (*seq == 0x81) {
        seq++;
        if (seq >= seq_end) return 0;
        s_len = *seq++;
    } else { printf("E: s len\n"); return 0; }
    const uint8_t *s_val = seq;
    if (s_len > 0 && *s_val == 0x00) { s_val++; s_len--; }
    if (s_len > 48 || s_val + s_len > seq_end) { printf("E: s len invalid\n"); return 0; }

    uint8_t signature[96];
    memset(signature, 0, 96);
    memcpy(signature + (48 - r_len), r_val, r_len);
    memcpy(signature + 48 + (48 - s_len), s_val, s_len);

    printf("Extracted signature:\n");
    for (int i = 0; i < 96; i++) printf("%02x", signature[i]);
    printf("\n");

    return ecdsa_verify(public_key, hash, signature);
}