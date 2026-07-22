#!/usr/bin/env python3
import serial
import subprocess
import time
import re
import sys
import os
import binascii
import ctypes
from ctypes import c_uint8, c_size_t, c_int
from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization

SERIAL_PORT = "/dev/ttyUSB1"       
BAUDRATE = 115200                  
PARITY = serial.PARITY_NONE
STOPBITS = serial.STOPBITS_ONE
BYTESIZE = serial.EIGHTBITS
READ_TIMEOUT_TOTAL = 120
READ_INTERVAL = 0.05               
NO_NEW_DATA_THRESHOLD = 2400
SERIAL_BUFFER_SIZE = 65536         
NONCE_SEND_TIMEOUT = 2             
SERIAL_WRITE_CHUNK = 8             

AK_LEN_HEX_LEN = 4
PCR_VALID_LEN = 64
NONCE_VALID_LEN = 64
MLDSA_SIGN_VALID_LEN = 4627*2
CERT_CHAIN_FLAG_HEX_LEN = 2

CERT_CHAIN_SUCCESS = 0xaa
CERT_CHAIN_FAILURE = 0xba

MLDSA_PK_EXTENSION_OID = "1.3.6.1.4.1.311.21.99"

QUOTE_START_MARKER = "#QUOTE#"
QUOTE_END_MARKER = "#END#"

def info(msg):
    print(f"[INFO] {msg}")

def error(msg):
    print(f"[ERROR] {msg}")
    sys.exit(1)

def warn(msg):
    print(f"[WARN] {msg}")

def success(msg):
    print(f"[SUCCESS] {msg}")

def debug(msg):
    print(f"[DEBUG] {msg}")

def generate_nonce():
    nonce_bytes = os.urandom(32)
    nonce_hex = binascii.hexlify(nonce_bytes).decode('utf-8').lower()
    info(f"Generated 32-byte Nonce (HEX length {len(nonce_hex)}): {nonce_hex[:20]}...{nonce_hex[-20:]}")
    return nonce_bytes, nonce_hex

def verify_ak_certificate(ak_cert_hex, expected_len):
    actual_len = len(ak_cert_hex)
    if actual_len != expected_len:
        error(f"AK certificate HEX length mismatch: expected {expected_len} bits, actual {actual_len} bits")
    
    with open("ak_cert.hex", 'w') as f:
        f.write(ak_cert_hex)
    
    xxd_res = subprocess.run(
        ["xxd", "-r", "-p", "ak_cert.hex", "ak_cert.bin"],
        capture_output=True, text=True
    )
    if xxd_res.returncode != 0:
        error(f"HEX to BIN conversion failed: {xxd_res.stderr}")
    
    openssl_der_res = subprocess.run(
        ["openssl", "x509", "-inform", "der", "-in", "ak_cert.bin",
         "-out", "ak_cert.pem", "-outform", "pem"],
        capture_output=True, text=True
    )
    if openssl_der_res.returncode != 0:
        error(f"DER to PEM conversion failed: {openssl_der_res.stderr}")
    
    verify_res = subprocess.run(
        ["openssl", "verify", "-CAfile", "ca_root.crt",
         "-ignore_critical", "-no_check_time", "ak_cert.pem"],
        capture_output=True, text=True
    )
    if "OK" in verify_res.stdout:
        success("AK certificate verification passed!")
    else:
        error(f"AK certificate verification failed:\n{verify_res.stdout}\n{verify_res.stderr}")

def reverse_pcr_endian(pcr_hex):
    group_size = 8
    pcr_groups = [pcr_hex[i:i+group_size] for i in range(0, len(pcr_hex), group_size)]
    
    reversed_groups = []
    for group in pcr_groups:
        bytes_in_group = [group[j:j+2] for j in range(0, len(group), 2)]
        reversed_bytes = bytes_in_group[::-1]
        reversed_group = ''.join(reversed_bytes)
        reversed_groups.append(reversed_group)
    
    reversed_pcr_hex = ''.join(reversed_groups)
    return reversed_pcr_hex

def verify_pcr(captured_pcr_hex):
    if len(captured_pcr_hex) != PCR_VALID_LEN:
        error(f"PCR HEX length error: expected {PCR_VALID_LEN} bits, actual {len(captured_pcr_hex)} bits")
    
    if not os.path.exists("pcr_expect.txt"):
        error("PCR expected value file not found: pcr_expect.txt")
    
    with open("pcr_expect.txt", 'r') as f:
        expect_pcr_hex = re.sub(r'[^0-9a-fA-F]', '', f.read().strip()).lower()
    
    if len(expect_pcr_hex) != PCR_VALID_LEN:
        error(f"pcr_expect.txt data invalid: expected {PCR_VALID_LEN} bits HEX, actual {len(expect_pcr_hex)} bits")

    if captured_pcr_hex == expect_pcr_hex:
        success("PCR verification passed!")
    else:
        error("PCR verification failed: captured value does not match expected value")

def verify_nonce(captured_nonce_hex, sent_nonce_hex):
    if len(captured_nonce_hex) != NONCE_VALID_LEN:
        error(f"Nonce HEX length error: expected {NONCE_VALID_LEN} bits, actual {len(captured_nonce_hex)} bits")
    
    info(f"Sent Nonce HEX: {sent_nonce_hex}")
    info(f"Captured Nonce HEX: {captured_nonce_hex}")
    if captured_nonce_hex == sent_nonce_hex:
        success("Nonce verification passed!")
    else:
        error("Nonce verification failed: captured value does not match sent value")

def extract_mldsa_pk_from_ak_cert(ak_cert_pem_path="ak_cert.pem"):
    info("\n========== Extract ML-DSA Public Key from AK Certificate ==========")
    
    try:
        with open(ak_cert_pem_path, "rb") as f:
            cert_data = f.read()
        try:
            cert = x509.load_pem_x509_certificate(cert_data)
        except:
            cert = x509.load_pem_x509_certificate(cert_data, default_backend())
    except Exception as e:
        error(f"Failed to load AK certificate: {e}")
    
    try:
        extension = cert.extensions.get_extension_for_oid(x509.ObjectIdentifier(MLDSA_PK_EXTENSION_OID))
        pk_raw = extension.value
        if hasattr(pk_raw, 'value'):
            pk_raw = pk_raw.value
    except x509.ExtensionNotFound:
        error(f"ML-DSA public key extension (OID: {MLDSA_PK_EXTENSION_OID}) not found in AK certificate")
    
    import asn1crypto.core as asn1
    try:
        octet_string = asn1.OctetString.load(pk_raw)
        pure_pk_bin = octet_string.native
    except Exception as e:
        if pk_raw.startswith(b'\x04\x82'):
            pure_pk_bin = pk_raw[4:]
        elif pk_raw.startswith(b'\x04'):
            pure_pk_bin = pk_raw[2:]
        else:
            pure_pk_bin = pk_raw[:2592]
    
    if len(pure_pk_bin) in [5184, 5188]:
        info(f"Detected HEX string binary (len={len(pure_pk_bin)}), converting to raw public key...")
        try:
            pure_pk_hex = pure_pk_bin.decode('utf-8', errors='ignore').strip()
            pure_pk_hex = re.sub(r'[^0-9a-fA-F]', '', pure_pk_hex)[:5184]
            pure_pk_bin = binascii.unhexlify(pure_pk_hex)
        except Exception as e:
            error(f"Failed to convert HEX string to raw public key: {e}")
    
    expected_pk_bin_len = 2592
    if len(pure_pk_bin) != expected_pk_bin_len:
        error(f"ML-DSA public key length ERROR: expected {expected_pk_bin_len} bytes, actual {len(pure_pk_bin)} bytes")
    else:
        success(f"ML-DSA public key extracted (pure binary length: {len(pure_pk_bin)} bytes)")
    
    pk_hex_full = binascii.hexlify(pure_pk_bin).decode('utf-8').lower()
    info(f"\n========== Full ML-DSA Public Key (HEX, 5184 chars) ==========")
    for i in range(0, len(pk_hex_full), 100):
        chunk = pk_hex_full[i:i+100]
        info(f"PK HEX [{i:04d}-{i+len(chunk)-1:04d}]: {chunk}")
    info(f"===============================================================")
    
    with open("mldsa_pk_full.hex", "w") as f:
        f.write(pk_hex_full)
    success(f"Full ML-DSA public key saved to: mldsa_pk_full.hex")
    
    pk_hex = pk_hex_full[:50] + "..." + pk_hex_full[-50:]
    info(f"ML-DSA Public Key: {pk_hex}")
    
    with open("mldsa_pk_bin.bin", "wb") as f:
        f.write(pure_pk_bin)
    info(f"ML-DSA public key binary saved to: mldsa_pk_bin.bin")
    
    return pure_pk_bin, pk_hex_full

try:
    lib = ctypes.CDLL('./libmldsa_verify.so')
    lib.mldsa_verify_wrapper.argtypes = [
        ctypes.POINTER(c_uint8), c_size_t,
        ctypes.POINTER(c_uint8), c_size_t,
        ctypes.POINTER(c_uint8), c_size_t
    ]
    lib.mldsa_verify_wrapper.restype = c_int
except Exception as e:
    error(f"Failed to load ML-DSA verify library: {e}")

def verify_mldsa_signature(pcr_hex, nonce_hex, flag_byte, mldsa_sig_hex, mldsa_pk_bin):
    info("\n========== Start ML-DSA Signature Verification ==========")

    pk_hex_check = binascii.hexlify(mldsa_pk_bin).decode('utf-8').lower()
    info(f"Verify using ML-DSA PK (first 100 chars): {pk_hex_check[:100]}")

    try:
        pcr_bin = binascii.unhexlify(pcr_hex)
        nonce_bin = binascii.unhexlify(nonce_hex)
        sig_bin = binascii.unhexlify(mldsa_sig_hex)
        flag_bin = bytes([flag_byte])
        with open("extracted_sig.bin", "wb") as f:
            f.write(sig_bin)
        info(f"Extracted signature saved to: extracted_sig.bin (len: {len(sig_bin)} bytes)")
        pk_bin = mldsa_pk_bin
    except binascii.Error as e:
        error(f"HEX to BIN conversion failed: {e}")

    msg_concat_bin = pcr_bin + nonce_bin + flag_bin
    info(f"PCR+Nonce+Flag concat length: {len(msg_concat_bin)} bytes "
         f"(PCR: {len(pcr_bin)}, Nonce: {len(nonce_bin)}, Flag: 0x{flag_byte:02x})")

    import hashlib
    sha256 = hashlib.sha256()
    sha256.update(msg_concat_bin)
    msg_digest_bin = sha256.digest()
    info(f"Computed SHA256 digest (len={len(msg_digest_bin)}): {binascii.hexlify(msg_digest_bin).decode()}")

    sig_arr = (c_uint8 * len(sig_bin)).from_buffer_copy(sig_bin)
    msg_arr = (c_uint8 * len(msg_digest_bin)).from_buffer_copy(msg_digest_bin)
    pk_arr = (c_uint8 * len(pk_bin)).from_buffer_copy(pk_bin)

    debug(f"MLDSA Verify Params: sig_len={len(sig_bin)}, msg_len={len(msg_digest_bin)}, pk_len={len(pk_bin)}")

    rc = lib.mldsa_verify_wrapper(
        sig_arr, len(sig_bin),
        msg_arr, len(msg_digest_bin),
        pk_arr, len(pk_bin)
    )

    if rc == 0:
        success("ML-DSA-87 signature verification PASSED!")
        return True
    else:
        error(f"ML-DSA-87 signature verification FAILED! return code: {rc})")
        return False

def send_data_non_blocking(ser, data, chunk_size=8, timeout=2):
    sent = 0
    total = len(data)
    start_time = time.time()
    
    debug(f"Starting non-blocking send: {total} bytes in {chunk_size}-byte chunks")
    while sent < total:
        if time.time() - start_time > timeout:
            raise serial.SerialTimeoutException(f"Send timeout after {timeout}s (sent {sent}/{total} bytes)")
        
        chunk = data[sent:sent+chunk_size]
        try:
            bytes_written = ser.write(chunk)
            sent += bytes_written
            debug(f"Sent chunk: {sent}/{total} bytes")
            time.sleep(0.001)
        except Exception as e:
            raise Exception(f"Failed to send chunk {sent//chunk_size +1}: {e}")
    
    time.sleep(0.1)
    debug(f"Non-blocking send complete: {sent}/{total} bytes")
    return sent

def read_and_parse_quote_data(nonce_bytes):
    try:
        debug(f"Opening serial port: {SERIAL_PORT}, baudrate: {BAUDRATE} (no hardware flow control)")
        ser = serial.Serial(
            port=SERIAL_PORT,
            baudrate=BAUDRATE,
            parity=PARITY,
            stopbits=STOPBITS,
            bytesize=BYTESIZE,
            timeout=READ_INTERVAL,
            write_timeout=NONCE_SEND_TIMEOUT,
            rtscts=False,
            dsrdtr=False,
            xonxoff=False
        )
        if hasattr(ser, 'set_buffer_size'):
            ser.set_buffer_size(rx_size=SERIAL_BUFFER_SIZE, tx_size=SERIAL_BUFFER_SIZE)
        success(f"Serial port opened successfully: {SERIAL_PORT} {BAUDRATE} 8N1 (buffer {SERIAL_BUFFER_SIZE} bytes)")
    except Exception as e:
        error(f"Failed to open serial port: {str(e)}\nTips: Check if {SERIAL_PORT} is available, or try 'sudo chmod 666 {SERIAL_PORT}'")

    try:
        debug("Resetting serial input/output buffer...")
        ser.reset_input_buffer()
        ser.reset_output_buffer()
        debug("Buffer reset completed")
        time.sleep(0.5)
    except Exception as e:
        error(f"Failed to reset serial buffer: {e}")

    try:
        debug(f"Sending Nonce (32 bytes): {binascii.hexlify(nonce_bytes).decode()[:20]}...")
        send_data_non_blocking(ser, nonce_bytes, SERIAL_WRITE_CHUNK, NONCE_SEND_TIMEOUT)
        debug("Nonce sent successfully, waiting for device response...")
        time.sleep(3)
    except serial.SerialTimeoutException:
        error(f"Nonce send timeout (>{NONCE_SEND_TIMEOUT}s)! Check if device is connected and responding")
    except Exception as e:
        error(f"Failed to send Nonce: {e}")

    raw_data = b""
    start_time = time.time()
    no_new_data_count = 0
    end_marker_found = False
    info("Starting data reception (dynamic length, waiting for #END# marker)...")

    while time.time() - start_time < READ_TIMEOUT_TOTAL:
        elapsed = time.time() - start_time
        try:
            if ser.in_waiting > 0:
                new_data = ser.read(ser.in_waiting)
                raw_data += new_data
                no_new_data_count = 0
                raw_str_temp = raw_data.decode('utf-8', errors='replace')
                if QUOTE_END_MARKER in raw_str_temp:
                    end_marker_found = True
                    info(f"#END# marker found at {len(raw_data)} bytes! Reading final data...")
                    time.sleep(0.5)
                    if ser.in_waiting > 0:
                        raw_data += ser.read(ser.in_waiting)
                    break
                info(f"Received data: {len(raw_data)} bytes")
            else:
                no_new_data_count += 1
                if no_new_data_count >= NO_NEW_DATA_THRESHOLD:
                    info(f"No new data for {NO_NEW_DATA_THRESHOLD * READ_INTERVAL}s, stop reading (total: {len(raw_data)} bytes)")
                    break
        except Exception as e:
            warn(f"Error reading serial data: {e}, continue reception...")
        time.sleep(READ_INTERVAL)

    ser.close()
    debug("Serial port closed")

    with open("raw_received.bin", "wb") as f:
        f.write(raw_data)
    info(f"Raw received data saved to raw_received.bin ({len(raw_data)} bytes)")

    raw_str = raw_data.decode('utf-8', errors='replace')
    raw_str = raw_str.replace('\n', '').replace('\r', '').replace(' ', '').replace('j', '')
    
    start = raw_str.find("#QUOTE#")
    end = raw_str.find("#END#")
    
    quote_hex = raw_str[start+7 : end]
    
    info(f"Extracted Quote HEX length: {len(quote_hex)} chars")
    return quote_hex


def parse_quote_and_verify(quote_hex, sent_nonce_hex):
    info("\n========== Start dynamic parsing of Quote data ==========")
    
    ak_len_hex = quote_hex[:AK_LEN_HEX_LEN]
    try:
        ak_cert_hex_len = int(ak_len_hex, 16)
    except ValueError:
        error(f"AK length parsing failed: {ak_len_hex}")
    
    info(f"Parsed AK certificate length: {ak_cert_hex_len} chars")
    
    total_required_len = (
        AK_LEN_HEX_LEN + 
        ak_cert_hex_len + 
        PCR_VALID_LEN + 
        NONCE_VALID_LEN + 
        CERT_CHAIN_FLAG_HEX_LEN +
        MLDSA_SIGN_VALID_LEN
    )
    if len(quote_hex) < total_required_len:
        error(f"Insufficient Quote data: need {total_required_len} chars, have {len(quote_hex)} chars")
    
    offset = AK_LEN_HEX_LEN
    ak_cert_hex = quote_hex[offset : offset + ak_cert_hex_len]
    offset += ak_cert_hex_len
    
    pcr_hex = quote_hex[offset : offset + PCR_VALID_LEN]
    offset += PCR_VALID_LEN
    
    nonce_hex = quote_hex[offset : offset + NONCE_VALID_LEN]
    offset += NONCE_VALID_LEN
    
    flag_hex = quote_hex[offset : offset + CERT_CHAIN_FLAG_HEX_LEN]
    offset += CERT_CHAIN_FLAG_HEX_LEN
    try:
        flag_byte = int(flag_hex, 16)
    except ValueError:
        error(f"Cert chain flag parsing failed: {flag_hex}")
    if flag_byte not in (CERT_CHAIN_SUCCESS, CERT_CHAIN_FAILURE):
        warn(f"Unexpected cert chain flag value: 0x{flag_byte:02x}, expected 0x9a or 0xaa. Proceeding anyway.")

    mldsa_sign_hex = quote_hex[offset : offset + MLDSA_SIGN_VALID_LEN]
    offset += MLDSA_SIGN_VALID_LEN

    info(f"Data parsing complete:")
    info(f"   AK Cert    : {len(ak_cert_hex)} chars")
    info(f"   PCR        : {len(pcr_hex)} chars")
    info(f"   Nonce      : {len(nonce_hex)} chars")
    info(f"   Cert Flag  : 0x{flag_byte:02x} ({'SUCCESS' if flag_byte == CERT_CHAIN_SUCCESS else 'FAILURE' if flag_byte == CERT_CHAIN_FAILURE else 'UNKNOWN'})")
    info(f"   ML-DSA Sig : {len(mldsa_sign_hex)} chars")

    info("\n========== Start Verification ==========")
    verify_ak_certificate(ak_cert_hex, ak_cert_hex_len)
    mldsa_pk_bin, mldsa_pk_hex = extract_mldsa_pk_from_ak_cert()
    
    verify_pcr(pcr_hex)
    
    verify_nonce(nonce_hex, sent_nonce_hex)
    
    verify_mldsa_signature(pcr_hex, nonce_hex, flag_byte, mldsa_sign_hex, mldsa_pk_bin)

    info(f"Cert chain verification status (from Quote, verified): "
         f"{'PASS' if flag_byte == CERT_CHAIN_SUCCESS else 'FAIL'}")

def main():
    info("========================================")
    info("Remote Attestation Verification Script")
    info("========================================")
    
    if not os.path.exists("ca_root.crt"):
        error("CA root certificate missing: ca_root.crt")
    
    nonce_bytes, sent_nonce_hex = generate_nonce()

    quote_hex = read_and_parse_quote_data(nonce_bytes)

    parse_quote_and_verify(quote_hex, sent_nonce_hex)

    info("========================================")
    success("All verification (AK + PCR + Nonce + MLDSA) passed!")
    info("========================================")

if __name__ == "__main__":
    main()
