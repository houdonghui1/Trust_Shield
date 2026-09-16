#ifndef CLUSTER_BLS_SCALE_NODE_H_
#define CLUSTER_BLS_SCALE_NODE_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifndef CLUSTER_BLS_SCALE_TEST_ENABLE
#define CLUSTER_BLS_SCALE_TEST_ENABLE 1
#endif

#if CLUSTER_BLS_SCALE_TEST_ENABLE != 0 && CLUSTER_BLS_SCALE_TEST_ENABLE != 1
#error "CLUSTER_BLS_SCALE_TEST_ENABLE must be 0 or 1"
#endif

enum {
    kClusterBlsScaleRequestBytes = 40,
    kClusterBlsScaleResponseBytes = 116,
    kClusterBlsScaleMaxL1Nodes = 10000,
};

#if CLUSTER_BLS_SCALE_TEST_ENABLE
extern uint64_t get_mcycle(void);

static inline uint32_t cluster_bls_scale_read_u32(const uint8_t *data) {
    return ((uint32_t)data[0] << 24) | ((uint32_t)data[1] << 16) |
           ((uint32_t)data[2] << 8) | (uint32_t)data[3];
}

static inline void cluster_bls_scale_write_u32(uint8_t *data, uint32_t value) {
    for (size_t i = 0; i < 4U; ++i) {
        data[i] = (uint8_t)(value >> (24U - 8U * i));
    }
}

static inline void cluster_bls_scale_write_u64(uint8_t *data, uint64_t value) {
    for (size_t i = 0; i < 8U; ++i) {
        data[i] = (uint8_t)(value >> (56U - 8U * i));
    }
}

static inline uint64_t cluster_bls_scale_cycles(void) {
    uint64_t value;
    __asm__ volatile ("" ::: "memory");
    value = get_mcycle();
    __asm__ volatile ("" ::: "memory");
    return value;
}

static inline void cluster_bls_scale_wipe(void *data, size_t length) {
    volatile uint8_t *cursor = (volatile uint8_t *)data;
    while (length-- != 0U) {
        *cursor++ = 0;
    }
}

static inline bool cluster_bls_scale_node_key_setup(
    uint8_t level, uint32_t index, uint8_t secret_key[32],
    uint64_t *setup_cycles) {
    uint64_t start;

    if ((level != 1U && level != 2U) || index == 0U) {
        return false;
    }
    start = cluster_bls_scale_cycles();
    for (size_t i = 0U; i < 32U; ++i) {
        secret_key[i] = 0U;
    }
    secret_key[0] = level;
    cluster_bls_scale_write_u32(secret_key + 28U, index);
    *setup_cycles = cluster_bls_scale_cycles() - start;
    return true;
}
#endif

#endif
