# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//rules:opentitan.bzl", "OPENTITAN_CPU")
load(
    "//rules:opentitan_test.bzl",
    "OPENTITANTOOL_OPENOCD_DATA_DEPS",
    "OPENTITANTOOL_OPENOCD_TEST_CMDS",
    "ROM_BOOT_FAILURE_MSG",
    "cw310_params",
    "dv_params",
    "opentitan_functest",
    "verilator_params",
)
load("//rules/opentitan:defs.bzl", "EARLGREY_TEST_ENVS", "opentitan_test")
load("//rules:splice.bzl", "bitstream_splice")
load("//rules:otp.bzl", "STD_OTP_OVERLAYS", "otp_image", "otp_json", "otp_partition")

package(default_visibility = ["//visibility:public"])

exports_files(glob([
    "*.c",
    "*.h",
    "x509/*.c",
    "x509/*.h",
    "sha256/*.c",
    "sha256/*.h",
]))

cc_library(
    name = "mldsa87",
    srcs = [
        "vendor_mldsa/src/sign.c",
        "vendor_mldsa/src/packing.c",
        "vendor_mldsa/src/poly.c",
        "vendor_mldsa/src/polyvec.c",
        "vendor_mldsa/src/poly_kl.c",
        "vendor_mldsa/src/ct.c",
        "vendor_mldsa/src/debug.c",
        "vendor_mldsa/src/randombytes.c",
        "vendor_mldsa/src/fips202/fips202.c",
        "vendor_mldsa/src/fips202/keccakf1600.c",
        "vendor_mldsa/src/fips202/fips202x4.c",
    ],
    hdrs = glob([
        "vendor_mldsa/**/*.h",
        "vendor_mldsa/**/*.inc",
    ]),
    includes = [
        "vendor_mldsa",
        "vendor_mldsa/src",
    ],
    target_compatible_with = [OPENTITAN_CPU],
    copts = [
        "-std=c99",
        "-ffreestanding",
        "-march=rv32imc",
        "-mabi=ilp32",
        "-Wno-duplicate-decl-specifier",
        "-Wno-unused-parameter",
        "-Wno-sign-conversion",
        "-Wno-conversion",
        "-Wno-missing-prototypes",
        "-Wno-unused-function",
        "-Wno-unused-variable",
        "-DOTT_STACK_SIZE=0x20000",
        "-DOTT_HEAP_SIZE=0x4000",
        "-DMLD_CONFIG_MONOBUILD_KEEP_SHARED_HEADERS=1",
        "-DMLD_SYS_RISCV32=1",
    ],
    deps = [
        "//sw/device/lib/base:macros",
    ],
)

cc_library(
    name = "sha256_lib",
    srcs = ["sha256/sha256.c"],
    hdrs = ["sha256/sha256.h"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [
        "//sw/device/lib/base:macros",
        "//sw/device/lib/base:memory",
    ],
)

cc_library(
    name = "x509_lib",
    srcs = ["x509/x509.c"],
    hdrs = ["x509/x509.h"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [
        "//sw/device/lib/base:macros",
        "//sw/device/lib/base:memory",
        ":sha256_lib",
    ],
)

cc_library(
    name = "attestation_lib",
    srcs = ["attestation.c"],
    hdrs = ["attestation.h"],
    target_compatible_with = [OPENTITAN_CPU],
    copts = [
        "-DOTT_STACK_SIZE=0x20000",
    ],
    deps = [
        "//sw/device/lib/crypto/drivers:otbn",
        "//sw/device/lib/crypto/drivers:entropy",
        "//sw/device/lib/crypto/impl:ecc",
        "//sw/device/lib/crypto/impl:hash",
        "//sw/device/lib/crypto/impl:keyblob",
        "//sw/device/lib/crypto/include:datatypes",
        "//sw/device/lib/runtime:log",
        "//sw/device/lib/dif:uart",
        "//sw/device/lib/dif:pinmux",
        "//sw/device/lib/dif:aes",
        "//sw/device/lib/testing:entropy_testutils",
        "//sw/device/lib/testing:otp_ctrl_testutils",
        "//sw/device/lib/testing:aes_testutils",
        "//sw/device/lib/testing/test_framework:ottf_main",
        "//sw/device/lib/testing:pinmux_testutils",
        ":mldsa87",
        ":x509_lib",
        ":sha256_lib",
    ],
)

opentitan_functest(
    name = "attestation_smoketest",
    srcs = ["attestation_smoketest.c"],
    targets = [
        "cw310_test_rom",
        "verilator",
    ],
    deps = [
        ":attestation_lib",
    ],
)
