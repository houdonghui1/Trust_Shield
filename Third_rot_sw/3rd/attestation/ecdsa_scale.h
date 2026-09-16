#ifndef ECDSA_SCALE_H_
#define ECDSA_SCALE_H_

#include <stddef.h>
#include <stdint.h>
#include <string.h>

enum {
    ECDSA_SCALE_REQUEST_BYTES = 60,
    ECDSA_SCALE_RESPONSE_BYTES = 116,
};

static inline uint32_t ecdsa_scale_get32(const uint8_t *p) {
    return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) |
           ((uint32_t)p[2] << 8) | p[3];
}

static inline void ecdsa_scale_put32(uint8_t *p, uint32_t value) {
    for (unsigned i = 0; i < 4; ++i) {
        p[i] = (uint8_t)(value >> (24 - 8 * i));
    }
}

static inline void ecdsa_scale_put64(uint8_t *p, uint64_t value) {
    for (unsigned i = 0; i < 8; ++i) {
        p[i] = (uint8_t)(value >> (56 - 8 * i));
    }
}

static inline int ecdsa_scale_secret(unsigned level, uint32_t index,
                                     uint8_t key[48]) {
    if (index == 0 || level < 1 || level > 3 ||
        index > (level == 1 ? 10000U : level == 2 ? 1000U : 1U)) {
        return 0;
    }
    memset(key, 0, 48);
    key[0] = (uint8_t)level;
    ecdsa_scale_put32(key + 44, index);
    return 1;
}

#endif
