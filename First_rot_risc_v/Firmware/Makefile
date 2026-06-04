PWD_DIR = $(shell pwd)
BUILD_DIR = build
LIB_DIR = $(PWD_DIR)/library
TOOLCHAIN_PATH = /home/jdeng/tool/toolchain
CC=riscv64-unknown-elf-gcc
OBJCOPY=riscv64-unknown-elf-objcopy

CFLAGS = -march=rv64imac -mabi=lp64 -O0 -nostartfiles -nostdlib -ffreestanding -mcmodel=medany -fno-builtin
INC_PATH = -I include -I ${LIB_DIR}/caliptra1x/inc -I ${LIB_DIR}/kprintf -I ${TOOLCHAIN_PATH}/riscv64-unknown-elf/include
LDFLAGS += -Llinker/

ROM_LDFLAGS = -T $(PWD_DIR)/linker/rom-linker.lds
FW_LDFLAGS = -T $(PWD_DIR)/linker/fw-linker.lds
STARTUP_S := $(PWD_DIR)/src/head.S
FW_STARTUP_S := $(PWD_DIR)/src/head-fw.S

CALIPTRA_SRCS = $(PWD_DIR)/library/caliptra1x/src/drv_caliptra1x.c $(PWD_DIR)/library/caliptra1x/src/mailbox.c
KPRINTF_SRC = $(PWD_DIR)/library/kprintf/kprintf.c

.PHONY: bootrom fw clean

all: bootrom fw

bootrom: $(BUILD_DIR)/bootrom.bin $(BUILD_DIR)/bootrom.asm

$(BUILD_DIR)/bootrom.elf: $(STARTUP_S) $(PWD_DIR)/src/bootrom.c $(KPRINTF_SRC)  $(CALIPTRA_SRCS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(INC_PATH) $(LDFLAGS) $(ROM_LDFLAGS) -Wl,--start-group $^ -Wl,--end-group -o $@ 

$(BUILD_DIR)/bootrom.bin: $(BUILD_DIR)/bootrom.elf | $(BUILD_DIR)
	$(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/bootrom.asm: $(BUILD_DIR)/bootrom.elf | $(BUILD_DIR)
	riscv64-unknown-elf-objdump -D $< > $@

fw: $(BUILD_DIR)/firmware.bin $(BUILD_DIR)/firmware.asm

$(BUILD_DIR)/firmware.elf: $(FW_STARTUP_S) $(PWD_DIR)/src/firmware.c $(KPRINTF_SRC) $(CALIPTRA_SRCS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(INC_PATH) $(FW_LDFLAGS) -Wl,--start-group $^ -Wl,--end-group -o $@

$(BUILD_DIR)/firmware.bin: $(BUILD_DIR)/firmware.elf | $(BUILD_DIR)
	$(OBJCOPY) -O binary $< $@
	@BIN_SIZE=$$(stat -c%s $@); \
	PAD_SIZE=$$(( ( ($$BIN_SIZE + 511) / 512 ) * 512 )); \
	if [ $$BIN_SIZE -ne $$PAD_SIZE ]; then \
		echo "Padding firmware.bin to $$PAD_SIZE bytes (original: $$BIN_SIZE)"; \
		dd if=/dev/zero bs=1 count=$$(( $$PAD_SIZE - $$BIN_SIZE )) >> $@; \
	fi

$(BUILD_DIR)/firmware.asm: $(BUILD_DIR)/firmware.elf | $(BUILD_DIR)
	riscv64-unknown-elf-objdump -D $< > $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)