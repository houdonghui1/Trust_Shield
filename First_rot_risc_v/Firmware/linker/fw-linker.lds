MEMORY {
    ROM (rx) : ORIGIN = 0x8000000, LENGTH = 32K  /* 严格限制ROM大小 */
    RAM (rwx) : ORIGIN = 0x80020000, LENGTH = 1M
}

SECTIONS {
    /* 代码段 */
    .text : {
        *(.text.entry)
        *(.text .text.*)
    } > ROM

    /* 只读数据 */
    .rodata : {
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
    } > ROM

    /* 初始化数据（不占用ROM体积） */
    .data : {
        _data_start = .;
        *(.data .data.*)
        _data_end = .;
    } > RAM AT> ROM

    /* 哈希段（不加载到ROM） */
    .vpk_hash (NOLOAD) : {
        *(.vpk_hash)
    } > RAM

    .opk_hash (NOLOAD) : {
        *(.opk_hash)
    } > RAM

    /* BSS和栈（绝对不占用二进制体积） */
    .bss (NOLOAD) : {
        _bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        _bss_end = .;
    } > RAM

    .stack (NOLOAD) : ALIGN(16) {
        _stack_end = .;
        . += 16K;  /* 16KB栈空间 */
        _stack_start = .;
    } > RAM

    /* 强制丢弃冗余段 */
    /DISCARD/ : {
        *(.comment)
        *(.riscv.attributes)
    }
}