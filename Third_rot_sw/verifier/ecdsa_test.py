#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import os
import secrets
import struct
import time
from datetime import datetime
from pathlib import Path

from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.x509.oid import NameOID

from attestation_scale_quote import (
    QUOTE_END,
    QUOTE_START,
    load_certificate as load_certificate_bytes,
    load_expected_measurement,
    parse_quote,
    read_exact,
    verify_certificate_signature,
    verify_quote,
    wait_ready,
    write_all,
)


CHAIN_COUNTS = (10, 100, 1000, 10000)
DEFAULT_L2_MCYCLE_HZ = 100_000_000.0
DEFAULT_L3_MCYCLE_HZ = 24_000_000.0
P384_ORDER = int(
    "ffffffffffffffffffffffffffffffffffffffffffffffffc7634d81f4372ddf"
    "581a0db248b0a77aecec196accc52973",
    16,
)
def percentile(values, quantile):
    ordered = sorted(values)
    position = (len(ordered) - 1) * quantile
    low = int(position)
    high = min(low + 1, len(ordered) - 1)
    return ordered[low] + (ordered[high] - ordered[low]) * (position - low)


def statistics(values):
    return {
        "count": len(values),
        "mean": sum(values) / len(values),
        "P50": percentile(values, 0.50),
        "P95": percentile(values, 0.95),
        "P99": percentile(values, 0.99),
    }


def private_key(label):
    digest = hashlib.sha384(b"ECDSA-CERT-CHAIN-v1/" + label).digest()
    scalar = int.from_bytes(digest, "big") % (P384_ORDER - 1) + 1
    return ec.derive_private_key(scalar, ec.SECP384R1(), default_backend())


def name(common_name):
    return x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, common_name)])


def build_certificate(subject, issuer, public_key, issuer_key, serial, is_ca, path_length):
    builder = (
        x509.CertificateBuilder()
        .subject_name(subject)
        .issuer_name(issuer)
        .public_key(public_key)
        .serial_number(serial)
        .not_valid_before(datetime(2025, 1, 1))
        .not_valid_after(datetime(2035, 1, 1))
        .add_extension(
            x509.BasicConstraints(ca=is_ca, path_length=path_length), critical=True
        )
        .add_extension(
            x509.KeyUsage(
                digital_signature=True,
                content_commitment=False,
                key_encipherment=False,
                data_encipherment=False,
                key_agreement=False,
                key_cert_sign=is_ca,
                crl_sign=is_ca,
                encipher_only=False,
                decipher_only=False,
            ),
            critical=True,
        )
    )
    return builder.sign(issuer_key, hashes.SHA384(), default_backend())


def generated_fixtures():
    root_key = private_key(b"L3/1")
    root_name = name("L3-001")
    root = build_certificate(
        root_name, root_name, root_key.public_key(), root_key, 1, True, 1
    )
    l2_keys = []
    l2_certificates = []
    l1_certificates = []
    for parent_slot in range(1, 11):
        key = private_key(f"L2/{parent_slot}".encode("ascii"))
        subject = name(f"L2-{parent_slot:03d}")
        certificate = build_certificate(
            subject,
            root.subject,
            key.public_key(),
            root_key,
            1000 + parent_slot,
            True,
            0,
        )
        l2_keys.append(key)
        l2_certificates.append(certificate)
        children = []
        for child_slot in range(1, 11):
            child_key = private_key(
                f"L1/{parent_slot}/{child_slot}".encode("ascii")
            )
            children.append(
                build_certificate(
                    name(f"L1-{parent_slot:02d}-{child_slot:02d}"),
                    subject,
                    child_key.public_key(),
                    key,
                    100000 + parent_slot * 100 + child_slot,
                    False,
                    None,
                )
            )
        l1_certificates.append(children)
    return root, l2_certificates, l1_certificates


def load_certificate(path):
    data = path.read_bytes()
    try:
        return x509.load_pem_x509_certificate(data, default_backend())
    except ValueError:
        return x509.load_der_x509_certificate(data, default_backend())


def supplied_fixtures(root_path, l2_path, l1_path):
    root = load_certificate(root_path)
    l2 = load_certificate(l2_path)
    l1 = load_certificate(l1_path)
    return root, [l2] * 10, [[l1] * 10 for _ in range(10)]


def require_p384(certificate):
    key = certificate.public_key()
    if not isinstance(key, ec.EllipticCurvePublicKey) or not isinstance(
        key.curve, ec.SECP384R1
    ):
        raise ValueError("all certificates must use ECDSA P-384 public keys")
    if not isinstance(certificate.signature_hash_algorithm, hashes.SHA384):
        raise ValueError("all certificates must use ECDSA with SHA-384")


def basic_constraints(certificate):
    return certificate.extensions.get_extension_for_class(x509.BasicConstraints).value


def verify_signature(certificate, issuer_certificate):
    issuer_certificate.public_key().verify(
        certificate.signature,
        certificate.tbs_certificate_bytes,
        ec.ECDSA(certificate.signature_hash_algorithm),
    )


def validate_fixtures(root, l2_certificates, l1_certificates):
    require_p384(root)
    if root.issuer != root.subject or not basic_constraints(root).ca:
        raise ValueError("invalid L3 root certificate")
    verify_signature(root, root)
    for parent_slot in range(10):
        l2 = l2_certificates[parent_slot]
        require_p384(l2)
        if l2.issuer != root.subject or not basic_constraints(l2).ca:
            raise ValueError("invalid L2 certificate")
        verify_signature(l2, root)
        for l1 in l1_certificates[parent_slot]:
            require_p384(l1)
            if l1.issuer != l2.subject or basic_constraints(l1).ca:
                raise ValueError("invalid L1 certificate")
            verify_signature(l1, l2)


def verify_all(chains, root, l2_certificates, l1_certificates):
    calls = 0
    verify_signature(root, root)
    calls += 1
    for group in range(chains // 10):
        parent_slot = group % 10
        l2 = l2_certificates[parent_slot]
        verify_signature(l2, root)
        calls += 1
        for child_slot in range(10):
            verify_signature(l1_certificates[parent_slot][child_slot], l2)
            calls += 1
    return calls


def logical_der_bytes(chains, root, l2_certificates, l1_certificates):
    sizes = {
        "root": len(root.public_bytes(serialization.Encoding.DER)),
        "l2": [len(cert.public_bytes(serialization.Encoding.DER)) for cert in l2_certificates],
        "l1": [
            [len(cert.public_bytes(serialization.Encoding.DER)) for cert in children]
            for children in l1_certificates
        ],
    }
    total = sizes["root"]
    for group in range(chains // 10):
        parent_slot = group % 10
        total += sizes["l2"][parent_slot]
        total += sum(sizes["l1"][parent_slot])
    return total


def read_exact_with_progress(port, length, timeout, message):
    data = bytearray()
    started = time.monotonic()
    deadline = started + timeout if timeout else None
    next_progress = started + 10
    while len(data) < length:
        chunk = port.read(length - len(data))
        now = time.monotonic()
        if chunk:
            data.extend(chunk)
            if timeout:
                deadline = now + timeout
        elif deadline is not None and now >= deadline:
            raise TimeoutError(f"{message} timed out after receiving {len(data)}/{length} bytes")
        if now >= next_progress:
            print(f"{message}: {int(now - started)} s", flush=True)
            next_progress = now + 10
    return bytes(data)


def read_quote_with_progress(port, timeout, message):
    data = bytearray()
    started = time.monotonic()
    deadline = started + timeout if timeout else None
    next_progress = started + 10
    while True:
        byte = port.read(1)
        now = time.monotonic()
        if byte:
            data.extend(byte)
            if timeout:
                deadline = now + timeout
            start = data.find(QUOTE_START)
            if start >= 0:
                end = data.find(QUOTE_END, start + len(QUOTE_START))
                if end >= 0:
                    return bytes(data[start:end + len(QUOTE_END)])
            elif len(data) > len(QUOTE_START):
                del data[:-len(QUOTE_START)]
        elif deadline is not None and now >= deadline:
            raise TimeoutError(f"{message} timed out")
        if now >= next_progress:
            print(f"{message}: {int(now - started)} s", flush=True)
            next_progress = now + 10


def receive_current_certificates(port, nonce, timeout, chains):
    header = read_exact_with_progress(
        port,
        8,
        timeout,
        f"ECDSA hardware verification in progress "
        f"(L2: {chains}, L3: {chains // 10})",
    )
    if header[:4] != b"KLV1":
        raise ValueError(f"L3 did not return the certificate list: {header[:4]!r}")
    total_length = int.from_bytes(header[4:8], "big")
    if total_length < 8 + 1 + 1 + 8 + 32 + 3 * 162 + 12 + 96:
        raise ValueError("certificate-list packet is too short")
    if total_length > 22528:
        raise ValueError("certificate-list packet exceeds the firmware bound")
    packet = header + read_exact(port, total_length - 8, timeout)
    signature_offset = len(packet) - 96
    offset = 8

    def take(length):
        nonlocal offset
        if length < 0 or offset + length > signature_offset:
            raise ValueError("truncated certificate-list packet")
        value = packet[offset:offset + length]
        offset += length
        return value

    if take(1) != b"\x01":
        raise ValueError("unsupported certificate-list version")
    cluster_length = take(1)[0]
    if not 1 <= cluster_length <= 128:
        raise ValueError("invalid certificate-list cluster identifier")
    take(cluster_length)
    take(8)
    if take(32) != nonce:
        raise ValueError("certificate-list nonce does not match the challenge")
    take(3 * 162)
    lengths = [int.from_bytes(take(4), "big") for _ in range(3)]
    if not all(0 < length <= 8192 for length in lengths):
        raise ValueError("invalid certificate length")
    certificates = [load_certificate_bytes(take(length)) for length in lengths]
    if offset != signature_offset:
        raise ValueError("unexpected certificate-list trailing data")
    return certificates


def describe_hardware_chain(root, l3, l2, l1):
    algorithms = []
    for label, certificate in (("CA", root), ("L3", l3),
                               ("L2", l2), ("L1", l1)):
        key = certificate.public_key()
        if not isinstance(key, ec.EllipticCurvePublicKey):
            raise ValueError(f"{label} certificate does not use an ECDSA public key")
        algorithms.append({
            "level": label,
            "curve": key.curve.name,
            "signatureHash": (
                certificate.signature_hash_algorithm.name
                if certificate.signature_hash_algorithm is not None else "none"
            ),
            "subject": certificate.subject.rfc4514_string(),
            "issuer": certificate.issuer.rfc4514_string(),
        })
    return algorithms


def parse_hierarchical_verification(block, chains):
    metadata = block[42:]
    if len(metadata) != 96 or metadata[:4] != b"EVT1":
        raise ValueError("Quote does not contain hierarchical ECDSA telemetry")
    status = int.from_bytes(metadata[4:8], "big")
    l2_completed = int.from_bytes(metadata[8:12], "big")
    l3_completed = int.from_bytes(metadata[12:16], "big")
    l2_cycles = int.from_bytes(metadata[16:24], "big")
    l3_cycles = int.from_bytes(metadata[24:32], "big")
    if status != 0:
        raise ValueError(f"hierarchical ECDSA verification failed: status={status}")
    if l2_completed != chains:
        raise ValueError(
            f"L2 verified {l2_completed}/{chains} L1 certificates"
        )
    expected_l3 = chains // 10
    if l3_completed != expected_l3:
        raise ValueError(
            f"L3 verified {l3_completed}/{expected_l3} L2 certificates"
        )
    return {
        "l2VerifiedL1Certificates": l2_completed,
        "l3VerifiedL2Certificates": l3_completed,
        "l2VerificationCycles": l2_cycles,
        "l3VerificationCycles": l3_cycles,
    }


def hardware_run(port, args, root):
    print("Waiting for L3 ready...", flush=True)
    wait_ready(port, args.ready_timeout)
    nonce = b"ECQ1" + struct.pack(">I", args.chains) + secrets.token_bytes(24)
    started = time.perf_counter_ns()
    write_all(port, nonce)
    print("ECDSA challenge sent; L2/L3 verification started.", flush=True)
    l3, l2, l1 = receive_current_certificates(
        port, nonce, args.response_timeout, args.chains
    )
    print(
        "Certificate list received; waiting for L2/L3 verification and Quote...",
        flush=True,
    )
    frame = read_quote_with_progress(
        port,
        args.response_timeout,
        f"ECDSA hardware verification in progress "
        f"(L2: {args.chains}, L3: {args.chains // 10})",
    )
    print("Quote received; verifying AK, PCR, nonce and ML-DSA...", flush=True)
    parsed = parse_quote(frame)
    quote_digest = hashlib.sha256(
        b"ECQ1" + struct.pack(">I", args.chains) + nonce +
        parsed["measurement"]
    ).digest()
    quote = verify_quote(
        frame, nonce, args.ca_cert, b"ECD1", args.chains,
        args.chains + args.chains // 10 + 1,
        expected_measurement=args.expected_measurement,
        expected_proof=parsed["block"][42:], expected_digest=quote_digest,
    )
    quote_ms = (time.perf_counter_ns() - started) / 1e6
    quote_l3 = load_certificate_bytes(quote["certificate"])
    if quote_l3.fingerprint(hashes.SHA256()) != l3.fingerprint(hashes.SHA256()):
        raise ValueError("Quote AK certificate does not match the L3 certificate list")
    algorithms = describe_hardware_chain(root, l3, l2, l1)
    if not basic_constraints(root).ca or not basic_constraints(l3).ca or \
            not basic_constraints(l2).ca or basic_constraints(l1).ca:
        raise ValueError("invalid CA constraints in the hardware certificate chain")
    if l3.issuer != root.subject or l2.issuer != l3.subject or \
            l1.issuer != l2.subject:
        raise ValueError("certificate issuer/subject hierarchy does not match")
    telemetry = parse_hierarchical_verification(parsed["block"], args.chains)
    verifier_ms = quote["certificateVerificationMs"]
    result = {
        "quoteRoundTripMs": quote_ms,
        "verificationCalls": args.chains + args.chains // 10 + 1,
        "verifierVerifiedL3Certificates": 1,
        "verifierL3VerificationMs": verifier_ms,
        "certificateAlgorithms": algorithms,
    }
    result.update(telemetry)
    if args.l2_clock_hz:
        result["l2VerificationMs"] = (
            telemetry["l2VerificationCycles"] * 1000 / args.l2_clock_hz
        )
    if args.l3_clock_hz:
        result["l3VerificationMs"] = (
            telemetry["l3VerificationCycles"] * 1000 / args.l3_clock_hz
        )
    if args.l2_clock_hz and args.l3_clock_hz:
        result["hierarchicalVerificationMs"] = (
            result["l2VerificationMs"] + result["l3VerificationMs"] +
            verifier_ms
        )
    print(f"Quote parsed: {len(frame)} bytes", flush=True)
    print("AK certificate signature verification passed", flush=True)
    print("PCR verification passed", flush=True)
    print("Nonce verification passed", flush=True)
    print("ML-DSA Quote signature verification passed", flush=True)
    print(
        "Hierarchical ECDSA certificate verification passed: "
        f"L2={telemetry['l2VerifiedL1Certificates']}/{args.chains}, "
        f"L3={telemetry['l3VerifiedL2Certificates']}/{args.chains // 10}, "
        "Verifier=1/1",
        flush=True,
    )
    return result


def main():
    parser = argparse.ArgumentParser(
        description="Hardware-attested traditional X.509/ECDSA certificate-chain benchmark"
    )
    parser.add_argument("chains", type=int, choices=CHAIN_COUNTS)
    parser.add_argument("--repeats", type=int, default=1)
    parser.add_argument("--warmup", type=int, default=1)
    parser.add_argument(
        "--port",
        default=os.environ.get(
            "VERIFIER_SERIAL_PORT",
            "/dev/serial/by-id/usb-Xilinx_VCU129_422029122114-if01-port0",
        ),
    )
    parser.add_argument("--baud", type=int, default=115200)
    parser.add_argument("--ready-timeout", type=float, default=10)
    parser.add_argument("--response-timeout", type=float, default=0)
    parser.add_argument(
        "--l2-clock-hz",
        type=float,
        default=float(os.environ.get("L2_MCYCLE_HZ", DEFAULT_L2_MCYCLE_HZ)),
    )
    parser.add_argument(
        "--l3-clock-hz",
        type=float,
        default=float(os.environ.get("L3_MCYCLE_HZ", DEFAULT_L3_MCYCLE_HZ)),
    )
    parser.add_argument(
        "--ca-cert", type=Path,
        default=Path(__file__).resolve().with_name("ca_root.crt"),
    )
    parser.add_argument(
        "--pcr-file", type=Path,
        default=Path(__file__).resolve().with_name("pcr_expect.txt"),
    )
    parser.add_argument("--offline", action="store_true")
    parser.add_argument("--root-cert", type=Path)
    parser.add_argument("--l2-cert", type=Path)
    parser.add_argument("--l1-cert", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if args.repeats < 1 or args.warmup < 0:
        parser.error("repeats must be positive and warmup must not be negative")
    if args.l2_clock_hz is not None and args.l2_clock_hz <= 0:
        parser.error("l2-clock-hz must be positive")
    if args.l3_clock_hz is not None and args.l3_clock_hz <= 0:
        parser.error("l3-clock-hz must be positive")
    supplied = (args.root_cert, args.l2_cert, args.l1_cert)
    if any(supplied) and not all(supplied):
        parser.error("root-cert, l2-cert and l1-cert must be provided together")
    output = args.output or Path(f"ecdsa_results_{args.chains}.json")

    expected_calls = args.chains + args.chains // 10 + 1
    if not args.offline:
        if any(supplied):
            parser.error("root-cert/l2-cert/l1-cert require --offline")
        if not args.ca_cert.is_file():
            parser.error(f"trusted CA certificate not found: {args.ca_cert}")
        try:
            args.expected_measurement = load_expected_measurement(args.pcr_file)
        except ValueError as error:
            parser.error(str(error))
        root = load_certificate_bytes(args.ca_cert.read_bytes())
        import serial
        runs = []
        with serial.Serial(
            args.port, args.baud, timeout=0.1, write_timeout=10,
            xonxoff=False, rtscts=False, dsrdtr=False,
        ) as port:
            for run_index in range(1, args.repeats + 1):
                run = hardware_run(port, args, root)
                run["run"] = run_index
                if run["verificationCalls"] != expected_calls:
                    raise RuntimeError("incorrect ECDSA verification count")
                runs.append(run)
                print(f"Chains: {args.chains}", flush=True)
                print(f"Devices: {expected_calls}", flush=True)
                print(
                    f"Total time: {run['quoteRoundTripMs']:.3f} ms",
                    flush=True,
                )
                print(
                    f"Verification time: "
                    f"{run['hierarchicalVerificationMs']:.3f} ms",
                    flush=True,
                )
        report = {
            "format": 3,
            "scheme": "X509-ECDSA-as-encoded-by-hardware-certificates",
            "mode": "distributed-hardware-X509-chain-verification-and-quote",
            "source": (
                "L2 repeatedly verifies the physical L1 certificate; "
                "L3 repeatedly verifies the physical L2 certificate"
            ),
            "chains": args.chains,
            "logicalL1Certificates": args.chains,
            "logicalL2Certificates": args.chains // 10,
            "logicalL3Certificates": 1,
            "verificationCallsPerRun": expected_calls,
            "l2McycleHz": args.l2_clock_hz,
            "l3McycleHz": args.l3_clock_hz,
            "runs": runs,
            "averageQuoteRoundTripMs": sum(
                run["quoteRoundTripMs"] for run in runs
            ) / len(runs),
            "averageL2VerificationCycles": sum(
                run["l2VerificationCycles"] for run in runs
            ) / len(runs),
            "averageL3VerificationCycles": sum(
                run["l3VerificationCycles"] for run in runs
            ) / len(runs),
        }
        if all("hierarchicalVerificationMs" in run for run in runs):
            report["averageHierarchicalVerificationMs"] = sum(
                run["hierarchicalVerificationMs"] for run in runs
            ) / len(runs)
        output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
        return

    setup_start = time.perf_counter_ns()
    if all(supplied):
        fixtures = supplied_fixtures(*supplied)
        source = "supplied no-BLS certificate chain"
        unique_fixtures = 3
    else:
        fixtures = generated_fixtures()
        source = "generated no-BLS certificate fixtures"
        unique_fixtures = 111
    root, l2_certificates, l1_certificates = fixtures
    validate_fixtures(root, l2_certificates, l1_certificates)
    setup_ms = (time.perf_counter_ns() - setup_start) / 1e6

    for _ in range(args.warmup):
        if verify_all(args.chains, *fixtures) != expected_calls:
            raise RuntimeError("incorrect warmup verification count")

    runs = []
    for run_index in range(1, args.repeats + 1):
        started = time.perf_counter_ns()
        calls = verify_all(args.chains, *fixtures)
        elapsed_ms = (time.perf_counter_ns() - started) / 1e6
        if calls != expected_calls:
            raise RuntimeError("incorrect ECDSA verification count")
        runs.append(
            {
                "run": run_index,
                "verificationMs": elapsed_ms,
                "verificationCalls": calls,
                "averagePerVerificationUs": elapsed_ms * 1000 / calls,
                "verificationsPerSecond": calls * 1000 / elapsed_ms,
            }
        )
        print(
            f"PASS: {args.chains} chains, {calls} ECDSA certificate verifications; "
            f"verify={elapsed_ms:.3f} ms",
            flush=True,
        )

    report = {
        "format": 1,
        "scheme": "ECDSA-P384-SHA384",
        "mode": "traditional-X509-chain-verification-no-BLS",
        "source": source,
        "chains": args.chains,
        "logicalL1Certificates": args.chains,
        "logicalL2Certificates": args.chains // 10,
        "logicalRootCertificates": 1,
        "verificationCallsPerRun": expected_calls,
        "uniqueCertificateFixtures": unique_fixtures,
        "logicalCertificateDerBytesPerRun": logical_der_bytes(
            args.chains, *fixtures
        ),
        "fixtureSetupMsExcludedFromVerification": setup_ms,
        "runs": runs,
        "verificationMs": statistics([run["verificationMs"] for run in runs]),
        "averagePerVerificationUs": statistics(
            [run["averagePerVerificationUs"] for run in runs]
        ),
    }
    output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report["verificationMs"], indent=2), flush=True)
    print(f"Saved: {output}", flush=True)


if __name__ == "__main__":
    main()
