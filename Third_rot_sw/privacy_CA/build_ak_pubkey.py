#!/usr/bin/env python3

import sys
import datetime
import binascii
from cryptography import x509
from cryptography.x509.oid import NameOID
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.serialization import Encoding, PublicFormat

VALID_DAYS = 365
SUBJECT_INFO = {"C": "CN", "ST": "BJ", "L": "BJ", "O": "TPM_Device", "OU": "TPM-AK", "CN": "TPM-AK-001"}
TPM_CURVE = ec.SECP256R1()
DIGITAL_SIGNATURE_OID = x509.ObjectIdentifier("1.3.6.1.5.5.7.3.1")
TPM_EKU_OID = x509.ObjectIdentifier("1.3.6.1.4.1.311.21.30")

def hex_to_le32_words(hex_str):
    if len(hex_str) != 128:
        raise ValueError("Pubkey must be 128 hex characters")
    x_hex = hex_str[:64]
    y_hex = hex_str[64:]
    words = []
    for part in [x_hex, y_hex]:
        for i in range(8):
            seg = part[i*8 : (i+1)*8]
            le_bytes = binascii.unhexlify(seg)
            le_int = int.from_bytes(le_bytes, byteorder='little')
            words.append(le_int)
    return words

def convert_le32_to_be_bytes(in_words):
    if len(in_words) != 8:
        raise ValueError("Input must be 8 32-bit words")
    temp = bytearray(32)
    for i in range(8):
        temp[i*4]   = (in_words[i] >> 24) & 0xFF
        temp[i*4+1] = (in_words[i] >> 16) & 0xFF
        temp[i*4+2] = (in_words[i] >> 8) & 0xFF
        temp[i*4+3] = in_words[i] & 0xFF
    out = bytearray(32)
    for i in range(8):
        out[i*4 : (i+1)*4] = temp[(7 - i)*4 : (8 - i)*4]
    return bytes(out)

def generate_correct_ak_pubkey(tpm_words):
    x_bytes = convert_le32_to_be_bytes(tpm_words[:8])
    y_bytes = convert_le32_to_be_bytes(tpm_words[8:])
    ecc_65_bytes = b"\x04" + x_bytes + y_bytes
    ecc_65_hex = binascii.hexlify(ecc_65_bytes).decode()
    return ecc_65_bytes, ecc_65_hex, x_bytes, y_bytes

def load_tpm_ak_pubkey(ecc_bytes, curve):
    return ec.EllipticCurvePublicKey.from_encoded_point(curve, ecc_bytes)

def save_file(data, filename, is_binary=True):
    mode = "wb" if is_binary else "w"
    encoding = None if is_binary else "utf-8"
    with open(filename, mode, encoding=encoding) as f:
        f.write(data)
    print(f"Info: Saved {filename}")

def main():
    # Check cmdline args
    if len(sys.argv) != 2:
        print("Usage: python3 tpm_ak_pubgen.py <128-hex-tpm-ak-pubkey>")
        sys.exit(1)
    raw_hex = sys.argv[1].strip()
    # Validate hex format
    try:
        binascii.unhexlify(raw_hex)
    except binascii.Error:
        print("Error: Invalid hex characters (only 0-9, a-f, A-F allowed)")
        sys.exit(1)
    
    try:
        tpm_words = hex_to_le32_words(raw_hex)
        ak_65_bytes, ak_65_hex, x_bytes, y_bytes = generate_correct_ak_pubkey(tpm_words)
        ak_pubkey = load_tpm_ak_pubkey(ak_65_bytes, TPM_CURVE)
        pem_pubkey = ak_pubkey.public_bytes(Encoding.PEM, PublicFormat.SubjectPublicKeyInfo)
        save_file(pem_pubkey, "ak_pub.pem")
        print("Info: All operations completed successfully")
        print(f"Info: Validated pubkey point on {TPM_CURVE.name} curve")
    except ValueError as e:
        print(f"Error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Error: Execution failed - {str(e)}")
        print("Hint: Check cryptography installation (pip install cryptography)")
        sys.exit(1)

if __name__ == "__main__":
    main()
