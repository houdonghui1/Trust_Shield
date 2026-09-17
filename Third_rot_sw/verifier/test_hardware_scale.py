import io
import json
import struct
import unittest
import zlib
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

from cluster_bls_hardware_common import (
    Backend, CHAIN_COUNTS, challenge_digest, l1_cached_key_index,
    l2_cached_key_index, node_secret_bytes, parse_final, parse_group,
    timing_summary,
)
from cluster_bls_hardware_scale_benchmark import read_packet, run_once
from generate_cluster_bls_hardware_profiles import build_profile


def crc_packet(data):
    return bytes(data) + struct.pack(">I", zlib.crc32(data))


def group_packet(index, signature):
    data = bytearray(300)
    struct.pack_into(">4sII", data, 0, b"BHG2", 0, index)
    data[12:108] = signature
    for i in range(10):
        struct.pack_into(">QQ", data, 108 + 16 * i, 10, 100 + i)
    struct.pack_into(">QQQQ", data, 268, 20, 150, 50, 30)
    return crc_packet(data)


def final_packet(chains, signature, measurement, recovery_ms=0, retries=0):
    data = bytearray(172)
    struct.pack_into(">4sIIII", data, 0, b"BHR2", 0, chains, chains // 10, chains + chains // 10 + 1)
    data[20:52], data[52:148] = measurement, signature
    struct.pack_into(">QQ", data, 148, 200, chains // 10 * 30)
    struct.pack_into(">II", data, 164, recovery_ms, retries)
    return crc_packet(data)


class ScaleTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.backend = Backend("native")

    def test_known_l3_key_and_reference_agreement(self):
        native = self.backend
        reference = Backend("reference")
        expected = "9112a0386a2340714ba0c6d2df235377a8679c3899d03e6ef04dba7a50ef49e5a1dc93105e9374e93ed301b63487e17c"
        self.assertEqual(native.public(native.secret_from_ikm(bytes(range(32)))).hex(), expected)
        for level, index in ((1, 1), (1, 10000), (2, 1000)):
            serialized = node_secret_bytes(level, index)
            key = native.node_secret(level, index)
            other = reference.node_secret(level, index)
            self.assertEqual(serialized, int.from_bytes(serialized, "big").to_bytes(32, "big"))
            self.assertEqual(native.public(key), reference.public(other))
            self.assertEqual(native.sign(key, b"hardware-scale-v2"), reference.sign(other, b"hardware-scale-v2"))

    def test_all_scales_cached_signatures(self):
        backend = self.backend
        cache = {}
        for chains in CHAIN_COUNTS:
            with self.subTest(chains=chains):
                print(f"Checking {chains} cyclic-key chains", flush=True)
                profile = build_profile(chains, backend, cache)
                nonce = b"HWB2" + struct.pack(">I", chains) + bytes(24)
                message = challenge_digest(chains, nonce, bytes(32))
                l3 = backend.sign(backend.secret_from_ikm(bytes(range(32))), message)
                combined = l3
                l1_signatures = [backend.sign(backend.node_secret(1, i), message)
                                 for i in range(1, 11)]
                l2_signatures = {
                    i: backend.sign(backend.node_secret(2, i), message)
                    for i in range(1, min(chains // 10, 10) + 1)
                }
                for group in range(1, chains // 10 + 1):
                    signatures = list(l1_signatures)
                    signatures.append(l2_signatures[l2_cached_key_index(group)])
                    combined = backend.aggregate([combined, backend.aggregate(signatures)])
                public = bytes.fromhex(profile["aggregatePublicKey"])
                self.assertTrue(backend.verify([public], message, combined))
                self.assertTrue(backend.verify([bytes.fromhex(m["publicKey"]) for m in profile["members"]], message, combined))
                self.assertFalse(backend.verify([public], message + b"x", combined))
                missing = backend.aggregate_public([bytes.fromhex(m["publicKey"]) for m in profile["members"][:-1]])
                self.assertFalse(backend.verify([missing], message, combined))

    def test_l2_ten_key_cache_repeats_for_all_scales(self):
        backend = self.backend
        for chains in CHAIN_COUNTS:
            with self.subTest(chains=chains):
                profile = build_profile(chains, backend, {})
                l2_keys = [bytes.fromhex(member["publicKey"])
                           for member in profile["members"]
                           if member["level"] == 2]
                self.assertLessEqual(len(set(l2_keys)), 10)
                for index, public_key in enumerate(l2_keys, 1):
                    expected = backend.public(backend.node_secret(
                        2, l2_cached_key_index(index)))
                    self.assertEqual(public_key, expected)

    def test_l1_ten_key_cache_repeats_for_all_scales(self):
        backend = self.backend
        for chains in CHAIN_COUNTS:
            with self.subTest(chains=chains):
                profile = build_profile(chains, backend, {})
                l1_keys = [bytes.fromhex(member["publicKey"])
                           for member in profile["members"]
                           if member["level"] == 1]
                self.assertLessEqual(len(set(l1_keys)), 10)
                for index, public_key in enumerate(l1_keys, 1):
                    expected = backend.public(backend.node_secret(
                        1, l1_cached_key_index(index)))
                    self.assertEqual(public_key, expected)

    def test_packet_and_parallel_model(self):
        packet = group_packet(1, bytes(96))
        group = parse_group(packet)
        final = parse_final(final_packet(10, bytes(96), bytes(32)))
        timing = timing_summary([group], final, (1000, 1000, 1000))
        self.assertAlmostEqual(timing["parallelComputeEstimateMs"], 230)
        self.assertAlmostEqual(timing["serialCryptoMs"], 1475)
        damaged = bytearray(packet)
        damaged[30] ^= 1
        with self.assertRaises(ValueError):
            parse_group(bytes(damaged))
        self.assertEqual(read_packet(io.BytesIO(b"log\n\xa5" + packet), 1), packet)
        with self.assertRaises(ValueError):
            timing_summary([group, group], final, (1000, 1000, 1000))
        recovered = parse_final(final_packet(10, bytes(96), bytes(32), 32000, 1))
        self.assertEqual(recovered["usbRecoveryMs"], 32000)
        self.assertEqual(recovered["usbRetryCount"], 1)

    def test_repeated_serial_roundtrip(self):
        backend = self.backend
        profile = build_profile(10, backend, {})
        fixtures = {"profiles": {"10": profile}}
        class FakePort:
            def __init__(self):
                self.buffer = io.BytesIO(b"\xa5")
            def read(self, n):
                return self.buffer.read(min(n, 7))
            def flush(self):
                pass
            def write(self, nonce):
                message = challenge_digest(10, nonce, bytes(32))
                children = [backend.sign(backend.node_secret(1, i), message) for i in range(1, 11)]
                children.append(backend.sign(backend.node_secret(2, 1), message))
                subtree = backend.aggregate(children)
                aggregate = backend.aggregate([subtree, backend.sign(backend.secret_from_ikm(bytes(range(32))), message)])
                self.buffer = io.BytesIO(group_packet(1, subtree) + final_packet(10, aggregate, bytes(32)) + b"\xa5")
                return len(nonce)
        port = FakePort()
        args = SimpleNamespace(chains=0, ready_timeout=1, response_timeout=1,
                               l1_clock_hz=1000, l2_clock_hz=1000,
                               l3_clock_hz=1000, ca_cert=Path("ca_root.crt"))
        cache = {}
        with patch(
            "cluster_bls_hardware_scale_benchmark.read_quote",
            return_value=b"#QUOTE##END#",
        ), patch(
            "cluster_bls_hardware_scale_benchmark.verify_quote",
            return_value={"certificate": b"certificate"},
        ):
            first = run_once(port, args, backend, fixtures, cache)
            second = run_once(port, args, backend, fixtures, cache)
        self.assertTrue(first["verified"] and second["verified"])
        self.assertNotEqual(first["nonce"], second["nonce"])
        self.assertNotEqual(first["signature"], second["signature"])


if __name__ == "__main__":
    unittest.main()
