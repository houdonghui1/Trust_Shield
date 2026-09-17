from __future__ import annotations

import ctypes
import hashlib
import re
import time
from pathlib import Path
from typing import Optional

from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec, ed25519, rsa, padding


QUOTE_START = b"#QUOTE#"
QUOTE_END = b"#END#"
QUOTE_BLOCK_BYTES = 138
MLDSA_SIGNATURE_BYTES = 4627
MLDSA_PUBLIC_KEY_BYTES = 2592
MLDSA_PUBLIC_KEY_OID = x509.ObjectIdentifier("1.3.6.1.4.1.311.21.99")


def load_expected_measurement(path: Path) -> bytes:
    try:
        encoded = re.sub(r"[^0-9a-fA-F]", "", path.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ValueError(f"cannot read expected PCR file: {path}") from exc
    if len(encoded) != 64:
        raise ValueError(
            f"expected PCR file must contain exactly 32 bytes: {path}"
        )
    return bytes.fromhex(encoded)


def read_exact(port, length: int, timeout: float) -> bytes:
    data = bytearray()
    deadline = time.monotonic() + timeout if timeout else None
    while len(data) < length:
        chunk = port.read(length - len(data))
        if chunk:
            data.extend(chunk)
            if timeout:
                deadline = time.monotonic() + timeout
        elif deadline is not None and time.monotonic() >= deadline:
            raise TimeoutError(f"received {len(data)}/{length} bytes")
    return bytes(data)


def wait_ready(port, timeout: float) -> None:
    deadline = time.monotonic() + timeout if timeout else None
    while True:
        if port.read(1) == b"\xa5":
            return
        if deadline is not None and time.monotonic() >= deadline:
            raise TimeoutError("L3 did not send ready byte 0xa5")


def write_all(port, data: bytes) -> None:
    offset = 0
    while offset < len(data):
        written = port.write(data[offset:])
        if written is None or written <= 0:
            raise IOError("incomplete verifier challenge write")
        offset += written
    port.flush()


def read_quote(port, timeout: float) -> bytes:
    data = bytearray()
    deadline = time.monotonic() + timeout if timeout else None
    while True:
        chunk = port.read(1)
        if chunk:
            data.extend(chunk)
            if timeout:
                deadline = time.monotonic() + timeout
            start = data.find(QUOTE_START)
            if start >= 0:
                end = data.find(QUOTE_END, start + len(QUOTE_START))
                if end >= 0:
                    return bytes(data[start:end + len(QUOTE_END)])
            elif len(data) > len(QUOTE_START):
                del data[0]
        elif deadline is not None and time.monotonic() >= deadline:
            raise TimeoutError("L3 did not return a complete Quote")


def load_certificate(encoded: bytes) -> x509.Certificate:
    if b"-----BEGIN CERTIFICATE-----" in encoded:
        try:
            return x509.load_pem_x509_certificate(encoded)
        except TypeError:
            return x509.load_pem_x509_certificate(encoded, default_backend())
    try:
        return x509.load_der_x509_certificate(encoded)
    except TypeError:
        return x509.load_der_x509_certificate(encoded, default_backend())


def verify_certificate_signature(certificate: x509.Certificate,
                                 issuer: x509.Certificate) -> None:
    if certificate.issuer != issuer.subject:
        raise ValueError("certificate issuer/subject mismatch")
    key = issuer.public_key()
    if isinstance(key, ec.EllipticCurvePublicKey):
        key.verify(certificate.signature, certificate.tbs_certificate_bytes,
                   ec.ECDSA(certificate.signature_hash_algorithm))
    elif isinstance(key, rsa.RSAPublicKey):
        key.verify(certificate.signature, certificate.tbs_certificate_bytes,
                   padding.PKCS1v15(), certificate.signature_hash_algorithm)
    elif isinstance(key, ed25519.Ed25519PublicKey):
        key.verify(certificate.signature, certificate.tbs_certificate_bytes)
    else:
        raise ValueError("unsupported certificate issuer key")


def _unwrap_octet_string(encoded: bytes) -> bytes:
    value = encoded
    for _ in range(3):
        if len(value) == MLDSA_PUBLIC_KEY_BYTES:
            return value
        if not value or value[0] != 4 or len(value) < 2:
            break
        first = value[1]
        if first < 128:
            header = 2
            length = first
        else:
            count = first & 0x7f
            if count == 0 or count > 4 or len(value) < 2 + count:
                break
            header = 2 + count
            length = int.from_bytes(value[2:header], "big")
        if header + length != len(value):
            break
        value = value[header:]
    if len(value) in (MLDSA_PUBLIC_KEY_BYTES * 2,
                      MLDSA_PUBLIC_KEY_BYTES * 2 + 4):
        try:
            decoded = bytes.fromhex(value.decode("ascii").strip())
            if len(decoded) == MLDSA_PUBLIC_KEY_BYTES:
                return decoded
        except (UnicodeDecodeError, ValueError):
            pass
    raise ValueError(f"invalid ML-DSA public key length: {len(value)}")


def extract_mldsa_public_key(certificate: x509.Certificate) -> bytes:
    extension = certificate.extensions.get_extension_for_oid(
        MLDSA_PUBLIC_KEY_OID
    )
    value = extension.value
    encoded = value.value if hasattr(value, "value") else bytes(value)
    return _unwrap_octet_string(encoded)


def verify_mldsa(signature: bytes, message: bytes, public_key: bytes,
                  library_path: Path) -> None:
    library = ctypes.CDLL(str(library_path))
    library.mldsa_verify_wrapper.argtypes = [
        ctypes.POINTER(ctypes.c_uint8), ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_uint8), ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_uint8), ctypes.c_size_t,
    ]
    library.mldsa_verify_wrapper.restype = ctypes.c_int
    signature_array = (ctypes.c_uint8 * len(signature)).from_buffer_copy(signature)
    message_array = (ctypes.c_uint8 * len(message)).from_buffer_copy(message)
    key_array = (ctypes.c_uint8 * len(public_key)).from_buffer_copy(public_key)
    result = library.mldsa_verify_wrapper(
        signature_array, len(signature), message_array, len(message),
        key_array, len(public_key)
    )
    if result != 0:
        raise ValueError(f"ML-DSA Quote signature verification failed: {result}")


def parse_quote(frame: bytes) -> dict:
    if not frame.startswith(QUOTE_START) or not frame.endswith(QUOTE_END):
        raise ValueError("invalid Quote frame")
    encoded = frame[len(QUOTE_START):-len(QUOTE_END)]
    try:
        cert_hex_length = int(encoded[:4], 16)
    except ValueError as exc:
        raise ValueError("invalid Quote certificate length") from exc
    expected = (4 + cert_hex_length + 64 + 64 +
                QUOTE_BLOCK_BYTES * 2 + MLDSA_SIGNATURE_BYTES * 2)
    if len(encoded) != expected:
        raise ValueError(
            f"invalid Quote length: received {len(encoded)}, expected {expected}"
        )
    offset = 4
    fields = {}
    fields["certificate"] = bytes.fromhex(
        encoded[offset:offset + cert_hex_length].decode("ascii")
    )
    offset += cert_hex_length
    fields["measurement"] = bytes.fromhex(encoded[offset:offset + 64].decode("ascii"))
    offset += 64
    fields["nonce"] = bytes.fromhex(encoded[offset:offset + 64].decode("ascii"))
    offset += 64
    fields["block"] = bytes.fromhex(
        encoded[offset:offset + QUOTE_BLOCK_BYTES * 2].decode("ascii")
    )
    offset += QUOTE_BLOCK_BYTES * 2
    fields["signature"] = bytes.fromhex(encoded[offset:].decode("ascii"))
    return fields


def verify_quote(frame: bytes, nonce: bytes, root_path: Path,
                 expected_mode: bytes, chains: int,
                 expected_members: int,
                 expected_measurement: Optional[bytes] = None,
                 expected_proof: Optional[bytes] = None,
                 expected_digest: Optional[bytes] = None) -> dict:
    fields = parse_quote(frame)
    if fields["nonce"] != nonce:
        raise ValueError("Quote nonce does not match the challenge")
    if expected_measurement is not None and fields["measurement"] != expected_measurement:
        raise ValueError(
            "PCR verification failed: "
            f"expected={expected_measurement.hex()}, "
            f"Quote={fields['measurement'].hex()}"
        )
    block = fields["block"]
    if (block[0] != 0xaa or block[1:5] != expected_mode or
            int.from_bytes(block[5:9], "big") != chains or
            int.from_bytes(block[9:13], "big") != expected_members):
        raise ValueError("Quote scale metadata does not match the request")
    if expected_digest is not None and block[13:41] != expected_digest[:28]:
        raise ValueError("Quote challenge digest does not match")
    if expected_proof is None:
        if any(block[42:]):
            raise ValueError("ECDSA Quote unexpectedly contains a BLS proof")
    elif block[42:] != expected_proof:
        raise ValueError("Quote BLS proof does not match the aggregate result")
    root = load_certificate(root_path.read_bytes())
    certificate = load_certificate(fields["certificate"])
    certificate_verify_started = time.perf_counter_ns()
    verify_certificate_signature(certificate, root)
    fields["certificateVerificationMs"] = (
        time.perf_counter_ns() - certificate_verify_started
    ) / 1e6
    public_key = extract_mldsa_public_key(certificate)
    digest = hashlib.sha256(
        fields["measurement"] + fields["nonce"] + block
    ).digest()
    verify_mldsa(
        fields["signature"], digest, public_key,
        Path(__file__).resolve().with_name("libmldsa_verify.so")
    )
    fields["certificateObject"] = certificate
    return fields
