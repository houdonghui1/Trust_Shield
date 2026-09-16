#!/usr/bin/env python3

import sys

from cluster_bls_hardware_scale_benchmark import main


if len(sys.argv) >= 2 and not sys.argv[1].startswith("-"):
    sys.argv[1:2] = ["--chains", sys.argv[1]]
if "--repeats" not in sys.argv:
    sys.argv.extend(["--repeats", "1"])

try:
    main()
except KeyboardInterrupt:
    print("BLS test interrupted")
    raise SystemExit(130)
except Exception as error:
    print(f"BLS test failed: {error}")
    raise SystemExit(1)
