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

from ecdsa_hardware_common import (
    CHAIN_COUNTS,
    challenge_digest,
    percentiles,
    prepare_public_keys,
    topology,
    verify_raw,
)


PACKET_LENGTHS = {b"ECH1": 40, b"ECR1": 120, b"ECF1": 20}


def wait_progress(stage):
    started = time.monotonic()
    next_report = started + 10

    def report():
        nonlocal next_report
        now = time.monotonic()
        if now >= next_report:
            print(f"Waiting for {stage} ({now - started:.0f}s)...", flush=True)
            next_report = now + 10

    return report


def read_exact(port, size: int, timeout: float, on_wait=None) -> bytes:
    data = bytearray()
    deadline = time.monotonic() + timeout if timeout else None
    while len(data) < size:
        chunk = port.read(size - len(data))
        if chunk:
            data.extend(chunk)
            if timeout:
                deadline = time.monotonic() + timeout
        elif deadline is not None and time.monotonic() >= deadline:
            raise TimeoutError(f"received {len(data)}/{size} bytes")
        elif on_wait is not None:
            on_wait()
    return bytes(data)


def read_packet(port, timeout: float, on_wait=None) -> bytes:
    window = bytearray()
    deadline = time.monotonic() + timeout if timeout else None
    while True:
        byte = port.read(1)
        if byte:
            window.extend(byte)
            if len(window) > 4:
                del window[0]
            if timeout:
                deadline = time.monotonic() + timeout
            magic = bytes(window)
            if magic in PACKET_LENGTHS:
                packet = magic + read_exact(
                    port, PACKET_LENGTHS[magic] - 4, timeout, on_wait
                )
                body, crc = packet[:-4], packet[-4:]
                if zlib.crc32(body) != int.from_bytes(crc, "big"):
                    raise ValueError("ECDSA response CRC mismatch")
                return body
        elif deadline is not None and time.monotonic() >= deadline:
            raise TimeoutError("no ECDSA hardware response")
        elif on_wait is not None:
            on_wait()


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
            raise IOError("incomplete ECDSA challenge write")
        offset += written
    port.flush()


def parse_signature(packet: bytes, identity):
    if len(packet) != 116 or packet[:4] != b"ECR1":
        raise ValueError("invalid ECDSA signature response")
    level, index, cycles = struct.unpack_from(">IIQ", packet, 4)
    if (level, index) != identity:
        raise ValueError(
            f"unexpected ECDSA member L{level}/{index}, expected "
            f"L{identity[0]}/{identity[1]}"
        )
    return cycles, packet[20:]


def run_once(port, chains: int, public_keys, args):
    print("Waiting for L3 ready byte 0xa5...", flush=True)
    wait_ready(port, args.ready_timeout)
    nonce = b"EHW1" + struct.pack(">I", chains) + secrets.token_bytes(24)
    expected = list(topology(chains))
    started = time.perf_counter_ns()
    write_all(port, nonce)
    print("ECDSA challenge sent; waiting for L3 measurement...", flush=True)
    header = read_packet(
        port, args.response_timeout, wait_progress("L3 measurement header ECH1")
    )
    if len(header) != 36 or header[:4] != b"ECH1":
        raise ValueError("missing ECDSA measurement header")
    measurement = header[4:]
    digest = challenge_digest(chains, nonce, measurement)
    print(
        f"L3 measurement received; collecting {len(expected)} signatures "
        "(L3 -> L1 -> L2)...",
        flush=True,
    )
    records = []
    cycles_by_level = {1: [], 2: [], 3: []}
    for identity in expected:
        stage = (
            f"L{identity[0]}/{identity[1]} ECDSA signature; "
            f"received {len(records)}/{len(expected)}"
        )
        packet = read_packet(port, args.response_timeout, wait_progress(stage))
        if packet[:4] == b"ECF1":
            status, got_chains, completed = struct.unpack_from(">III", packet, 4)
            raise ValueError(
                f"hardware stopped at {completed}/{len(expected)}: "
                f"status={status}, chains={got_chains}"
            )
        cycles, signature = parse_signature(packet, identity)
        cycles_by_level[identity[0]].append(cycles)
        records.append((identity, signature))
        if chains == 10 or identity[0] != 1:
            print(
                f"Received {len(records)}/{len(expected)}: "
                f"L{identity[0]}/{identity[1]} ECDSA signature",
                flush=True,
            )
    print("All signatures received; waiting for L3 completion...", flush=True)
    final = read_packet(
        port, args.response_timeout, wait_progress("L3 completion packet ECF1")
    )
    if len(final) != 16 or final[:4] != b"ECF1":
        raise ValueError("missing ECDSA completion packet")
    status, got_chains, completed = struct.unpack_from(">III", final, 4)
    if status != 0 or got_chains != chains or completed != len(expected):
        raise ValueError(
            f"invalid ECDSA completion: status={status}, "
            f"chains={got_chains}, completed={completed}"
        )
    pipeline_ms = (time.perf_counter_ns() - started) / 1e6
    print(f"Verifying {len(records)} ECDSA signatures...", flush=True)
    verify_started = time.perf_counter_ns()
    for identity, signature in records:
        verify_raw(public_keys[identity], digest, signature)
    verification_ms = (time.perf_counter_ns() - verify_started) / 1e6
    result = {
        "chains": chains,
        "l1Nodes": chains,
        "l2Nodes": chains // 10,
        "members": len(expected),
        "verified": True,
        "nonce": nonce.hex(),
        "measurement": measurement.hex(),
        "signatureBytes": len(expected) * 96,
        "serialPipelineMs": pipeline_ms,
        "fullMemberVerificationMs": verification_ms,
        "nodeCycleStatistics": {
            f"L{level}Sign": percentiles(cycles_by_level[level])
            for level in (1, 2, 3)
        },
    }
    clocks = {
        1: args.l1_clock_hz,
        2: args.l2_clock_hz,
        3: args.l3_clock_hz,
    }
    if all(clocks.values()):
        durations_ms = [
            cycles / clocks[level] * 1000
            for level in (1, 2, 3)
            for cycles in cycles_by_level[level]
        ]
        result["serialSignMs"] = sum(durations_ms)
        result["parallelSignEstimateMs"] = max(durations_ms)
    return result


def main():
    parser = argparse.ArgumentParser(
        description="Three-level hardware ECDSA P-384 scale test"
    )
    parser.add_argument("chains", type=int, choices=CHAIN_COUNTS)
    parser.add_argument(
        "--port",
        default=os.environ.get(
            "VERIFIER_SERIAL_PORT",
            "/dev/serial/by-id/usb-Xilinx_VCU129_422029122114-if01-port0",
        ),
    )
    parser.add_argument("--baud", type=int, default=115200)
    parser.add_argument("--repeats", type=int, default=1)
    parser.add_argument("--ready-timeout", type=float, default=10)
    parser.add_argument("--response-timeout", type=float, default=0)
    parser.add_argument("--output", type=Path)
    for level in (1, 2, 3):
        parser.add_argument(f"--l{level}-clock-hz", type=float, default=0)
    args = parser.parse_args()
    clocks = (args.l1_clock_hz, args.l2_clock_hz, args.l3_clock_hz)
    if args.repeats < 1 or min(args.ready_timeout, args.response_timeout) < 0:
        parser.error("invalid repeat count or timeout")
    if min(clocks) < 0 or (any(clocks) and not all(clocks)):
        parser.error("provide all three positive clock frequencies or none")
    output = args.output or Path(f"ecdsa_hardware_results_{args.chains}.json")
    print(
        f"Preparing {args.chains + args.chains // 10 + 1} ECDSA public keys...",
        flush=True,
    )
    public_keys = prepare_public_keys(args.chains)
    import serial

    report = {
        "format": 1,
        "execution": "three-level-hardware",
        "scheme": "ECDSA-P384-SHA384",
        "testOnly": True,
        "keyPolicy": "one deterministic fixed key per logical member",
        "scope": "common-nonce signatures; excludes X.509 parsing",
        "parallelModel": "all independent L1/L2/L3 signers execute concurrently",
        "clockHz": list(clocks),
        "runs": [],
    }
    print(f"Opening L3 verifier UART: {args.port}", flush=True)
    try:
        with serial.Serial(
            args.port,
            args.baud,
            timeout=0.1,
            write_timeout=10,
            xonxoff=False,
            rtscts=False,
            dsrdtr=False,
        ) as port:
            for _ in range(args.repeats):
                result = run_once(port, args.chains, public_keys, args)
                report["runs"].append(result)
                fields = (
                    "serialPipelineMs",
                    "fullMemberVerificationMs",
                    "serialSignMs",
                    "parallelSignEstimateMs",
                )
                report["statistics"] = {
                    field: percentiles(
                        run[field] for run in report["runs"] if field in run
                    )
                    for field in fields
                    if field in result
                }
                output.write_text(
                    json.dumps(report, indent=2) + "\n", encoding="utf-8"
                )
                print(
                    f"PASS: {result['chains']} chains, "
                    f"{result['members']} independent hardware signatures; "
                    f"pipeline={result['serialPipelineMs']:.3f} ms; "
                    f"verify={result['fullMemberVerificationMs']:.3f} ms",
                    flush=True,
                )
    except (Exception, KeyboardInterrupt) as error:
        report["error"] = str(error) or "interrupted"
        output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
        raise
    print(json.dumps(report["statistics"], indent=2))


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("ECDSA test interrupted")
        raise SystemExit(130)
    except Exception as error:
        print(f"ECDSA test failed: {error}")
        raise SystemExit(1)
