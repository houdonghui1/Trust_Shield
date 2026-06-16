#!/usr/bin/env python3
import sys
import binascii
import base64

def save_file(data, filename, is_binary=True):
    mode = "wb" if is_binary else "w"
    encoding = None if is_binary else "utf-8"
    with open(filename, mode, encoding=encoding) as f:
        f.write(data)
    print(f"Info: Saved {filename}")

def der_length(length):
    if length < 0x80:
        return bytes([length])
    else:
        length_bytes = []
        while length > 0:
            length_bytes.append(length & 0xFF)
            length >>= 8
        length_bytes.reverse()
        return bytes([0x80 | len(length_bytes)]) + bytes(length_bytes)

def build_mldsa87_spki_der(pk_bytes):
    # 1. AlgorithmIdentifier 部分
    alg_id = bytes([
        0x30, 0x0D,             # SEQUENCE (13 bytes)
        0x06, 0x0B,             # OBJECT IDENTIFIER (11 bytes)
        0x2B, 0x65, 0x71, 0x01, 0x01  # OID 1.3.101.113 的 DER 编码
    ])
    
    # 2. SubjectPublicKey BIT STRING 部分
    pk_bit_str_content = bytes([0x00]) + pk_bytes  # unused bits(0x00) + 公钥数据
    pk_bit_str = bytes([0x03]) + der_length(len(pk_bit_str_content)) + pk_bit_str_content
    
    # 3. 外层 SEQUENCE
    total_content = alg_id + pk_bit_str
    spki = bytes([0x30]) + der_length(len(total_content)) + total_content
    
    return spki

def der_to_pem(der_data, label="PUBLIC KEY"):
    b64_data = base64.b64encode(der_data).decode('ascii')
    pem_lines = [f"-----BEGIN {label}-----"]
    for i in range(0, len(b64_data), 64):
        pem_lines.append(b64_data[i:i+64])
    pem_lines.append(f"-----END {label}-----")
    return '\n'.join(pem_lines).encode('ascii')

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 build_mldsa_pubkey.py <5184-hex-mldsa87-pubkey>")
        sys.exit(1)
    
    raw_hex = sys.argv[1].strip()
    
    try:
        binascii.unhexlify(raw_hex)
    except binascii.Error:
        print("Error: Invalid hex characters")
        sys.exit(1)
    
    if len(raw_hex) != 5184:
        print(f"Error: ml-dsa87 hex length must be 5184 (got {len(raw_hex)})")
        sys.exit(1)
    
    try:
        pk_bytes = binascii.unhexlify(raw_hex)
        spki_der = build_mldsa87_spki_der(pk_bytes)
        pem_pubkey = der_to_pem(spki_der)
        save_file(pem_pubkey, "mldsa_ak_pub.pem")
        print("Info: All operations completed successfully")
    except Exception as e:
        print(f"Error: Execution failed - {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()
