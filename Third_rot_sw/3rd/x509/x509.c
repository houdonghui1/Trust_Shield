#include "x509.h"

static const uint8_t kClusterBlsOid[] = {
    0x2B, 0x06, 0x01, 0x04, 0x01, 0x83, 0xB2, 0x03, 0x01, 0x01,
};
/* The former ROM-digest experiment must never share the strict PoP binding
 * OID consumed by the cluster protocol. */
static const uint8_t kLegacyBlsRomOid[] = {
    0x2B, 0x06, 0x01, 0x04, 0x01, 0x83, 0xB2, 0x03, 0x01, 0x02,
};
static const uint8_t kClusterBlsCiphersuite[] =
    "BLS12381G2_XMD:SHA-256_SSWU_RO_POP_";

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

static void asn1_write_header(uint8_t **p, uint8_t tag, size_t len) {
    *(*p)++ = tag;
    asn1_write_length(p, len);
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
    uint8_t ext_seq[512];
    uint8_t *p = ext_seq;

    asn1_write_tag(&p, ASN1_OID, extnID, oid_len);
    if (critical) {
        uint8_t crit_flag = 0xFF;
        asn1_write_tag(&p, ASN1_BOOLEAN, &crit_flag, 1);
    }
    asn1_write_tag(&p, ASN1_OCTET_STRING, value, val_len);

    asn1_write_tag(ext_p, ASN1_SEQUENCE, ext_seq, PTR_DIFF(p, ext_seq));
}

static int asn1_read_length(const uint8_t *p, size_t available,
                            size_t *length, size_t *encoded_len) {
    if (p == NULL || length == NULL || encoded_len == NULL || available == 0) {
        return -1;
    }
    uint8_t first = p[0];
    if ((first & 0x80) == 0) {
        *length = first;
        *encoded_len = 1;
        return *length <= available - 1 ? 0 : -1;
    }
    size_t length_bytes = first & 0x7F;
    if (length_bytes == 0 || length_bytes > sizeof(size_t) ||
        available < 1 + length_bytes) {
        return -1;
    }
    size_t value = 0;
    for (size_t i = 0; i < length_bytes; ++i) {
        value = (value << 8) | p[1 + i];
    }
    if (value > available - 1 - length_bytes) {
        return -1;
    }
    *length = value;
    *encoded_len = 1 + length_bytes;
    return 0;
}

static int asn1_read_tlv(const uint8_t *p, size_t available, size_t *tlv_len) {
    size_t value_len;
    size_t length_len;
    if (available < 2 ||
        asn1_read_length(p + 1, available - 1, &value_len, &length_len) != 0) {
        return -1;
    }
    *tlv_len = 1 + length_len + value_len;
    return 0;
}

static size_t asn1_length_size(size_t length) {
    if (length <= 0x7F) return 1;
    if (length <= 0xFF) return 2;
    if (length <= 0xFFFF) return 3;
    return 0;
}

static size_t asn1_tlv_size(size_t value_len) {
    size_t length_size = asn1_length_size(value_len);
    return length_size == 0 ? 0 : 1 + length_size + value_len;
}

static int add_private_extension_to_tbs(
    const uint8_t *tbs_der, size_t tbs_len, const uint8_t *oid,
    size_t oid_len, const uint8_t *value, size_t value_len,
    uint8_t *tbs_out, size_t *tbs_out_len) {
    uint8_t extension_list[512];
    uint8_t *extension_list_p = extension_list;
    size_t outer_content_len;
    size_t outer_length_len;
    size_t outer_tlv_len;

    if (tbs_der == NULL || oid == NULL || oid_len == 0 || value == NULL ||
        value_len == 0 || tbs_out == NULL || tbs_out_len == NULL ||
        asn1_read_tlv(tbs_der, tbs_len, &outer_tlv_len) != 0 ||
        tbs_der[0] != ASN1_SEQUENCE ||
        asn1_read_length(tbs_der + 1, tbs_len - 1, &outer_content_len,
                         &outer_length_len) != 0 ||
        outer_tlv_len != tbs_len) {
        return -1;
    }

    build_x509_extension(&extension_list_p, oid, oid_len, 0, value, value_len);

    const uint8_t *content = tbs_der + 1 + outer_length_len;
    size_t content_offset = 0;
    size_t extensions_offset = 0;
    size_t extensions_field_tlv_len = 0;
    size_t extensions_tlv_len = 0;
    size_t extension_content_len = 0;
    bool found_extensions = false;

    while (content_offset < outer_content_len) {
        size_t field_tlv_len;
        if (asn1_read_tlv(content + content_offset,
                          outer_content_len - content_offset,
                          &field_tlv_len) != 0) {
            return -1;
        }
        if (content[content_offset] == (ASN1_CONTEXT_SPECIFIC |
                                        ASN1_CONSTRUCTED | 0x03)) {
            if (found_extensions) {
                return -1;
            }
            const uint8_t *field = content + content_offset;
            size_t field_length_len;
            if (asn1_read_length(field + 1,
                                 field_tlv_len - 1,
                                 &extension_content_len,
                                 &field_length_len) != 0 ||
                field_length_len == 0 ||
                field[1 + field_length_len] != ASN1_SEQUENCE ||
                asn1_read_tlv(field + 1 + field_length_len,
                              extension_content_len,
                              &extensions_tlv_len) != 0) {
                return -1;
            }
            size_t sequence_length_len;
            if (asn1_read_length(field + 1 + field_length_len + 1,
                                 extension_content_len - 1,
                                 &extension_content_len,
                                 &sequence_length_len) != 0 ||
                1 + sequence_length_len + extension_content_len !=
                    extensions_tlv_len) {
                return -1;
            }
            extensions_offset = content_offset;
            extensions_field_tlv_len = field_tlv_len;
            found_extensions = true;
        }
        content_offset += field_tlv_len;
    }

    if (!found_extensions) {
        return -1;
    }

    const uint8_t *field = content + extensions_offset;
    size_t field_length_len;
    size_t field_value_len;
    if (asn1_read_length(field + 1, outer_content_len - extensions_offset - 1,
                         &field_value_len, &field_length_len) != 0) {
        return -1;
    }
    const uint8_t *sequence = field + 1 + field_length_len;
    size_t sequence_length_len;
    size_t sequence_content_len;
    if (asn1_read_length(sequence + 1, field_value_len - 1,
                         &sequence_content_len, &sequence_length_len) != 0) {
        return -1;
    }

    size_t new_sequence_content_len =
        sequence_content_len + PTR_DIFF(extension_list_p, extension_list);
    size_t new_field_value_len = asn1_tlv_size(new_sequence_content_len);
    size_t new_content_len = outer_content_len - extensions_field_tlv_len +
                             asn1_tlv_size(new_field_value_len);
    size_t new_tbs_len = asn1_tlv_size(new_content_len);
    if (new_sequence_content_len == 0 || new_field_value_len == 0 ||
        new_content_len == 0 || new_tbs_len > *tbs_out_len) {
        return -1;
    }

    size_t prefix_len = extensions_offset;
    /* Callers provide distinct input and output buffers. Rebuild directly in
     * the bounded output buffer instead of reserving another 4 KiB stack
     * object on the small OpenTitan test stack. */
    if (tbs_out == tbs_der) return -1;
    uint8_t *rebuilt = tbs_out;
    uint8_t *rebuilt_p = rebuilt;
    asn1_write_header(&rebuilt_p, ASN1_SEQUENCE, new_content_len);
    memcpy(rebuilt_p, content, prefix_len);
    rebuilt_p += prefix_len;
    asn1_write_header(&rebuilt_p,
                      ASN1_CONTEXT_SPECIFIC | ASN1_CONSTRUCTED | 0x03,
                      new_field_value_len);
    asn1_write_header(&rebuilt_p, ASN1_SEQUENCE, new_sequence_content_len);
    memcpy(rebuilt_p, sequence + 1 + sequence_length_len, sequence_content_len);
    rebuilt_p += sequence_content_len;
    memcpy(rebuilt_p, extension_list, PTR_DIFF(extension_list_p, extension_list));
    rebuilt_p += PTR_DIFF(extension_list_p, extension_list);
    size_t suffix_offset = extensions_offset + extensions_field_tlv_len;
    memcpy(rebuilt_p, content + suffix_offset, outer_content_len - suffix_offset);
    rebuilt_p += outer_content_len - suffix_offset;
    if (PTR_DIFF(rebuilt_p, rebuilt) != new_tbs_len) return -1;
    *tbs_out_len = new_tbs_len;
    return 0;
}

int add_bls_rom_extension_to_tbs(
    const uint8_t *tbs_der,
    size_t tbs_len,
    const uint8_t rom_sha256[SHA256_DIGEST_SIZE],
    const uint8_t bls_signature[kOtBlsSignatureBytes],
    uint8_t *tbs_out,
    size_t *tbs_out_len) {
    uint8_t value[X509_BLS_ROM_EXTENSION_VALUE_SIZE];
    uint8_t *value_p = value;

    if (rom_sha256 == NULL || bls_signature == NULL) {
        return -1;
    }
    asn1_write_tag(&value_p, ASN1_OCTET_STRING, rom_sha256,
                   SHA256_DIGEST_SIZE);
    asn1_write_tag(&value_p, ASN1_OCTET_STRING, bls_signature,
                   kOtBlsSignatureBytes);
    return add_private_extension_to_tbs(
        tbs_der, tbs_len, kLegacyBlsRomOid, sizeof(kLegacyBlsRomOid), value,
        PTR_DIFF(value_p, value), tbs_out, tbs_out_len);
}

int add_cluster_bls_binding_extension_to_tbs(
    const uint8_t *tbs_der, size_t tbs_len,
    const uint8_t key_id[X509_CLUSTER_BLS_KEY_ID_BYTES],
    const uint8_t public_key[kOtBlsPublicKeyBytes],
    const uint8_t proof_of_possession[kOtBlsSignatureBytes],
    uint8_t *tbs_out, size_t *tbs_out_len) {
    uint8_t fields[256];
    uint8_t value[256];
    uint8_t expected_key_id[X509_CLUSTER_BLS_KEY_ID_BYTES];
    uint8_t version = X509_CLUSTER_BLS_PROTOCOL_VERSION;
    uint8_t *fields_p = fields;
    uint8_t *value_p = value;

    if (key_id == NULL || public_key == NULL || proof_of_possession == NULL ||
        !ot_bls_key_id_from_public_key(public_key, expected_key_id) ||
        memcmp(expected_key_id, key_id, X509_CLUSTER_BLS_KEY_ID_BYTES) != 0 ||
        !ot_bls_pop_verify(public_key, proof_of_possession)) {
        return -1;
    }
    asn1_write_tag(&fields_p, ASN1_INTEGER, &version, sizeof(version));
    asn1_write_tag(&fields_p, ASN1_UTF8_STRING, kClusterBlsCiphersuite,
                   sizeof(kClusterBlsCiphersuite) - 1);
    asn1_write_tag(&fields_p, ASN1_OCTET_STRING, key_id,
                   X509_CLUSTER_BLS_KEY_ID_BYTES);
    asn1_write_tag(&fields_p, ASN1_OCTET_STRING, public_key,
                   kOtBlsPublicKeyBytes);
    asn1_write_tag(&fields_p, ASN1_OCTET_STRING, proof_of_possession,
                   kOtBlsSignatureBytes);
    asn1_write_tag(&value_p, ASN1_SEQUENCE, fields, PTR_DIFF(fields_p, fields));
    return add_private_extension_to_tbs(
        tbs_der, tbs_len, kClusterBlsOid, sizeof(kClusterBlsOid), value,
        PTR_DIFF(value_p, value), tbs_out, tbs_out_len);
}

static int asn1_get_tag_length(const uint8_t *p, size_t available,
                               uint8_t *tag, size_t *length,
                               size_t *header_len) {
    if (available < 2 || p == NULL || tag == NULL || length == NULL || header_len == NULL) {
        return -1;
    }
    *tag = p[0];
    size_t len_len;
    if (asn1_read_length(p + 1, available - 1, length, &len_len) != 0) {
        return -1;
    }
    *header_len = 1 + len_len;
    if (*length > available - *header_len) {
        return -1;
    }
    return 0;
}

static int extract_bls_rom_extension_value(const uint8_t *ext_value,
                                           size_t ext_value_len,
                                           uint8_t rom_sha256[SHA256_DIGEST_SIZE],
                                           uint8_t bls_signature[kOtBlsSignatureBytes]) {
    if (ext_value == NULL || rom_sha256 == NULL || bls_signature == NULL) {
        return -1;
    }
    if (ext_value_len < 1 || ext_value[0] != ASN1_SEQUENCE) {
        return -1;
    }

    size_t seq_len;
    size_t seq_len_len;
    if (asn1_read_length(ext_value + 1, ext_value_len - 1, &seq_len, &seq_len_len) != 0) {
        return -1;
    }
    const uint8_t *seq_content = ext_value + 1 + seq_len_len;
    size_t seq_content_len = seq_len;
    if (seq_content_len != ext_value_len - 1 - seq_len_len) {
        return -1;
    }

    size_t offset = 0;
    if (offset >= seq_content_len || seq_content[offset++] != ASN1_OCTET_STRING) {
        return -1;
    }
    size_t rom_digest_len;
    size_t rom_digest_len_len;
    if (asn1_read_length(seq_content + offset, seq_content_len - offset,
                         &rom_digest_len, &rom_digest_len_len) != 0) {
        return -1;
    }
    offset += rom_digest_len_len;
    if (rom_digest_len != SHA256_DIGEST_SIZE || offset + rom_digest_len > seq_content_len) {
        return -1;
    }
    memcpy(rom_sha256, seq_content + offset, SHA256_DIGEST_SIZE);
    offset += rom_digest_len;

    if (offset >= seq_content_len || seq_content[offset++] != ASN1_OCTET_STRING) {
        return -1;
    }
    size_t sig_len;
    size_t sig_len_len;
    if (asn1_read_length(seq_content + offset, seq_content_len - offset, &sig_len, &sig_len_len) != 0) {
        return -1;
    }
    offset += sig_len_len;
    if (sig_len != kOtBlsSignatureBytes || offset + sig_len > seq_content_len) {
        return -1;
    }
    memcpy(bls_signature, seq_content + offset, kOtBlsSignatureBytes);
    return 0;
}

static int find_private_extension_value(const uint8_t *cert_der,
                                        size_t cert_len,
                                        const uint8_t *expected_oid,
                                        size_t expected_oid_len,
                                        const uint8_t **ext_value,
                                        size_t *ext_value_len) {
    if (cert_der == NULL || expected_oid == NULL || expected_oid_len == 0 ||
        ext_value == NULL || ext_value_len == NULL) {
        return -1;
    }

    if (cert_len < 2 || cert_der[0] != ASN1_SEQUENCE) {
        return -1;
    }

    size_t cert_len_len;
    size_t cert_content_len;
    if (asn1_read_length(cert_der + 1, cert_len - 1, &cert_content_len, &cert_len_len) != 0) {
        return -1;
    }
    if (1 + cert_len_len + cert_content_len != cert_len) {
        return -1;
    }

    const uint8_t *p = cert_der + 1 + cert_len_len;
    size_t remaining = cert_len - (1 + cert_len_len);

    if (remaining < 2 || *p != ASN1_SEQUENCE) {
        return -1;
    }

    size_t tbs_len_len;
    size_t tbs_content_len;
    if (asn1_read_length(p + 1, remaining - 1, &tbs_content_len, &tbs_len_len) != 0) {
        return -1;
    }
    const uint8_t *tbs_content = p + 1 + tbs_len_len;
    size_t tbs_len = tbs_content_len;
    size_t offset = 0;
    const uint8_t *matched_value = NULL;
    size_t matched_value_len = 0;

    while (offset < tbs_len) {
        size_t field_tlv_len;
        if (asn1_read_tlv(tbs_content + offset, tbs_len - offset, &field_tlv_len) != 0) {
            return -1;
        }

        if (tbs_content[offset] == (ASN1_CONTEXT_SPECIFIC | ASN1_CONSTRUCTED | 0x03)) {
            const uint8_t *field = tbs_content + offset;
            size_t field_value_len;
            size_t field_length_len;
            if (asn1_read_length(field + 1, tbs_len - offset - 1,
                                 &field_value_len, &field_length_len) != 0) {
                return -1;
            }
            const uint8_t *field_value = field + 1 + field_length_len;
            if (field_value_len < 1 || field_value[0] != ASN1_SEQUENCE) {
                return -1;
            }
            size_t seq_len_len;
            size_t seq_content_len;
            if (asn1_read_length(field_value + 1, field_value_len - 1,
                                 &seq_content_len, &seq_len_len) != 0) {
                return -1;
            }
            const uint8_t *extn_sequence = field_value + 1 + seq_len_len;
            size_t extn_sequence_len = seq_content_len;
            size_t extn_offset = 0;

            while (extn_offset < extn_sequence_len) {
                const uint8_t *entry = extn_sequence + extn_offset;
                size_t entry_tlv_len;
                if (asn1_read_tlv(entry, extn_sequence_len - extn_offset,
                                  &entry_tlv_len) != 0) {
                    return -1;
                }
                if (entry_tlv_len < 2 || entry[0] != ASN1_SEQUENCE) {
                    return -1;
                }

                size_t entry_len_len;
                size_t entry_content_len;
                if (asn1_read_length(entry + 1, entry_tlv_len - 1,
                                     &entry_content_len, &entry_len_len) != 0) {
                    return -1;
                }
                const uint8_t *entry_content = entry + 1 + entry_len_len;
                size_t entry_offset = 0;

                uint8_t tag;
                size_t length;
                size_t header_len;
                if (asn1_get_tag_length(entry_content, entry_content_len,
                                        &tag, &length, &header_len) != 0 || tag != ASN1_OID) {
                    return -1;
                }
                if (length == expected_oid_len &&
                    memcmp(entry_content + header_len, expected_oid,
                           expected_oid_len) == 0) {
                    entry_offset = header_len + length;
                    if (entry_offset < entry_content_len &&
                        entry_content[entry_offset] == ASN1_BOOLEAN) {
                        size_t boolean_len;
                        size_t boolean_header_len;
                        if (asn1_get_tag_length(entry_content + entry_offset,
                                                entry_content_len - entry_offset,
                                                &tag, &boolean_len, &boolean_header_len) != 0 ||
                            tag != ASN1_BOOLEAN || boolean_len != 1 ||
                            entry_content[entry_offset + boolean_header_len] != 0x00) {
                            return -1;
                        }
                        entry_offset += boolean_header_len + boolean_len;
                    }
                    if (entry_offset >= entry_content_len ||
                        entry_content[entry_offset] != ASN1_OCTET_STRING) {
                        return -1;
                    }
                    size_t value_len;
                    size_t value_len_len;
                    if (asn1_read_length(entry_content + entry_offset + 1,
                                         entry_content_len - entry_offset - 1,
                                         &value_len, &value_len_len) != 0) {
                        return -1;
                    }
                    size_t value_offset = entry_offset + 1 + value_len_len;
                    if (value_offset + value_len != entry_content_len ||
                        matched_value != NULL) {
                        return -1;
                    }
                    matched_value = entry_content + value_offset;
                    matched_value_len = value_len;
                }

                extn_offset += entry_tlv_len;
            }
        }

        offset += field_tlv_len;
    }

    if (matched_value == NULL) {
        return -1;
    }
    *ext_value = matched_value;
    *ext_value_len = matched_value_len;
    return 0;
}

int extract_bls_rom_extension_from_cert(
    const uint8_t *cert_der,
    size_t cert_len,
    uint8_t rom_sha256[SHA256_DIGEST_SIZE],
    uint8_t bls_signature[kOtBlsSignatureBytes]) {
    const uint8_t *ext_value;
    size_t ext_value_len;
    if (find_private_extension_value(cert_der, cert_len, kLegacyBlsRomOid,
                                     sizeof(kLegacyBlsRomOid), &ext_value,
                                     &ext_value_len) != 0) {
        return -1;
    }
    return extract_bls_rom_extension_value(ext_value, ext_value_len,
                                           rom_sha256, bls_signature);
}

bool verify_bls_rom_extension(
    const uint8_t *cert_der,
    size_t cert_len,
    const uint8_t bls_public_key[kOtBlsPublicKeyBytes]) {
    uint8_t rom_sha256[SHA256_DIGEST_SIZE];
    uint8_t bls_signature[kOtBlsSignatureBytes];
    if (extract_bls_rom_extension_from_cert(cert_der, cert_len,
                                            rom_sha256, bls_signature) != 0) {
        return false;
    }
    return ot_bls_verify(bls_public_key, bls_signature,
                         rom_sha256, SHA256_DIGEST_SIZE);
}

static int read_expected_tlv(const uint8_t *data, size_t data_len,
                             size_t *offset, uint8_t expected_tag,
                             const uint8_t **value, size_t *value_len) {
    uint8_t tag;
    size_t header_len;
    if (data == NULL || offset == NULL || value == NULL || value_len == NULL ||
        *offset >= data_len ||
        asn1_get_tag_length(data + *offset, data_len - *offset, &tag,
                            value_len, &header_len) != 0 ||
        tag != expected_tag) {
        return -1;
    }
    *value = data + *offset + header_len;
    *offset += header_len + *value_len;
    return 0;
}

static int extract_cluster_bls_binding_value(
    const uint8_t *ext_value, size_t ext_value_len,
    uint8_t key_id[X509_CLUSTER_BLS_KEY_ID_BYTES],
    uint8_t public_key[kOtBlsPublicKeyBytes],
    uint8_t proof_of_possession[kOtBlsSignatureBytes]) {
    uint8_t tag;
    size_t seq_len;
    size_t seq_header_len;
    const uint8_t *sequence;
    const uint8_t *field;
    size_t field_len;
    size_t offset = 0;
    uint8_t expected_key_id[X509_CLUSTER_BLS_KEY_ID_BYTES];

    if (ext_value == NULL || key_id == NULL || public_key == NULL ||
        proof_of_possession == NULL ||
        asn1_get_tag_length(ext_value, ext_value_len, &tag, &seq_len,
                            &seq_header_len) != 0 ||
        tag != ASN1_SEQUENCE || seq_header_len + seq_len != ext_value_len) {
        return -1;
    }
    sequence = ext_value + seq_header_len;
    if (read_expected_tlv(sequence, seq_len, &offset, ASN1_INTEGER, &field,
                          &field_len) != 0 ||
        field_len != 1 || field[0] != X509_CLUSTER_BLS_PROTOCOL_VERSION ||
        read_expected_tlv(sequence, seq_len, &offset, ASN1_UTF8_STRING,
                          &field, &field_len) != 0 ||
        field_len != sizeof(kClusterBlsCiphersuite) - 1 ||
        memcmp(field, kClusterBlsCiphersuite, field_len) != 0 ||
        read_expected_tlv(sequence, seq_len, &offset, ASN1_OCTET_STRING,
                          &field, &field_len) != 0 ||
        field_len != X509_CLUSTER_BLS_KEY_ID_BYTES) {
        return -1;
    }
    memcpy(key_id, field, X509_CLUSTER_BLS_KEY_ID_BYTES);
    if (read_expected_tlv(sequence, seq_len, &offset, ASN1_OCTET_STRING,
                          &field, &field_len) != 0 ||
        field_len != kOtBlsPublicKeyBytes) {
        return -1;
    }
    memcpy(public_key, field, kOtBlsPublicKeyBytes);
    if (read_expected_tlv(sequence, seq_len, &offset, ASN1_OCTET_STRING,
                          &field, &field_len) != 0 ||
        field_len != kOtBlsSignatureBytes || offset != seq_len) {
        return -1;
    }
    memcpy(proof_of_possession, field, kOtBlsSignatureBytes);
    if (!ot_bls_key_id_from_public_key(public_key, expected_key_id) ||
        memcmp(expected_key_id, key_id, X509_CLUSTER_BLS_KEY_ID_BYTES) != 0 ||
        !ot_bls_pop_verify(public_key, proof_of_possession)) {
        return -1;
    }
    return 0;
}

int extract_cluster_bls_binding_from_cert(
    const uint8_t *cert_der, size_t cert_len,
    uint8_t key_id[X509_CLUSTER_BLS_KEY_ID_BYTES],
    uint8_t public_key[kOtBlsPublicKeyBytes],
    uint8_t proof_of_possession[kOtBlsSignatureBytes]) {
    const uint8_t *ext_value;
    size_t ext_value_len;
    if (find_private_extension_value(cert_der, cert_len, kClusterBlsOid,
                                     sizeof(kClusterBlsOid), &ext_value,
                                     &ext_value_len) != 0) {
        return -1;
    }
    return extract_cluster_bls_binding_value(ext_value, ext_value_len, key_id,
                                             public_key, proof_of_possession);
}

bool verify_cluster_bls_binding(const uint8_t *cert_der, size_t cert_len) {
    uint8_t key_id[X509_CLUSTER_BLS_KEY_ID_BYTES];
    uint8_t public_key[kOtBlsPublicKeyBytes];
    uint8_t proof_of_possession[kOtBlsSignatureBytes];
    return extract_cluster_bls_binding_from_cert(
               cert_der, cert_len, key_id, public_key, proof_of_possession) == 0;
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

static int encode_ecdsa_signature_der(const uint8_t *sig_r,
                                      const uint8_t *sig_s, size_t width,
                                      uint8_t *out, size_t *out_len) {
    size_t r_offset = 0;
    size_t s_offset = 0;
    size_t r_len;
    size_t s_len;
    bool r_pad;
    bool s_pad;
    size_t inner_len;
    size_t total_len;
    uint8_t *p;

    if (sig_r == NULL || sig_s == NULL || out == NULL || out_len == NULL ||
        width == 0) {
        return -1;
    }
    while (r_offset + 1 < width && sig_r[r_offset] == 0) ++r_offset;
    while (s_offset + 1 < width && sig_s[s_offset] == 0) ++s_offset;
    r_len = width - r_offset;
    s_len = width - s_offset;
    r_pad = (sig_r[r_offset] & 0x80) != 0;
    s_pad = (sig_s[s_offset] & 0x80) != 0;
    inner_len = asn1_tlv_size(r_len + (r_pad ? 1U : 0U)) +
                asn1_tlv_size(s_len + (s_pad ? 1U : 0U));
    total_len = asn1_tlv_size(inner_len);
    if (inner_len == 0 || total_len == 0 || *out_len < total_len) {
        return -1;
    }

    p = out;
    asn1_write_header(&p, ASN1_SEQUENCE, inner_len);
    *p++ = ASN1_INTEGER;
    asn1_write_length(&p, r_len + (r_pad ? 1U : 0U));
    if (r_pad) *p++ = 0;
    memcpy(p, sig_r + r_offset, r_len);
    p += r_len;
    *p++ = ASN1_INTEGER;
    asn1_write_length(&p, s_len + (s_pad ? 1U : 0U));
    if (s_pad) *p++ = 0;
    memcpy(p, sig_s + s_offset, s_len);
    p += s_len;
    if ((size_t)(p - out) != total_len) {
        return -1;
    }
    *out_len = total_len;
    return 0;
}

static int add_ecdsa_signature_to_cert(const uint8_t *tbs_der, size_t tbs_len,
                                       const uint8_t *sig_r,
                                       const uint8_t *sig_s, size_t sig_width,
                                       const uint8_t *sig_alg, size_t sig_alg_len,
                                       uint8_t *cert_out, size_t *cert_len) {
    uint8_t sig_der[192];
    size_t sig_der_len = sizeof(sig_der);
    size_t bit_string_value_len;
    size_t bit_string_tlv_len;
    size_t inner_len;
    size_t total_len;
    uint8_t *p;

    if (tbs_der == NULL || sig_r == NULL || sig_s == NULL || sig_alg == NULL ||
        cert_out == NULL || cert_len == NULL || tbs_len > 0xffff ||
        encode_ecdsa_signature_der(sig_r, sig_s, sig_width, sig_der,
                                   &sig_der_len) != 0) {
        return -1;
    }
    bit_string_value_len = 1 + sig_der_len;
    bit_string_tlv_len = asn1_tlv_size(bit_string_value_len);
    inner_len = tbs_len + sig_alg_len + bit_string_tlv_len;
    total_len = asn1_tlv_size(inner_len);
    if (bit_string_tlv_len == 0 || total_len == 0 || *cert_len < total_len) {
        return -1;
    }

    p = cert_out;
    asn1_write_header(&p, ASN1_SEQUENCE, inner_len);
    memcpy(p, tbs_der, tbs_len);
    p += tbs_len;
    memcpy(p, sig_alg, sig_alg_len);
    p += sig_alg_len;
    *p++ = ASN1_BIT_STRING;
    asn1_write_length(&p, bit_string_value_len);
    *p++ = 0;
    memcpy(p, sig_der, sig_der_len);
    p += sig_der_len;
    if ((size_t)(p - cert_out) != total_len) {
        return -1;
    }
    *cert_len = total_len;
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
    const uint8_t sig_alg[] = {
        0x30, 0x0A, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE,
        0x3D, 0x04, 0x03, 0x02,
    };
    uint8_t sig_r[32];
    uint8_t sig_s[32];

    if (sig_r_words == NULL || sig_s_words == NULL) {
        return -1;
    }
    convert_le32_to_be_bytes(sig_r, sig_r_words, 8);
    convert_le32_to_be_bytes(sig_s, sig_s_words, 8);
    return add_ecdsa_signature_to_cert(tbs_der, tbs_len, sig_r, sig_s,
                                       sizeof(sig_r), sig_alg, sizeof(sig_alg),
                                       cert_out, cert_len);
}

int add_signature_to_cert_p384_sig(
    const uint8_t *tbs_der,
    size_t tbs_len,
    const uint8_t *sig_r_bytes,
    const uint8_t *sig_s_bytes,
    uint8_t *cert_out,
    size_t *cert_len)
{
    const uint8_t sig_alg[] = {
        0x30, 0x0A, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE,
        0x3D, 0x04, 0x03, 0x03,
    };
    return add_ecdsa_signature_to_cert(tbs_der, tbs_len, sig_r_bytes,
                                       sig_s_bytes, 48, sig_alg,
                                       sizeof(sig_alg), cert_out, cert_len);
}

static int extract_ecc_int(const uint8_t **p, uint8_t out[48]) {
    if (*(*p)++ != 0x02) return -1;
    size_t len = *(*p)++;
    if (len > 0x80) return -1;
    if (len == 49) {
        if (*(*p)++ != 0x00) return -1;
        len = 48;
    } else if (len > 48) {
        return -1;
    }
    size_t pad = 48 - len;
    memset(out, 0, pad);
    memcpy(out + pad, *p, len);
    *p += len;
    return 0;
}

static int x509_read_bounded_length(const uint8_t **cursor,
                                    const uint8_t *end, size_t *length)
{
    uint8_t first;
    size_t count;
    size_t value = 0;

    if (!cursor || !*cursor || !end || !length || *cursor >= end)
        return -1;
    first = *(*cursor)++;
    if ((first & 0x80) == 0) {
        value = first;
    } else {
        count = first & 0x7f;
        if (count == 0 || count > sizeof(size_t) ||
            (size_t)(end - *cursor) < count || (*cursor)[0] == 0)
            return -1;
        for (size_t i = 0; i < count; ++i)
            value = (value << 8) | *(*cursor)++;
        if (value < 128)
            return -1;
    }
    if (value > (size_t)(end - *cursor))
        return -1;
    *length = value;
    return 0;
}

int x509_get_tbs_der(const uint8_t *cert_der, size_t cert_len,
                     const uint8_t **tbs_der, size_t *tbs_len)
{
    const uint8_t *cursor;
    const uint8_t *end;
    const uint8_t *outer_content;
    const uint8_t *tbs_start;
    size_t outer_len;
    size_t tbs_content_len;

    if (!cert_der || !tbs_der || !tbs_len || cert_len < 4)
        return -1;
    cursor = cert_der;
    end = cert_der + cert_len;
    if (*cursor++ != ASN1_SEQUENCE ||
        x509_read_bounded_length(&cursor, end, &outer_len) != 0)
        return -1;
    outer_content = cursor;
    if (outer_len != (size_t)(end - outer_content) || cursor >= end)
        return -1;

    tbs_start = cursor;
    if (*cursor++ != ASN1_SEQUENCE ||
        x509_read_bounded_length(&cursor, end, &tbs_content_len) != 0 ||
        tbs_content_len > (size_t)(end - cursor))
        return -1;
    *tbs_der = tbs_start;
    *tbs_len = (size_t)(cursor - tbs_start) + tbs_content_len;
    return 0;
}


int verify_cert(const uint8_t *cert_der, size_t cert_len, const uint8_t public_key[ECC_BYTES + 1]) {
    const uint8_t *p = cert_der;

    if (*p++ != 0x30) return 0;
    size_t len = *p++;
    if (len > 0x80) {
        size_t bytes = len & 0x7F;
        len = 0;
        while (bytes--) len = (len << 8) | *p++;
    }

    const uint8_t *tbs_start = p;
    if (*p++ != 0x30) return 0;
    size_t tbs_content_len = *p++;
    size_t tbs_len_len = 1;
    if (tbs_content_len > 0x80) {
        size_t bytes = tbs_content_len & 0x7F;
        tbs_len_len += bytes;
        tbs_content_len = 0;
        while (bytes--) tbs_content_len = (tbs_content_len << 8) | *p++;
    }

    size_t tbs_total_len = 1 + tbs_len_len + tbs_content_len;
    const uint8_t *tbs_data = tbs_start;

    p = tbs_start + tbs_total_len;

    const uint8_t sig_alg[12] = {
        0x30, 0x0A, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x03
    };
    if (memcmp(p, sig_alg, 12) != 0) return 0;
    p += 12;

    if (*p++ != 0x03) return 0;
    len = *p++;
    if (len > 0x80) {
        size_t bytes = len & 0x7F;
        len = 0;
        while (bytes--) len = (len << 8) | *p++;
    }
    if (*p++ != 0x00) return 0;

    if (*p++ != 0x30) return 0;
    len = *p++;
    if (len > 0x80) {
        size_t bytes = len & 0x7F;
        len = 0;
        while (bytes--) len = (len << 8) | *p++;
    }

    uint8_t r[48], s[48];
    if (extract_ecc_int(&p, r) != 0) return 0;
    if (extract_ecc_int(&p, s) != 0) return 0;

    uint8_t signature[96];
    memcpy(signature,       r, 48);
    memcpy(signature + 48, s, 48);

    uint8_t hash[48];
    SHA384_hash(tbs_data, tbs_total_len, hash);

    return ecdsa_verify(public_key, hash, signature);
}
