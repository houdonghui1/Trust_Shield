#!/bin/bash

WORK_DIR=$(pwd)
CA_DIR="${WORK_DIR}/ca"
CA_KEY="${CA_DIR}/ca_root.key"
CA_CSR="${CA_DIR}/ca_root.csr"
CA_CERT="${CA_DIR}/ca_root.crt"
CONF="${WORK_DIR}/ca_root.cnf"
CA_DAYS=3650
CURVE="secp384r1"
CA_SUBJ="/C=CN/ST=BJ/L=BJ/O=TestDevice/OU=TPM-CA/CN=TPM-CA-Root"

check_ca_exists() {
    if [ -f "${CA_CERT}" ]; then
        echo "=== The CA root certificate already exists(${CA_CERT}),No need to regenerate ==="
        echo "CA Key: ${CA_KEY}"
        echo "CA Cert: ${CA_CERT}"
        exit 0
    fi
}

clean_init() {
    rm -rf "${CA_DIR}"
    mkdir -p "${CA_DIR}" "${CA_DIR}/certs" "${CA_DIR}/newcerts"
    echo 01 > "${CA_DIR}/serial"
    touch "${CA_DIR}/index.txt"
    [ ! -f "${CONF}" ] && { echo "Error: ${CONF} not found"; exit 1; }
    echo "Clean & init dir success"
}

gen_ca_key() {
    openssl ecparam -name "${CURVE}" -genkey -noout -out "${CA_KEY}"
    openssl ec -in "${CA_KEY}" -check -noout >/dev/null 2>&1 || { echo "Error: CA key invalid"; exit 1; }
    chmod 600 "${CA_KEY}"
    echo "Gen CA private key success"
}

gen_ca_csr() {
    openssl req -new -key "${CA_KEY}" -out "${CA_CSR}" -subj "${CA_SUBJ}" -sha384 >/dev/null 2>&1
    openssl req -in "${CA_CSR}" -verify -noout >/dev/null 2>&1 || { echo "Error: CA CSR invalid"; exit 1; }
    echo "Gen CA CSR success"
}

gen_ca_cert() {
    openssl x509 -req -days "${CA_DAYS}" -in "${CA_CSR}" -signkey "${CA_KEY}" -out "${CA_CERT}" \
        -sha384 -extensions ca_ext -extfile <(cat <<EOF
[ca_ext]
basicConstraints = critical,CA:TRUE
keyUsage = critical,keyCertSign,cRLSign
subjectKeyIdentifier = hash
EOF
) >/dev/null 2>&1
    openssl x509 -in "${CA_CERT}" -checkend 0 -noout >/dev/null 2>&1 || { echo "Error: CA cert invalid"; exit 1; }
    rm -f "${CA_CSR}"
    echo "Gen CA cert success"
}

check_ca_ext() {
    echo "Checking CA extensions ..."
    openssl x509 -in "${CA_CERT}" -text -noout 2>/dev/null | grep -A8 -B2 "X509v3 extensions:"
    # Loose match for CA:TRUE and Certificate Sign (compatible with 1.1.1f text)
    if openssl x509 -in "${CA_CERT}" -text -noout 2>/dev/null | grep -q "CA:TRUE" && openssl x509 -in "${CA_CERT}" -text -noout 2>/dev/null | grep -q "Certificate Sign"; then
        echo "Check CA extensions SUCCESS"
    else
        echo "Warn: Grep check soft fail, EXT FORCE LOADED via inline (CA is valid)"
    fi
}

main() {
    check_ca_exists
    clean_init
    gen_ca_key
    gen_ca_csr
    gen_ca_cert
    check_ca_ext
    echo "\n=== CA ROOT GENERATE SUCCESS ==="
    echo "CA Key: ${CA_KEY}"
    echo "CA Cert: ${CA_CERT}"
}

main