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
    "sha/*.c",
    "sha/*.h",
    "bls/*.c",
    "bls/*.h",
]))

cc_library(
    name = "blst",
    srcs = ["bls/blst/src/server.c"],
    textual_hdrs = glob(
        ["bls/blst/src/*.c"],
        exclude = ["bls/blst/src/server.c"],
    ),
    hdrs = glob([
        "bls/blst/bindings/*.h",
        "bls/blst/src/**/*.h",
    ]),
    includes = ["bls/blst/bindings"],
    target_compatible_with = [OPENTITAN_CPU],
    copts = [
        "-std=c99",
        "-march=rv32imc",
        "-mabi=ilp32",
        "-mcmodel=medany",
        "-Os",
        "-ffreestanding",
        "-fno-builtin",
        "-fno-stack-protector",
        "-ffunction-sections",
        "-fdata-sections",
        # BLST is vendored third-party code.  OpenTitan promotes conversion
        # warnings to errors globally, while upstream BLST intentionally uses
        # bitwise integer idioms that trigger Clang's sign-conversion warning.
        "-Wno-sign-conversion",
        "-D__BLST_NO_ASM__",
        "-D__BLST_NO_CPUID__",
        "-DMILLER_LOOP_N_MAX=1",
    ],
    deps = [
        "//sw/device/lib/base:macros",
        "//sw/device/lib/base:memory",
    ],
)

cc_library(
    name = "bls_opentitan",
    srcs = ["bls/bls_opentitan.c"],
    hdrs = ["bls/bls_opentitan.h"],
    includes = ["bls"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [":blst"],
)

# Protocol glue deliberately has no OpenTitan-specific secret source.  Each
# role provides CDI-derived IKM through its platform adapter, which prevents a
# test seed from becoming a production BLS identity.
cc_library(
    name = "cluster_bls_protocol",
    srcs = ["bls/cluster_bls_protocol.c"],
    hdrs = ["bls/cluster_bls_protocol.h"],
    includes = ["bls"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [":bls_opentitan"],
)

cc_library(
    name = "cluster_bls_l3",
    srcs = ["bls/cluster_bls_l3.c"],
    hdrs = ["bls/cluster_bls_l3.h"],
    includes = ["bls"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [":cluster_bls_protocol"],
)

cc_library(
    name = "cluster_bls_x509",
    srcs = ["bls/cluster_bls_x509.c"],
    hdrs = ["bls/cluster_bls_x509.h"],
    includes = ["bls"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [":cluster_bls_protocol"],
)

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
        "-DMLD_CONFIG_MONOBUILD_KEEP_SHARED_HEADERS=1",
        "-DMLD_SYS_RISCV32=1",
    ],
    deps = [
        "//sw/device/lib/base:macros",
    ],
)

cc_library(
    name = "ecdsa_p384_lib",
    srcs = ["ecdsa-p384/ecc.c"],
    hdrs = ["ecdsa-p384/ecc.h"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [
        "//sw/device/lib/base:macros",
        "//sw/device/lib/base:memory",
    ],
)

cc_library(
    name = "sha_lib",
    srcs = glob(["sha/*.c"]),
    hdrs = glob(["sha/*.h"]),
    target_compatible_with = [OPENTITAN_CPU],
    defines = ["SHA512_SUPPORT=1"],
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
        "//sw/device/lib/runtime:log",
        ":sha_lib",
        ":ecdsa_p384_lib",
        ":bls_opentitan",
    ],
)

cc_library(
    name = "attestation_lib",
    srcs = ["attestation.c"],
    hdrs = ["attestation.h"],
    target_compatible_with = [OPENTITAN_CPU],
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
        ":sha_lib",
        ":ecdsa_p384_lib",
        ":bls_opentitan",
        ":cluster_bls_protocol",
        ":cluster_bls_l3",
        ":cluster_bls_x509",
    ],
)

opentitan_functest(
    name = "attestation_smoketest",
    srcs = [
        "attestation_smoketest.c",
        "cluster_bls_scale_config.h",
        "ecdsa_scale.h",
        "ecdsa_scale_opentitan.h",
        "ecdsa_scale_stream.h",
    ],
    targets = [
        "cw310_test_rom",
        "verilator",
    ],
    deps = [
        ":attestation_lib",
    ],
)
