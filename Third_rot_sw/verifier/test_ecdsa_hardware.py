import io
import struct
import unittest
import zlib
from types import SimpleNamespace

from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec, utils

from ecdsa_hardware_common import (
    challenge_digest,
    prepare_public_keys,
    private_scalar,
    topology,
)
from ecdsa_hardware_test import run_once


def packet(data):
    return data + struct.pack(">I", zlib.crc32(data))


class FakePort:
    def __init__(self):
        self.stream = io.BytesIO(b"\xa5")

    def read(self, size):
        return self.stream.read(min(size, 7))

    def write(self, nonce):
        chains = int.from_bytes(nonce[4:8], "big")
        measurement = bytes(range(32))
        digest = challenge_digest(chains, nonce, measurement)
        response = packet(b"ECH1" + measurement)
        for level, index in topology(chains):
            key = ec.derive_private_key(
                private_scalar(level, index), ec.SECP384R1(),
                default_backend()
            )
            der = key.sign(
                digest, ec.ECDSA(utils.Prehashed(hashes.SHA384()))
            )
            r, s = utils.decode_dss_signature(der)
            raw = r.to_bytes(48, "big") + s.to_bytes(48, "big")
            response += packet(
                struct.pack(">4sIIQ", b"ECR1", level, index, 100) + raw
            )
        members = chains + chains // 10 + 1
        response += packet(struct.pack(">4sIII", b"ECF1", 0, chains, members))
        self.stream = io.BytesIO(response)
        return len(nonce)

    def flush(self):
        return None


class HardwareProtocolTest(unittest.TestCase):
    def test_partial_reads_and_two_consecutive_runs(self):
        args = SimpleNamespace(
            ready_timeout=1,
            response_timeout=1,
            l1_clock_hz=1000,
            l2_clock_hz=1000,
            l3_clock_hz=1000,
        )
        public_keys = prepare_public_keys(10)
        for _ in range(2):
            result = run_once(FakePort(), 10, public_keys, args)
            self.assertTrue(result["verified"])
            self.assertEqual(result["members"], 12)
            self.assertEqual(result["signatureBytes"], 1152)


if __name__ == "__main__":
    unittest.main()
