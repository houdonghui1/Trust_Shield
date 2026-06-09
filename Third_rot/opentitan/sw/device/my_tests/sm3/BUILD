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

# TODO(lowRISC:opentitan#13180): this is a temporary solution to enable writing
# manufacturer specific tests in the `manufacturer_test_hooks` repository that
# use open source test code. Specifically, this enables defining an
# `opentitan_functest` in the `manufacturer_test_hooks` repository without the
# need to specify the corresponding test hooks that should be used with the test
# on the command line.
exports_files(glob([
    "*.c",
    "*.h",
]))

opentitan_functest(
    name = "sm3_smoketest",
    srcs = ["sm3_smoketest.c"],
    
    targets =[
        "cw310_test_rom",
        "verilator",
    ],
    
    deps = [
        
        ":sm3_lib",
        
    ],
)
opentitan_functest(
    name = "sm3_30wordtest",
    srcs = ["sm3_30wordtest.c"],
    
    targets =[
        "cw310_test_rom",
        "verilator",
    ],
    
    deps = [
        
        ":sm3_lib",
        
    ],
)
opentitan_functest(
    name = "sm3_60wordtest",
    srcs = ["sm3_60wordtest.c"],
    
    targets =[
        "cw310_test_rom",
        "verilator",
    ],
    
    deps = [
        
        ":sm3_lib",
        
    ],
)
opentitan_functest(
    name = "sm3_600wordtest",
    srcs = ["sm3_600wordtest.c"],
    
    targets =[
        "cw310_test_rom",
        "verilator",
    ],
    
    deps = [
        
        ":sm3_lib",
        
    ],
)
cc_library(
    name = "sm3_lib",
    srcs = ["sm3.c"],
    hdrs = ["sm3.h"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [
        "//hw/top_earlgrey/sw/autogen:top_earlgrey",
        "//sw/device/lib/runtime:log",
        "//sw/device/lib/testing/test_framework:ottf_main",
        "//sw/device/my_tests/base:base_lib",
        "//sw/device/lib/dif:rv_timer",
        "//sw/device/lib/runtime:hart",
        "//sw/device/lib/runtime:ibex",
        "//sw/device/lib/testing/test_framework:check",
        "//hw/ip/rv_timer/data:rv_timer_regs",
    ],
)