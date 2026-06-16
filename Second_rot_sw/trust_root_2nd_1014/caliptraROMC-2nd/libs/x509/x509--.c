#include "x509.h"

cert_t cert_store[3]; // 索引 0: LDEVID, 1: FMC, 2: RT

// 写入 ASN.1 长度字段
static void asn1_write_length(uint8_t **p, size_t length) {
    if (length < 0x80) {
        *(*p)++ = (uint8_t)length;
    } else {
        uint8_t len_bytes = 0;
        size_t tmp = length;
        while (tmp > 0) {
            tmp >>= 8;
            len_bytes++;
        }
        *(*p)++ = 0x80 | len_bytes;
        for (int i = len_bytes - 1; i >= 0; i--) {
            *(*p)++ = (length >> (8 * i)) & 0xFF;
        }
    }
}

// 写入 ASN.1 标签 + 长度 + 值
static void asn1_write_tag(uint8_t **p, uint8_t tag, const uint8_t *value, size_t len) {
    printf("Writing tag 0x%02X, length 0x%x\n", tag, len);
    *(*p)++ = tag;
    asn1_write_length(p, len);
    memcpy(*p, value, len);
    *p += len;
}

// 生成 ECC 公钥的 SubjectPublicKeyInfo (DER 格式)
static void build_ecc_pubkey_der(uint8_t **p, const uint8_t *pubkey_x, const uint8_t *pubkey_y) {
    // 未压缩公钥格式: 0x04 + X + Y (共 97 字节)
    uint8_t pubkey_raw[97] = {0x04};
    memcpy(pubkey_raw + 1, pubkey_x, 48);
    memcpy(pubkey_raw + 49, pubkey_y, 48);

    // SubjectPublicKeyInfo 的算法标识 (secp384r1 OID)
    const uint8_t ec_params[] = {0x2B, 0x81, 0x04, 0x00, 0x22}; // 1.3.132.0.34

    // 1. 写入公钥 BIT STRING
    asn1_write_tag(p, ASN1_BIT_STRING, pubkey_raw, sizeof(pubkey_raw));

    // 2. 写入算法标识 (SEQUENCE + OID)
    uint8_t alg_seq[32], *alg_p = alg_seq;
    asn1_write_tag(&alg_p, ASN1_OID, ec_params, sizeof(ec_params));
    asn1_write_tag(p, ASN1_SEQUENCE, alg_seq, alg_p - alg_seq);
}

// 生成 CSR 的 DER 编码
int generate_csr_der(
    const uint8_t *pubkey_x,  // ECC 公钥 X 坐标 (48 字节)
    const uint8_t *pubkey_y,  // ECC 公钥 Y 坐标 (48 字节)
    const char *subject_name, // 主题名称 (如 "CN=Device")
    uint8_t *der_out,         // 输出 DER 数据
    size_t *der_len          // 输出 DER 长度
) {
    uint8_t *p = der_out + 512; // DER 从后往前写
    uint8_t *start = p;

    // 1. 构造 SubjectPublicKeyInfo
    build_ecc_pubkey_der(&p, pubkey_x, pubkey_y);

    // 2. 写入主题名称 (UTF8String)
    uint8_t subject[128], *sub_p = subject;
    asn1_write_tag(&sub_p, ASN1_UTF8_STRING, (uint8_t*)subject_name, strlen(subject_name));
    asn1_write_tag(&p, ASN1_SEQUENCE, subject, sub_p - subject);

    // 3. 写入版本号 (INTEGER 0)
    uint8_t version = 0;
    asn1_write_tag(&p, ASN1_INTEGER, &version, 1);

    // 4. 封装为 CSR 主体 (SEQUENCE)
    uint8_t *csr_body_start = p;
    asn1_write_tag(&p, ASN1_SEQUENCE, p, start - p);

    // 5. 调整 DER 数据到缓冲区开头
    *der_len = csr_body_start - p;
    memmove(der_out, p, *der_len);

    return 0;
}

// 生成 X.509 证书的 DER 编码
int generate_cert_der(
    const uint8_t *pubkey_x,
    const uint8_t *pubkey_y,
    const uint8_t *sig_r,
    const uint8_t *sig_s,
    const char *issuer_name,
    const char *subject_name,
    uint32_t serial,
    uint8_t extensions,
    uint8_t *der_out,
    size_t *der_len
) {
    uint8_t *p = der_out + 2048; // 从后往前写
    uint8_t *start = p;
    uint8_t *tbs_end;
    if (der_out == NULL || der_len == NULL || *der_len < 2048) {
        printf("Error: Invalid buffer (der_out=%p, der_len=%p, *der_len=%zu)\n",
               der_out, der_len, der_len ? *der_len : 0);
        return -1;
    }

    if (!pubkey_x || !pubkey_y || !sig_r || !sig_s || !issuer_name || !subject_name) {
        printf("Error: NULL input parameter\n");
        return -1;
    }

    // 1. 构造 SubjectPublicKeyInfo
    build_ecc_pubkey_der(&p, pubkey_x, pubkey_y);

    // 2. 写入主题名称
    uint8_t subject[128], *sub_p = subject;
    asn1_write_tag(&sub_p, ASN1_UTF8_STRING, (uint8_t*)subject_name, strlen(subject_name));
    asn1_write_tag(&p, ASN1_SEQUENCE, subject, sub_p - subject);

    // 3. 写入颁发者名称
    uint8_t issuer[128], *iss_p = issuer;
    asn1_write_tag(&iss_p, ASN1_UTF8_STRING, (uint8_t*)issuer_name, strlen(issuer_name));
    asn1_write_tag(&p, ASN1_SEQUENCE, issuer, iss_p - issuer);

    // 4. 写入有效期
    uint8_t validity[] = {
        0x17, 0x0D, '2', '0', '2', '5', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', 'Z', // notBefore
        0x17, 0x0D, '2', '0', '2', '7', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', 'Z'  // notAfter
    };
    asn1_write_tag(&p, ASN1_SEQUENCE, validity, sizeof(validity));

    // 5. 写入序列号 (INTEGER)
    uint8_t serial_bytes[4] = {
        (serial >> 24) & 0xFF,
        (serial >> 16) & 0xFF,
        (serial >> 8) & 0xFF,
        serial & 0xFF
    };
    asn1_write_tag(&p, ASN1_INTEGER, serial_bytes, sizeof(serial_bytes));

    // 6. 添加扩展字段（如 CA 证书标记）
    if (extensions & X509_EXT_BASIC_CONSTRAINTS_CA) {
        uint8_t ext_basic_constraints[] = {
            0x30, 0x0C,  // SEQUENCE (12 bytes)
            0x06, 0x03, 0x55, 0x1D, 0x13,  // OID: basicConstraints
            0x01, 0x01, 0xFF,              // critical: TRUE
            0x04, 0x02, 0x30, 0x00         // OCTET STRING: CA:TRUE
        };
        asn1_write_tag(&p, ASN1_SEQUENCE, ext_basic_constraints, sizeof(ext_basic_constraints));
    }

    // 7. 封装为 TBSCertificate (SEQUENCE)
    tbs_end = p; // 记录TBSCertificate结束位置
    size_t tbs_content_length = tbs_end - start;
    
    // 计算长度字段需要的字节数
    size_t len_bytes = 1;
    if (tbs_content_length >= 0x80) {
        size_t tmp = tbs_content_length;
        while (tmp > 0) {
            tmp >>= 8;
            len_bytes++;
        }
    }
    
    // 预留空间(SEQUENCE tag + 长度字段)
    p -= (1 + len_bytes);
    
    // 写入SEQUENCE头和长度
    asn1_write_tag(&p, ASN1_SEQUENCE, start, tbs_content_length);
    printf("TBSCertificate content length: 0x%x\n", tbs_content_length);
    printf("Length bytes needed: 0x%x\n", len_bytes);

    // 8. 写入签名算法 (ecdsaWithSHA384)
    uint8_t sig_alg[] = {0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03};
    asn1_write_tag(&p, ASN1_SEQUENCE, sig_alg, sizeof(sig_alg));

    // 9. 写入签名值 (BIT STRING)
    uint8_t signature[96];
    memcpy(signature, sig_r, 48);
    memcpy(signature + 48, sig_s, 48);
    asn1_write_tag(&p, ASN1_BIT_STRING, signature, sizeof(signature));

    // 10. 封装为完整证书 (SEQUENCE)
    uint8_t *cert_content_start = p;
    size_t cert_content_length = (der_out + 2048) - p;
    
    // 计算证书总长度(包括SEQUENCE头和长度字段)
    size_t cert_len_bytes = 1;
    if (cert_content_length >= 0x80) {
        size_t tmp = cert_content_length;
        while (tmp > 0) {
            tmp >>= 8;
            cert_len_bytes++;
        }
    }
    
    // 预留空间(SEQUENCE tag + 长度字段)
    p -= (1 + cert_len_bytes);
    
    // 写入证书SEQUENCE头和长度
    asn1_write_tag(&p, ASN1_SEQUENCE, cert_content_start, cert_content_length);
    // 检查指针是否有效
    if (p < der_out) {
        printf("Error: Buffer underflow! p=0x%08x, der_out=0x%08x\n",(unsigned int)p, (unsigned int)der_out);
        return -1;
    }

    // 复制数据到缓冲区开头
    *der_len = start - p;
    printf("cert_len = 0x%x\n", *der_len);
    memcpy(der_out, p, *der_len);

    return 0;
}

int generate_root_ca(
    const uint8_t *ca_pubkey_x,  // 根CA公钥X
    const uint8_t *ca_pubkey_y,  // 根CA公钥Y 
    const uint8_t *ca_sig_r,     // 根CA自签名r
    const uint8_t *ca_sig_s,     // 根CA自签名s
    uint8_t *der_out,
    size_t *der_len
) {
    return generate_cert_der(
        ca_pubkey_x, ca_pubkey_y,
        ca_sig_r, ca_sig_s,
        "CN=Root CA", "InitialDeviceID",  // 自签名
        11111111,                          // 固定序列号
        X509_EXT_BASIC_CONSTRAINTS_CA, // 标记为CA证书
        der_out, der_len
    );
}

int generate_intermediate_tbs_der(
    const uint8_t *pubkey_x,      // 中间CA公钥X (48字节)
    const uint8_t *pubkey_y,      // 中间CA公钥Y (48字节)
    const char *issuer_name,      // 颁发者名称 (如"CN=Root CA")
    const char *subject_name,    // 主题名称 (如"CN=Intermediate CA")
    uint32_t serial,             // 序列号
    uint8_t *tbs_out,            // 输出TBSCertificate DER数据
    size_t *tbs_len,             // 输出数据长度
    uint8_t cert_type            // 证书类型：LDEVID, FMC, RT
) {
    uint8_t *p = tbs_out + 512;  // DER从后往前写
    uint8_t *start = p;

    /* 1. 版本号 (v3) */
    uint8_t version[] = {0xA0, 0x03, 0x02, 0x01, 0x02}; // ContextSpecific[0] + INTEGER 2
    asn1_write_tag(&p, ASN1_CONTEXT_SPECIFIC, version, sizeof(version));

    /* 2. 序列号 */
    uint8_t serial_bytes[4] = {
        (serial >> 24) & 0xFF,
        (serial >> 16) & 0xFF,
        (serial >> 8) & 0xFF,
        serial & 0xFF
    };
    asn1_write_tag(&p, ASN1_INTEGER, serial_bytes, sizeof(serial_bytes));

    /* 3. 签名算法 (ecdsaWithSHA384) */
    uint8_t sig_alg[] = {0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03};
    asn1_write_tag(&p, ASN1_SEQUENCE, sig_alg, sizeof(sig_alg));

    /* 4. 颁发者名称 */
    uint8_t issuer[128], *iss_p = issuer;
    asn1_write_tag(&iss_p, ASN1_UTF8_STRING, (uint8_t*)issuer_name, strlen(issuer_name));
    asn1_write_tag(&p, ASN1_SEQUENCE, issuer, iss_p - issuer);

    /* 5. 有效期  */
    uint8_t validity[] = {
        0x17, 0x0D, '2', '0', '2', '5', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', 'Z', // notBefore
        0x17, 0x0D, '2', '0', '3', '5', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', 'Z'  // notAfter
    };
    asn1_write_tag(&p, ASN1_SEQUENCE, validity, sizeof(validity));

    /* 6. 主题名称 */
    uint8_t subject[128], *sub_p = subject;
    asn1_write_tag(&sub_p, ASN1_UTF8_STRING, (uint8_t*)subject_name, strlen(subject_name));
    asn1_write_tag(&p, ASN1_SEQUENCE, subject, sub_p - subject);

    /* 7. 公钥信息 */
    uint8_t pubkey_der[97] = {0x04}; // 0x04 + X + Y
    memcpy(pubkey_der + 1, pubkey_x, 48);
    memcpy(pubkey_der + 49, pubkey_y, 48);
    
    uint8_t pubkey_seq[256], *pk_p = pubkey_seq;
    asn1_write_tag(&pk_p, ASN1_BIT_STRING, pubkey_der, sizeof(pubkey_der));
    
    const uint8_t ec_params[] = {0x06, 0x05, 0x2B, 0x81, 0x04, 0x00, 0x22}; // secp384r1 OID
    asn1_write_tag(&pk_p, ASN1_SEQUENCE, ec_params, sizeof(ec_params));
    
    asn1_write_tag(&p, ASN1_SEQUENCE, pubkey_seq, pk_p - pubkey_seq);

    /* 8. 扩展字段 (关键) */
    uint8_t extensions[256], *ext_p = extensions;
    
    // Basic Constraints: CA:TRUE
    uint8_t basic_constraints[] = {
        0x30, 0x0C,  // SEQUENCE (12 bytes)
        0x06, 0x03, 0x55, 0x1D, 0x13,  // OID: basicConstraints
        0x01, 0x01, 0xFF,              // critical: TRUE
        0x04, 0x03, 0x30, 0x01, 0x01   // OCTET STRING: CA:TRUE
    };
    asn1_write_tag(&ext_p, ASN1_SEQUENCE, basic_constraints, sizeof(basic_constraints));

    // Key Usage: keyCertSign
    uint8_t key_usage[] = {
        0x30, 0x0E,  // SEQUENCE (14 bytes)
        0x06, 0x03, 0x55, 0x1D, 0x0F,  // OID: keyUsage
        0x01, 0x01, 0xFF,              // critical: TRUE
        0x04, 0x04, 0x03, 0x02, 0x04, 0x80  // BIT STRING: keyCertSign
    };
    asn1_write_tag(&ext_p, ASN1_SEQUENCE, key_usage, sizeof(key_usage));

    // 根据证书类型添加特定扩展
    switch (cert_type) {
        case LDEVID:
            // LDEVID 特定扩展
            uint8_t ldevid_ext[] = {
                0x30, 0x0A,  // SEQUENCE (10 bytes)
                0x06, 0x08, 0x2B, 0x06, 0x01, 0x04, 0x01, 0x82, 0x37, 0x15  // OID: LDEVID
            };
            asn1_write_tag(&ext_p, ASN1_SEQUENCE, ldevid_ext, sizeof(ldevid_ext));
            break;
        case FMC:
            // FMC 特定扩展
            uint8_t fmc_ext[] = {
                0x30, 0x0A,  // SEQUENCE (10 bytes)
                0x06, 0x08, 0x2B, 0x06, 0x01, 0x04, 0x01, 0x82, 0x37, 0x16  // OID: FMC
            };
            asn1_write_tag(&ext_p, ASN1_SEQUENCE, fmc_ext, sizeof(fmc_ext));
            break;
        case RT:
            // RT 特定扩展
            uint8_t rt_ext[] = {
                0x30, 0x0A,  // SEQUENCE (10 bytes)
                0x06, 0x08, 0x2B, 0x06, 0x01, 0x04, 0x01, 0x82, 0x37, 0x17  // OID: RT
            };
            asn1_write_tag(&ext_p, ASN1_SEQUENCE, rt_ext, sizeof(rt_ext));
            break;
        default:
            break;
    }

    // 封装所有扩展
    uint8_t ext_seq[256], *ext_seq_p = ext_seq;
    asn1_write_tag(&ext_seq_p, ASN1_SEQUENCE, extensions, ext_p - extensions);
    asn1_write_tag(&p, ASN1_CONTEXT_SPECIFIC | 0x03, ext_seq, ext_seq_p - ext_seq);

    /* 9. 封装为TBSCertificate */
    uint8_t *tbs_start = p;
    asn1_write_tag(&p, ASN1_SEQUENCE, p, start - p);

    /* 10. 调整数据到缓冲区开头 */
    *tbs_len = tbs_start - p;
    memmove(tbs_out, p, *tbs_len);

    /* 11. 存储证书到全局变量 */
    switch (cert_type) {
        case LDEVID:
            memcpy(cert_store[0].der_data, tbs_out, *tbs_len);
            cert_store[0].der_len = *tbs_len;
            cert_store[0].type = CERT_TYPE_LDEVID;
            break;
        case FMC:
            memcpy(cert_store[1].der_data, tbs_out, *tbs_len);
            cert_store[1].der_len = *tbs_len;
            cert_store[1].type = CERT_TYPE_FMC;
            break;
        case RT:
            memcpy(cert_store[2].der_data, tbs_out, *tbs_len);
            cert_store[2].der_len = *tbs_len;
            cert_store[2].type = CERT_TYPE_RT;
            break;
        default:
            break;
    }

    return 0;
}

/**
 * @brief 生成 RT 终端证书的待签名部分（TBSCertificate）
 * @param pubkey_x, pubkey_y   - 证书公钥 (X, Y 坐标)
 * @param issuer_name          - 颁发者名称（如 "CN=Caliptra Runtime Alias"）
 * @param subject_name         - 主题名称（如 "CN=Caliptra DPE Leaf"）
 * @param serial               - 序列号（20 字节，SHA256(公钥) 前 20 字节）
 * @param tbs_out              - 输出 TBSCertificate DER 数据
 * @param tbs_len              - 输出 TBSCertificate 长度
 * @return 0 成功，-1 失败
 */
int generate_rt_tbs_der(
    const uint8_t *pubkey_x,
    const uint8_t *pubkey_y,
    const char *issuer_name,
    const char *subject_name,
    const uint8_t *serial,      // 20 字节序列号
    uint8_t *tbs_out,
    size_t *tbs_len
) {
    uint8_t *p = tbs_out + 512; // DER 从后往前写
    uint8_t *start = p;

    /* --- TBSCertificate 字段 --- */
    // 1. 版本号 (v3)
    uint8_t version[] = {0xA0, 0x03, 0x02, 0x01, 0x02}; // ContextSpecific[0] + INTEGER 2
    asn1_write_tag(&p, ASN1_CONTEXT_SPECIFIC, version, sizeof(version));

    // 2. 序列号 (20 字节)
    asn1_write_tag(&p, ASN1_INTEGER, serial, 20);

    // 3. 签名算法 (ecdsaWithSHA384)
    uint8_t sig_alg[] = {0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03};
    asn1_write_tag(&p, ASN1_SEQUENCE, sig_alg, sizeof(sig_alg));

    // 4. 颁发者名称
    uint8_t issuer[128], *iss_p = issuer;
    asn1_write_tag(&iss_p, ASN1_UTF8_STRING, (uint8_t*)issuer_name, strlen(issuer_name));
    asn1_write_tag(&p, ASN1_SEQUENCE, issuer, iss_p - issuer);

    // 5. 有效期
    uint8_t validity[] = {
        0x17, 0x0D, '2', '0', '2', '5', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', 'Z', // notBefore
        0x17, 0x0D, '2', '0', '3', '5', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', 'Z'  // notAfter
    };
    asn1_write_tag(&p, ASN1_SEQUENCE, validity, sizeof(validity));

    // 6. 主题名称
    uint8_t subject[128], *sub_p = subject;
    asn1_write_tag(&sub_p, ASN1_UTF8_STRING, (uint8_t*)subject_name, strlen(subject_name));
    asn1_write_tag(&p, ASN1_SEQUENCE, subject, sub_p - subject);

    // 7. 公钥信息
    uint8_t pubkey_der[97] = {0x04}; // 0x04 + X + Y
    memcpy(pubkey_der + 1, pubkey_x, 48);
    memcpy(pubkey_der + 49, pubkey_y, 48);
    asn1_write_tag(&p, ASN1_BIT_STRING, pubkey_der, sizeof(pubkey_der));

    // 8. 扩展字段（RT 特定）
    uint8_t extensions[256], *ext_p = extensions;
    
    // Basic Constraints: CA:FALSE
    uint8_t basic_constraints[] = {
        0x30, 0x0A, 0x06, 0x03, 0x55, 0x1D, 0x13, 0x01, 0x01, 0xFF, 0x04, 0x02, 0x30, 0x00
    };
    asn1_write_tag(&ext_p, ASN1_SEQUENCE, basic_constraints, sizeof(basic_constraints));

    // Key Usage: keyCertSign
    uint8_t key_usage[] = {
        0x30, 0x0E, 0x06, 0x03, 0x55, 0x1D, 0x0F, 0x01, 0x01, 0xFF, 0x04, 0x04, 0x03, 0x02, 0x04, 0x80
    };
    asn1_write_tag(&ext_p, ASN1_SEQUENCE, key_usage, sizeof(key_usage));

    // RT 特定扩展（OID: 1.3.6.1.4.1.4128.23）
    uint8_t rt_ext[] = {
        0x30, 0x0A, 0x06, 0x08, 0x2B, 0x06, 0x01, 0x04, 0x01, 0x82, 0x37, 0x17
    };
    asn1_write_tag(&ext_p, ASN1_SEQUENCE, rt_ext, sizeof(rt_ext));

    // 封装所有扩展
    uint8_t ext_seq[256], *ext_seq_p = ext_seq;
    asn1_write_tag(&ext_seq_p, ASN1_SEQUENCE, extensions, ext_p - extensions);
    asn1_write_tag(&p, ASN1_CONTEXT_SPECIFIC | 0x03, ext_seq, ext_seq_p - ext_seq);

    // 9. 封装为 TBSCertificate
    uint8_t *tbs_start = p;
    asn1_write_tag(&p, ASN1_SEQUENCE, p, start - p);

    // 10. 调整数据到缓冲区开头
    *tbs_len = tbs_start - p;
    memmove(tbs_out, p, *tbs_len);

    return 0;
}

/**
 * @brief 将签名添加到 TBSCertificate，生成完整证书
 * @param tbs_der             - 待签名证书（TBSCertificate）的 DER 数据
 * @param tbs_len            - TBSCertificate 长度
 * @param sig_r, sig_s       - 签名值 (r, s，各 48 字节)
 * @param cert_out           - 输出完整证书 DER 数据
 * @param cert_len           - 输出证书长度
 * @return 0 成功，-1 失败
 */
int add_signature_to_cert(
    const uint8_t *tbs_der,
    size_t tbs_len,
    const uint8_t *sig_r,
    const uint8_t *sig_s,
    uint8_t *cert_out,
    size_t *cert_len
) {
    uint8_t *p = cert_out + 1024; // DER 从后往前写
    uint8_t *start = p;

    // 1. 写入签名算法 (ecdsaWithSHA384)
    uint8_t sig_alg[] = {0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03};
    asn1_write_tag(&p, ASN1_SEQUENCE, sig_alg, sizeof(sig_alg));

    // 2. 写入签名值 (r + s)
    uint8_t signature[96];
    memcpy(signature, sig_r, 48);
    memcpy(signature + 48, sig_s, 48);
    asn1_write_tag(&p, ASN1_BIT_STRING, signature, sizeof(signature));

    // 3. 写入 TBSCertificate
    asn1_write_tag(&p, ASN1_SEQUENCE, tbs_der, tbs_len);

    // 4. 封装为完整证书
    uint8_t *cert_start = p;
    asn1_write_tag(&p, ASN1_SEQUENCE, p, start - p);

    // 5. 调整数据到缓冲区开头
    *cert_len = cert_start - p;
    memmove(cert_out, p, *cert_len);

    // 6. 存储到全局变量（可选）
    memcpy(cert_store[2].der_data, cert_out, *cert_len);
    cert_store[2].der_len = *cert_len;
    cert_store[2].type = CERT_TYPE_RT;

    return 0;
}

// 读取 ASN.1 长度字段
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

// 解析 ASN.1 标签
static void asn1_skip_tag(const uint8_t **p, uint8_t expected_tag) {
    if (*(*p)++ != expected_tag) {
        printf("Unexpected tag: expected 0x%02X\n", expected_tag);
        return;
    }
    size_t len = asn1_read_length(p);
    *p += len;
}

// 解析 TBSCertificate 部分
int parse_tbs_certificate(const uint8_t **p, x509_cert_t *cert) {
    if (*(*p)++ != ASN1_SEQUENCE) {
        printf("Invalid TBSCertificate: expected SEQUENCE\n");
        return -1;
    }
    size_t tbs_len = asn1_read_length(p);
    const uint8_t *tbs_end = *p + tbs_len;

    // 1. 版本号 (可选)
    if (**p == ASN1_CONTEXT_SPECIFIC) {
        asn1_skip_tag(p, ASN1_CONTEXT_SPECIFIC);
    }

    // 2. 序列号
    if (*(*p)++ != ASN1_INTEGER) {
        printf("Invalid serial number: expected INTEGER\n");
        return -1;
    }
    cert->serial_len = asn1_read_length(p);
    cert->serial = (uint8_t *)*p;
    *p += cert->serial_len;

    // 3. 签名算法
    asn1_skip_tag(p, ASN1_SEQUENCE);

    // 4. 颁发者名称
    if (*(*p)++ != ASN1_SEQUENCE) {
        printf("Invalid issuer: expected SEQUENCE\n");
        return -1;
    }
    cert->issuer_len = asn1_read_length(p);
    cert->issuer = (uint8_t *)*p;
    *p += cert->issuer_len;

    // 5. 有效期
    if (*(*p)++ != ASN1_SEQUENCE) {
        printf("Invalid validity: expected SEQUENCE\n");
        return -1;
    }
    cert->validity_len = asn1_read_length(p);
    cert->validity = (uint8_t *)*p;
    *p += cert->validity_len;

    // 6. 主题名称
    if (*(*p)++ != ASN1_SEQUENCE) {
        printf("Invalid subject: expected SEQUENCE\n");
        return -1;
    }
    cert->subject_len = asn1_read_length(p);
    cert->subject = (uint8_t *)*p;
    *p += cert->subject_len;

    // 7. 公钥信息
    if (*(*p)++ != ASN1_SEQUENCE) {
        printf("Invalid public key: expected SEQUENCE\n");
        return -1;
    }

    // 跳过算法标识
    asn1_skip_tag(p, ASN1_SEQUENCE);

    // 提取公钥 BIT STRING
    if (*(*p)++ != ASN1_BIT_STRING) {
        printf("Invalid public key: expected BIT STRING\n");
        return -1;
    }
    cert->pubkey_len = asn1_read_length(p) - 1; // 跳过 unused bits 字段
    *p += 1; // 跳过 unused bits
    cert->pubkey = (uint8_t *)*p;
    *p += cert->pubkey_len;

    // 跳过扩展字段（可选）
    if (*p < tbs_end && **p == (ASN1_CONTEXT_SPECIFIC | 0x03)) {
        asn1_skip_tag(p, ASN1_CONTEXT_SPECIFIC | 0x03);
    }

    return 0;
}

/**
 * @brief 解析 X.509 证书或 TBSCertificate
 * @param der_data   DER 编码的证书数据
 * @param der_len    数据长度
 * @param cert       输出解析后的证书结构
 * @param parse_full 是否解析完整证书（true=完整证书，false=仅 TBSCertificate）
 * @return 0 成功，-1 失败
 */
int parse_x509_cert(const uint8_t *der_data, size_t der_len, x509_cert_t *cert, bool parse_full) {
    const uint8_t *p = der_data;
    if (*p++ != ASN1_SEQUENCE) {
        printf("Invalid certificate: expected SEQUENCE\n");
        return -1;
    }
    size_t cert_len = asn1_read_length(&p);
    const uint8_t *cert_end = p + cert_len;

    // 1. 解析 TBSCertificate
    if (parse_tbs_certificate(&p, cert) != 0) {
        return -1;
    }

    // 如果是完整证书，继续解析签名算法和签名值
    if (parse_full) {
        // 2. 解析签名算法
        asn1_skip_tag(&p, ASN1_SEQUENCE);

        // 3. 解析签名值
        if (*p++ != ASN1_BIT_STRING) {
            printf("Invalid signature: expected BIT STRING\n");
            return -1;
        }
        cert->signature_len = asn1_read_length(&p) - 1; // 跳过 unused bits
        p += 1;
        cert->signature = (uint8_t *)p;
        p += cert->signature_len;

        if (p != cert_end) {
            printf("Extra data at end of certificate\n");
            return -1;
        }
    }

    return 0;
}

// 打印证书信息
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

    // 解析 LDEVID（仅 TBSCertificate）
    x509_cert_t ldevid_cert;
    if (parse_x509_cert(cert_store[0].der_data, cert_store[0].der_len, &ldevid_cert, false) == 0) {
        printf("=== LDEVID (TBSCertificate) ===\n");
        print_cert_info(&ldevid_cert);
    }

    // 解析 FMC（仅 TBSCertificate）
    x509_cert_t fmc_cert;
    if (parse_x509_cert(cert_store[1].der_data, cert_store[1].der_len, &fmc_cert, false) == 0) {
        printf("=== FMC (TBSCertificate) ===\n");
        print_cert_info(&fmc_cert);
    }

    // 解析 RT（完整证书）
    x509_cert_t rt_cert;
    if (parse_x509_cert(cert_store[2].der_data, cert_store[2].der_len, &rt_cert, true) == 0) {
        printf("=== RT (Full Certificate) ===\n");
        print_cert_info(&rt_cert);
    }

    return 0;
}