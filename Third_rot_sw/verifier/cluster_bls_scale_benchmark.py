#!/usr/bin/env python3

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import statistics
import sys
import time
from pathlib import Path
from typing import Any, Callable


SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

import protocol


TEST_KEY_DOMAIN = b"CLUSTER-BLS-scale-benchmark-key-v1\x00"
TEST_NONCE_DOMAIN = b"CLUSTER-BLS-scale-benchmark-nonce-v1\x00"
TEST_MEASUREMENT_DOMAIN = b"CLUSTER-BLS-scale-benchmark-measurement-v1\x00"


def _derive_test_key(index: int) -> tuple[Any, bytes]:
    digest = hashlib.sha256(TEST_KEY_DOMAIN + index.to_bytes(8, "big")).digest()
    scalar = int.from_bytes(digest, "big") % protocol._default_ec.n
    if scalar == 0:
        scalar = 1
    secret_key = protocol._PrivateKey.from_int(scalar)
    return secret_key, bytes(secret_key.get_g1())


def _member(node_id: str, level: str, parent_node_id: str | None,
            public_key: bytes) -> dict[str, Any]:
    result: dict[str, Any] = {
        "nodeID": node_id,
        "keyID": protocol.key_id_for_public_key(public_key).hex(),
        "blsPublicKey": public_key.hex(),
        "status": "active",
        "level": level,
    }
    if parent_node_id is not None:
        result["parentNodeID"] = parent_node_id
    return result


def _prepare_case(chain_count: int) -> dict[str, Any]:
    started = time.perf_counter()
    secret_keys: list[Any] = []
    members: list[dict[str, Any]] = []

    l3_secret, l3_public = _derive_test_key(0)
    secret_keys.append(l3_secret)
    members.append(_member("L3-0001", "L3", None, l3_public))

    for chain_index in range(chain_count):
        l2_node_id = f"L2-{chain_index + 1:04d}"
        l1_node_id = f"L1-{chain_index + 1:04d}"
        l2_secret, l2_public = _derive_test_key(1 + chain_index * 2)
        l1_secret, l1_public = _derive_test_key(2 + chain_index * 2)
        secret_keys.extend((l2_secret, l1_secret))
        members.append(_member(l2_node_id, "L2", "L3-0001", l2_public))
        members.append(_member(l1_node_id, "L1", l2_node_id, l1_public))

    key_list = protocol.build_key_list(
        f"BENCH-{chain_count}", 1, members
    )
    nonce = hashlib.sha256(
        TEST_NONCE_DOMAIN + chain_count.to_bytes(8, "big")
    ).digest()
    measurement_digest = hashlib.sha256(
        TEST_MEASUREMENT_DOMAIN + chain_count.to_bytes(8, "big")
    ).digest()
    list_digest = protocol.key_list_digest(key_list)
    message = protocol.build_challenge_message(
        str(key_list["clusterID"]),
        int(key_list["epoch"]),
        nonce,
        measurement_digest,
        list_digest,
    )

    aggregate_secret = protocol._PrivateKey.aggregate(secret_keys)
    aggregate_signature = protocol.sign_message(aggregate_secret, message)
    participant_ids = sorted(member["nodeID"] for member in members)
    response = protocol.make_aggregate_response(
        key_list, participant_ids, aggregate_signature
    )
    aggregate_public_key = bytes.fromhex(response["aggregatePublicKey"])

    return {
        "chains": chain_count,
        "participants": len(members),
        "keyList": key_list,
        "response": response,
        "nonce": nonce,
        "measurementDigest": measurement_digest,
        "message": message,
        "aggregateSignature": aggregate_signature,
        "aggregatePublicKey": aggregate_public_key,
        "preparationSeconds": time.perf_counter() - started,
    }


def _measure(operation: Callable[[], bool], repeats: int) -> list[float]:
    samples: list[float] = []
    for _ in range(repeats):
        started = time.perf_counter_ns()
        verified = operation()
        elapsed_ns = time.perf_counter_ns() - started
        if not verified:
            raise RuntimeError("timed BLS verification failed")
        samples.append(elapsed_ns / 1_000_000_000.0)
    return samples


def _summarize(samples: list[float], chains: int) -> dict[str, float]:
    mean_seconds = statistics.fmean(samples)
    ordered = sorted(samples)
    p95_index = max(0, (95 * len(ordered) + 99) // 100 - 1)
    return {
        "meanMs": mean_seconds * 1000.0,
        "medianMs": statistics.median(samples) * 1000.0,
        "minMs": min(samples) * 1000.0,
        "p95Ms": ordered[p95_index] * 1000.0,
        "chainsPerSecond": chains / mean_seconds,
        "microsecondsPerChain": mean_seconds * 1_000_000.0 / chains,
    }


def _run_case(chain_count: int, full_repeats: int,
              cached_repeats: int) -> dict[str, Any]:
    case = _prepare_case(chain_count)
    key_list = case["keyList"]
    response = case["response"]
    nonce = case["nonce"]
    measurement_digest = case["measurementDigest"]
    aggregate_public_key = case["aggregatePublicKey"]
    message = case["message"]
    aggregate_signature = case["aggregateSignature"]

    full_samples = _measure(
        lambda: protocol.verify_aggregate_response(
            key_list, response, nonce, measurement_digest
        ),
        full_repeats,
    )
    cached_samples = _measure(
        lambda: protocol.fast_aggregate_verify(
            [aggregate_public_key], message, aggregate_signature
        ),
        cached_repeats,
    )

    return {
        "chains": chain_count,
        "participants": case["participants"],
        "topology": "1 shared L3 + N L2 + N L1",
        "currentWireParticipantLimit": 255,
        "fitsCurrentWireFormat": case["participants"] <= 255,
        "aggregateSignatureBytes": len(aggregate_signature),
        "preparationSeconds": case["preparationSeconds"],
        "fullProtocolRepeats": full_repeats,
        "fullProtocol": _summarize(full_samples, chain_count),
        "cachedAggregateKeyRepeats": cached_repeats,
        "cachedAggregateKey": _summarize(cached_samples, chain_count),
    }


def _write_csv(path: Path, results: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as output:
        writer = csv.writer(output)
        writer.writerow([
            "chains", "participants", "preparation_seconds",
            "full_mean_ms", "full_p95_ms", "full_chains_per_second",
            "cached_mean_ms", "cached_p95_ms", "cached_chains_per_second",
        ])
        for result in results:
            writer.writerow([
                result["chains"],
                result["participants"],
                f'{result["preparationSeconds"]:.6f}',
                f'{result["fullProtocol"]["meanMs"]:.6f}',
                f'{result["fullProtocol"]["p95Ms"]:.6f}',
                f'{result["fullProtocol"]["chainsPerSecond"]:.6f}',
                f'{result["cachedAggregateKey"]["meanMs"]:.6f}',
                f'{result["cachedAggregateKey"]["p95Ms"]:.6f}',
                f'{result["cachedAggregateKey"]["chainsPerSecond"]:.6f}',
            ])


def _print_result(result: dict[str, Any]) -> None:
    full = result["fullProtocol"]
    cached = result["cachedAggregateKey"]
    print(
        f'\n[{result["chains"]} chains / {result["participants"]} BLS participants]'
    )
    print(f'Preparation (not benchmarked): {result["preparationSeconds"]:.3f} s')
    print(
        "Current full verifier: "
        f'{full["meanMs"]:.3f} ms mean, {full["p95Ms"]:.3f} ms p95, '
        f'{full["chainsPerSecond"]:.2f} chains/s'
    )
    print(
        "Cached aggregate-key BLS core: "
        f'{cached["meanMs"]:.3f} ms mean, {cached["p95Ms"]:.3f} ms p95, '
        f'{cached["chainsPerSecond"]:.2f} chains/s'
    )
    print(
        f'Aggregate signature size: {result["aggregateSignatureBytes"]} bytes'
    )
    if not result["fitsCurrentWireFormat"]:
        print(
            "Wire-format note: offline scale test only; the current one-byte "
            "participant count cannot carry this case"
        )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Benchmark simulated Cluster-BLS certificate-chain aggregation"
    )
    parser.add_argument(
        "--chains", type=int, nargs="+", default=[100, 1000]
    )
    parser.add_argument("--full-repeats", type=int, default=1)
    parser.add_argument("--cached-repeats", type=int, default=3)
    parser.add_argument(
        "--json-output", type=Path,
        default=SCRIPT_DIR / "cluster_bls_scale_results.json",
    )
    parser.add_argument(
        "--csv-output", type=Path,
        default=SCRIPT_DIR / "cluster_bls_scale_results.csv",
    )
    args = parser.parse_args()
    if any(value <= 0 for value in args.chains):
        parser.error("every chain count must be positive")
    if args.full_repeats <= 0 or args.cached_repeats <= 0:
        parser.error("repeat counts must be positive")
    return args


def main() -> int:
    args = parse_args()
    results: list[dict[str, Any]] = []
    print("Cluster-BLS certificate-chain scale benchmark")
    print("Topology: one shared L3, one L2 and one L1 per logical chain")
    print("Key generation and fixture preparation are outside verification timing")
    for chain_count in args.chains:
        result = _run_case(
            chain_count, args.full_repeats, args.cached_repeats
        )
        results.append(result)
        _print_result(result)

    args.json_output.parent.mkdir(parents=True, exist_ok=True)
    args.json_output.write_text(
        json.dumps(results, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    _write_csv(args.csv_output, results)
    print(f"\nJSON results: {args.json_output}")
    print(f"CSV results:  {args.csv_output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
