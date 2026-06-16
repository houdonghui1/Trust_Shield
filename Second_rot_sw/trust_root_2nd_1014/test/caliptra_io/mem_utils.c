#include "mem_utils.h"

static void __iomem *g_mapped_base = NULL;
static size_t g_map_size = 0;

int memory_map_init(phys_addr_t phys_addr, size_t size) {
    g_mapped_base = ioremap(phys_addr, size);
    if (!g_mapped_base) {
        printk("ioremap failed for 0x%llx\n", (u64)phys_addr);
        return -ENOMEM;
    }
    
    printk("Mapped physical 0x%llx to virtual %p\n", (u64)phys_addr, g_mapped_base);
    
    g_map_size = size;
    return 0;
}

void memory_map_cleanup(void) {
    if (g_mapped_base) {
        iounmap(g_mapped_base);
        g_mapped_base = NULL;
    }
}

u32 readreg32(unsigned long offset) {
    if (!g_mapped_base) {
        printk("Memory not mapped!\n");
        return 0x1;
    }
    return ioread32(g_mapped_base + offset);
}

void writereg32(unsigned long offset, u32 value) {
    if (g_mapped_base) {
        iowrite32(value, g_mapped_base + offset);
    }
}

