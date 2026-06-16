#!/usr/bin/env python3
"""
Certificate HEX to PEM Converter
Input: Hex encoded X.509 certificate (cmdline arg)
Output: Standard PEM format X.509 certificate
No byte order conversion, only HEX->DER->PEM
"""
import sys
import binascii
from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.serialization import Encoding

def hex2pem(hex_str, output_file):
    der_data = binascii.unhexlify(hex_str)
    cert = x509.load_der_x509_certificate(der_data, default_backend())
    pem_data = cert.public_bytes(Encoding.PEM)
    with open(output_file, "wb") as f:
        f.write(pem_data)
    print(f"Info: PEM certificate saved to {output_file}")
    return True

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 cert_hex2pem.py <hex-encoded-x509-cert>")
        sys.exit(1)
    raw_hex = sys.argv[1].strip()
    
    try:
        binascii.unhexlify(raw_hex)
    except binascii.Error:
        print("Error: Invalid hex characters (only 0-9, a-f, A-F allowed)")
        sys.exit(1)
    
    try:
        hex2pem(raw_hex, "ek_cert.pem")
        print("Info: Conversion completed successfully (no byte order modified)")
    except Exception as e:
        print(f"Error: Conversion failed - {str(e)}")
        print("Hint: Check if input is a legal X.509 certificate hex string")
        sys.exit(1)

if __name__ == "__main__":
    main()

