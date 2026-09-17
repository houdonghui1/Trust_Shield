#ifndef ECDSA_SCALE_CALIPTRA_H_
#define ECDSA_SCALE_CALIPTRA_H_

#include "ecdsa_scale.h"
#include "ecc.h"

extern uint64_t get_mcycle(void);

static int ecdsa_scale_caliptra_sign(
    unsigned local_level, const uint8_t *request, size_t length,
    uint8_t response[ECDSA_SCALE_RESPONSE_BYTES]) {
    ecc_io key = {0};
    ecc_io message = {0};
    ecc_io iv = {0};
    ecc_io r = {.kv_intf = 1};
    ecc_io s = {.kv_intf = 1};
    uint8_t serialized_key[48];
    uint32_t index;
    uint64_t start;
    uint64_t cycles;
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
    for (unsigned i = 0; i < 12; ++i) {
        key.data[i] = ecdsa_scale_get32(serialized_key + 4 * i);
        message.data[i] = ecdsa_scale_get32(request + 12 + 4 * i);
        iv.data[i] = message.data[i] ^ key.data[i];
    }
    start = get_mcycle();
    ecc_signing_flow(&key, &message, &iv, &r, &s);
    cycles = get_mcycle() - start;
    memcpy(response, "ECR1", 4);
    ecdsa_scale_put32(response + 4, local_level);
    ecdsa_scale_put32(response + 8, index);
    ecdsa_scale_put64(response + 12, cycles);
    for (unsigned i = 0; i < 12; ++i) {
        ecdsa_scale_put32(response + 20 + 4 * i, r.data[i]);
        ecdsa_scale_put32(response + 68 + 4 * i, s.data[i]);
    }
    ecc_zeroize();
    memset(&key, 0, sizeof(key));
    memset(serialized_key, 0, sizeof(serialized_key));
    return 1;
}

#endif
