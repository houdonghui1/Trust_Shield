#ifndef MEM_DEVICE_H
#define MEM_DEVICE_H

#include <linux/types.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/stat.h> 
#include <linux/io.h>
#include <linux/ioport.h>

typedef __u32 uint32_t;
typedef __u64 uint64_t;

int memory_map_init(phys_addr_t phys_addr, size_t size);

void memory_map_cleanup(void);

u32 readreg32(unsigned long offset);

void writereg32(unsigned long offset, u32 value);

#endif
