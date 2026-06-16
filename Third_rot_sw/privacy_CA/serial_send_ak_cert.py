import serial
import time
import binascii
import os
from cryptography import x509
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.backends import default_backend

from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.padding import PKCS7

AES_256_KEY = bytes([
    0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,
    0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f,
    0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,
    0x18,0x19,0x1a,0x1b,0x1c,0x1d,0x1e,0x1f
])

def aes_256_ecb_encrypt(plain_data):
    BLOCK_SIZE = 16
    # 标准PKCS7填充
    from cryptography.hazmat.primitives.padding import PKCS7
    padder = PKCS7(BLOCK_SIZE * 8).padder()
    padded_plain = padder.update(plain_data) + padder.finalize()
    # 加密
    from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
    cipher = Cipher(algorithms.AES(AES_256_KEY), modes.ECB(), default_backend())
    encryptor = cipher.encryptor()
    encrypted = encryptor.update(padded_plain) + encryptor.finalize()
    # 检查长度
    assert len(encrypted) % 16 == 0, f"The length is incorrect after encryption:{len(encrypted)}"
    return encrypted


PEM_FILE = "ak_cert.pem"
HEX_FILE = "ak_cert_hex.txt"
SERIAL_PORT = "/dev/ttyACM1"
BAUD_RATE = 115200
BLOCK_SIZE = 32
ACK_BYTE = b'\x06'
TIMEOUT = 3
PREFIX = "AK_CERT:"

def parse_HEX_FILE(file_path):
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            text_content = f.read().strip()
    except Exception as e:
        raise Exception(f"Failed to read file: {e}")

    if PREFIX not in text_content:
        raise Exception(f"Prefix '{PREFIX}' not found in file")

    hex_str = text_content.split(PREFIX)[1]
    valid_hex = ''.join([c for c in hex_str if c in '0123456789abcdefABCDEF'])
    if len(valid_hex) == 0:
        raise Exception("No valid hex characters found after prefix")

    try:
        cert_bin = bytes.fromhex(valid_hex)
    except Exception as e:
        raise Exception(f"Hex to binary conversion failed: {e}")

    encrypted_cert_bin = aes_256_ecb_encrypt(cert_bin)
    final_data = PREFIX.encode('ascii') + encrypted_cert_bin

    print(f"[Parsed] Prefix: {PREFIX} ({len(PREFIX)} bytes ASCII)")
    print(f"Valid hex length: {len(valid_hex)} → Binary: {len(cert_bin)} bytes")
    print(f"Encrypted length: {len(encrypted_cert_bin)} bytes")
    print(f"Total data length: {len(final_data)} bytes")
    return final_data

def send_cert_by_uart():
    try:
        cert_data = parse_HEX_FILE(HEX_FILE)
    except Exception as e:
        print(f"{e}")
        return

    try:
        ser = serial.Serial(
            port=SERIAL_PORT,
            baudrate=BAUD_RATE,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            xonxoff=False,
            rtscts=False,
            dsrdtr=False,
            timeout=TIMEOUT
        )
    except Exception as e:
        print(f"Failed to open serial port: {e}")
        return

    time.sleep(0.8)
    if not ser.is_open:
        print("Serial port not opened")
        return
    print(f"Serial port opened: {SERIAL_PORT} @ {BAUD_RATE} baud")
    print("Sending sync signal...")
    ser.write(b'\x00'*8)
    ser.flush()
    time.sleep(0.1)
    ser.flushInput()

    total_len = len(cert_data)
    sent_len = 0
    block_num = 1
    total_blocks = (total_len + BLOCK_SIZE - 1) // BLOCK_SIZE
    print(f"Starting block transfer | Block size: {BLOCK_SIZE} bytes | Total blocks: {total_blocks} | Total length: {total_len} bytes")
    print("-" * 60)

    while sent_len < total_len:
        block_data = cert_data[sent_len:sent_len+BLOCK_SIZE]
        block_len = len(block_data)
        ser.write(block_data)
        ser.flush()
        print(f"[Block {block_num:2d}] Sent {block_len:2d} bytes | Total sent: {sent_len+block_len:3d}/{total_len:3d} bytes")

        ser.flushInput()
        time.sleep(0.005)

        ack_found = False
        start_time = time.time()
        while time.time() - start_time < TIMEOUT:
            if ser.in_waiting > 0:
                recv_byte = ser.read(1)
                if recv_byte == ACK_BYTE:
                    print(f"[ACK] Block {block_num:2d} received ACK (0x06)\n")
                    ack_found = True
                    break

        if not ack_found:
            print(f"Block {block_num:2d} timeout after {TIMEOUT} seconds")
            ser.close()
            return

        sent_len += block_len
        block_num += 1
        time.sleep(0.005)

    ser.close()
    print("-" * 60)
    print(f"Sent {total_len} bytes of certificate data")
    print("Check firmware logs to confirm reception")

def check_file_exists(file_path):
    try:
        with open(file_path, 'rb'):
            pass
    except FileNotFoundError:
        print(f"File {file_path} not found! Please check if ak_cert.pem exists in current directory")

def pem2hex_and_save(pem_path, hex_path):
    try:
        with open(pem_path, 'rb') as f:
            pem_data = f.read()
        
        try:
            cert = x509.load_pem_x509_certificate(pem_data)
        except TypeError:
            cert = x509.load_pem_x509_certificate(pem_data, backend=default_backend())
        
        der_bin = cert.public_bytes(encoding=serialization.Encoding.DER)
        der_hex = binascii.hexlify(der_bin).decode('utf-8')
        hex_with_prefix = PREFIX + der_hex
        
        with open(hex_path, 'w') as f:
            f.write(hex_with_prefix)
        
        print(f"Successfully converted {pem_path} to hex")
        print(f"Hex file saved as: {hex_path} (length: {len(der_hex)} bytes)")
    except Exception as e:
        print(f"Failed to convert or save file: {e}")
        raise


def main():
    check_file_exists(PEM_FILE)
    pem2hex_and_save(PEM_FILE, HEX_FILE)
    send_cert_by_uart()

if __name__ == "__main__":
    main()
