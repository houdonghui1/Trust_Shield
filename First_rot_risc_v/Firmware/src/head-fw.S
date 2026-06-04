// See LICENSE.Sifive for license details.
#include <platform.h>
#include <smp.h>
#include "common.h"

.section .text.entry
.global _start
_start:
    // 1. 初始化栈指针（绝对安全地址）
    la sp, _stack_end   # 使用链接脚本定义的栈顶
    
    // 2. 清零关键寄存器
    li a0, 0
    li a1, 0
    li ra, 0
    
    // 3. 跳转到main（不使用相对跳转）
    la a0, main
    jr a0

.section .stack
    .align 4
    .space 0x4000      # 16KB栈空间
_stack_end: