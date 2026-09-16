#ifndef ECDSA_SCALE_STREAM_H_
#define ECDSA_SCALE_STREAM_H_

#include "ecdsa_scale.h"

typedef int (*ecdsa_scale_send_fn)(void *, const uint8_t *, size_t);
typedef int (*ecdsa_scale_exchange_fn)(void *, const uint8_t *, size_t,
                                       uint8_t *);

static uint32_t ecdsa_scale_crc32(const uint8_t *data, size_t length) {
    uint32_t crc = 0xffffffffU;
    while (length--) {
        crc ^= *data++;
        for (unsigned i = 0; i < 8; ++i) {
            crc = (crc >> 1) ^ ((crc & 1U) ? 0xedb88320U : 0U);
        }
    }
    return crc ^ 0xffffffffU;
}

static int ecdsa_scale_emit(ecdsa_scale_send_fn send, void *context,
                            const uint8_t *packet, size_t size) {
    uint8_t crc[4];
    ecdsa_scale_put32(crc, ecdsa_scale_crc32(packet, size));
    return send(context, packet, size) && send(context, crc, sizeof(crc));
}

static int ecdsa_scale_run_stream(
    uint32_t chains, const uint8_t digest[48], const uint8_t measurement[32],
    ecdsa_scale_exchange_fn sign_l3, void *local_context,
    ecdsa_scale_exchange_fn downstream, void *downstream_context,
    ecdsa_scale_send_fn send, void *verifier_context) {
    uint8_t request[ECDSA_SCALE_REQUEST_BYTES];
    uint8_t reply[ECDSA_SCALE_RESPONSE_BYTES];
    uint8_t header[36];
    uint8_t final[16];
    uint32_t completed = 0;
    uint32_t status = 0;
    if ((chains != 10U && chains != 100U && chains != 1000U &&
         chains != 10000U) ||
        digest == NULL || measurement == NULL || sign_l3 == NULL ||
        downstream == NULL || send == NULL) {
        return 0;
    }
    memcpy(header, "ECH1", 4);
    memcpy(header + 4, measurement, 32);
    if (!ecdsa_scale_emit(send, verifier_context, header, sizeof(header))) {
        return 0;
    }
    memcpy(request, "ECS1", 4);
    memcpy(request + 12, digest, 48);
    for (uint32_t ordinal = 0;
         ordinal < chains + chains / 10U + 1U; ++ordinal) {
        uint32_t level;
        uint32_t index;
        if (ordinal == 0) {
            level = 3;
            index = 1;
        } else {
            uint32_t position = ordinal - 1U;
            uint32_t group = position / 11U;
            uint32_t child = position % 11U;
            level = child == 10U ? 2U : 1U;
            index = child == 10U ? group + 1U : group * 10U + child + 1U;
        }
        ecdsa_scale_put32(request + 4, level);
        ecdsa_scale_put32(request + 8, index);
        memset(reply, 0, sizeof(reply));
        if (!(level == 3
                  ? sign_l3(local_context, request, sizeof(request), reply)
                  : downstream(downstream_context, request, sizeof(request),
                               reply))) {
            status = 1;
            break;
        }
        if (memcmp(reply, "ECR1", 4) != 0 ||
            ecdsa_scale_get32(reply + 4) != level ||
            ecdsa_scale_get32(reply + 8) != index) {
            status = 2;
            break;
        }
        if (!ecdsa_scale_emit(send, verifier_context, reply, sizeof(reply))) {
            return 0;
        }
        ++completed;
    }
    memcpy(final, "ECF1", 4);
    ecdsa_scale_put32(final + 4, status);
    ecdsa_scale_put32(final + 8, chains);
    ecdsa_scale_put32(final + 12, completed);
    return ecdsa_scale_emit(send, verifier_context, final, sizeof(final)) &&
           status == 0;
}

#endif
