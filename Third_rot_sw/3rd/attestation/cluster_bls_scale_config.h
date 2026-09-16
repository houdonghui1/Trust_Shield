#ifndef CLUSTER_BLS_SCALE_CONFIG_H_
#define CLUSTER_BLS_SCALE_CONFIG_H_

#include <stddef.h>
#include <stdint.h>

#define CLUSTER_BLS_SCALE_CHAINS_10 10
#define CLUSTER_BLS_SCALE_CHAINS_100 100
#define CLUSTER_BLS_SCALE_CHAINS_1000 1000
#define CLUSTER_BLS_SCALE_CHAINS_10000 10000

#ifndef CLUSTER_BLS_SCALE_TEST_ENABLE
#define CLUSTER_BLS_SCALE_TEST_ENABLE 1
#endif

#if CLUSTER_BLS_SCALE_TEST_ENABLE != 0 && CLUSTER_BLS_SCALE_TEST_ENABLE != 1
#error "CLUSTER_BLS_SCALE_TEST_ENABLE must be 0 or 1"
#endif

#ifndef CLUSTER_BLS_SCALE_CHAIN_COUNT
#define CLUSTER_BLS_SCALE_CHAIN_COUNT CLUSTER_BLS_SCALE_CHAINS_10
#endif

#if CLUSTER_BLS_SCALE_CHAIN_COUNT != 10 && CLUSTER_BLS_SCALE_CHAIN_COUNT != 100 && CLUSTER_BLS_SCALE_CHAIN_COUNT != 1000 && CLUSTER_BLS_SCALE_CHAIN_COUNT != 10000
#error "CLUSTER_BLS_SCALE_CHAIN_COUNT must be 10, 100, 1000 or 10000"
#endif

static uint32_t scale_get_u32(const uint8_t *p) {
    return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) |
           ((uint32_t)p[2] << 8) | p[3];
}

static void scale_put_u32(uint8_t *p, uint32_t value) {
    for (size_t i = 0; i < 4U; ++i) {
        p[i] = (uint8_t)(value >> (24U - i * 8U));
    }
}

static void scale_put_u64(uint8_t *p, uint64_t value) {
    for (size_t i = 0; i < 8U; ++i) {
        p[i] = (uint8_t)(value >> (56U - i * 8U));
    }
}

static uint32_t scale_crc32(const uint8_t *p, size_t length) {
    uint32_t crc = 0xffffffffU;
    while (length-- != 0U) {
        crc ^= *p++;
        for (unsigned int bit = 0; bit < 8U; ++bit) {
            crc = (crc >> 1) ^ ((crc & 1U) ? 0xedb88320U : 0U);
        }
    }
    return crc ^ 0xffffffffU;
}

static uint64_t scale_cycles(void) {
    uint32_t high, low, again;
    do {
        __asm__ volatile ("csrr %0, mcycleh" : "=r"(high) :: "memory");
        __asm__ volatile ("csrr %0, mcycle" : "=r"(low) :: "memory");
        __asm__ volatile ("csrr %0, mcycleh" : "=r"(again) :: "memory");
    } while (high != again);
    return ((uint64_t)high << 32) | low;
}

#endif
