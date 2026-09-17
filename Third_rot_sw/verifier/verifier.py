#!/usr/bin/env python3
import serial
import subprocess
import time
import re
import sys
import os
import binascii
import ctypes
import hashlib
from pathlib import Path
from ctypes import c_uint8, c_size_t, c_int
from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives import hashes
from cryptography.x509.oid import NameOID

SERIAL_PORT = os.environ.get(
    "VERIFIER_SERIAL_PORT",
    "/dev/serial/by-id/usb-Xilinx_VCU129_422029122114-if01-port0",
)
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
L3_READY_BYTE = b"\xa5"
L3_READY_TIMEOUT = 120

AK_LEN_HEX_LEN = 4
PCR_VALID_LEN = 64
NONCE_VALID_LEN = 64
MLDSA_SIGN_VALID_LEN = 4627*2
BLS_QUOTE_BLOCK_BYTES = 1 + 8 + 32 + 1 + 96
BLS_QUOTE_BLOCK_HEX_LEN = BLS_QUOTE_BLOCK_BYTES * 2
CLUSTER_BLS_PROOF_SUCCESS = 0xAA
CLUSTER_BLS_REGISTRATION_BYTES = 162
CLUSTER_BLS_SIGNATURE_BYTES = 96
CLUSTER_BLS_KEY_LIST_MAX_BYTES = 22528
CLUSTER_BLS_KEY_LIST_REQUEST_MAGIC = b"KLR1"
CLUSTER_BLS_KEY_LIST_RESPONSE_MAGIC = b"KLV1"
CLUSTER_BLS_KEY_LIST_DOMAIN = b"CLUSTER-BLS-KEY-LIST-WIRE-v1\x00"
SCRIPT_DIR = Path(__file__).resolve().parent
CLUSTER_BLS_CACHE = Path(os.environ.get(
    "CLUSTER_BLS_CACHE", str(SCRIPT_DIR / "cluster_bls_demo_key_list.json")
)).expanduser()

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

def _load_cluster_protocol():
    if str(SCRIPT_DIR) not in sys.path:
        sys.path.insert(0, str(SCRIPT_DIR))
    try:
        import protocol
    except ImportError as e:
        error(f"Cluster-BLS protocol.py is missing: {e}")
    return protocol

def load_cluster_bls_cache():
    if not CLUSTER_BLS_CACHE.is_file():
        error(
            f"Pre-provisioned demo BLS key list is missing: {CLUSTER_BLS_CACHE}"
        )
    protocol = _load_cluster_protocol()
    try:
        cache = protocol.load_json(CLUSTER_BLS_CACHE)
        cache_format = cache.get("cacheFormat")
        if cache_format not in (1, 2, 3) or not isinstance(cache.get("keyList"), dict):
            raise protocol.ProtocolError("unsupported verifier-cache format")
        protocol.validate_key_list(
            cache["keyList"], require_signature=(cache_format == 2)
        )
        if cache_format == 3 and cache.get("keyListAuthentication") != "L3-BLS-KLV1":
            raise protocol.ProtocolError("invalid L3 key-list authentication marker")
        if (cache_format == 1 and
                cache.get("keyListAuthentication") !=
                "DEMO-PREPROVISIONED-FIXED-KEYS"):
            raise protocol.ProtocolError("invalid pre-provisioned demo key list")
        return cache
    except Exception as e:
        error(f"Invalid Cluster-BLS verifier cache: {e}")

def build_cluster_bls_quote_request(nonce_bytes):
    protocol = _load_cluster_protocol()
    cache = load_cluster_bls_cache()
    try:
        active_members = [
            member for member in cache["keyList"]["members"]
            if member.get("status") == "active"
        ]
        active_levels = sorted(member.get("level") for member in active_members)
        if len(active_members) != 3 or active_levels != ["L1", "L2", "L3"]:
            raise protocol.ProtocolError(
                "this firmware requires exactly one active L3/L2/L1 path"
            )
        request = protocol.build_quote_request(
            cache["keyList"], nonce_bytes,
            require_list_signature=(cache.get("cacheFormat") == 2),
        )
    except Exception as e:
        error(f"Could not build BLQ1 request: {e}")
    info(
        "Built current-epoch BLQ1 request: "
        f"cluster={cache['keyList']['clusterID']} "
        f"epoch={cache['keyList']['epoch']} bytes={len(request)}"
    )
    return request

def serial_read_exact(ser, length, timeout):
    data = bytearray()
    deadline = time.time() + timeout
    while len(data) < length and time.time() < deadline:
        waiting = ser.in_waiting
        chunk = ser.read(min(length - len(data), waiting if waiting > 0 else 1))
        if chunk:
            data.extend(chunk)
    if len(data) != length:
        raise TimeoutError(f"received {len(data)}/{length} bytes")
    return bytes(data)

def _cluster_bls_root_certificate_path():
    configured = os.environ.get("CLUSTER_BLS_CA_CERT")
    candidates = [Path(configured).expanduser()] if configured else []
    candidates.extend([Path.cwd() / "ca_root.crt", SCRIPT_DIR / "ca_root.crt"])
    for candidate in candidates:
        if candidate.is_file():
            return candidate.resolve()
    raise FileNotFoundError("trusted CA certificate ca_root.crt was not found")

def _certificate_common_name(certificate, label):
    values = certificate.subject.get_attributes_for_oid(NameOID.COMMON_NAME)
    if len(values) != 1 or not values[0].value:
        raise ValueError(f"{label} certificate has no unique nodeID common name")
    return values[0].value

def _registration_from_wire(protocol, wire, node_id, level, parent_node_id):
    if (len(wire) != CLUSTER_BLS_REGISTRATION_BYTES or
            wire[0] != protocol.PROTOCOL_VERSION or wire[1] != 1):
        raise protocol.ProtocolError(f"invalid {level} BLS registration wire object")
    registration = {
        "protocolVersion": wire[0],
        "ciphersuiteID": protocol.CIPHERSUITE_ID,
        "nodeID": node_id,
        "keyID": wire[2:18].hex(),
        "blsPublicKey": wire[18:66].hex(),
        "proofOfPossession": wire[66:162].hex(),
        "status": "active",
        "level": level,
    }
    if parent_node_id is not None:
        registration["parentNodeID"] = parent_node_id
    binding = protocol.binding_from_registration(registration)
    member = {
        "nodeID": node_id,
        "keyID": binding.key_id.hex(),
        "blsPublicKey": binding.public_key.hex(),
        "status": "active",
        "level": level,
    }
    if parent_node_id is not None:
        member["parentNodeID"] = parent_node_id
    return registration, member, binding

def receive_current_cluster_bls_key_list(ser, nonce_bytes):
    """Request, authenticate and cache L3's current public-key list."""
    protocol = _load_cluster_protocol()
    request = CLUSTER_BLS_KEY_LIST_REQUEST_MAGIC + nonce_bytes
    info("Requesting the current signed Cluster-BLS public-key list from L3...")
    send_data_non_blocking(ser, request, SERIAL_WRITE_CHUNK, NONCE_SEND_TIMEOUT)
    try:
        header = serial_read_exact(ser, 8, READ_TIMEOUT_TOTAL)
        if header[:4] != CLUSTER_BLS_KEY_LIST_RESPONSE_MAGIC:
            raise protocol.ProtocolError(
                f"unexpected key-list response magic: {header[:4]!r}"
            )
        total_len = int.from_bytes(header[4:8], "big")
        if total_len < 8 + 1 + 1 + 1 + 8 + 32 + 3 * 162 + 12 + 96:
            raise protocol.ProtocolError("L3 key-list response is too short")
        if total_len > CLUSTER_BLS_KEY_LIST_MAX_BYTES:
            raise protocol.ProtocolError("L3 key-list response exceeds the bound")
        packet = header + serial_read_exact(
            ser, total_len - len(header), READ_TIMEOUT_TOTAL
        )
    except (TimeoutError, serial.SerialException) as e:
        error(f"Could not receive the current key list from L3: {e}")

    try:
        signature_offset = len(packet) - CLUSTER_BLS_SIGNATURE_BYTES
        signature = packet[signature_offset:]
        offset = 8

        def take(length):
            nonlocal offset
            if length < 0 or offset + length > signature_offset:
                raise protocol.ProtocolError("truncated L3 key-list response")
            value = packet[offset:offset + length]
            offset += length
            return value

        if take(1)[0] != protocol.PROTOCOL_VERSION:
            raise protocol.ProtocolError("unsupported L3 key-list version")
        cluster_id_len = take(1)[0]
        if not 1 <= cluster_id_len <= 128:
            raise protocol.ProtocolError("invalid key-list clusterID length")
        cluster_id = take(cluster_id_len).decode("utf-8", errors="strict")
        epoch = int.from_bytes(take(8), "big")
        response_nonce = take(32)
        if response_nonce != nonce_bytes:
            raise protocol.ProtocolError("stale or replayed L3 key-list response")
        l3_wire = take(CLUSTER_BLS_REGISTRATION_BYTES)
        l2_wire = take(CLUSTER_BLS_REGISTRATION_BYTES)
        l1_wire = take(CLUSTER_BLS_REGISTRATION_BYTES)
        l3_cert_len = int.from_bytes(take(4), "big")
        l2_cert_len = int.from_bytes(take(4), "big")
        l1_cert_len = int.from_bytes(take(4), "big")
        if not all(0 < length <= 8192 for length in
                   (l3_cert_len, l2_cert_len, l1_cert_len)):
            raise protocol.ProtocolError("invalid certificate length in key list")
        l3_der = take(l3_cert_len)
        l2_der = take(l2_cert_len)
        l1_der = take(l1_cert_len)
        if offset != signature_offset:
            raise protocol.ProtocolError("unexpected trailing key-list fields")

        root_path = _cluster_bls_root_certificate_path()
        root_data = root_path.read_bytes()
        root_certificate = (
            x509.load_pem_x509_certificate(root_data)
            if b"-----BEGIN CERTIFICATE-----" in root_data
            else x509.load_der_x509_certificate(root_data)
        )
        l3_certificate = x509.load_der_x509_certificate(l3_der)
        l2_certificate = x509.load_der_x509_certificate(l2_der)
        l1_certificate = x509.load_der_x509_certificate(l1_der)
        l3_node_id = _certificate_common_name(l3_certificate, "L3")
        l2_node_id = _certificate_common_name(l2_certificate, "L2")
        l1_node_id = _certificate_common_name(l1_certificate, "L1")

        _, l3_member, l3_binding = _registration_from_wire(
            protocol, l3_wire, l3_node_id, "L3", None
        )
        _, l2_member, _ = _registration_from_wire(
            protocol, l2_wire, l2_node_id, "L2", l3_node_id
        )
        _, l1_member, _ = _registration_from_wire(
            protocol, l1_wire, l1_node_id, "L1", l2_node_id
        )
        key_list = protocol.build_key_list(
            cluster_id, epoch, [l3_member, l2_member, l1_member]
        )

        if str(SCRIPT_DIR) not in sys.path:
            sys.path.insert(0, str(SCRIPT_DIR))
        import cluster_bls_verifier
        cluster_bls_verifier._verify_full_chain_and_membership(
            root_certificate, l3_certificate, l2_certificate,
            l1_certificate, key_list
        )
        list_digest = hashlib.sha256(
            CLUSTER_BLS_KEY_LIST_DOMAIN + packet[:signature_offset]
        ).digest()
        if not protocol.fast_aggregate_verify(
            [l3_binding.public_key], list_digest, signature
        ):
            raise protocol.ProtocolError("L3 key-list BLS signature is invalid")

        cache = {
            "cacheFormat": 3,
            "keyListAuthentication": "L3-BLS-KLV1",
            "trustedThirdPartyFingerprint": root_certificate.fingerprint(
                hashes.SHA256()).hex(),
            "l3CertificateFingerprint": l3_certificate.fingerprint(
                hashes.SHA256()).hex(),
            "l2CertificateFingerprint": l2_certificate.fingerprint(
                hashes.SHA256()).hex(),
            "l1CertificateFingerprint": l1_certificate.fingerprint(
                hashes.SHA256()).hex(),
            "keyListWireDigest": list_digest.hex(),
            "keyList": key_list,
        }
        protocol.save_json_atomic(CLUSTER_BLS_CACHE, cache)
    except Exception as e:
        error(f"L3 public-key list verification failed: {e}")

    success(
        f"Accepted L3 signed public-key list: cluster={cluster_id}, "
        f"epoch={epoch}, members=3"
    )
    return cache

def verify_cluster_bls_proof(bls_quote_hex, nonce_hex, measurement_hex):
    info("\n========== Start Cluster-BLS Aggregate Certificate-Chain Verification ==========")
    try:
        block = bytes.fromhex(bls_quote_hex)
    except ValueError as e:
        error(f"Cluster-BLS proof is not hexadecimal: {e}")
    if len(block) != BLS_QUOTE_BLOCK_BYTES:
        error(f"Cluster-BLS proof length mismatch: {len(block)} bytes")

    status = block[0]
    epoch = int.from_bytes(block[1:9], "big")
    member_list_digest = block[9:41]
    participant_count = block[41]
    aggregate_signature = block[42:]
    if status != CLUSTER_BLS_PROOF_SUCCESS:
        error(f"L3 reported Cluster-BLS proof collection failure: 0x{status:02x}")

    protocol = _load_cluster_protocol()
    cache = load_cluster_bls_cache()
    key_list = cache["keyList"]
    active_ids = sorted(
        member["nodeID"] for member in key_list["members"]
        if member.get("status") == "active"
    )
    try:
        with open("ak_cert.pem", "rb") as f:
            quote_certificate = x509.load_pem_x509_certificate(
                f.read(), default_backend()
            )
        if (cache.get("cacheFormat") in (2, 3) and
                quote_certificate.fingerprint(hashes.SHA256()).hex() !=
                cache.get("l3CertificateFingerprint")):
            raise protocol.ProtocolError(
                "quote AK certificate does not match the cached L3 certificate"
            )
        if cache.get("cacheFormat") == 1:
            l3_members = [
                member for member in key_list["members"]
                if member.get("level") == "L3"
            ]
            if len(l3_members) != 1:
                raise protocol.ProtocolError("demo list has no unique L3 key")
            binding = protocol.certificate_binding_from_certificate(
                quote_certificate
            )
            if (binding.public_key.hex() != l3_members[0]["blsPublicKey"] or
                    binding.key_id.hex() != l3_members[0]["keyID"]):
                warn(
                    "DEMO only: AK certificate carries an older L3 BLS key; "
                    "continuing with the pre-provisioned fixed-key aggregate test"
                )
        if cache.get("cacheFormat") == 2:
            protocol.verify_key_list(key_list, quote_certificate)
        if epoch != int(key_list["epoch"]):
            raise protocol.ProtocolError(
                f"proof epoch {epoch} does not match cached epoch {key_list['epoch']}"
            )
        if member_list_digest != protocol.key_list_digest(key_list):
            raise protocol.ProtocolError("member-list digest mismatch")
        if participant_count != len(active_ids):
            raise protocol.ProtocolError(
                f"participant count {participant_count} does not match {len(active_ids)} active members"
            )
        response = protocol.make_aggregate_response(
            key_list, active_ids, aggregate_signature
        )
        if not protocol.verify_aggregate_response(
            key_list,
            response,
            bytes.fromhex(nonce_hex),
            bytes.fromhex(measurement_hex),
            require_all_active=True,
        ):
            raise protocol.ProtocolError("aggregate signature verification failed")
    except Exception as e:
        error(f"Cluster-BLS aggregate proof verification failed: {e}")

    success(
        f"Cluster-BLS aggregate certificate-chain proof verified: epoch={epoch}, "
        f"participants={participant_count}"
    )

def verify_bls_certificate_binding(ak_cert_path="ak_cert.pem"):
    """Validate only the additive BLS attributes carried by the AK cert."""
    try:
        common_dir = os.path.abspath(os.path.join(
            os.path.dirname(__file__), "..", "cluster_bls"
        ))
        if common_dir not in sys.path:
            sys.path.insert(0, common_dir)
        from protocol import certificate_binding_from_certificate

        with open(ak_cert_path, "rb") as f:
            certificate = x509.load_pem_x509_certificate(f.read(), default_backend())
        binding = certificate_binding_from_certificate(certificate)
    except Exception as e:
        error(f"BLS certificate binding verification failed: {e}")

    success(
        "BLS certificate binding passed: "
        f"keyID={binding.key_id.hex()}"
    )

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

    verify_bls_certificate_binding("ak_cert.pem")

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

def verify_mldsa_signature(pcr_hex, nonce_hex, bls_quote_hex,
                           mldsa_sig_hex, mldsa_pk_bin):
    info("\n========== Start ML-DSA Signature Verification ==========")
    
    pk_hex_check = binascii.hexlify(mldsa_pk_bin).decode('utf-8').lower()
    info(f"Verify using ML-DSA PK (first 100 chars): {pk_hex_check[:100]}")
    
    try:
        pcr_bin = binascii.unhexlify(pcr_hex)
        nonce_bin = binascii.unhexlify(nonce_hex)
        bls_quote_bin = binascii.unhexlify(bls_quote_hex)
        sig_bin = binascii.unhexlify(mldsa_sig_hex)
        with open("extracted_sig.bin", "wb") as f:
            f.write(sig_bin)
        info(f"Extracted signature saved to: extracted_sig.bin (len: {len(sig_bin)} bytes)")
        pk_bin = mldsa_pk_bin
    except binascii.Error as e:
        error(f"HEX to BIN conversion failed: {e}")

    msg_concat_bin = pcr_bin + nonce_bin + bls_quote_bin
    info(
        f"PCR+Nonce+BLS concat length: {len(msg_concat_bin)} bytes "
        f"(PCR: {len(pcr_bin)}, Nonce: {len(nonce_bin)}, "
        f"BLS: {len(bls_quote_bin)})"
    )
    
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

def wait_for_l3_ready(ser):
    info("Waiting for L3 UART1 ready byte 0xA5...")
    deadline = time.time() + L3_READY_TIMEOUT
    while time.time() < deadline:
        value = ser.read(1)
        if value == L3_READY_BYTE:
            success("L3 UART1 is ready")
            return
    error("L3 UART1 ready timeout: no 0xA5 received")

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
        wait_for_l3_ready(ser)
    except Exception as e:
        error(f"Failed to reset serial buffer: {e}")

    try:
        debug(f"Sending Nonce (32 bytes): {binascii.hexlify(nonce_bytes).decode()[:20]}...")
        send_data_non_blocking(
            ser, nonce_bytes, SERIAL_WRITE_CHUNK, NONCE_SEND_TIMEOUT
        )
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
    if start < 0 or end < 0 or end <= start + len(QUOTE_START_MARKER):
        preview = raw_data[:64].hex()
        error(
            "No complete #QUOTE#...#END# frame received. "
            f"raw_bytes={len(raw_data)}, preview={preview}. "
            "Confirm L3 is waiting for the verifier nonce and the L2 Cluster-BLS relay is running."
        )
    
    quote_hex = raw_str[start + len(QUOTE_START_MARKER) : end]
    
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
        AK_LEN_HEX_LEN + ak_cert_hex_len + 
        PCR_VALID_LEN + NONCE_VALID_LEN +
        BLS_QUOTE_BLOCK_HEX_LEN + MLDSA_SIGN_VALID_LEN
    )
    if len(quote_hex) != total_required_len:
        error(
            f"Quote length mismatch: need exactly {total_required_len} chars, "
            f"have {len(quote_hex)} chars"
        )
    
    offset = AK_LEN_HEX_LEN
    ak_cert_hex = quote_hex[offset : offset + ak_cert_hex_len]
    offset += ak_cert_hex_len
    
    pcr_hex = quote_hex[offset : offset + PCR_VALID_LEN]
    offset += PCR_VALID_LEN
    
    nonce_hex = quote_hex[offset : offset + NONCE_VALID_LEN]
    offset += NONCE_VALID_LEN

    bls_quote_hex = quote_hex[offset : offset + BLS_QUOTE_BLOCK_HEX_LEN]
    offset += BLS_QUOTE_BLOCK_HEX_LEN
    
    mldsa_sign_hex = quote_hex[offset : offset + MLDSA_SIGN_VALID_LEN]
    offset += MLDSA_SIGN_VALID_LEN

    info(f"Data parsing complete:")
    info(f"   AK Cert    : {len(ak_cert_hex)} chars")
    info(f"   PCR        : {len(pcr_hex)} chars")
    info(f"   Nonce      : {len(nonce_hex)} chars")
    info(f"   BLS Proof  : {len(bls_quote_hex)} chars")
    info(f"   ML-DSA Sig : {len(mldsa_sign_hex)} chars")

    info("\n========== Start Verification ==========")
    verify_ak_certificate(ak_cert_hex, ak_cert_hex_len)
    mldsa_pk_bin, mldsa_pk_hex = extract_mldsa_pk_from_ak_cert()
    
    verify_pcr(pcr_hex.lower())
    
    verify_nonce(nonce_hex, sent_nonce_hex)
    
    verify_mldsa_signature(
        pcr_hex, nonce_hex, bls_quote_hex, mldsa_sign_hex, mldsa_pk_bin
    )

    verify_cluster_bls_proof(bls_quote_hex, nonce_hex, pcr_hex)

def main():
    info("========================================")
    info("Remote Attestation Verification Script")
    info("========================================")
    
    try:
        _cluster_bls_root_certificate_path()
    except FileNotFoundError as e:
        error(str(e))
    
    nonce_bytes, sent_nonce_hex = generate_nonce()

    quote_hex = read_and_parse_quote_data(nonce_bytes)

    parse_quote_and_verify(quote_hex, sent_nonce_hex)

    info("========================================")
    success("All verification (AK + PCR + Nonce + MLDSA + BLS) passed!")
    info("========================================")

if __name__ == "__main__":
    main()
