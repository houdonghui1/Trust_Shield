#include "randombytes.h"
#include <stdint.h>
#include <string.h>

static uint64_t lcg_state = 123456789;

static uint32_t lcg_next(void) {
    lcg_state = lcg_state * 1103515245 + 12345;
    return (uint32_t)(lcg_state >> 16) & 0xFFFFFFFF;
}

int randombytes(uint8_t *out, size_t out_len) {
    if (out == NULL || out_len == 0) {
        return -1;
    }

    size_t i = 0;
    while (i + 4 <= out_len) {
        uint32_t r = lcg_next();
        memcpy(&out[i], &r, 4);
        i += 4;
    }

    if (i < out_len) {
        uint32_t r = lcg_next();
        memcpy(&out[i], &r, out_len - i);
    }

    return 0;
}