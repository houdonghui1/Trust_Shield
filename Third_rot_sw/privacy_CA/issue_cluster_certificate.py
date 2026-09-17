#!/usr/bin/env python3
"""Issue an L3 certificate with the non-critical cluster-BLS binding.

The existing CA workflow uses the EK certificate and AK public-key whitelist
as its device-identity gate.  This tool deliberately performs the additional
cryptographic gate required by the cluster scheme: it refuses a registration
whose BLS public key, key ID, or proof of possession is invalid before adding
the binding to the X.509 certificate.
"""

from __future__ import annotations

import argparse
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path

from cryptography import x509
from cryptography.exceptions import UnsupportedAlgorithm
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec


SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from protocol import (  # noqa: E402
    CERT_BINDING_OID,
    BlsCertificateBinding,
    ProtocolError,
    binding_from_registration,
    certificate_binding_from_certificate,
    encode_certificate_binding,
    load_json,
)


MLDSA_PUBLIC_KEY_OID = x509.ObjectIdentifier("1.3.6.1.4.1.311.21.99")
MLDSA87_PUBLIC_KEY_BYTES = 2592


def _path(value: str) -> Path:
    return Path(value).expanduser().resolve()


def _read_required_file(path: Path, label: str) -> bytes:
    try:
        data = path.read_bytes()
    except OSError as exc:
        raise ProtocolError(f"cannot read {label} {path}: {exc}") from exc
    if not data:
        raise ProtocolError(f"{label} is empty: {path}")
    return data


def _load_ca_private_key(path: Path) -> ec.EllipticCurvePrivateKey:
    data = _read_required_file(path, "CA private key")
    backend = default_backend()
    try:
        if data.lstrip().startswith(b"-----BEGIN"):
            key = serialization.load_pem_private_key(
                data, password=None, backend=backend
            )
        else:
            key = serialization.load_der_private_key(
                data, password=None, backend=backend
            )
    except (ValueError, TypeError, UnsupportedAlgorithm) as exc:
        raise ProtocolError(
            f"cannot load CA private key {path}: {type(exc).__name__}: {exc}"
        ) from exc
    if not isinstance(key, ec.EllipticCurvePrivateKey):
        raise ProtocolError(f"CA private key is not an EC key: {path}")
    return key


def _load_ca_certificate(path: Path) -> x509.Certificate:
    data = _read_required_file(path, "CA certificate")
    backend = default_backend()
    try:
        if data.lstrip().startswith(b"-----BEGIN"):
            certificate = x509.load_pem_x509_certificate(data, backend)
        else:
            certificate = x509.load_der_x509_certificate(data, backend)
    except (ValueError, UnsupportedAlgorithm) as exc:
        raise ProtocolError(
            f"cannot load CA certificate {path}: {type(exc).__name__}: {exc}"
        ) from exc
    return certificate


def _load_ak_public_key(path: Path) -> ec.EllipticCurvePublicKey:
    data = _read_required_file(path, "L3 certificate-signing public key")
    backend = default_backend()
    try:
        if data.lstrip().startswith(b"-----BEGIN"):
            key = serialization.load_pem_public_key(data, backend=backend)
        else:
            key = serialization.load_der_public_key(data, backend=backend)
    except (ValueError, TypeError, UnsupportedAlgorithm) as exc:
        raise ProtocolError(
            "cannot load L3 certificate-signing public key "
            f"{path}: {type(exc).__name__}: {exc}"
        ) from exc
    if not isinstance(key, ec.EllipticCurvePublicKey):
        raise ProtocolError(f"L3 certificate-signing key is not an EC public key: {path}")
    return key


def _read_registration(path: Path) -> tuple[str, BlsCertificateBinding]:
    registration = load_json(path)
    binding = binding_from_registration(registration)
    # The node ID is authenticated by the issuing workflow and becomes the
    # certificate subject.  Do not attach a valid PoP for one device to a
    # certificate named for another device.
    node_id = registration.get("nodeID")
    if not isinstance(node_id, str) or not node_id:
        raise ProtocolError("registration does not contain nodeID")
    return node_id, binding


def _read_mldsa_public_key(path: Path) -> bytes:
    try:
        value = "".join(path.read_text(encoding="ascii").split())
        public_key = bytes.fromhex(value)
    except (OSError, UnicodeError, ValueError) as exc:
        raise ProtocolError(f"cannot read ML-DSA public key from {path}") from exc
    if len(public_key) != MLDSA87_PUBLIC_KEY_BYTES:
        raise ProtocolError(
            f"ML-DSA public key must be {MLDSA87_PUBLIC_KEY_BYTES} bytes, got {len(public_key)}"
        )
    return public_key


def _subject(args: argparse.Namespace) -> x509.Name:
    # Caliptra's compact certificate encoder represents issuer/subject as a
    # single CN.  Keeping the L3 subject in the same canonical form makes the
    # L2 issuer DN byte-for-byte equivalent instead of merely sharing a CN.
    return x509.Name(
        [x509.NameAttribute(x509.NameOID.COMMON_NAME, args.common_name)]
    )


def issue_certificate(args: argparse.Namespace) -> None:
    node_id, binding = _read_registration(args.registration)
    if args.common_name is None:
        args.common_name = node_id
    elif args.common_name != node_id:
        raise ProtocolError("certificate common name must match registration nodeID")
    ca_private_key = _load_ca_private_key(args.ca_key)
    ca_certificate = _load_ca_certificate(args.ca_cert)
    ak_public_key = _load_ak_public_key(args.ak_public_key)

    ca_certificate_key = ca_certificate.public_key()
    if not isinstance(ca_certificate_key, ec.EllipticCurvePublicKey):
        raise ProtocolError("CA certificate does not contain an EC public key")
    if ca_certificate_key.public_numbers() != ca_private_key.public_key().public_numbers():
        raise ProtocolError("CA private key does not match the CA certificate")
    try:
        ca_constraints = ca_certificate.extensions.get_extension_for_class(
            x509.BasicConstraints
        ).value
    except x509.ExtensionNotFound as exc:
        raise ProtocolError("CA certificate has no BasicConstraints extension") from exc
    if not ca_constraints.ca:
        raise ProtocolError("CA certificate BasicConstraints does not permit CA signing")

    if not isinstance(ak_public_key.curve, ec.SECP384R1):
        raise ProtocolError("L3 certificate-signing key must be P-384")

    print(
        "Loaded certificate inputs: "
        f"CA-key={ca_private_key.curve.name} "
        f"CA-cert={ca_certificate_key.curve.name} "
        f"L3-key={ak_public_key.curve.name}"
    )

    mldsa_public_key = _read_mldsa_public_key(args.mldsa_public_key)
    # datetime.UTC was added in Python 3.11. The deployed Privacy_CA uses
    # Python 3.9, where timezone.utc is the equivalent portable spelling.
    now = datetime.now(timezone.utc)
    certificate = (
        x509.CertificateBuilder()
        .subject_name(_subject(args))
        .issuer_name(ca_certificate.subject)
        .public_key(ak_public_key)
        .serial_number(x509.random_serial_number())
        .not_valid_before(now - timedelta(minutes=1))
        .not_valid_after(now + timedelta(days=args.valid_days))
        .add_extension(x509.BasicConstraints(ca=True, path_length=1), critical=True)
        .add_extension(
            x509.KeyUsage(
                digital_signature=True,
                content_commitment=False,
                key_encipherment=False,
                data_encipherment=False,
                key_agreement=False,
                key_cert_sign=True,
                crl_sign=True,
                encipher_only=False,
                decipher_only=False,
            ),
            critical=True,
        )
        .add_extension(x509.UnrecognizedExtension(MLDSA_PUBLIC_KEY_OID, mldsa_public_key), critical=False)
        .add_extension(
            x509.UnrecognizedExtension(CERT_BINDING_OID, encode_certificate_binding(binding)),
            critical=False,
        )
        .sign(ca_private_key, hashes.SHA384(), default_backend())
    )
    args.output.write_bytes(certificate.public_bytes(serialization.Encoding.PEM))
    print(
        "Issued L3 certificate with validated cluster-BLS binding: "
        f"keyID={binding.key_id.hex()} publicKey={binding.public_key.hex()[:24]}..."
    )


def verify_certificate(args: argparse.Namespace) -> None:
    certificate_path = args.verify_certificate
    try:
        certificate = x509.load_pem_x509_certificate(
            certificate_path.read_bytes(), default_backend()
        )
    except (OSError, ValueError, TypeError, UnsupportedAlgorithm) as exc:
        raise ProtocolError(
            f"cannot load certificate {certificate_path}: "
            f"{type(exc).__name__}: {exc}"
        ) from exc
    binding = certificate_binding_from_certificate(certificate)
    print(
        "Certificate BLS binding is valid: "
        f"version={binding.protocol_version} suite={binding.ciphersuite_id} keyID={binding.key_id.hex()}"
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--registration", type=_path, default=SCRIPT_DIR / "bls_registration.json")
    parser.add_argument("--binding-der", action="store_true", help="validate registration and print DER extension bytes")
    parser.add_argument("--verify-certificate", type=_path, metavar="CERT", help="validate the BLS extension in CERT")
    parser.add_argument("--ca-key", type=_path, default=SCRIPT_DIR / "ca" / "ca_root.key")
    parser.add_argument("--ca-cert", type=_path, default=SCRIPT_DIR / "ca" / "ca_root.crt")
    parser.add_argument("--ak-public-key", type=_path, default=SCRIPT_DIR / "ak_pub.pem")
    parser.add_argument("--mldsa-public-key", type=_path, default=SCRIPT_DIR / "mldsa_ak_hex.txt")
    parser.add_argument("--output", type=_path, default=SCRIPT_DIR / "ak_cert.pem")
    parser.add_argument("--valid-days", type=int, default=365)
    parser.add_argument("--country", default="CN")
    parser.add_argument("--state", default="BJ")
    parser.add_argument("--locality", default="BJ")
    parser.add_argument("--organization", default="TestDevice")
    parser.add_argument("--organizational-unit", default="TPM-AK")
    parser.add_argument(
        "--common-name",
        help="must match registration nodeID; omitted means use registration nodeID",
    )
    args = parser.parse_args()
    if args.valid_days <= 0:
        parser.error("--valid-days must be positive")
    return args


def main() -> int:
    args = parse_args()
    try:
        if args.verify_certificate is not None:
            verify_certificate(args)
        elif args.binding_der:
            _, binding = _read_registration(args.registration)
            print(encode_certificate_binding(binding).hex())
        else:
            issue_certificate(args)
    except ProtocolError as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
