#!/usr/bin/env python3
import serial
import serial.tools.list_ports
import subprocess
import time
import re
import sys

SERIAL_PORT = "/dev/ttyACM1"
BAUDRATE = 115200
TIMEOUT = 60
PARITY = serial.PARITY_NONE
STOPBITS = serial.STOPBITS_ONE
BYTESIZE = serial.EIGHTBITS

# Constants
AK_VALID_LEN = 128
EK_VALID_LEN = 650
MLDSA87_PK_VALID_LEN = (2592*2)

CAPTURED_EK = False
CAPTURED_AK = False
CAPTURED_MLDSA_PK = False
ek_cert_hex = ""
ak_pub_128hex = ""
mldsa_pk_hex = ""
start_time = time.time()

HEX_PATTERN = re.compile(r'^[0-9a-fA-F]+$')

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
    global CAPTURED_EK, CAPTURED_AK, CAPTURED_MLDSA_PK, ek_cert_hex, ak_pub_128hex, mldsa_pk_hex
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
                error(f"Capture timeout ({TIMEOUT}s) - missing data: EK={CAPTURED_EK}, AK={CAPTURED_AK}, MLDSA_PK={CAPTURED_MLDSA_PK}")
            
            line = ser.readline().decode('utf-8', errors='ignore').strip()
            if not line:
                continue

            # Capture EK certificate
            if "EK Certificate DER ,length=0x28a" in line and not CAPTURED_EK:
                info("Detected EK certificate keyword - capturing data...")
                ek_line = ser.readline().decode('utf-8', errors='ignore').strip()
                ek_cert_hex = re.sub(r'[^0-9a-fA-F]', '', ek_line)
                ek_cert_hex = ek_cert_hex[-EK_VALID_LEN:] if len(ek_cert_hex) >= EK_VALID_LEN else ek_cert_hex
                validate_hex(ek_cert_hex, "EK certificate DER hex", EK_VALID_LEN)
                CAPTURED_EK = True
                info("Successfully captured EK certificate DER hex")

            # Capture traditional AK public key
            if "AK Public key ,length=0x80" in line and not CAPTURED_AK:
                info("Detected AK public key keyword - capturing data...")
                ak_line = ser.readline().decode('utf-8', errors='ignore').strip()
                ak_pub_128hex = re.sub(r'[^0-9a-fA-F]', '', ak_line)
                ak_pub_128hex = ak_pub_128hex[-AK_VALID_LEN:] if len(ak_pub_128hex) >= AK_VALID_LEN else ak_pub_128hex
                validate_hex(ak_pub_128hex, "AK public key hex", AK_VALID_LEN)
                CAPTURED_AK = True
                info("Successfully captured AK public key hex")

            # Capture MLDSA AK public key
            if "MLDSA Public Key ,length=0x1440" in line and not CAPTURED_MLDSA_PK:
                info("Detected MLDSA Public Key keyword - capturing data...")
                mldsa_lines = []
                while True:
                    mldsa_line = ser.readline().decode('utf-8', errors='ignore').strip()
                    if not mldsa_line:
                        break
                    
                    clean_line = re.sub(r'\[.*?\]', '', mldsa_line)
                    clean_line = re.sub(r'I\d+.*?\]', '', clean_line)
                    clean_line = re.sub(r'[^0-9a-fA-F]', '', clean_line)
                    
                    if clean_line:
                        mldsa_lines.append(clean_line)
                    if len(''.join(mldsa_lines)) >= MLDSA87_PK_VALID_LEN:
                        break
                
                mldsa_pk_hex = ''.join(mldsa_lines)[:MLDSA87_PK_VALID_LEN]
                validate_hex(mldsa_pk_hex, "MLDSA Public Key hex", MLDSA87_PK_VALID_LEN)
                CAPTURED_MLDSA_PK = True
                info("Successfully captured MLDSA Public Key hex")
                save_mldsa_hex_to_file(mldsa_pk_hex)

            # All required data captured
            if CAPTURED_EK and CAPTURED_MLDSA_PK:
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
