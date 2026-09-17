from __future__ import annotations

import hashlib

from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec, utils


CHAIN_COUNTS = (10, 100, 1000, 10000)
P384_ORDER = int(
    "ffffffffffffffffffffffffffffffffffffffffffffffffc7634d81f4372ddf"
    "581a0db248b0a77aecec196accc52973",
    16,
)


def topology(chains: int):
    if chains not in CHAIN_COUNTS:
        raise ValueError("chains must be 10, 100, 1000 or 10000")
    yield 3, 1
    for group in range(1, chains // 10 + 1):
        first_child = (group - 1) * 10 + 1
        for child in range(first_child, first_child + 10):
            yield 1, child
        yield 2, group


def private_scalar(level: int, index: int) -> int:
    maximum = 10000 if level == 1 else 1000 if level == 2 else 1
    if level not in (1, 2, 3) or not 1 <= index <= maximum:
        raise ValueError("invalid ECDSA test identity")
    value = int.from_bytes(
        bytes([level]) + bytes(43) + index.to_bytes(4, "big"), "big"
    )
    if not 0 < value < P384_ORDER:
        raise ValueError("invalid ECDSA test private scalar")
    return value


def prepare_public_keys(chains: int):
    return {
        identity: ec.derive_private_key(
            private_scalar(*identity), ec.SECP384R1(), default_backend()
        ).public_key()
        for identity in topology(chains)
    }


def challenge_digest(chains: int, nonce: bytes, measurement: bytes) -> bytes:
    if len(nonce) != 32 or len(measurement) != 32:
        raise ValueError("nonce and measurement must both be 32 bytes")
    return hashlib.sha384(
        b"ECDSA-SCALE-v1" + chains.to_bytes(4, "big") + nonce + measurement
    ).digest()


def verify_raw(public_key, digest: bytes, signature: bytes) -> None:
    if len(digest) != 48 or len(signature) != 96:
        raise ValueError("invalid P-384 digest or signature length")
    r = int.from_bytes(signature[:48], "big")
    s = int.from_bytes(signature[48:], "big")
    public_key.verify(
        utils.encode_dss_signature(r, s),
        digest,
        ec.ECDSA(utils.Prehashed(hashes.SHA384())),
    )


def percentiles(values):
    values = list(values)
    if not values:
        return {}
    ordered = sorted(values)

    def at(quantile):
        position = (len(ordered) - 1) * quantile
        low = int(position)
        high = min(low + 1, len(ordered) - 1)
        return ordered[low] + (ordered[high] - ordered[low]) * (
            position - low
        )

    return {
        "count": len(ordered),
        "mean": sum(ordered) / len(ordered),
        "P50": at(0.50),
        "P95": at(0.95),
        "P99": at(0.99),
    }
