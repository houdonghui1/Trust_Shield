"""Wire-format and cryptographic helpers for cluster BLS attestation.

This module is intentionally shared by Privacy_CA and the verifier.  It
implements the protocol in the design document rather than treating a BLS
signature as an opaque add-on to the existing ML-DSA quote:

* certificates bind a BLS public key and proof of possession (PoP);
* the L3-signed key list is versioned by ``clusterID`` and ``epoch``;
* all online participants sign one canonical challenge digest; and
* verifier-side validation reconstructs the aggregate public key from the
  accepted participant set.

The checked-in ``bls-signatures/python-impl`` reference implementation is
used so that the enrollment and verifier utilities work without fetching a
package from the network.  It is appropriate for the software test flow; a
production verifier should install the audited ``blspy`` binding and retain
the exact byte-level vectors in ``tests``.
"""

from __future__ import annotations

import base64
import hashlib
import hmac
import json
import os
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable, Mapping, Sequence

from cryptography import x509
from cryptography.exceptions import InvalidSignature
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec


PROTOCOL_VERSION = 1
CIPHERSUITE_ID = "BLS12381G2_XMD:SHA-256_SSWU_RO_POP_"
CERT_BINDING_OID = x509.ObjectIdentifier("1.3.6.1.4.1.55555.1.1")
LIST_SIGNATURE_ALGORITHM = "ECDSA-SHA384"

PUBLIC_KEY_BYTES = 48
SIGNATURE_BYTES = 96
POP_BYTES = 96
KEY_ID_BYTES = 16
NONCE_BYTES = 32
DIGEST_BYTES = 32

_CHALLENGE_DOMAIN = b"CLUSTER-BLS-ATTEST-v1\x00"
_LIST_SIGNATURE_FIELD = "listSignature"
QUOTE_REQUEST_MAGIC = b"BLQ1"
_NODE_ID_RE = re.compile(r"[A-Za-z0-9._-]{1,128}\Z")


class ProtocolError(ValueError):
    """Raised when an untrusted protocol object violates the contract."""


def _load_bls_reference() -> tuple[Any, Any, Any, Any, Any, Any]:
    """Load the repository-local, dependency-free BLS reference code.

    The codebase keeps ``bls-signatures`` beside ``多级可信根软件源码260720``.
    ``BLS_PYTHON_IMPL`` is provided for deployment layouts that keep it
    elsewhere.  Importing it only changes this process' module search path.
    """

    candidates: list[Path] = []
    configured = os.environ.get("BLS_PYTHON_IMPL")
    if configured:
        candidates.append(Path(configured))

    # The development tree keeps ``bls-signatures`` near the multi-root
    # sources, while Privacy_CA is commonly deployed as a standalone folder
    # under ``/home/<user>/work``.  Search every ancestor so both layouts work
    # without relying on a hard-coded parent depth.
    module_path = Path(__file__).resolve()
    for ancestor in module_path.parents:
        candidates.append(ancestor / "bls-signatures" / "python-impl")

    for candidate in candidates:
        if (candidate / "schemes.py").is_file():
            candidate_text = str(candidate)
            if candidate_text not in sys.path:
                sys.path.insert(0, candidate_text)
            try:
                from schemes import PopSchemeMPL  # type: ignore
                from ec import bytes_to_point, default_ec, default_ec_twist  # type: ignore
                from fields import Fq, Fq2  # type: ignore
                from private_key import PrivateKey  # type: ignore

                return PopSchemeMPL, bytes_to_point, default_ec, default_ec_twist, (Fq, Fq2), PrivateKey
            except ImportError as exc:  # pragma: no cover - deployment error
                raise RuntimeError(f"Unable to import BLS reference implementation from {candidate}") from exc

    raise RuntimeError(
        "BLS reference implementation not found. Set BLS_PYTHON_IMPL to "
        "the bls-signatures/python-impl directory."
    )


PopSchemeMPL, _bytes_to_point, _default_ec, _default_ec_twist, (_Fq, _Fq2), _PrivateKey = _load_bls_reference()


def canonical_json_bytes(value: Mapping[str, Any]) -> bytes:
    """Return a deterministic UTF-8 JSON representation for signed objects."""

    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode("utf-8")


def _require_string(value: Any, field: str, *, max_bytes: int = 255) -> str:
    if not isinstance(value, str) or not value:
        raise ProtocolError(f"{field} must be a non-empty string")
    try:
        encoded = value.encode("utf-8")
    except UnicodeError as exc:
        raise ProtocolError(f"{field} is not valid UTF-8") from exc
    if len(encoded) > max_bytes:
        raise ProtocolError(f"{field} is too long")
    return value


def _require_node_id(value: Any, field: str = "nodeID") -> str:
    """Validate node IDs shared with the firmware enrollment frame.

    Keeping this deliberately small ASCII alphabet ensures that a registered
    identity cannot alter the colon-delimited UART enrollment record or create
    a different canonical JSON representation on another implementation.
    """

    node_id = _require_string(value, field, max_bytes=128)
    if _NODE_ID_RE.fullmatch(node_id) is None:
        raise ProtocolError(f"{field} contains unsupported characters")
    return node_id


def _require_uint(value: Any, field: str, *, bits: int = 64) -> int:
    if isinstance(value, bool) or not isinstance(value, int) or value < 0 or value >= (1 << bits):
        raise ProtocolError(f"{field} must be an unsigned {bits}-bit integer")
    return value


def _hex_bytes(value: Any, field: str, expected_length: int | None = None) -> bytes:
    if not isinstance(value, str):
        raise ProtocolError(f"{field} must be hexadecimal text")
    try:
        result = bytes.fromhex(value)
    except ValueError as exc:
        raise ProtocolError(f"{field} is not valid hexadecimal") from exc
    if expected_length is not None and len(result) != expected_length:
        raise ProtocolError(f"{field} must be {expected_length} bytes")
    return result


def _b64_bytes(value: Any, field: str) -> bytes:
    if not isinstance(value, str):
        raise ProtocolError(f"{field} must be base64 text")
    try:
        return base64.b64decode(value.encode("ascii"), validate=True)
    except (UnicodeError, ValueError) as exc:
        raise ProtocolError(f"{field} is not valid base64") from exc


def key_id_for_public_key(public_key: bytes) -> bytes:
    if len(public_key) != PUBLIC_KEY_BYTES:
        raise ProtocolError("BLS public key has an invalid length")
    return hashlib.sha256(b"CLUSTER-BLS-key-id-v1\x00" + public_key).digest()[:KEY_ID_BYTES]


def _g1_from_bytes(serialized: bytes) -> Any:
    if len(serialized) != PUBLIC_KEY_BYTES:
        raise ProtocolError("BLS public key has an invalid length")
    try:
        point = _bytes_to_point(serialized, _default_ec, _Fq)
        point.check_valid()
        if point.infinity:
            raise ProtocolError("BLS public key must not be the point at infinity")
        return point
    except (AssertionError, ValueError) as exc:
        raise ProtocolError("BLS public key is not a valid G1 subgroup point") from exc


def _g2_from_bytes(serialized: bytes, field: str) -> Any:
    if len(serialized) != SIGNATURE_BYTES:
        raise ProtocolError(f"{field} has an invalid length")
    try:
        point = _bytes_to_point(serialized, _default_ec_twist, _Fq2)
        point.check_valid()
        if point.infinity:
            raise ProtocolError(f"{field} must not be the point at infinity")
        return point
    except (AssertionError, ValueError) as exc:
        raise ProtocolError(f"{field} is not a valid G2 subgroup point") from exc


def keygen_from_ikm(ikm: bytes) -> tuple[Any, bytes, bytes]:
    """Derive a PoP BLS key pair from a CDI-derived IKM.

    Callers must feed an already domain-separated, device-bound IKM.  This
    helper deliberately never invents or persists device secrets.
    """

    if not isinstance(ikm, bytes) or len(ikm) < 32:
        raise ProtocolError("BLS IKM must contain at least 32 bytes")
    # Match blst_keygen() (KeyGen v4) used by the firmware.  The bundled
    # Python reference still implements the older v3 salt rule, which derives
    # a different key from the same IKM.
    salt = hashlib.sha256(b"BLS-SIG-KEYGEN-SALT-").digest()
    while True:
        prk = hmac.new(salt, ikm + b"\x00", hashlib.sha256).digest()
        info = (48).to_bytes(2, "big")
        okm = b""
        previous = b""
        counter = 1
        while len(okm) < 48:
            previous = hmac.new(
                prk, previous + info + bytes([counter]), hashlib.sha256
            ).digest()
            okm += previous
            counter += 1
        scalar = int.from_bytes(okm[:48], "big") % _default_ec.n
        if scalar != 0:
            secret_key = _PrivateKey.from_int(scalar)
            break
        salt = hashlib.sha256(salt).digest()
    public_key = bytes(secret_key.get_g1())
    proof = bytes(PopSchemeMPL.pop_prove(secret_key))
    if not PopSchemeMPL.pop_verify(_g1_from_bytes(public_key), _g2_from_bytes(proof, "PoP")):
        raise ProtocolError("locally generated BLS PoP did not verify")
    return secret_key, public_key, proof


def pop_verify(public_key: bytes, proof: bytes) -> bool:
    try:
        return bool(PopSchemeMPL.pop_verify(_g1_from_bytes(public_key), _g2_from_bytes(proof, "PoP")))
    except ProtocolError:
        return False


def sign_message(secret_key: Any, message: bytes) -> bytes:
    if not isinstance(message, bytes) or not message:
        raise ProtocolError("BLS message must be non-empty bytes")
    return bytes(PopSchemeMPL.sign(secret_key, message))


def aggregate_signatures(signatures: Iterable[bytes]) -> bytes:
    points = [_g2_from_bytes(signature, "BLS signature") for signature in signatures]
    if not points:
        raise ProtocolError("at least one signature is required for aggregation")
    return bytes(PopSchemeMPL.aggregate(points))


def aggregate_public_keys(public_keys: Iterable[bytes]) -> bytes:
    points = [_g1_from_bytes(public_key) for public_key in public_keys]
    if not points:
        raise ProtocolError("at least one public key is required for aggregation")
    aggregate = points[0]
    for public_key in points[1:]:
        aggregate += public_key
    aggregate.check_valid()
    if aggregate.infinity:
        raise ProtocolError("aggregate public key is the point at infinity")
    return bytes(aggregate)


def fast_aggregate_verify(public_keys: Sequence[bytes], message: bytes, signature: bytes) -> bool:
    try:
        if not isinstance(message, bytes) or not message:
            return False
        points = [_g1_from_bytes(public_key) for public_key in public_keys]
        if not points:
            return False
        if len({bytes(point) for point in points}) != len(points):
            return False
        return bool(PopSchemeMPL.fast_aggregate_verify(points, message, _g2_from_bytes(signature, "BLS signature")))
    except ProtocolError:
        return False


def _der_length(length: int) -> bytes:
    if length < 0:
        raise ProtocolError("negative DER length")
    if length < 0x80:
        return bytes([length])
    encoded = length.to_bytes((length.bit_length() + 7) // 8, "big")
    if len(encoded) > 4:
        raise ProtocolError("DER value is too large")
    return bytes([0x80 | len(encoded)]) + encoded


def _der_tlv(tag: int, value: bytes) -> bytes:
    return bytes([tag]) + _der_length(len(value)) + value


def _der_positive_integer(value: int) -> bytes:
    encoded = value.to_bytes(max(1, (value.bit_length() + 7) // 8), "big")
    if encoded[0] & 0x80:
        encoded = b"\x00" + encoded
    return _der_tlv(0x02, encoded)


def _der_read_tlv(data: bytes, offset: int) -> tuple[int, bytes, int]:
    if offset + 2 > len(data):
        raise ProtocolError("truncated DER value")
    tag = data[offset]
    first_length = data[offset + 1]
    cursor = offset + 2
    if first_length < 0x80:
        length = first_length
    else:
        number_of_length_bytes = first_length & 0x7F
        if number_of_length_bytes == 0 or number_of_length_bytes > 4 or cursor + number_of_length_bytes > len(data):
            raise ProtocolError("invalid DER length")
        length_bytes = data[cursor : cursor + number_of_length_bytes]
        if length_bytes[0] == 0:
            raise ProtocolError("non-canonical DER length")
        length = int.from_bytes(length_bytes, "big")
        if length < 0x80:
            raise ProtocolError("non-canonical DER length")
        cursor += number_of_length_bytes
    end = cursor + length
    if end > len(data):
        raise ProtocolError("truncated DER value")
    return tag, data[cursor:end], end


@dataclass(frozen=True)
class BlsCertificateBinding:
    protocol_version: int
    ciphersuite_id: str
    key_id: bytes
    public_key: bytes
    proof_of_possession: bytes

    def as_registration(self, node_id: str) -> dict[str, Any]:
        _require_node_id(node_id)
        return {
            "protocolVersion": self.protocol_version,
            "ciphersuiteID": self.ciphersuite_id,
            "nodeID": node_id,
            "keyID": self.key_id.hex(),
            "blsPublicKey": self.public_key.hex(),
            "proofOfPossession": self.proof_of_possession.hex(),
        }


def encode_certificate_binding(binding: BlsCertificateBinding) -> bytes:
    validate_certificate_binding(binding)
    sequence = b"".join(
        (
            _der_positive_integer(binding.protocol_version),
            _der_tlv(0x0C, binding.ciphersuite_id.encode("utf-8")),
            _der_tlv(0x04, binding.key_id),
            _der_tlv(0x04, binding.public_key),
            _der_tlv(0x04, binding.proof_of_possession),
        )
    )
    return _der_tlv(0x30, sequence)


def decode_certificate_binding(encoded: bytes) -> BlsCertificateBinding:
    outer_tag, sequence, end = _der_read_tlv(encoded, 0)
    if outer_tag != 0x30 or end != len(encoded):
        raise ProtocolError("BLS certificate binding must be one DER SEQUENCE")
    fields: list[tuple[int, bytes]] = []
    offset = 0
    while offset < len(sequence):
        tag, value, offset = _der_read_tlv(sequence, offset)
        fields.append((tag, value))
    if len(fields) != 5 or [tag for tag, _ in fields] != [0x02, 0x0C, 0x04, 0x04, 0x04]:
        raise ProtocolError("BLS certificate binding fields are malformed")
    version_bytes = fields[0][1]
    if not version_bytes or version_bytes[0] & 0x80 or (len(version_bytes) > 1 and version_bytes[0] == 0):
        raise ProtocolError("BLS binding protocolVersion is malformed")
    try:
        ciphersuite = fields[1][1].decode("utf-8")
    except UnicodeDecodeError as exc:
        raise ProtocolError("BLS binding ciphersuiteID is not UTF-8") from exc
    binding = BlsCertificateBinding(
        protocol_version=int.from_bytes(version_bytes, "big"),
        ciphersuite_id=ciphersuite,
        key_id=fields[2][1],
        public_key=fields[3][1],
        proof_of_possession=fields[4][1],
    )
    validate_certificate_binding(binding)
    return binding


def validate_certificate_binding(binding: BlsCertificateBinding) -> None:
    if binding.protocol_version != PROTOCOL_VERSION:
        raise ProtocolError("unsupported BLS protocolVersion")
    if binding.ciphersuite_id != CIPHERSUITE_ID:
        raise ProtocolError("unsupported BLS ciphersuiteID")
    if len(binding.key_id) != KEY_ID_BYTES:
        raise ProtocolError("BLS keyID has an invalid length")
    _g1_from_bytes(binding.public_key)
    _g2_from_bytes(binding.proof_of_possession, "PoP")
    if binding.key_id != key_id_for_public_key(binding.public_key):
        raise ProtocolError("BLS keyID does not match the public key")
    if not pop_verify(binding.public_key, binding.proof_of_possession):
        raise ProtocolError("BLS proof of possession did not verify")


def binding_from_registration(registration: Mapping[str, Any]) -> BlsCertificateBinding:
    _require_node_id(registration.get("nodeID"))
    binding = BlsCertificateBinding(
        protocol_version=_require_uint(registration.get("protocolVersion"), "protocolVersion", bits=8),
        ciphersuite_id=_require_string(registration.get("ciphersuiteID"), "ciphersuiteID", max_bytes=128),
        key_id=_hex_bytes(registration.get("keyID"), "keyID", KEY_ID_BYTES),
        public_key=_hex_bytes(registration.get("blsPublicKey"), "blsPublicKey", PUBLIC_KEY_BYTES),
        proof_of_possession=_hex_bytes(registration.get("proofOfPossession"), "proofOfPossession", POP_BYTES),
    )
    validate_certificate_binding(binding)
    return binding


def certificate_binding_from_certificate(certificate: x509.Certificate) -> BlsCertificateBinding:
    try:
        extension = certificate.extensions.get_extension_for_oid(CERT_BINDING_OID)
    except x509.ExtensionNotFound as exc:
        raise ProtocolError("certificate does not contain the cluster BLS extension") from exc
    if extension.critical:
        raise ProtocolError("cluster BLS certificate extension must be non-critical")
    raw_value = extension.value.value if hasattr(extension.value, "value") else extension.value
    if not isinstance(raw_value, bytes):
        raise ProtocolError("cluster BLS certificate extension has an invalid value")
    return decode_certificate_binding(raw_value)


def _member_from_mapping(member: Mapping[str, Any]) -> dict[str, Any]:
    node_id = _require_node_id(member.get("nodeID"))
    key_id = _hex_bytes(member.get("keyID"), "keyID", KEY_ID_BYTES)
    public_key = _hex_bytes(member.get("blsPublicKey"), "blsPublicKey", PUBLIC_KEY_BYTES)
    status = member.get("status")
    if status not in ("active", "revoked"):
        raise ProtocolError("member status must be active or revoked")
    level = member.get("level")
    if level is not None and level not in ("L1", "L2", "L3"):
        raise ProtocolError("member level must be L1, L2, or L3")
    parent = member.get("parentNodeID")
    if parent is not None:
        _require_node_id(parent, "parentNodeID")
    _g1_from_bytes(public_key)
    if key_id != key_id_for_public_key(public_key):
        raise ProtocolError("member keyID does not match its BLS public key")
    result: dict[str, Any] = {
        "nodeID": node_id,
        "keyID": key_id.hex(),
        "blsPublicKey": public_key.hex(),
        "status": status,
    }
    if level is not None:
        result["level"] = level
    if parent is not None:
        result["parentNodeID"] = parent
    return result


def _active_member_public_keys(key_list: Mapping[str, Any]) -> list[bytes]:
    return [
        _hex_bytes(member["blsPublicKey"], "blsPublicKey", PUBLIC_KEY_BYTES)
        for member in key_list["members"]
        if member["status"] == "active"
    ]


def build_key_list(cluster_id: str, epoch: int, members: Iterable[Mapping[str, Any]]) -> dict[str, Any]:
    """Create an unsigned canonical key list.

    The caller signs this object with ``sign_key_list`` after its registration
    policy has verified the certificate binding and PoP for every new key.
    """

    cluster_id = _require_string(cluster_id, "clusterID", max_bytes=128)
    epoch = _require_uint(epoch, "epoch")
    canonical_members = [_member_from_mapping(member) for member in members]
    canonical_members.sort(key=lambda member: (member["nodeID"], member["keyID"]))
    identities = [(member["nodeID"], member["keyID"]) for member in canonical_members]
    if len(identities) != len(set(identities)):
        raise ProtocolError("key list contains duplicate nodeID/keyID pairs")
    node_ids = [member["nodeID"] for member in canonical_members]
    if len(node_ids) != len(set(node_ids)):
        raise ProtocolError("key list contains multiple keys for one nodeID")
    active_keys = [
        _hex_bytes(member["blsPublicKey"], "blsPublicKey", PUBLIC_KEY_BYTES)
        for member in canonical_members
        if member["status"] == "active"
    ]
    if not active_keys:
        raise ProtocolError("key list must contain at least one active member")
    if len(active_keys) != len(set(active_keys)):
        raise ProtocolError("key list contains duplicate active BLS public keys")
    return {
        "protocolVersion": PROTOCOL_VERSION,
        "ciphersuiteID": CIPHERSUITE_ID,
        "clusterID": cluster_id,
        "epoch": epoch,
        "members": canonical_members,
        "aggregatePublicKey": aggregate_public_keys(active_keys).hex(),
    }


def unsigned_key_list(key_list: Mapping[str, Any]) -> dict[str, Any]:
    return {key: value for key, value in key_list.items() if key != _LIST_SIGNATURE_FIELD}


def key_list_digest(key_list: Mapping[str, Any]) -> bytes:
    validate_key_list(key_list, require_signature=False)
    return hashlib.sha256(b"CLUSTER-BLS-key-list-v1\x00" + canonical_json_bytes(unsigned_key_list(key_list))).digest()


def build_quote_request(
    key_list: Mapping[str, Any], nonce: bytes, *,
    require_list_signature: bool = True,
) -> bytes:
    """Encode the verifier-to-L3 current-epoch quote request.

    ``BLQ1 | clusterIDLen | clusterID | epoch:u64be | listDigest |
    participantCount | nonce`` mirrors the bounded firmware parser.
    """

    validate_key_list(key_list, require_signature=require_list_signature)
    if not isinstance(nonce, bytes) or len(nonce) != NONCE_BYTES:
        raise ProtocolError("quote-request nonce must be 32 bytes")
    cluster_id = str(key_list["clusterID"]).encode("utf-8")
    active_count = sum(
        member["status"] == "active" for member in key_list["members"]
    )
    if not 1 <= len(cluster_id) <= 128:
        raise ProtocolError("quote-request clusterID has an invalid length")
    if not 3 <= active_count <= 255:
        raise ProtocolError("quote request requires at least one active L3/L2/L1 path")
    return (
        QUOTE_REQUEST_MAGIC
        + bytes([len(cluster_id)])
        + cluster_id
        + int(key_list["epoch"]).to_bytes(8, "big")
        + key_list_digest(key_list)
        + bytes([active_count])
        + nonce
    )


def validate_key_list(key_list: Mapping[str, Any], *, require_signature: bool = False) -> None:
    if not isinstance(key_list, Mapping):
        raise ProtocolError("key list must be an object")
    if _require_uint(key_list.get("protocolVersion"), "protocolVersion", bits=8) != PROTOCOL_VERSION:
        raise ProtocolError("unsupported key-list protocolVersion")
    if _require_string(key_list.get("ciphersuiteID"), "ciphersuiteID", max_bytes=128) != CIPHERSUITE_ID:
        raise ProtocolError("unsupported key-list ciphersuiteID")
    _require_string(key_list.get("clusterID"), "clusterID", max_bytes=128)
    _require_uint(key_list.get("epoch"), "epoch")
    members = key_list.get("members")
    if not isinstance(members, list) or not members:
        raise ProtocolError("key list members must be a non-empty array")
    rebuilt = build_key_list(str(key_list["clusterID"]), int(key_list["epoch"]), members)
    if list(members) != rebuilt["members"]:
        raise ProtocolError("key-list members are not canonical or contain invalid entries")
    members_by_node = {member["nodeID"]: member for member in rebuilt["members"]}
    l3_members = [member for member in rebuilt["members"] if member.get("level") == "L3"]
    if len(l3_members) != 1 or l3_members[0].get("parentNodeID") is not None:
        raise ProtocolError("key list must contain exactly one parentless L3 member")
    for member in rebuilt["members"]:
        level = member.get("level")
        parent_id = member.get("parentNodeID")
        if level not in ("L1", "L2", "L3"):
            raise ProtocolError("every key-list member must declare its trust level")
        if level == "L3":
            continue
        parent = members_by_node.get(parent_id)
        expected_parent_level = "L3" if level == "L2" else "L2"
        if parent is None or parent.get("level") != expected_parent_level:
            raise ProtocolError(
                f"{level} member must reference an existing {expected_parent_level} parent"
            )
        if member["status"] == "active" and parent["status"] != "active":
            raise ProtocolError("an active member cannot descend from a revoked parent")
    supplied_aggregate = _hex_bytes(key_list.get("aggregatePublicKey"), "aggregatePublicKey", PUBLIC_KEY_BYTES)
    if supplied_aggregate != bytes.fromhex(rebuilt["aggregatePublicKey"]):
        raise ProtocolError("key-list aggregate public key is inconsistent with active members")
    if require_signature and _LIST_SIGNATURE_FIELD not in key_list:
        raise ProtocolError("key list does not contain a signature")


def _sign_object(unsigned_object: Mapping[str, Any], private_key: Any) -> dict[str, str]:
    if not isinstance(private_key, ec.EllipticCurvePrivateKey):
        raise ProtocolError("list signer must be an ECDSA private key")
    signature = private_key.sign(canonical_json_bytes(unsigned_object), ec.ECDSA(hashes.SHA384()))
    return {"algorithm": LIST_SIGNATURE_ALGORITHM, "value": base64.b64encode(signature).decode("ascii")}


def _verify_object_signature(signed_object: Mapping[str, Any], public_key: Any) -> None:
    signature_descriptor = signed_object.get(_LIST_SIGNATURE_FIELD)
    if not isinstance(signature_descriptor, Mapping):
        raise ProtocolError("signed object does not contain listSignature")
    if signature_descriptor.get("algorithm") != LIST_SIGNATURE_ALGORITHM:
        raise ProtocolError("unsupported list-signature algorithm")
    if not isinstance(public_key, ec.EllipticCurvePublicKey):
        raise ProtocolError("list signer certificate does not contain an ECDSA key")
    signature = _b64_bytes(signature_descriptor.get("value"), "listSignature.value")
    try:
        public_key.verify(signature, canonical_json_bytes(unsigned_key_list(signed_object)), ec.ECDSA(hashes.SHA384()))
    except InvalidSignature as exc:
        raise ProtocolError("listSignature verification failed") from exc


def sign_key_list(key_list: Mapping[str, Any], private_key: Any) -> dict[str, Any]:
    validate_key_list(key_list, require_signature=False)
    result = unsigned_key_list(key_list)
    result[_LIST_SIGNATURE_FIELD] = _sign_object(result, private_key)
    return result


def verify_key_list(key_list: Mapping[str, Any], signer_certificate: x509.Certificate) -> None:
    validate_key_list(key_list, require_signature=True)
    _verify_object_signature(key_list, signer_certificate.public_key())


def _members_by_node_id(key_list: Mapping[str, Any]) -> dict[str, dict[str, Any]]:
    return {member["nodeID"]: dict(member) for member in key_list["members"]}


def create_update_notification(
    previous_key_list: Mapping[str, Any], new_key_list: Mapping[str, Any], private_key: Any
) -> dict[str, Any]:
    """Sign an epoch transition carrying only changed members.

    The notification has enough data for the verifier to apply a local update
    and check that the resulting complete list has the advertised digest.
    """

    validate_key_list(previous_key_list)
    validate_key_list(new_key_list)
    if previous_key_list["clusterID"] != new_key_list["clusterID"]:
        raise ProtocolError("an update cannot change clusterID")
    if int(new_key_list["epoch"]) != int(previous_key_list["epoch"]) + 1:
        raise ProtocolError("new epoch must be exactly previous epoch plus one")
    old_members = _members_by_node_id(previous_key_list)
    new_members = _members_by_node_id(new_key_list)
    changes: list[dict[str, Any]] = []
    for node_id in sorted(set(old_members) | set(new_members)):
        old_member = old_members.get(node_id)
        new_member = new_members.get(node_id)
        if old_member == new_member:
            continue
        if new_member is None:
            changes.append({"nodeID": node_id, "action": "remove"})
        else:
            changes.append({"nodeID": node_id, "action": "upsert", "member": new_member})
    if not changes:
        raise ProtocolError("epoch update must change at least one member")
    unsigned = {
        "protocolVersion": PROTOCOL_VERSION,
        "ciphersuiteID": CIPHERSUITE_ID,
        "clusterID": previous_key_list["clusterID"],
        "baseEpoch": previous_key_list["epoch"],
        "epoch": new_key_list["epoch"],
        "previousListDigest": key_list_digest(previous_key_list).hex(),
        "newListDigest": key_list_digest(new_key_list).hex(),
        "newAggregatePublicKey": new_key_list["aggregatePublicKey"],
        "changes": changes,
    }
    result = dict(unsigned)
    result[_LIST_SIGNATURE_FIELD] = _sign_object(unsigned, private_key)
    return result


def apply_update_notification(
    current_key_list: Mapping[str, Any], notification: Mapping[str, Any], signer_certificate: x509.Certificate
) -> dict[str, Any]:
    """Validate and atomically derive the next key-list state."""

    validate_key_list(current_key_list)
    _verify_object_signature(notification, signer_certificate.public_key())
    if _require_uint(notification.get("protocolVersion"), "protocolVersion", bits=8) != PROTOCOL_VERSION:
        raise ProtocolError("unsupported update protocolVersion")
    if _require_string(notification.get("ciphersuiteID"), "ciphersuiteID", max_bytes=128) != CIPHERSUITE_ID:
        raise ProtocolError("unsupported update ciphersuiteID")
    if notification.get("clusterID") != current_key_list["clusterID"]:
        raise ProtocolError("update clusterID does not match cached key list")
    if _require_uint(notification.get("baseEpoch"), "baseEpoch") != current_key_list["epoch"]:
        raise ProtocolError("update baseEpoch does not match cached key list")
    if _require_uint(notification.get("epoch"), "epoch") != int(current_key_list["epoch"]) + 1:
        raise ProtocolError("update epoch is not the next epoch")
    if _hex_bytes(notification.get("previousListDigest"), "previousListDigest", DIGEST_BYTES) != key_list_digest(current_key_list):
        raise ProtocolError("update previousListDigest does not match cached key list")
    changes = notification.get("changes")
    if not isinstance(changes, list) or not changes:
        raise ProtocolError("update changes must be a non-empty array")
    members = _members_by_node_id(current_key_list)
    seen_nodes: set[str] = set()
    for change in changes:
        if not isinstance(change, Mapping):
            raise ProtocolError("update change must be an object")
        node_id = _require_node_id(change.get("nodeID"))
        if node_id in seen_nodes:
            raise ProtocolError("update contains duplicate node changes")
        seen_nodes.add(node_id)
        action = change.get("action")
        if action == "remove":
            if set(change) != {"nodeID", "action"}:
                raise ProtocolError("remove change contains unexpected fields")
            members.pop(node_id, None)
        elif action == "upsert":
            member = change.get("member")
            if not isinstance(member, Mapping):
                raise ProtocolError("upsert change does not contain a member")
            canonical_member = _member_from_mapping(member)
            if canonical_member["nodeID"] != node_id:
                raise ProtocolError("upsert nodeID does not match member nodeID")
            members[node_id] = canonical_member
        else:
            raise ProtocolError("update action must be remove or upsert")
    next_list = build_key_list(str(current_key_list["clusterID"]), int(notification["epoch"]), members.values())
    if key_list_digest(next_list) != _hex_bytes(notification.get("newListDigest"), "newListDigest", DIGEST_BYTES):
        raise ProtocolError("update newListDigest does not match applied changes")
    if next_list["aggregatePublicKey"] != notification.get("newAggregatePublicKey"):
        raise ProtocolError("update aggregate public key does not match applied changes")
    return next_list


def build_challenge_message(
    cluster_id: str,
    epoch: int,
    nonce: bytes,
    measurement_digest: bytes,
    member_list_digest: bytes,
) -> bytes:
    """Build the common BLS message every participating root signs.

    The caller sends the individual fields in a length-delimited challenge
    frame; the BLS operation signs only this digest.  Including the exact
    cached list digest prevents a valid proof from another membership version
    from being replayed under the same ``clusterID`` and ``epoch``.
    """

    cluster_id = _require_string(cluster_id, "clusterID", max_bytes=128)
    epoch = _require_uint(epoch, "epoch")
    if not isinstance(nonce, bytes) or len(nonce) != NONCE_BYTES:
        raise ProtocolError("challenge nonce must be 32 bytes")
    if not isinstance(measurement_digest, bytes) or len(measurement_digest) != DIGEST_BYTES:
        raise ProtocolError("measurement digest must be 32 bytes")
    if not isinstance(member_list_digest, bytes) or len(member_list_digest) != DIGEST_BYTES:
        raise ProtocolError("member-list digest must be 32 bytes")
    cluster_bytes = cluster_id.encode("utf-8")
    transcript = (
        _CHALLENGE_DOMAIN
        + bytes([PROTOCOL_VERSION])
        + bytes([len(CIPHERSUITE_ID)])
        + CIPHERSUITE_ID.encode("ascii")
        + bytes([len(cluster_bytes)])
        + cluster_bytes
        + epoch.to_bytes(8, "big")
        + nonce
        + measurement_digest
        + member_list_digest
    )
    return hashlib.sha256(transcript).digest()


def make_aggregate_response(
    key_list: Mapping[str, Any], participant_node_ids: Sequence[str], aggregate_signature: bytes
) -> dict[str, Any]:
    validate_key_list(key_list)
    participants = list(participant_node_ids)
    if not participants or participants != sorted(participants) or len(participants) != len(set(participants)):
        raise ProtocolError("participantNodeIDs must be a non-empty sorted unique list")
    members = _members_by_node_id(key_list)
    participant_keys: list[bytes] = []
    for node_id in participants:
        member = members.get(node_id)
        if member is None or member["status"] != "active":
            raise ProtocolError("aggregate response contains a non-active participant")
        participant_keys.append(_hex_bytes(member["blsPublicKey"], "blsPublicKey", PUBLIC_KEY_BYTES))
    _g2_from_bytes(aggregate_signature, "aggregateSignature")
    return {
        "protocolVersion": PROTOCOL_VERSION,
        "ciphersuiteID": CIPHERSUITE_ID,
        "clusterID": key_list["clusterID"],
        "epoch": key_list["epoch"],
        "memberListDigest": key_list_digest(key_list).hex(),
        "participantNodeIDs": participants,
        "aggregatePublicKey": aggregate_public_keys(participant_keys).hex(),
        "aggregateSignature": aggregate_signature.hex(),
    }


def verify_aggregate_response(
    key_list: Mapping[str, Any],
    response: Mapping[str, Any],
    nonce: bytes,
    measurement_digest: bytes,
    *,
    require_all_active: bool = True,
) -> bool:
    """Verify a current-epoch BLS PoP aggregate proof without fallbacks."""

    try:
        validate_key_list(key_list)
        if _require_uint(response.get("protocolVersion"), "protocolVersion", bits=8) != PROTOCOL_VERSION:
            return False
        if _require_string(response.get("ciphersuiteID"), "ciphersuiteID", max_bytes=128) != CIPHERSUITE_ID:
            return False
        if response.get("clusterID") != key_list["clusterID"] or response.get("epoch") != key_list["epoch"]:
            return False
        if _hex_bytes(response.get("memberListDigest"), "memberListDigest", DIGEST_BYTES) != key_list_digest(key_list):
            return False
        participants = response.get("participantNodeIDs")
        if not isinstance(participants, list) or not participants or participants != sorted(participants):
            return False
        if any(not isinstance(node_id, str) for node_id in participants) or len(participants) != len(set(participants)):
            return False
        members = _members_by_node_id(key_list)
        active_node_ids = sorted(node_id for node_id, member in members.items() if member["status"] == "active")
        if require_all_active and participants != active_node_ids:
            return False
        public_keys: list[bytes] = []
        for node_id in participants:
            member = members.get(node_id)
            if member is None or member["status"] != "active":
                return False
            public_keys.append(_hex_bytes(member["blsPublicKey"], "blsPublicKey", PUBLIC_KEY_BYTES))
        if _hex_bytes(response.get("aggregatePublicKey"), "aggregatePublicKey", PUBLIC_KEY_BYTES) != aggregate_public_keys(public_keys):
            return False
        signature = _hex_bytes(response.get("aggregateSignature"), "aggregateSignature", SIGNATURE_BYTES)
        message = build_challenge_message(
            str(key_list["clusterID"]),
            int(key_list["epoch"]),
            nonce,
            measurement_digest,
            key_list_digest(key_list),
        )
        return fast_aggregate_verify(public_keys, message, signature)
    except ProtocolError:
        return False


def load_json(path: Path) -> dict[str, Any]:
    try:
        loaded = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise ProtocolError(f"cannot read JSON file {path}") from exc
    if not isinstance(loaded, dict):
        raise ProtocolError(f"JSON file {path} must contain an object")
    return loaded


def save_json_atomic(path: Path, value: Mapping[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_bytes(canonical_json_bytes(value) + b"\n")
    os.replace(temporary, path)
