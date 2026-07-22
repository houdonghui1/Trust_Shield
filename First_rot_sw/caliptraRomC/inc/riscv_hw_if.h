// SPDX-License-Identifier: Apache-2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifndef RISCV_HW_IF_H
#define RISCV_HW_IF_H

#include <stdint.h>
#include "caliptra_defines.h"

// lsu_write_32 writes data to a given address pointer.  The uintptr_t is tied
// to the address width of the architeture and defines an appropriately sized
// value that can be cast to a void* and back indefinitely without losing
// information.  We cast to uint32_t since the value pointed to is definitively
// coded as a 32-bit register (uint32_t).
inline void lsu_write_32(uintptr_t addr, uint32_t data) {
  asm volatile ("fence r,r" ::: "memory");
  volatile uint32_t *ptr = (volatile uint32_t *)addr;
  asm volatile ("fence r,r" ::: "memory");
  *ptr = data;
}

// lsu_read_32 returns data from a given a address pointer.
inline uint32_t lsu_read_32(uintptr_t addr) {
  return *(volatile uint32_t *)addr;
}

// lsu_write_8 writes 1 byte (8 bits) to a given address pointer.
inline void lsu_write_8(uintptr_t addr, uint8_t data) {
  asm volatile ("fence r,r" ::: "memory");
  volatile uint8_t *ptr = (volatile uint8_t *)addr;
  asm volatile ("fence r,r" ::: "memory");
  *ptr = data;
}

// lsu_read_8 returns 1 byte (8 bits) from a given address pointer.
inline uint8_t lsu_read_8(uintptr_t addr) {
  return *(volatile uint8_t *)addr;
}

static inline void memcpy_fw_to_iccm(const void *src, void *dest, uint32_t size) {
  uint32_t *src_ptr = (uint32_t *)src;
  uint32_t *dest_ptr = (uint32_t *)dest;

  for (uint32_t i = 0; i < size / sizeof(uint32_t); i++) {
      dest_ptr[i] = src_ptr[i];
  }
}

static inline void delay_second(uint32_t count) {
    volatile uint64_t *mtime = (uint64_t*)CLP_SOC_IFC_REG_INTERNAL_RV_MTIME_L;
    volatile uint64_t *mtimecmp = (uint64_t*)CLP_SOC_IFC_REG_INTERNAL_RV_MTIMECMP_L;

    uint64_t start = *mtime;
    uint64_t end = start + count * 40000000;
      
    *mtimecmp = end;
    
    while (*mtime < end) {
        __asm__ volatile ("wfi");
    }
}

static inline void delay_ms(uint32_t milliseconds) {
    volatile uint64_t *mtime = (uint64_t*)CLP_SOC_IFC_REG_INTERNAL_RV_MTIME_L;
    volatile uint64_t *mtimecmp = (uint64_t*)CLP_SOC_IFC_REG_INTERNAL_RV_MTIMECMP_L;

    uint64_t start = *mtime;
    uint64_t end = start + (milliseconds * 40000);
    
    *mtimecmp = end;
    
    while (*mtime < end) {
        __asm__ volatile ("wfi");
    }
}

static inline uint64_t swap_64bit(uint64_t num) {
    return ((num & 0x00000000FFFFFFFF) << 32) |
           ((num & 0xFFFFFFFF00000000) >> 32);
}

#endif /* RISCV_HW_IF_H */
