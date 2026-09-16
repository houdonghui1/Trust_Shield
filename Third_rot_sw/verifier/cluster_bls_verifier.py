#!/usr/bin/env python3
"""Build and update the verified cache used by the online BLS quote verifier."""

from __future__ import annotations

import argparse
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from cryptography import x509
from cryptography.exceptions import InvalidSignature
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec, ed25519, ed448, rsa
from cryptography.x509.oid import ExtensionOID, NameOID


SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from protocol import (  # noqa: E402
    DIGEST_BYTES,
    NONCE_BYTES,
    ProtocolError,
    apply_update_notification,
    certificate_binding_from_certificate,
    load_json,
    save_json_atomic,
    validate_key_list,
    verify_aggregate_response,
    verify_key_list,
)


def _path(value: str) -> Path:
    return Path(value).expanduser().resolve()


def _load_certificate(path: Path) -> x509.Certificate:
    try:
        data = path.read_bytes()
        if b"-----BEGIN CERTIFICATE-----" in data:
            return x509.load_pem_x509_certificate(data)
        return x509.load_der_x509_certificate(data)
    except (OSError, ValueError) as exc:
        raise ProtocolError(f"cannot load certificate {path}") from exc


def _certificate_fingerprint(certificate: x509.Certificate) -> str:
    return certificate.fingerprint(hashes.SHA256()).hex()


def _certificate_time(certificate: x509.Certificate, field: str) -> datetime:
    utc_field = f"{field}_utc"
    value = getattr(certificate, utc_field, None)
    if value is not None:
        return value
    legacy = getattr(certificate, field)
    return legacy.replace(tzinfo=timezone.utc)


def _require_certificate_role(
    certificate: x509.Certificate, *, label: str, ca: bool
) -> None:
    try:
        constraints = certificate.extensions.get_extension_for_oid(
            ExtensionOID.BASIC_CONSTRAINTS
        ).value
        key_usage = certificate.extensions.get_extension_for_oid(
            ExtensionOID.KEY_USAGE
        ).value
    except x509.ExtensionNotFound as exc:
        raise ProtocolError(f"{label} certificate lacks required CA/key-usage constraints") from exc
    if constraints.ca != ca:
        expected = "CA" if ca else "leaf"
        raise ProtocolError(f"{label} certificate is not marked as a {expected} certificate")
    if ca and not key_usage.key_cert_sign:
        raise ProtocolError(f"{label} certificate is not authorized to sign certificates")
    if not ca and not key_usage.digital_signature:
        raise ProtocolError(f"{label} certificate is not authorized for digital signatures")


def _verify_certificate_issued_by(
    certificate: x509.Certificate,
    issuer: x509.Certificate,
    *,
    label: str,
) -> None:
    if certificate.issuer != issuer.subject:
        raise ProtocolError(f"{label} certificate issuer does not match its configured parent")
    now = datetime.now(timezone.utc)
    if not (_certificate_time(certificate, "not_valid_before") <= now <= _certificate_time(certificate, "not_valid_after")):
        raise ProtocolError(f"{label} certificate is outside its validity period")
    public_key = issuer.public_key()
    try:
        if isinstance(public_key, ec.EllipticCurvePublicKey):
            public_key.verify(certificate.signature, certificate.tbs_certificate_bytes, ec.ECDSA(certificate.signature_hash_algorithm))
        elif isinstance(public_key, rsa.RSAPublicKey):
            from cryptography.hazmat.primitives.asymmetric import padding

            public_key.verify(certificate.signature, certificate.tbs_certificate_bytes, padding.PKCS1v15(), certificate.signature_hash_algorithm)
        elif isinstance(public_key, (ed25519.Ed25519PublicKey, ed448.Ed448PublicKey)):
            public_key.verify(certificate.signature, certificate.tbs_certificate_bytes)
        else:
            raise ProtocolError(f"unsupported issuer key type for {label} certificate")
    except InvalidSignature as exc:
        raise ProtocolError(f"{label} certificate signature did not validate") from exc


def _verify_l3_identity(l3_certificate: x509.Certificate, ca_certificate: x509.Certificate) -> None:
    _require_certificate_role(ca_certificate, label="trusted third party", ca=True)
    _require_certificate_role(l3_certificate, label="L3", ca=True)
    _verify_certificate_issued_by(
        l3_certificate, ca_certificate, label="L3"
    )
    # This validates the non-critical extension and its PoP before this L3
    # identity is allowed to authorize a list or epoch update.
    certificate_binding_from_certificate(l3_certificate)


def _certificate_node_id(certificate: x509.Certificate, label: str) -> str:
    values = certificate.subject.get_attributes_for_oid(NameOID.COMMON_NAME)
    if len(values) != 1 or not values[0].value:
        raise ProtocolError(f"{label} certificate must contain exactly one common-name nodeID")
    return values[0].value


def _verify_certificate_member_binding(
    certificate: x509.Certificate,
    key_list: dict[str, Any],
    *,
    level: str,
    parent_node_id: str | None,
) -> str:
    node_id = _certificate_node_id(certificate, level)
    binding = certificate_binding_from_certificate(certificate)
    members = [member for member in key_list["members"] if member["nodeID"] == node_id]
    if len(members) != 1:
        raise ProtocolError(f"{level} certificate nodeID is not unique in the current key list")
    member = members[0]
    if member["status"] != "active":
        raise ProtocolError(f"{level} certificate is bound to a revoked member")
    if member.get("level") != level or member.get("parentNodeID") != parent_node_id:
        raise ProtocolError(f"{level} member hierarchy does not match the certificate chain")
    if (
        member["keyID"] != binding.key_id.hex()
        or member["blsPublicKey"] != binding.public_key.hex()
    ):
        raise ProtocolError(f"{level} certificate BLS binding does not match the current key list")
    return node_id


def _verify_full_chain_and_membership(
    ca_certificate: x509.Certificate,
    l3_certificate: x509.Certificate,
    l2_certificate: x509.Certificate,
    l1_certificate: x509.Certificate,
    key_list: dict[str, Any],
) -> None:
    _verify_l3_identity(l3_certificate, ca_certificate)
    _require_certificate_role(l2_certificate, label="L2", ca=True)
    _require_certificate_role(l1_certificate, label="L1", ca=False)
    _verify_certificate_issued_by(l2_certificate, l3_certificate, label="L2")
    _verify_certificate_issued_by(l1_certificate, l2_certificate, label="L1")
    l3_node_id = _verify_certificate_member_binding(
        l3_certificate, key_list, level="L3", parent_node_id=None
    )
    l2_node_id = _verify_certificate_member_binding(
        l2_certificate, key_list, level="L2", parent_node_id=l3_node_id
    )
    _verify_certificate_member_binding(
        l1_certificate, key_list, level="L1", parent_node_id=l2_node_id
    )


def _cache_object(
    ca_certificate: x509.Certificate,
    l3_certificate: x509.Certificate,
    l2_certificate: x509.Certificate,
    l1_certificate: x509.Certificate,
    key_list: dict[str, Any],
) -> dict[str, Any]:
    return {
        "cacheFormat": 2,
        "trustedThirdPartyFingerprint": _certificate_fingerprint(ca_certificate),
        "l3CertificateFingerprint": _certificate_fingerprint(l3_certificate),
        "l2CertificateFingerprint": _certificate_fingerprint(l2_certificate),
        "l1CertificateFingerprint": _certificate_fingerprint(l1_certificate),
        "keyList": key_list,
    }


def _load_cache(path: Path) -> dict[str, Any]:
    cache = load_json(path)
    if cache.get("cacheFormat") != 2 or not isinstance(cache.get("keyList"), dict):
        raise ProtocolError("BLS verifier cache has an unsupported format")
    validate_key_list(cache["keyList"])
    return cache


def bootstrap(args: argparse.Namespace) -> None:
    ca_certificate = _load_certificate(args.ca_certificate)
    l3_certificate = _load_certificate(args.l3_certificate)
    l2_certificate = _load_certificate(args.l2_certificate)
    l1_certificate = _load_certificate(args.l1_certificate)
    key_list = load_json(args.key_list)
    verify_key_list(key_list, l3_certificate)
    _verify_full_chain_and_membership(
        ca_certificate, l3_certificate, l2_certificate, l1_certificate, key_list
    )
    save_json_atomic(
        args.cache,
        _cache_object(
            ca_certificate, l3_certificate, l2_certificate, l1_certificate, key_list
        ),
    )
    print(f"Cached verified BLS key list: cluster={key_list['clusterID']} epoch={key_list['epoch']}")


def apply_update(args: argparse.Namespace) -> None:
    cache = _load_cache(args.cache)
    ca_certificate = _load_certificate(args.ca_certificate)
    l3_certificate = _load_certificate(args.l3_certificate)
    _verify_l3_identity(l3_certificate, ca_certificate)
    if cache["trustedThirdPartyFingerprint"] != _certificate_fingerprint(ca_certificate):
        raise ProtocolError("cache trust anchor does not match the supplied trusted-third-party certificate")
    if cache["l3CertificateFingerprint"] != _certificate_fingerprint(l3_certificate):
        raise ProtocolError("epoch update is signed by an unexpected L3 certificate")
    notification = load_json(args.update)
    next_key_list = apply_update_notification(cache["keyList"], notification, l3_certificate)
    _verify_certificate_member_binding(
        l3_certificate, next_key_list, level="L3", parent_node_id=None
    )
    cache["keyList"] = next_key_list
    cache["lastAcceptedUpdate"] = notification
    save_json_atomic(args.cache, cache)
    print(f"Applied verified BLS update: cluster={next_key_list['clusterID']} epoch={next_key_list['epoch']}")


def verify_response(args: argparse.Namespace) -> None:
    cache = _load_cache(args.cache)
    try:
        nonce = bytes.fromhex(args.nonce)
        measurement_digest = bytes.fromhex(args.measurement_digest)
    except ValueError as exc:
        raise ProtocolError("nonce and measurement digest must be hexadecimal") from exc
    if len(nonce) != NONCE_BYTES or len(measurement_digest) != DIGEST_BYTES:
        raise ProtocolError("nonce and measurement digest must both be 32 bytes")
    response = load_json(args.response)
    if not verify_aggregate_response(
        cache["keyList"], response, nonce, measurement_digest, require_all_active=not args.allow_partial
    ):
        raise ProtocolError("BLS aggregate proof did not verify for the current cached list")
    print(
        "BLS aggregate proof verified: "
        f"cluster={response['clusterID']} epoch={response['epoch']} participants={len(response['participantNodeIDs'])}"
    )


def verify_certificate_binding(args: argparse.Namespace) -> None:
    certificate = _load_certificate(args.certificate)
    binding = certificate_binding_from_certificate(certificate)
    print(
        "BLS certificate binding verified: "
        f"keyID={binding.key_id.hex()} suite={binding.ciphersuite_id} version={binding.protocol_version}"
    )


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)

    bootstrap_parser = commands.add_parser("bootstrap", help="verify an L3-signed key list and cache it")
    bootstrap_parser.add_argument("--ca-certificate", type=_path, required=True)
    bootstrap_parser.add_argument("--l3-certificate", type=_path, required=True)
    bootstrap_parser.add_argument("--l2-certificate", type=_path, required=True)
    bootstrap_parser.add_argument("--l1-certificate", type=_path, required=True)
    bootstrap_parser.add_argument("--key-list", type=_path, required=True)
    bootstrap_parser.add_argument("--cache", type=_path, required=True)
    bootstrap_parser.set_defaults(handler=bootstrap)

    update_parser = commands.add_parser("apply-update", help="verify and atomically apply one epoch transition")
    update_parser.add_argument("--ca-certificate", type=_path, required=True)
    update_parser.add_argument("--l3-certificate", type=_path, required=True)
    update_parser.add_argument("--update", type=_path, required=True)
    update_parser.add_argument("--cache", type=_path, required=True)
    update_parser.set_defaults(handler=apply_update)

    verify_parser = commands.add_parser("verify", help="verify one current-epoch aggregate proof")
    verify_parser.add_argument("--cache", type=_path, required=True)
    verify_parser.add_argument("--response", type=_path, required=True)
    verify_parser.add_argument("--nonce", required=True, help="32-byte challenge nonce in hexadecimal")
    verify_parser.add_argument("--measurement-digest", required=True, help="32-byte measurement digest in hexadecimal")
    verify_parser.add_argument("--allow-partial", action="store_true", help="accept the explicit participant subset")
    verify_parser.set_defaults(handler=verify_response)

    certificate_parser = commands.add_parser("verify-certificate", help="validate an X.509 BLS binding and PoP")
    certificate_parser.add_argument("--certificate", type=_path, required=True)
    certificate_parser.set_defaults(handler=verify_certificate_binding)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    try:
        args.handler(args)
    except ProtocolError as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
