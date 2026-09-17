#!/usr/bin/env python3
"""L3 key-list lifecycle utility for the cluster-BLS protocol.

It deliberately requires a PoP-bearing registration for every member.  This
keeps unverified public keys out of the L3-signed active list and gives the
verifier the prerequisite needed for same-message FastAggregateVerify.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path
from typing import Any, Iterable, Mapping

from cryptography import x509
from cryptography.hazmat.primitives import serialization
from cryptography.x509.oid import NameOID

from protocol import (
    CIPHERSUITE_ID,
    PROTOCOL_VERSION,
    ProtocolError,
    binding_from_registration,
    build_key_list,
    certificate_binding_from_certificate,
    create_update_notification,
    load_json,
    save_json_atomic,
    sign_key_list,
    verify_key_list,
)


REGISTRATION_WIRE_BYTES = 162


def _path(value: str) -> Path:
    return Path(value).expanduser().resolve()


def _load_certificate(path: Path) -> x509.Certificate:
    try:
        encoded = path.read_bytes()
        if b"-----BEGIN CERTIFICATE-----" in encoded:
            return x509.load_pem_x509_certificate(encoded)
        return x509.load_der_x509_certificate(encoded)
    except (OSError, ValueError) as exc:
        raise ProtocolError(f"cannot load L3 certificate {path}") from exc


def _load_l3_private_key(path: Path, certificate: x509.Certificate) -> Any:
    try:
        private_key = serialization.load_pem_private_key(path.read_bytes(), password=None)
    except (OSError, ValueError, TypeError) as exc:
        raise ProtocolError(f"cannot load L3 private key {path}") from exc
    try:
        private_public = private_key.public_key().public_bytes(
            serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo
        )
        certificate_public = certificate.public_key().public_bytes(
            serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo
        )
    except (AttributeError, ValueError, TypeError) as exc:
        raise ProtocolError("L3 certificate/key use an unsupported public-key format") from exc
    if private_public != certificate_public:
        raise ProtocolError("L3 private key does not match the supplied L3 certificate")
    return private_key


def _load_member_registrations(path: Path) -> list[Mapping[str, Any]]:
    value = load_json(path)
    registrations = value.get("members") if isinstance(value.get("members"), list) else value.get("registrations")
    if not isinstance(registrations, list) or not registrations:
        raise ProtocolError("member file must contain a non-empty members or registrations array")
    if any(not isinstance(registration, Mapping) for registration in registrations):
        raise ProtocolError("each member registration must be an object")
    return list(registrations)


def _members_from_registrations(registrations: Iterable[Mapping[str, Any]]) -> list[dict[str, Any]]:
    members: list[dict[str, Any]] = []
    for registration in registrations:
        binding = binding_from_registration(registration)
        status = registration.get("status", "active")
        if status not in ("active", "revoked"):
            raise ProtocolError("member status must be active or revoked")
        member: dict[str, Any] = {
            "nodeID": registration["nodeID"],
            "keyID": binding.key_id.hex(),
            "blsPublicKey": binding.public_key.hex(),
            "status": status,
        }
        for optional_field in ("level", "parentNodeID"):
            if optional_field in registration:
                member[optional_field] = registration[optional_field]
        members.append(member)
    return members


def _registration_from_wire(
    path: Path, *, node_id: str, level: str, parent_node_id: str
) -> dict[str, Any]:
    try:
        wire = path.read_bytes()
    except OSError as exc:
        raise ProtocolError(f"cannot read BLS registration {path}") from exc
    if (
        len(wire) != REGISTRATION_WIRE_BYTES
        or wire[0] != PROTOCOL_VERSION
        or wire[1] != 1
    ):
        raise ProtocolError(f"{path} is not a version-1 PoP registration")
    registration = {
        "protocolVersion": wire[0],
        "ciphersuiteID": CIPHERSUITE_ID,
        "nodeID": node_id,
        "keyID": wire[2:18].hex(),
        "blsPublicKey": wire[18:66].hex(),
        "proofOfPossession": wire[66:162].hex(),
        "status": "active",
        "level": level,
        "parentNodeID": parent_node_id,
    }
    binding_from_registration(registration)
    return registration


def assemble_members(args: argparse.Namespace) -> None:
    l3_registration = load_json(args.l3_registration)
    binding_from_registration(l3_registration)
    l3_node_id = l3_registration.get("nodeID")
    if not isinstance(l3_node_id, str) or not l3_node_id:
        raise ProtocolError("L3 registration has no nodeID")
    l3_registration = dict(l3_registration)
    l3_registration.update({"status": "active", "level": "L3"})
    l3_registration.pop("parentNodeID", None)
    registrations = [
        l3_registration,
        _registration_from_wire(
            args.l2_registration,
            node_id=args.l2_node_id,
            level="L2",
            parent_node_id=l3_node_id,
        ),
        _registration_from_wire(
            args.l1_registration,
            node_id=args.l1_node_id,
            level="L1",
            parent_node_id=args.l2_node_id,
        ),
    ]
    # Reuse all PoP and hierarchy validation before writing management input.
    build_key_list(args.cluster_id, args.epoch, _members_from_registrations(registrations))
    save_json_atomic(args.output, {"registrations": registrations})
    print(f"Assembled validated L3/L2/L1 registrations in {args.output}")


def _prepare(args: argparse.Namespace) -> tuple[Any, x509.Certificate, list[dict[str, Any]]]:
    certificate = _load_certificate(args.l3_certificate)
    # A local management key is only permitted after its own certificate
    # binding/PoP has passed; the verifier independently validates its chain.
    certificate_binding = certificate_binding_from_certificate(certificate)
    private_key = _load_l3_private_key(args.l3_private_key, certificate)
    members = _members_from_registrations(_load_member_registrations(args.members))
    common_names = certificate.subject.get_attributes_for_oid(NameOID.COMMON_NAME)
    l3_members = [member for member in members if member.get("level") == "L3"]
    if (
        len(common_names) != 1
        or len(l3_members) != 1
        or l3_members[0]["nodeID"] != common_names[0].value
        or l3_members[0]["keyID"] != certificate_binding.key_id.hex()
        or l3_members[0]["blsPublicKey"] != certificate_binding.public_key.hex()
    ):
        raise ProtocolError("L3 certificate binding does not match the L3 member registration")
    return private_key, certificate, members


def sign_list(args: argparse.Namespace) -> None:
    private_key, _, members = _prepare(args)
    key_list = sign_key_list(build_key_list(args.cluster_id, args.epoch, members), private_key)
    save_json_atomic(args.output, key_list)
    print(f"Signed L3 BLS key list: cluster={key_list['clusterID']} epoch={key_list['epoch']}")


def update_list(args: argparse.Namespace) -> None:
    private_key, certificate, members = _prepare(args)
    previous = load_json(args.previous)
    verify_key_list(previous, certificate)
    next_list = build_key_list(str(previous["clusterID"]), int(previous["epoch"]) + 1, members)
    signed_next = sign_key_list(next_list, private_key)
    notification = create_update_notification(previous, signed_next, private_key)
    save_json_atomic(args.output, signed_next)
    save_json_atomic(args.update_output, notification)
    print(f"Signed L3 BLS update: cluster={signed_next['clusterID']} epoch={signed_next['epoch']}")


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)

    assemble_parser = commands.add_parser(
        "assemble", help="assemble captured L3 JSON and L2/L1 wire registrations"
    )
    assemble_parser.add_argument("--l3-registration", type=_path, required=True)
    assemble_parser.add_argument("--l2-registration", type=_path, required=True)
    assemble_parser.add_argument("--l1-registration", type=_path, required=True)
    assemble_parser.add_argument("--l2-node-id", default="L2-001")
    assemble_parser.add_argument("--l1-node-id", default="L1-001")
    assemble_parser.add_argument("--cluster-id", required=True)
    assemble_parser.add_argument("--epoch", type=int, required=True)
    assemble_parser.add_argument("--output", type=_path, required=True)
    assemble_parser.set_defaults(handler=assemble_members)

    def common(command: argparse.ArgumentParser) -> None:
        command.add_argument("--l3-certificate", type=_path, required=True)
        command.add_argument("--l3-private-key", type=_path, required=True)
        command.add_argument(
            "--members", type=_path, required=True,
            help="JSON object containing a members/registrations array of PoP-bearing registrations",
        )

    sign_parser = commands.add_parser("sign", help="validate registrations and sign a complete list")
    common(sign_parser)
    sign_parser.add_argument("--cluster-id", required=True)
    sign_parser.add_argument("--epoch", type=int, required=True)
    sign_parser.add_argument("--output", type=_path, required=True)
    sign_parser.set_defaults(handler=sign_list)

    update_parser = commands.add_parser("update", help="produce the next signed list and epoch notification")
    common(update_parser)
    update_parser.add_argument("--previous", type=_path, required=True)
    update_parser.add_argument("--output", type=_path, required=True)
    update_parser.add_argument("--update-output", type=_path, required=True)
    update_parser.set_defaults(handler=update_list)
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

