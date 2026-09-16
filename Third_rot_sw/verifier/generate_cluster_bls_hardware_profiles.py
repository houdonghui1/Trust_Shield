#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from pathlib import Path
from cluster_bls_hardware_common import (
    Backend, CHAIN_COUNTS, PROFILE_DERIVATION, l1_cached_key_index,
    l2_cached_key_index,
)


def build_profile(chains, backend, public_cache):
    members = []
    for level, count in ((3, 1), (2, chains // 10), (1, chains)):
        for index in range(1, count + 1):
            key_index = (l2_cached_key_index(index) if level == 2 else
                         l1_cached_key_index(index) if level == 1 else index)
            key_identity = (level, key_index)
            if key_identity not in public_cache:
                secret = (backend.secret_from_ikm(bytes(range(32))) if level == 3
                          else backend.node_secret(level, key_index))
                public_cache[key_identity] = backend.public(secret)
            members.append({"level": level, "index": index,
                            "parent": None if level == 3 else (1 if level == 2 else (index - 1) // 10 + 1),
                            "publicKey": public_cache[key_identity].hex()})
    keys = [bytes.fromhex(m["publicKey"]) for m in members]
    return {"chains": chains, "l2Nodes": chains // 10, "memberCount": len(members),
            "members": members, "aggregatePublicKey": backend.aggregate_public(keys).hex()}


def main():
    parser = argparse.ArgumentParser(description="Generate fixed cyclic-key test public rosters.")
    parser.add_argument("--chains", choices=["all"] + [str(x) for x in CHAIN_COUNTS], default="10")
    parser.add_argument("--backend", choices=["native", "reference"], default="native")
    parser.add_argument("--json-output", type=Path,
                        default=Path(__file__).with_name("cluster_bls_hardware_profiles_v2.json"))
    args = parser.parse_args()
    backend = Backend(args.backend)
    counts = CHAIN_COUNTS if args.chains == "all" else [int(args.chains)]
    profiles, cache = {}, {}
    for chains in counts:
        print(f"Generating {chains} chains ({chains + chains // 10 + 1} public keys)", flush=True)
        profiles[str(chains)] = build_profile(chains, backend, cache)
    document = {"format": 2, "testOnly": True,
                "derivation": PROFILE_DERIVATION,
                "profiles": profiles}
    args.json_output.write_text(json.dumps(document, indent=2) + "\n", encoding="utf-8")
    print(args.json_output)


if __name__ == "__main__":
    main()
