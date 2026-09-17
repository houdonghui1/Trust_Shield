#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import secrets
import struct
import time
import zlib
from pathlib import Path
from cluster_bls_hardware_common import (
    Backend, CHAIN_COUNTS, L1_CACHED_KEY_COUNT, L2_CACHED_KEY_COUNT,
    PROFILE_DERIVATION,
    challenge_digest, parse_group, parse_final, timing_summary,
)
from attestation_scale_quote import (
    load_expected_measurement, read_quote, verify_quote,
)

DEFAULT_L2_MCYCLE_HZ = 100_000_000.0
DEFAULT_L3_MCYCLE_HZ = 24_000_000.0


def read_packet(port, timeout):
    buffer = bytearray()
    last = time.monotonic()
    while timeout == 0 or time.monotonic() - last < timeout:
        data = port.read(1)
        if not data:
            continue
        last = time.monotonic()
        buffer += data
        if len(buffer) > 4 and buffer[:4] not in (b"BHG2", b"BHR2"):
            del buffer[0]
        if buffer[:4] in (b"BHG2", b"BHR2"):
            length = 304 if buffer[:4] == b"BHG2" else 168
            while len(buffer) < length:
                chunk = port.read(length - len(buffer))
                if chunk:
                    buffer += chunk
                    last = time.monotonic()
                elif timeout and time.monotonic() - last >= timeout:
                    raise TimeoutError("incomplete hardware response")
            if buffer[:4] == b"BHR2" and zlib.crc32(buffer[:-4]) != int.from_bytes(buffer[-4:], "big"):
                while len(buffer) < 176:
                    chunk = port.read(176 - len(buffer))
                    if chunk:
                        buffer += chunk
                        last = time.monotonic()
                    elif timeout and time.monotonic() - last >= timeout:
                        raise TimeoutError("incomplete hardware response")
            return bytes(buffer)
    raise TimeoutError("no hardware scale response")


def wait_ready(port, timeout):
    start = time.monotonic()
    while timeout == 0 or time.monotonic() - start < timeout:
        if port.read(1) == b"\xa5":
            return
    raise TimeoutError("L3 did not send ready byte 0xa5")


def validate_roster(profile, chains, backend):
    members = profile["members"]
    expected = [(3, 1)] + [(2, i) for i in range(1, chains // 10 + 1)] + [(1, i) for i in range(1, chains + 1)]
    if [(m["level"], m["index"]) for m in members] != expected:
        raise ValueError("fixture membership mismatch; regenerate v2 fixtures")
    keys = [bytes.fromhex(m["publicKey"]) for m in members]
    if any(len(k) != 48 for k in keys):
        raise ValueError("invalid fixture public keys")
    l2_keys = [bytes.fromhex(m["publicKey"]) for m in members if m["level"] == 2]
    l1_keys = [bytes.fromhex(m["publicKey"]) for m in members if m["level"] == 1]
    l2_unique = l2_keys[:min(L2_CACHED_KEY_COUNT, len(l2_keys))]
    l1_unique = l1_keys[:min(L1_CACHED_KEY_COUNT, len(l1_keys))]
    if (len(set(l1_unique)) != len(l1_unique) or
            any(key != l1_unique[i % len(l1_unique)]
                for i, key in enumerate(l1_keys)) or
            len(set(l2_unique)) != len(l2_unique) or
            any(key != l2_unique[i % len(l2_unique)]
                for i, key in enumerate(l2_keys)) or
            set(l1_unique).intersection(l2_unique)):
        raise ValueError("invalid cyclic L1/L2 public-key roster")
    combined = backend.aggregate_public(keys)
    if combined.hex() != profile["aggregatePublicKey"]:
        raise ValueError("fixture aggregate public key mismatch")
    return keys, combined


def run_once(port, args, backend, fixtures, roster_cache):
    wait_ready(port, args.ready_timeout)
    nonce = b"HWB2" + struct.pack(">I", args.chains) + secrets.token_bytes(24)
    request_started = time.perf_counter_ns()
    if port.write(nonce) != len(nonce):
        raise IOError("incomplete nonce send")
    port.flush()
    groups = []
    while True:
        packet = read_packet(port, args.response_timeout)
        if packet[:4] == b"BHG2":
            group = parse_group(packet)
            if group["group"] != len(groups) + 1 or len(groups) >= 1000:
                raise ValueError("unexpected group number")
            groups.append(group)
        else:
            final = parse_final(packet)
            break
    aggregate_elapsed_ms = (time.perf_counter_ns() - request_started) / 1e6
    chains = final["chains"]
    if args.chains and chains != args.chains:
        raise ValueError("firmware chain count mismatch")
    if len(groups) != final["l2Nodes"]:
        raise ValueError("incomplete group telemetry")
    if sum(g["l3AggregateCycles"] for g in groups) != final["l3AggregateCycles"]:
        raise ValueError("inconsistent aggregation timing")
    if chains not in roster_cache:
        profile = fixtures["profiles"].get(str(chains))
        if profile is None:
            raise ValueError(f"generate public fixture for {chains} chains first")
        _, roster_cache[chains] = validate_roster(profile, chains, backend)
    combined = roster_cache[chains]
    message = challenge_digest(chains, nonce, bytes.fromhex(final["measurement"]))
    signature = bytes.fromhex(final["signature"])
    measurement = bytes.fromhex(final["measurement"])
    if measurement != args.expected_measurement:
        raise ValueError("PCR verification failed")
    verify_started = time.perf_counter_ns()
    cached_ok = backend.verify([combined], message, signature)
    verify_ms = (time.perf_counter_ns() - verify_started) / 1e6
    if not cached_ok:
        raise ValueError("final cyclic-roster aggregate verification failed")
    quote_frame = read_quote(port, args.response_timeout)
    quote = verify_quote(
        quote_frame, nonce, args.ca_cert, b"BLS1", chains,
        final["members"], measurement, signature,
        message,
    )
    attestation_elapsed_ms = (time.perf_counter_ns() - request_started) / 1e6
    recovery_ms = float(final["usbRecoveryMs"])
    pipeline_ms = max(0.0, aggregate_elapsed_ms - recovery_ms)
    result = {**final, "nonce": nonce.hex(), "groups": groups,
              "serialPipelineMs": pipeline_ms,
              "attestationTotalMs": max(
                  0.0, attestation_elapsed_ms - recovery_ms),
              "finalVerificationMs": verify_ms, "verified": True,
              "quoteVerified": True,
              "quoteBytes": len(quote_frame),
              "quoteCertificateBytes": len(quote["certificate"]),
              "benchmarkMode": "10-key cyclic signature cache",
              "physicalL1Signatures": sum(
                  value != 0 for group in groups
                  for value in group["l1SignCycles"]),
              "physicalL2Signatures": sum(
                  group["l2SignCycles"] != 0 for group in groups)}
    result["aggregationMs"] = (
        sum(group["l2AggregateCycles"] for group in groups) /
        args.l2_clock_hz +
        final["l3AggregateCycles"] / args.l3_clock_hz
    ) * 1000
    clocks = (args.l1_clock_hz, args.l2_clock_hz, args.l3_clock_hz)
    if all(clocks):
        result.update(timing_summary(groups, final, clocks))
    print(f"Quote parsed: {len(quote_frame)} bytes", flush=True)
    print("AK certificate signature verification passed", flush=True)
    print("PCR verification passed", flush=True)
    print("Nonce verification passed", flush=True)
    print("ML-DSA Quote signature verification passed", flush=True)
    print("BLS aggregate signature verification passed", flush=True)
    print(f"Chains: {chains}", flush=True)
    print(f"Devices: {final['members']}", flush=True)
    print(f"Total time: {result['attestationTotalMs']:.3f} ms", flush=True)
    print(f"Aggregation time: {result['aggregationMs']:.3f} ms", flush=True)
    print(f"Verification time: {verify_ms:.3f} ms", flush=True)
    return result


def main():
    parser = argparse.ArgumentParser(description="Logical-node BLS hardware scale test v2")
    parser.add_argument(
        "--port",
        default=os.environ.get(
            "VERIFIER_SERIAL_PORT",
            "/dev/serial/by-id/usb-Xilinx_VCU129_422029122114-if01-port0",
        ),
    )
    parser.add_argument("--baud", type=int, default=115200)
    parser.add_argument("--chains", type=int, choices=(0,) + CHAIN_COUNTS, default=0,
                        help="0 uses CLUSTER_BLS_SCALE_CHAIN_COUNT in L3 firmware")
    parser.add_argument("--repeats", type=int, default=5)
    parser.add_argument("--backend", choices=["native", "reference"], default="native")
    parser.add_argument("--profiles", type=Path,
                        default=Path(__file__).with_name("cluster_bls_hardware_profiles_v2.json"))
    parser.add_argument("--ca-cert", type=Path,
                        default=Path(__file__).with_name("ca_root.crt"))
    parser.add_argument("--pcr-file", type=Path,
                        default=Path(__file__).with_name("pcr_expect.txt"))
    parser.add_argument("--output", type=Path, default=Path("hardware_scale_results_v2.json"))
    parser.add_argument("--ready-timeout", type=float, default=10)
    parser.add_argument("--response-timeout", type=float, default=0)
    parser.add_argument("--l1-clock-hz", type=float, default=0)
    parser.add_argument(
        "--l2-clock-hz", type=float,
        default=float(os.environ.get("L2_MCYCLE_HZ", DEFAULT_L2_MCYCLE_HZ)),
    )
    parser.add_argument(
        "--l3-clock-hz", type=float,
        default=float(os.environ.get("L3_MCYCLE_HZ", DEFAULT_L3_MCYCLE_HZ)),
    )
    args = parser.parse_args()
    try:
        args.expected_measurement = load_expected_measurement(args.pcr_file)
    except ValueError as error:
        parser.error(str(error))
    clocks = (args.l1_clock_hz, args.l2_clock_hz, args.l3_clock_hz)
    if (args.repeats < 1 or args.l1_clock_hz < 0 or
            args.l2_clock_hz <= 0 or args.l3_clock_hz <= 0 or
            min(args.ready_timeout, args.response_timeout) < 0):
        parser.error("invalid count, frequency or timeout")
    fixtures = json.loads(args.profiles.read_text(encoding="utf-8"))
    if (fixtures.get("format") != 2 or fixtures.get("testOnly") is not True or
            fixtures.get("derivation") != PROFILE_DERIVATION):
        parser.error("v2 test public roster required")
    backend = Backend(args.backend)
    import serial
    runs, roster_cache = [], {}
    report = {"format": 2, "backend": args.backend, "clockHz": list(clocks),
              "parallelModel": "10 sampled L1 and 10 sampled L2 signs; all logical groups and L3 sign concurrently; barrier; one serial L3 aggregator; no communication",
              "runs": runs}
    with serial.Serial(args.port, args.baud, timeout=.1, write_timeout=10,
                       xonxoff=False, rtscts=False, dsrdtr=False) as port:
        for _ in range(args.repeats):
            try:
                runs.append(run_once(port, args, backend, fixtures, roster_cache))
                metrics = ("serialPipelineMs", "attestationTotalMs",
                           "aggregationMs", "finalVerificationMs", "serialCryptoMs",
                           "parallelComputeEstimateMs")
                report["averageMs"] = {
                    name: sum(r[name] for r in runs if name in r) /
                          sum(name in r for r in runs)
                    for name in metrics if any(name in r for r in runs)
                }
                args.output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
            except (Exception, KeyboardInterrupt) as exc:
                report["error"] = str(exc) or "interrupted"
                args.output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
                raise


if __name__ == "__main__":
    main()
