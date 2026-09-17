from __future__ import annotations

import hashlib
import hmac
import struct
import zlib

CHAIN_COUNTS = (10, 100, 1000, 10000)
ORDER = 0x73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001
DOMAIN = b"CBSTEST2"
L1_CACHED_KEY_COUNT = 10
L2_CACHED_KEY_COUNT = 10
PROFILE_DERIVATION = "L1-10-fixed-keys-cyclic-v1;L2-10-static-keys-cyclic-v1"


def node_secret_bytes(level: int, index: int) -> bytes:
    if level not in (1, 2) or not 1 <= index <= (10000 if level == 1 else 1000):
        raise ValueError("invalid virtual node")
    secret = bytearray(32)
    secret[0] = level
    secret[28:] = index.to_bytes(4, "big")
    return bytes(secret)


def node_ikm(level: int, index: int) -> bytes:
    if level not in (1, 2) or not 1 <= index <= (10000 if level == 1 else 1000):
        raise ValueError("invalid virtual node")
    seed = bytearray(range(32))
    seed[0] = level
    seed[28:] = index.to_bytes(4, "big")
    return bytes(seed)


def l2_cached_key_index(index: int) -> int:
    if not 1 <= index <= 1000:
        raise ValueError("invalid virtual L2 node")
    return (index - 1) % L2_CACHED_KEY_COUNT + 1


def l1_cached_key_index(index: int) -> int:
    if not 1 <= index <= 10000:
        raise ValueError("invalid virtual L1 node")
    return (index - 1) % L1_CACHED_KEY_COUNT + 1


def scalar_from_ikm(ikm: bytes) -> int:
    salt = hashlib.sha256(b"BLS-SIG-KEYGEN-SALT-").digest()
    while True:
        prk = hmac.new(salt, ikm + b"\0", hashlib.sha256).digest()
        first = hmac.new(prk, b"\0\x30\x01", hashlib.sha256).digest()
        second = hmac.new(prk, first + b"\0\x30\x02", hashlib.sha256).digest()
        value = int.from_bytes((first + second)[:48], "big") % ORDER
        if value:
            return value
        salt = hashlib.sha256(salt).digest()


def challenge_digest(chains: int, nonce: bytes, measurement: bytes) -> bytes:
    if chains not in CHAIN_COUNTS or len(nonce) != 32 or len(measurement) != 32:
        raise ValueError("invalid scale challenge")
    return hashlib.sha256(DOMAIN + struct.pack(">I", chains) + nonce + measurement).digest()


def check_packet(packet: bytes, magic: bytes, length: int) -> None:
    if len(packet) != length or packet[:4] != magic:
        raise ValueError("invalid packet type or length")
    if zlib.crc32(packet[:-4]) != int.from_bytes(packet[-4:], "big"):
        raise ValueError("packet CRC mismatch")


def parse_group(packet: bytes) -> dict:
    check_packet(packet, b"BHG2", 304)
    status, group = struct.unpack_from(">II", packet, 4)
    if status:
        raise ValueError(f"group {group} failed: 0x{status:08x}")
    samples = [struct.unpack_from(">QQ", packet, 108 + i * 16) for i in range(10)]
    keygen, sign, aggregate = struct.unpack_from(">QQQ", packet, 268)
    return {
        "group": group, "signature": packet[12:108].hex(),
        "l1KeySetupCycles": [s[0] for s in samples],
        "l1SignCycles": [s[1] for s in samples],
        "l2KeySetupCycles": keygen, "l2SignCycles": sign,
        "l2AggregateCycles": aggregate,
        "l3AggregateCycles": struct.unpack_from(">Q", packet, 292)[0],
    }


def parse_final(packet: bytes) -> dict:
    if len(packet) not in (168, 176):
        raise ValueError("invalid packet type or length")
    check_packet(packet, b"BHR2", len(packet))
    status, chains, groups, members = struct.unpack_from(">IIII", packet, 4)
    if status:
        raise ValueError(f"hardware scale test failed: 0x{status:08x}")
    if chains not in CHAIN_COUNTS or groups != chains // 10 or members != chains + groups + 1:
        raise ValueError("invalid topology counts")
    sign, aggregate = struct.unpack_from(">QQ", packet, 148)
    recovery_ms, retry_count = (struct.unpack_from(">II", packet, 164)
                                if len(packet) == 176 else (0, 0))
    return {"chains": chains, "l2Nodes": groups, "members": members,
            "measurement": packet[20:52].hex(), "signature": packet[52:148].hex(),
            "l3SignCycles": sign, "l3AggregateCycles": aggregate,
            "usbRecoveryMs": recovery_ms, "usbRetryCount": retry_count,
            "recoveryTelemetry": len(packet) == 176}


def timing_summary(groups: list[dict], final: dict, clocks: tuple[float, float, float]) -> dict:
    f1, f2, f3 = clocks
    if min(clocks) <= 0:
        raise ValueError("all three actual mcycle clock frequencies must be positive")
    if [g["group"] for g in groups] != list(range(1, final["l2Nodes"] + 1)):
        raise ValueError("missing, duplicate or reordered group")
    if sum(g["l3AggregateCycles"] for g in groups) != final["l3AggregateCycles"]:
        raise ValueError("L3 aggregation timing total mismatch")
    l3_sign = final["l3SignCycles"] / f3
    l3_aggregate = final["l3AggregateCycles"] / f3
    group_ready = [
        max(max(g["l1SignCycles"]) / f1, g["l2SignCycles"] / f2) +
        g["l2AggregateCycles"] / f2 for g in groups]
    serial = l3_sign + l3_aggregate + sum(
        sum(g["l1SignCycles"]) / f1 + (g["l2SignCycles"] + g["l2AggregateCycles"]) / f2
        for g in groups)
    keygen = sum(sum(g["l1KeySetupCycles"]) / f1 + g["l2KeySetupCycles"] / f2 for g in groups)
    return {
        "serialCryptoMs": serial * 1000,
        "virtualKeySetupMs": keygen * 1000,
        "parallelComputeEstimateMs": (max(l3_sign, max(group_ready)) + l3_aggregate) * 1000,
        "l3AggregateMs": l3_aggregate * 1000,
    }


class Backend:
    def __init__(self, name="native"):
        self.name = name
        if name == "native":
            try:
                from blspy import PrivateKey, G1Element, G2Element, PopSchemeMPL
            except ModuleNotFoundError as exc:
                raise RuntimeError(
                    "blspy is not installed for this Python. Run: "
                    "sudo python3 -m pip install blspy==2.0.3 pyserial==3.5"
                ) from exc
            self.PrivateKey, self.G1, self.G2, self.scheme = PrivateKey, G1Element, G2Element, PopSchemeMPL
        elif name == "reference":
            import protocol
            self.p = protocol
        else:
            raise ValueError("unknown backend")

    def secret_from_ikm(self, ikm):
        value = scalar_from_ikm(ikm)
        if self.name == "native":
            return self.PrivateKey.from_bytes(value.to_bytes(32, "big"))
        return self.p._PrivateKey.from_int(value)

    def node_secret(self, level, index):
        if level == 2:
            return self.secret_from_ikm(node_ikm(level, index))
        serialized = node_secret_bytes(level, index)
        if self.name == "native":
            return self.PrivateKey.from_bytes(serialized)
        return self.p._PrivateKey.from_int(int.from_bytes(serialized, "big"))

    def public(self, secret):
        return bytes(secret.get_g1())

    def sign(self, secret, message):
        if self.name == "native":
            return bytes(self.scheme.sign(secret, message))
        return self.p.sign_message(secret, message)

    def aggregate(self, signatures):
        if self.name == "native":
            return bytes(self.scheme.aggregate([self.G2.from_bytes(s) for s in signatures]))
        return self.p.aggregate_signatures(signatures)

    def aggregate_public(self, keys):
        if self.name == "native":
            points = [self.G1.from_bytes(k) for k in keys]
            total = points[0]
            for point in points[1:]:
                total = total + point
            return bytes(total)
        return self.p.aggregate_public_keys(keys)

    def verify(self, keys, message, signature):
        if self.name == "native":
            return bool(self.scheme.fast_aggregate_verify(
                [self.G1.from_bytes(k) for k in keys], message, self.G2.from_bytes(signature)))
        return self.p.fast_aggregate_verify(
            [self.p.aggregate_public_keys(keys)], message, signature)
