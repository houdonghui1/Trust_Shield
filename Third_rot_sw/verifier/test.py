#!/usr/bin/env python3
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


CHAIN_COUNTS = (10, 100, 1000, 10000)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Compare BLS aggregation with traditional ECDSA certificate validation",
        epilog=(
            "Examples: python3 test.py bls 1000 --repeats 3; "
            "python3 test.py ecdsa 1000 --repeats 3"
        ),
    )
    parser.add_argument("mode", choices=("bls", "ecdsa"))
    parser.add_argument("chains", type=int, choices=CHAIN_COUNTS)
    parser.add_argument("--repeats", type=int, default=1)
    args, mode_args = parser.parse_known_args()
    if args.repeats < 1:
        parser.error("repeats must be positive")

    directory = Path(__file__).resolve().parent
    if args.mode == "bls":
        script = directory / "bls_test.py"
    else:
        script = directory / "ecdsa_test.py"
        if "--offline" in mode_args:
            print("Mode: explicit offline ECDSA microbenchmark", flush=True)

    command = [
        sys.executable,
        str(script),
        str(args.chains),
        "--repeats",
        str(args.repeats),
        *mode_args,
    ]
    return subprocess.call(command)


if __name__ == "__main__":
    raise SystemExit(main())
