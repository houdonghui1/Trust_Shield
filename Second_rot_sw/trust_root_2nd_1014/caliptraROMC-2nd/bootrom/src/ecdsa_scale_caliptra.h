#ifndef ECDSA_SCALE_CALIPTRA_H_
#define ECDSA_SCALE_CALIPTRA_H_

#include "ecdsa_scale.h"
#include "ecdsa-p384.h"

extern uint64_t get_mcycle(void);

static int ecdsa_scale_caliptra_sign(
    unsigned local_level, const uint8_t *request, size_t length,
    uint8_t response[ECDSA_SCALE_RESPONSE_BYTES]) {
    uint8_t serialized_key[48];
    uint32_t index;
    uint64_t start;
    uint64_t cycles;
    int ok;
    if (request == NULL || response == NULL ||
        length != ECDSA_SCALE_REQUEST_BYTES ||
        memcmp(request, "ECS1", 4) != 0 ||
        ecdsa_scale_get32(request + 4) != local_level) {
        return 0;
    }
    index = ecdsa_scale_get32(request + 8);
    if (!ecdsa_scale_secret(local_level, index, serialized_key)) {
        return 0;
    }
    start = get_mcycle();
    ok = ecdsa_sign(serialized_key, request + 12, response + 20);
    cycles = get_mcycle() - start;
    memset(serialized_key, 0, sizeof(serialized_key));
    if (ok != 1) {
        return 0;
    }
    memcpy(response, "ECR1", 4);
    ecdsa_scale_put32(response + 4, local_level);
    ecdsa_scale_put32(response + 8, index);
    ecdsa_scale_put64(response + 12, cycles);
    return 1;
}

#endif
