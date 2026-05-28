##
#
# Licensed under the Apache-2.0 license.
#
# File Name:
#
#    Makefile
#
# Abstract:
#
#    File contains helper routines for building debugging Caliptra ROM.
#
##

TARGET_DIR=../../target/riscv32imc-unknown-none-elf/firmware
CTEST_DIR=/home/houdonghui/cm3_ahbmtx_mcu/user/firmware/caliptra_sw/Ctest/src
BUILD_DIR=${CTEST_DIR}/../build
INC_PATH := -I ${CTEST_DIR}/../inc -I ${CTEST_DIR}/../libs/caliptra_isr
GCC_PREFIX = riscv64-unknown-elf
ABI = -mabi=ilp32 -march=rv32imc_zicsr_zifencei
RUST_ELF_DIR = /home/jdeng/work/test/target/riscv32imac-unknown-none-elf/release

PLAYBOOK_RANDOM_SEED ?= $(shell date +%s)
BUILD_CFLAGS ?= 
TEST_CFLAGS = -Wall -g3 -O2 -fno-inline-functions -DMY_RANDOM_SEED=$(PLAYBOOK_RANDOM_SEED) $(BUILD_CFLAGS)

SHELL := /bin/bash

default: clean build

build:
	rm -rf ${BUILD_DIR}
	mkdir ${BUILD_DIR}
	$(GCC_PREFIX)-gcc $(ABI) -c $(CTEST_DIR)/start.S -o ${BUILD_DIR}/start.o
	$(GCC_PREFIX)-gcc $(ABI) $(INC_PATH) $(TEST_CFLAGS) -c $(CTEST_DIR)/main.c -o ${BUILD_DIR}/main.o 
	$(GCC_PREFIX)-gcc $(ABI) $(INC_PATH) $(TEST_CFLAGS) -c $(CTEST_DIR)/uart.c -o ${BUILD_DIR}/uart.o
	$(GCC_PREFIX)-gcc $(ABI) $(INC_PATH) $(TEST_CFLAGS) -c $(CTEST_DIR)/qspi.c -o ${BUILD_DIR}/qspi.o

	$(GCC_PREFIX)-gcc $(ABI) -nostartfiles -Wl,-Map=${BUILD_DIR}/Ctest.map -lgcc -T $(CTEST_DIR)/rom.ld ${BUILD_DIR}/*.o -o ${BUILD_DIR}/Ctest.elf

	$(GCC_PREFIX)-objcopy -O verilog -R .data_iccm0 -R .data_iccm1 -R .data_iccm2 -R .iccm -R .dccm -R .eh_frame --pad-to 0xC000 --no-change-warnings ${BUILD_DIR}/Ctest.elf ${BUILD_DIR}/Ctest.hex
	-$(GCC_PREFIX)-objcopy -O verilog -j .data_iccm0 -j .data_iccm1 -j .data_iccm2 -j .dccm \
				  --change-section-lma       .data-0x50000000 \
			      --change-section-lma     .rodata-0x50000000 \
			      --change-section-lma        .bss-0x50000000 \
			      --change-section-lma       .sbss-0x50000000 \
			      --change-section-lma       .dccm-0x50000000 \
			      --pad-to 0x20000 \
			      --no-change-warnings \
			      ${BUILD_DIR}/Ctest.elf ${BUILD_DIR}/dccm.hex
	-$(GCC_PREFIX)-objcopy -O verilog -j .iccm                       --change-section-address .iccm=0 --pad-to 0x20000 --no-change-warnings ${BUILD_DIR}/Ctest.elf ${BUILD_DIR}/iccm.hex
	-$(GCC_PREFIX)-objcopy -O verilog -j .mailbox --gap-fill 0x0     --change-section-address .mailbox=0 --pad-to 0x20000 --no-change-warnings ${BUILD_DIR}/Ctest.elf ${BUILD_DIR}/mailbox.hex
	$(GCC_PREFIX)-objdump -S  ${BUILD_DIR}/Ctest.elf > ${BUILD_DIR}/Ctest.dis
	$(GCC_PREFIX)-size        ${BUILD_DIR}/Ctest.elf | tee ${BUILD_DIR}/Ctest.size
	$(GCC_PREFIX)-objdump -D ${BUILD_DIR}/Ctest.elf > ${BUILD_DIR}/Ctest.asm

	$(GCC_PREFIX)-objcopy -O binary ${BUILD_DIR}/Ctest.elf ${BUILD_DIR}/Ctest.bin
	xxd -c 8 -p ${BUILD_DIR}/Ctest.bin > ${BUILD_DIR}/Ctest.txt
	source $(CTEST_DIR)/../txt2coe.sh ${BUILD_DIR}/.. ${BUILD_DIR}/Ctest.txt ${BUILD_DIR}/Ctest.coe

rust:
	$(GCC_PREFIX)-objcopy -O verilog -R .data_iccm0 -R .data_iccm1 -R .data_iccm2 -R .iccm -R .dccm -R .eh_frame --pad-to 0xC000 --gap-fill 0xFF --no-change-warnings ${RUST_ELF_DIR}/test ${RUST_ELF_DIR}/test.hex

clean:
	rm -rf ${BUILD_DIR}
