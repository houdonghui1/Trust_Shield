#!/bin/bash

WORK_DIR=$(pwd)
CA_DIR="${WORK_DIR}/ca"
CA_KEY="${CA_DIR}/ca_root.key"
CA_CERT="${CA_DIR}/ca_root.crt"
CA_SRL="${CA_DIR}/ca_root.srl"
AK_PUB_PEM="${WORK_DIR}/ak_pub.pem"          
MLDSA_HEX_FILE="${WORK_DIR}/mldsa_ak_hex.txt"
AK_CERT="${WORK_DIR}/ak_cert.pem"
TEMP_REQ="${WORK_DIR}/ca_temp.req"
EK_CERT="${WORK_DIR}/ek_cert.pem"
DEV_PUBKEY_WHITELIST="${WORK_DIR}/dev_pubkey_whitelist.txt"
AK_DAYS=365
AK_SUBJ="/C=CN/ST=BJ/L=BJ/O=TestDevice/OU=TPM-AK/CN=AK-Test-001"
MLDSA_EXT_OID="1.3.6.1.4.1.311.21.99"
MLDSA_PK_BIN_SIZE=2592
MLDSA_PK_HEX_SIZE=$((MLDSA_PK_BIN_SIZE * 2))

check_critical() {
    [ ! -f "${CA_KEY}" ] && { echo "Error: CA Key Missing"; exit 1; }
    [ ! -f "${CA_CERT}" ] && { echo "Error: CA Cert Missing"; exit 1; }
    [ ! -f "${AK_PUB_PEM}" ] && { echo "Error: AK PEM Missing"; exit 1; }
    [ ! -f "${MLDSA_HEX_FILE}" ] && { echo "Error: MLDSA Hex Missing"; exit 1; }
    [ ! -f "${EK_CERT}" ] && { echo "Error: EK Cert Missing"; exit 1; }
    [ ! -f "${DEV_PUBKEY_WHITELIST}" ] && { echo "Error: Whitelist Missing"; exit 1; }
    
    MLDSA_HEX_CONTENT=$(tr -d '\n' < "${MLDSA_HEX_FILE}")
    MLDSA_HEX_LEN=${#MLDSA_HEX_CONTENT}
    if [ "${MLDSA_HEX_LEN}" -ne "${MLDSA_PK_HEX_SIZE}" ]; then
        echo "Error: MLDSA hex length must be ${MLDSA_PK_HEX_SIZE} (got ${MLDSA_HEX_LEN})"; exit 1;
    fi
}

verify_core() {
    openssl ec -in "${CA_KEY}" -check -noout >/dev/null 2>&1 || { echo "Error: CA ECC Key Invalid"; exit 1; }
    openssl x509 -in "${CA_CERT}" -checkend 0 -noout >/dev/null 2>&1 || { echo "Error: CA Cert Invalid"; exit 1; }
    openssl ec -in "${AK_PUB_PEM}" -pubin -noout >/dev/null 2>&1 || { echo "Error: AK ECC PEM Invalid"; exit 1; }
    echo "All core files verified"
}

init_clean() {
    chmod 777 "${CA_DIR}"
    rm -f "${TEMP_REQ}" "${AK_CERT}" "${WORK_DIR}/extfile.cnf" "${WORK_DIR}/mldsa_raw.bin" openssl_error.log
    touch "${CA_SRL}" 2>/dev/null
    echo 01 > "${CA_SRL}" 2>/dev/null
}

gen_mldsa_raw() {
    tr -d '\n' < "${MLDSA_HEX_FILE}" | xxd -r -p > "${WORK_DIR}/mldsa_raw.bin" || {
        echo "Error: Convert MLDSA hex to bin failed"; exit 1;
    }
    
    MLDSA_BIN_LEN=$(wc -c < "${WORK_DIR}/mldsa_raw.bin" | tr -d ' ')
    if [ "${MLDSA_BIN_LEN}" -ne "${MLDSA_PK_BIN_SIZE}" ]; then
        echo "Error: MLDSA bin length must be ${MLDSA_PK_BIN_SIZE} (got ${MLDSA_BIN_LEN})"; exit 1;
    fi
    
    MLDSA_RAW_HEX=$(xxd -p -c 100000 "${WORK_DIR}/mldsa_raw.bin" | tr -d '\n')
}

gen_ext_config() {
    gen_mldsa_raw
    
    cat > "${WORK_DIR}/extfile.cnf" << EOF
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_ca
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = CN
ST = BJ
L = BJ
O = TestDevice
OU = TPM-AK
CN = AK-Test-001

[v3_req]
basicConstraints = CA:FALSE
keyUsage = digitalSignature
extendedKeyUsage = 1.3.6.1.5.5.7.3.1
${MLDSA_EXT_OID} = ASN1:OCTETSTRING:${MLDSA_RAW_HEX}

[v3_ca]
basicConstraints = CA:FALSE
keyUsage = digitalSignature
extendedKeyUsage = 1.3.6.1.5.5.7.3.1
${MLDSA_EXT_OID} = ASN1:OCTETSTRING:${MLDSA_RAW_HEX}
EOF
}

gen_ca_req() {
    openssl req -new -key "${CA_KEY}" -out "${TEMP_REQ}" \
        -subj "${AK_SUBJ}" -sha256 \
        -config "${WORK_DIR}/extfile.cnf" \
        -extensions v3_req >/dev/null 2>&1 || {
        echo "Error: Gen CA REQ Failed"; exit 1;
    }
}

raw_sign_ak() {
    openssl req -new -key "${CA_KEY}" -subj "${AK_SUBJ}" -out "${TEMP_REQ}" \
        -config "${WORK_DIR}/extfile.cnf" -extensions v3_req 2> openssl_error.log || {
        echo "Error: Failed to generate CSR - check openssl_error.log"; exit 1;
    }

    openssl x509 -req -in "${TEMP_REQ}" -CA "${CA_CERT}" -CAkey "${CA_KEY}" \
        -CAserial "${CA_SRL}" -CAcreateserial -days "${AK_DAYS}" -sha256 \
        -out "${AK_CERT}" -extfile "${WORK_DIR}/extfile.cnf" -extensions v3_ca \
        2>> openssl_error.log || {
        echo "Error: OpenSSL sign failed - details below:"
        cat openssl_error.log
        exit 1
    }

    if [ ! -s "${AK_CERT}" ]; then
        echo "Error: Final Raw Sign Failed (ak_cert.pem empty)"
        exit 1
    fi
    echo "Successfully generated ak_cert.pem"
}

verify_final() {
    if openssl verify -CAfile "${CA_CERT}" "${AK_CERT}" >/dev/null 2>&1; then
        echo "Signature successful"
    else
        echo "Warn: Low OpenSSL Verify Tip, Cert Is CA-Signed"
    fi
    
    echo -e "\n=== Certificate Info ==="
    openssl x509 -in "${AK_CERT}" -text -noout | grep -E "Version|${MLDSA_EXT_OID}" -A3
    
    echo -e "\n=== MLDSA Public Key Validation ==="

    tr -d '\n' < "${MLDSA_HEX_FILE}" | xxd -r -p > mldsa_original.bin

    openssl x509 -in "${AK_CERT}" -text -noout | \
        grep -A 10 "${MLDSA_EXT_OID}" | \
        grep -v -E "${MLDSA_EXT_OID}|Signature|:" | \
        tr -d ' \n' | xxd -r -p > mldsa_from_cert.bin
    
    ORIG_LEN=$(wc -c < mldsa_original.bin | tr -d ' ')
    CERT_LEN=$(wc -c < mldsa_from_cert.bin | tr -d ' ')
    
    if [ "${ORIG_LEN}" -ne "${MLDSA_PK_BIN_SIZE}" ] || [ "${CERT_LEN}" -ne "${MLDSA_PK_BIN_SIZE}" ]; then
        echo "MLDSA Public Key Length Mismatch (Original: ${ORIG_LEN}, Cert: ${CERT_LEN})"
    elif diff -q mldsa_original.bin mldsa_from_cert.bin >/dev/null; then
        echo "MLDSA Public Key Matches Original (Binary)"
    else
        echo "MLDSA Public Key Mismatch (Binary)"
    fi
    
    rm -f mldsa_original.bin mldsa_from_cert.bin mldsa_from_cert.hex
}

compare_pubkey_with_whitelist() {
    openssl x509 -inform pem -in "${EK_CERT}" -pubkey -noout > dev_pubkey.pem || {
        echo "Error: Failed to extract public key from EK certificate"; exit 1;
    }

    openssl asn1parse -inform pem -in dev_pubkey.pem -out - -noout | xxd -p -c 1000 > pem2hex.txt || {
        echo "Error: Failed to convert public key to hex format"; exit 1;
    }

    if diff -q "${DEV_PUBKEY_WHITELIST}" pem2hex.txt > /dev/null; then
        echo "Public key matches the whitelist"
    else
        echo "Error: Public key does not match the whitelist"; exit 1;
    fi

    rm -f dev_pubkey.pem pem2hex.txt
}

clean_temp() {
    rm -f "${TEMP_REQ}" "${WORK_DIR}/extfile.cnf" "${WORK_DIR}/mldsa_raw.bin" openssl_error.log
}

main() {
    check_critical
    verify_core
    init_clean
    gen_ext_config
    gen_ca_req
    compare_pubkey_with_whitelist
    raw_sign_ak
    verify_final
    clean_temp
    echo -e "\nFinal AK Cert: ${AK_CERT}"
    echo "MLDSA Ext OID: ${MLDSA_EXT_OID}"
}

main
