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

ROM_NAME=caliptraROMC
FMC_NAME=caliptraFMCC
RT_NAME=caliptraRTC
FMC_IMAGE_SIZE=20480
RT_IMAGE_SIZE=37376
ROMC_DIR=${shell pwd}
ROM_DIR=${ROMC_DIR}/bootrom/src
FMC_DIR=${ROMC_DIR}/fmc/src
RT_DIR=${ROMC_DIR}/runtime/src
LIB_DIR=${ROMC_DIR}/libs
BLS_DIR := ${LIB_DIR}/bls
BUILD_DIR=${ROMC_DIR}/build
OUTPUT_DIR=${ROMC_DIR}/output
INC_PATH := -I ${ROMC_DIR}/inc -I ${ROM_DIR} -I ${LIB_DIR}/caliptra_isr -I ${LIB_DIR}/soc_ifc -I ${LIB_DIR}/uart -I ${LIB_DIR}/qspi -I ${LIB_DIR}/printf -I ${LIB_DIR}/mailbox -I ${LIB_DIR}/hmac \
			-I ${LIB_DIR}/ecc -I ${LIB_DIR}/sha256 -I ${LIB_DIR}/sha384 -I ${LIB_DIR}/sha512 -I ${LIB_DIR}/keyvault -I ${LIB_DIR}/datavault -I ${LIB_DIR}/x509 -I ${LIB_DIR}/sm3 -I ${LIB_DIR}/trng \
			-I ${BLS_DIR} -I ${BLS_DIR}/blst/bindings
GCC_PREFIX = riscv64-unknown-elf
ABI = -mabi=ilp32 -march=rv32imc_zicsr_zifencei
RUST_ELF_DIR = /home/jdeng/work/test/target/riscv32imac-unknown-none-elf/release
PLAYBOOK_RANDOM_SEED ?= ${shell date +%s}
BUILD_CFLAGS ?= 
TEST_CFLAGS = -Wall -g0 -Os -ffunction-sections -fdata-sections -DMY_RANDOM_SEED=${PLAYBOOK_RANDOM_SEED} ${BUILD_CFLAGS} -std=gnu99 -Wno-main
BLS_CFLAGS = -D__BLST_NO_ASM__ -D__BLST_NO_CPUID__ \
	-DCLUSTER_BLS_FIXED_L1_DEMO_KEY

SHELL := /bin/bash

.PHONY: default bootrom fmc rt libs verify-layout

default: verify-layout

bootrom:libs 
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} -c ${ROM_DIR}/start.S -o ${ROM_DIR}/start.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${ROM_DIR}/main.c -o ${ROM_DIR}/main.o
	${GCC_PREFIX}-gcc ${ABI} -nostartfiles -Wl,--gc-sections -Wl,--entry=_start -Wl,--gc-sections -Wl,-Map=${OUTPUT_DIR}/${ROM_NAME}.map -L${ROMC_DIR} -lgcc -T ${ROM_DIR}/rom.ld ${BUILD_DIR}/*.o ${ROM_DIR}/*.o -o ${OUTPUT_DIR}/${ROM_NAME}.elf

	${GCC_PREFIX}-objcopy -O verilog -R .data_iccm0 -R .data_iccm1 -R .data_iccm2 -R .iccm -R .dccm -R .eh_frame --pad-to 0xC000 --no-change-warnings ${OUTPUT_DIR}/${ROM_NAME}.elf ${OUTPUT_DIR}/${ROM_NAME}.hex
	-${GCC_PREFIX}-objcopy -O verilog -j .data_iccm0 -j .data_iccm1 -j .data_iccm2 -j .dccm \
				  --change-section-lma       .data-0x50000000 \
			      --change-section-lma     .rodata-0x50000000 \
			      --change-section-lma        .bss-0x50000000 \
			      --change-section-lma       .sbss-0x50000000 \
			      --change-section-lma       .dccm-0x50000000 \
			      --pad-to 0x20000 \
			      --no-change-warnings \
			      ${OUTPUT_DIR}/${ROM_NAME}.elf ${OUTPUT_DIR}/dccm.hex
	-${GCC_PREFIX}-objcopy -O verilog -j .iccm                       --change-section-address .iccm=0 --pad-to 0x20000 --no-change-warnings ${OUTPUT_DIR}/${ROM_NAME}.elf ${OUTPUT_DIR}/iccm.hex
	-${GCC_PREFIX}-objcopy -O verilog -j .mailbox --gap-fill 0x0     --change-section-address .mailbox=0 --pad-to 0x20000 --no-change-warnings ${OUTPUT_DIR}/${ROM_NAME}.elf ${OUTPUT_DIR}/mailbox.hex
	${GCC_PREFIX}-objdump -S  ${OUTPUT_DIR}/${ROM_NAME}.elf > ${OUTPUT_DIR}/${ROM_NAME}.dis
	${GCC_PREFIX}-size        ${OUTPUT_DIR}/${ROM_NAME}.elf | tee ${OUTPUT_DIR}/${ROM_NAME}.size
	${GCC_PREFIX}-objdump -D ${OUTPUT_DIR}/${ROM_NAME}.elf > ${OUTPUT_DIR}/${ROM_NAME}.asm

	${GCC_PREFIX}-objcopy -O binary ${OUTPUT_DIR}/${ROM_NAME}.elf ${OUTPUT_DIR}/${ROM_NAME}.bin
	xxd -c 8 -p ${OUTPUT_DIR}/${ROM_NAME}.bin > ${OUTPUT_DIR}/${ROM_NAME}.txt
	source ${ROMC_DIR}/txt2coe.sh ${OUTPUT_DIR}/.. ${OUTPUT_DIR}/${ROM_NAME}.txt ${OUTPUT_DIR}/${ROM_NAME}.coe

fmc:libs
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} -c ${FMC_DIR}/start.S -o ${FMC_DIR}/start.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${FMC_DIR}/main.c -o ${FMC_DIR}/main.o
	${GCC_PREFIX}-gcc ${ABI} -nostartfiles -Wl,--gc-sections -Wl,--entry=_start -Wl,--gc-sections -Wl,-Map=${OUTPUT_DIR}/${FMC_NAME}.map -L${ROMC_DIR} -lgcc -T ${FMC_DIR}/caliptra_fmc.ld ${BUILD_DIR}/*.o ${FMC_DIR}/*.o -o ${OUTPUT_DIR}/${FMC_NAME}.elf

	${GCC_PREFIX}-objcopy -O verilog -R .data_iccm0 -R .data_iccm1 -R .data_iccm2 -R .iccm -R .dccm -R .eh_frame --pad-to 0xC000 --no-change-warnings ${OUTPUT_DIR}/${FMC_NAME}.elf ${OUTPUT_DIR}/${FMC_NAME}.hex
	${GCC_PREFIX}-objdump -D ${OUTPUT_DIR}/${FMC_NAME}.elf > ${OUTPUT_DIR}/${FMC_NAME}.asm
	${GCC_PREFIX}-objcopy -O binary ${OUTPUT_DIR}/${FMC_NAME}.elf ${OUTPUT_DIR}/${FMC_NAME}.bin.tmp
	filesize=$$(wc -c < "${OUTPUT_DIR}/${FMC_NAME}.bin.tmp"); \
	if [ $$filesize -gt ${FMC_IMAGE_SIZE} ]; then \
		echo "Error: ${FMC_NAME}.bin exceeds ${FMC_IMAGE_SIZE} bytes (size: $$filesize)"; \
		exit 1; \
	fi; \
	if [ $$filesize -lt ${FMC_IMAGE_SIZE} ]; then \
		dd if=/dev/zero bs=1 count=$$(( ${FMC_IMAGE_SIZE} - filesize )) >> "${OUTPUT_DIR}/${FMC_NAME}.bin.tmp"; \
	fi; \
	mv "${OUTPUT_DIR}/${FMC_NAME}.bin.tmp" "${OUTPUT_DIR}/${FMC_NAME}.bin"
	filesize=$$(wc -c < "${OUTPUT_DIR}/${FMC_NAME}.bin"); \
	if [ $$filesize -ne ${FMC_IMAGE_SIZE} ]; then \
		echo "Error: ${FMC_NAME}.bin size is $$filesize, expected ${FMC_IMAGE_SIZE}"; \
		exit 1; \
	fi

rt:libs
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} -c ${RT_DIR}/start.S -o ${RT_DIR}/start.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${RT_DIR}/main.c -o ${RT_DIR}/main.o
	${GCC_PREFIX}-gcc ${ABI} -nostartfiles -Wl,--gc-sections -Wl,--entry=_start -Wl,--gc-sections -Wl,-Map=${OUTPUT_DIR}/${RT_NAME}.map -L${ROMC_DIR} -lgcc -T ${RT_DIR}/caliptra_rt.ld ${BUILD_DIR}/*.o ${RT_DIR}/*.o -o ${OUTPUT_DIR}/${RT_NAME}.elf

	${GCC_PREFIX}-objcopy -O verilog -R .data_iccm0 -R .data_iccm1 -R .data_iccm2 -R .iccm -R .dccm -R .eh_frame --pad-to 0xC000 --no-change-warnings ${OUTPUT_DIR}/${RT_NAME}.elf ${OUTPUT_DIR}/${RT_NAME}.hex
	${GCC_PREFIX}-objcopy -O binary ${OUTPUT_DIR}/${RT_NAME}.elf ${OUTPUT_DIR}/${RT_NAME}.bin.tmp
	filesize=$$(wc -c < "${OUTPUT_DIR}/${RT_NAME}.bin.tmp"); \
	echo "${RT_NAME} unpadded size: $$filesize bytes"; \
	if [ $$filesize -gt ${RT_IMAGE_SIZE} ]; then \
		echo "Error: ${RT_NAME}.bin exceeds ${RT_IMAGE_SIZE} bytes (size: $$filesize)"; \
		exit 1; \
	fi; \
	if [ $$filesize -lt ${RT_IMAGE_SIZE} ]; then \
		dd if=/dev/zero bs=1 count=$$(( ${RT_IMAGE_SIZE} - filesize )) >> "${OUTPUT_DIR}/${RT_NAME}.bin.tmp"; \
	fi; \
	mv "${OUTPUT_DIR}/${RT_NAME}.bin.tmp" "${OUTPUT_DIR}/${RT_NAME}.bin"
	filesize=$$(wc -c < "${OUTPUT_DIR}/${RT_NAME}.bin"); \
	if [ $$filesize -ne ${RT_IMAGE_SIZE} ]; then \
		echo "Error: ${RT_NAME}.bin size is $$filesize, expected ${RT_IMAGE_SIZE}"; \
		exit 1; \
	fi

verify-layout: bootrom fmc rt
	for elf in "${OUTPUT_DIR}/${ROM_NAME}.elf" "${OUTPUT_DIR}/${FMC_NAME}.elf" "${OUTPUT_DIR}/${RT_NAME}.elf"; do \
		${GCC_PREFIX}-nm -n "$$elf" | grep -q '^5001de00 A _cert_store_start$$' || { echo "Error: $$elf has the wrong certificate store address"; exit 1; }; \
		${GCC_PREFIX}-nm -n "$$elf" | grep -q '^5001ee40 A _tbs_der_store_start$$' || { echo "Error: $$elf has the wrong TBS store address"; exit 1; }; \
		${GCC_PREFIX}-nm -n "$$elf" | grep -q '^5001ff00 A _cluster_bls_state_start$$' || { echo "Error: $$elf has the wrong BLS state address"; exit 1; }; \
		echo "Verified persistent layout: $$elf"; \
	done

libs:
	-mkdir -p ${BUILD_DIR} ${OUTPUT_DIR}
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/caliptra_isr/caliptra_isr.c -o ${BUILD_DIR}/caliptra_isr.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/soc_ifc/soc_ifc.c -o ${BUILD_DIR}/soc_ifc.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/uart/uart.c -o ${BUILD_DIR}/uart.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/qspi/qspi.c -o ${BUILD_DIR}/qspi.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/printf/printf.c -o ${BUILD_DIR}/printf.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/mailbox/mailbox.c -o ${BUILD_DIR}/mailbox.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/hmac/hmac.c -o ${BUILD_DIR}/hmac.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/ecc/ecc.c -o ${BUILD_DIR}/ecc.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/sha256/sha256.c -o ${BUILD_DIR}/sha256.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/sha384/sha384.c -o ${BUILD_DIR}/sha384.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/sha512/sha512.c -o ${BUILD_DIR}/sha512.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/keyvault/keyvault.c -o ${BUILD_DIR}/keyvault.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/datavault/datavault.c -o ${BUILD_DIR}/datavault.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/x509/x509.c -o ${BUILD_DIR}/x509.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/sm3/sm3.c -o ${BUILD_DIR}/sm3.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} -c ${LIB_DIR}/trng/trng.c -o ${BUILD_DIR}/trng.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} ${BLS_CFLAGS} -c ${BLS_DIR}/blst/src/server.c -o ${BUILD_DIR}/blst-server.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} ${BLS_CFLAGS} -c ${BLS_DIR}/bls_opentitan.c -o ${BUILD_DIR}/bls_opentitan.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} ${BLS_CFLAGS} -c ${BLS_DIR}/cluster_bls_protocol.c -o ${BUILD_DIR}/cluster_bls_protocol.o
	${GCC_PREFIX}-gcc ${ABI} ${INC_PATH} ${TEST_CFLAGS} ${BLS_CFLAGS} -c ${ROM_DIR}/cluster_bls_l1.c -o ${BUILD_DIR}/cluster_bls_l1.o


clean:
	rm -rf ${BUILD_DIR} ${OUTPUT_DIR} 
	find ${ROMC_DIR} -type f -name "*.o" -delete
