#!/usr/bin/env python3
import serial
import serial.tools.list_ports
import subprocess
import time
import re
import sys
import json
import hashlib

SERIAL_PORT = "/dev/ttyACM1"
BAUDRATE = 115200
TIMEOUT = 60
PARITY = serial.PARITY_NONE
STOPBITS = serial.STOPBITS_ONE
BYTESIZE = serial.EIGHTBITS

# Constants
AK_VALID_LEN = 49 * 2
EK_MAX_HEX_LEN = 8192 * 2
MLDSA87_PK_VALID_LEN = (2592*2)
BLS_PUBLIC_KEY_HEX_LEN = 48 * 2
BLS_POP_HEX_LEN = 96 * 2
BLS_REGISTRATION_PREFIX = "BLS_REGISTRATION:"

CAPTURED_EK = False
CAPTURED_AK = False
CAPTURED_MLDSA_PK = False
CAPTURED_BLS_REGISTRATION = False
ek_cert_hex = ""
ak_pub_128hex = ""
mldsa_pk_hex = ""
bls_registration = None
start_time = time.time()

HEX_PATTERN = re.compile(r'^[0-9a-fA-F]+$')
EK_HEADER_PATTERN = re.compile(
    r"EK\s+Certificate\s+DER\s*,?\s*length\s*=\s*0x([0-9a-fA-F]+)",
    re.IGNORECASE,
)

def extract_hex_payload(line):
    payload = re.sub(r'^\[[^\]]*\]\s*', '', line.strip())
    payload = re.sub(r'^[A-Z]\d+\s+[^\]]+\]\s*', '', payload)
    payload = re.sub(r'\s+', '', payload)
    return payload if HEX_PATTERN.fullmatch(payload or '') else ''

def collect_hex_payload(ser, expected_len, name):
    chunks = []
    collected = 0
    deadline = time.time() + TIMEOUT
    while collected < expected_len:
        if time.time() >= deadline:
            error(f"Timeout collecting {name}: expected {expected_len}, got {collected}")
        line = ser.readline().decode('utf-8', errors='ignore').strip()
        if not line:
            continue
        payload = extract_hex_payload(line)
        if not payload:
            continue
        remaining = expected_len - collected
        if len(payload) > remaining:
            error(
                f"Invalid {name} line: remaining {remaining} hex characters, "
                f"received {len(payload)}"
            )
        chunks.append(payload)
        collected += len(payload)
    value = ''.join(chunks)
    validate_hex(value, name, expected_len)
    return value

def info(msg):
    print(f"[INFO] {msg}")

def error(msg, exit_code=1):
    print(f"[ERROR] {msg}")
    sys.exit(exit_code)

def check_serial_port():
    ports = [p.device for p in serial.tools.list_ports.comports()]
    if SERIAL_PORT not in ports:
        error(f"Serial port {SERIAL_PORT} not found! Available ports: {ports}")

def check_serial_permission():
    try:
        with open(SERIAL_PORT, 'r'):
            pass
    except PermissionError:
        error(f"No permission to access {SERIAL_PORT}! Fix: sudo usermod -aG dialout $USER && logout")

def validate_hex(data, name, expected_len):
    if not HEX_PATTERN.match(data):
        error(f"Invalid {name} - non-hex characters found")
    if len(data) != expected_len:
        error(f"Invalid {name} length - expected {expected_len}, got {len(data)}")
    info(f"Validated {name}: {data[:20]}...{data[-20:]} (length: {len(data)})")

def save_mldsa_hex_to_file(hex_data):
    try:
        with open("mldsa_ak_hex.txt", "w", encoding="utf-8") as f:
            f.write(hex_data.strip())
        info(f"Saved MLDSA public key hex to mldsa_ak_hex.txt (length: {len(hex_data)})")
    except Exception as e:
        error(f"Failed to save MLDSA hex file: {str(e)}")

def parse_and_save_bls_registration(line):
    marker_offset = line.find(BLS_REGISTRATION_PREFIX)
    if marker_offset < 0:
        return None

    fields = line[marker_offset + len(BLS_REGISTRATION_PREFIX):].split(":")
    if len(fields) != 3:
        error("Invalid BLS registration: expected nodeID, public key, and PoP")
    node_id, public_key_hex, pop_hex = (field.strip() for field in fields)
    if not re.fullmatch(r"[A-Za-z0-9._-]{1,128}", node_id):
        error("Invalid BLS registration nodeID")
    validate_hex(public_key_hex, "BLS public key", BLS_PUBLIC_KEY_HEX_LEN)
    validate_hex(pop_hex, "BLS proof of possession", BLS_POP_HEX_LEN)

    public_key = bytes.fromhex(public_key_hex)
    key_id = hashlib.sha256(
        b"CLUSTER-BLS-key-id-v1\x00" + public_key
    ).digest()[:16].hex()
    registration = {
        "protocolVersion": 1,
        "ciphersuiteID": "BLS12381G2_XMD:SHA-256_SSWU_RO_POP_",
        "nodeID": node_id,
        "keyID": key_id,
        "blsPublicKey": public_key_hex.lower(),
        "proofOfPossession": pop_hex.lower(),
    }
    try:
        with open("bls_registration.json", "w", encoding="utf-8") as f:
            json.dump(registration, f, sort_keys=True, separators=(",", ":"))
            f.write("\n")
    except OSError as e:
        error(f"Failed to save BLS registration: {str(e)}")
    info(f"Captured BLS registration for {node_id}, keyID={key_id}")
    return registration

def gen_pem_files(ak_hex, ek_hex, mldsa_pk_hex):
    info("Generating AK public key PEM...")
    ak_result = subprocess.run(["python3", "./build_ak_pubkey.py", ak_hex], capture_output=True, text=True)
    if ak_result.returncode != 0:
        error(f"Generate AK PEM failed: {ak_result.stderr}")
    
    info("Generating EK certificate PEM...")
    ek_result = subprocess.run(["python3", "./build_ek_cert.py", ek_hex], capture_output=True, text=True)
    if ek_result.returncode != 0:
        error(f"Generate EK PEM failed: {ek_result.stderr}")
    
    info("Generating MLDSA AK Public Key PEM...")
    mldsa_result = subprocess.run(
        ["python3", "./build_mldsa_pubkey.py", mldsa_pk_hex], 
        capture_output=True, 
        text=True
    )
    if mldsa_result.returncode != 0:
        error(f"Generate MLDSA PEM failed:\nSTDOUT: {mldsa_result.stdout}\nSTDERR: {mldsa_result.stderr}")

def main():
    global CAPTURED_EK, CAPTURED_AK, CAPTURED_MLDSA_PK, CAPTURED_BLS_REGISTRATION
    global ek_cert_hex, ak_pub_128hex, mldsa_pk_hex, bls_registration
    check_serial_port()
    check_serial_permission()

    try:
        ser = serial.Serial(
            port=SERIAL_PORT,
            baudrate=BAUDRATE,
            parity=PARITY,
            stopbits=STOPBITS,
            bytesize=BYTESIZE,
            timeout=1
        )
        info(f"Opened serial port {SERIAL_PORT} (baudrate: {BAUDRATE}, timeout: {TIMEOUT}s)")
        info("Waiting for serial data... (start your device now)")
    except Exception as e:
        error(f"Failed to open serial port: {str(e)}")

    try:
        while ser.is_open:
            if time.time() - start_time > TIMEOUT:
                error(f"Capture timeout ({TIMEOUT}s) - missing data: EK={CAPTURED_EK}, AK={CAPTURED_AK}, MLDSA_PK={CAPTURED_MLDSA_PK}, BLS={CAPTURED_BLS_REGISTRATION}")
            
            line = ser.readline().decode('utf-8', errors='ignore').strip()
            if not line:
                continue

            # Capture EK certificate
            ek_header = EK_HEADER_PATTERN.search(line)
            if ek_header is not None and not CAPTURED_EK:
                ek_valid_len = int(ek_header.group(1), 16)
                if ek_valid_len < 4 or ek_valid_len > EK_MAX_HEX_LEN or ek_valid_len % 2 != 0:
                    error(f"Invalid EK certificate hex length: {ek_valid_len}")
                info(f"Detected EK certificate keyword - capturing 0x{ek_valid_len:x} hex characters...")
                ek_cert_hex = collect_hex_payload(
                    ser, ek_valid_len, "EK certificate DER hex"
                )
                CAPTURED_EK = True
                info("Successfully captured EK certificate DER hex")

            # The same P-384 key signs the L2 certificate and is certified as
            # L3's AK key, so the conventional chain and BLS binding describe
            # one identity.  print_hex_buffer reports 49 compressed bytes as
            # 0x62 hexadecimal characters.
            if "ecdsa-p384 test public_key ,length=0x62" in line and not CAPTURED_AK:
                info("Detected AK public key keyword - capturing data...")
                ak_pub_128hex = collect_hex_payload(
                    ser, AK_VALID_LEN, "AK public key hex"
                )
                CAPTURED_AK = True
                info("Successfully captured AK public key hex")

            # Capture MLDSA AK public key
            if "MLDSA Public Key ,length=0x1440" in line and not CAPTURED_MLDSA_PK:
                info("Detected MLDSA Public Key keyword - capturing data...")
                mldsa_pk_hex = collect_hex_payload(
                    ser, MLDSA87_PK_VALID_LEN, "MLDSA Public Key hex"
                )
                CAPTURED_MLDSA_PK = True
                info("Successfully captured MLDSA Public Key hex")
                save_mldsa_hex_to_file(mldsa_pk_hex)

            # Capture only the additive BLS certificate-binding attributes.
            if BLS_REGISTRATION_PREFIX in line and not CAPTURED_BLS_REGISTRATION:
                bls_registration = parse_and_save_bls_registration(line)
                CAPTURED_BLS_REGISTRATION = bls_registration is not None

            # All required data captured
            if CAPTURED_EK and CAPTURED_AK and CAPTURED_MLDSA_PK and CAPTURED_BLS_REGISTRATION:
                info("================================ CAPTURE COMPLETE ================================")
                info(f"Extracted EK DER-hex: {ek_cert_hex[:20]}...{ek_cert_hex[-20:]}")
                info(f"Extracted MLDSA AK PK-hex: {mldsa_pk_hex[:20]}...{mldsa_pk_hex[-20:]}")
                if CAPTURED_AK:
                    info(f"Extracted traditional AK hex: {ak_pub_128hex[:20]}...{ak_pub_128hex[-20:]}")
                
                ser.close()
                info(f"Closed serial port {SERIAL_PORT}")
                
                # Generate PEM files
                gen_pem_files(ak_pub_128hex, ek_cert_hex, mldsa_pk_hex)
                
                info("================================ ALL DONE ================================")
                info(f"Generated files in current directory:")
                info(f"  - ak_pub.pem        (traditional AK public key, PEM format)")
                info(f"  - ek_cert.pem       (EK certificate, PEM format)")
                info(f"  - mldsa_ak_pub.pem  (MLDSA Public Key, PEM format)")
                info(f"  - mldsa_ak_hex.txt  (MLDSA Public Key raw hex string)")
                info(f"  - bls_registration.json (BLS public key and PoP)")
                sys.exit(0)

    except KeyboardInterrupt:
        if ser.is_open:
            ser.close()
        info(f"\nKeyboard interrupt - closed serial port {SERIAL_PORT}")
        sys.exit(0)
    except Exception as e:
        if ser.is_open:
            ser.close()
        error(f"Serial read failed: {str(e)}")

if __name__ == "__main__":
    main()
