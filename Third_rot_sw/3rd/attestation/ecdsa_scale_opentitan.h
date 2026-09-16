#ifndef ECDSA_SCALE_OPENTITAN_H_
#define ECDSA_SCALE_OPENTITAN_H_

#include "ecdsa_scale_stream.h"

static uint64_t ecdsa_scale_ot_cycles(void) {
    uint32_t high;
    uint32_t low;
    uint32_t again;
    do {
        __asm__ volatile("csrr %0, mcycleh" : "=r"(high) :: "memory");
        __asm__ volatile("csrr %0, mcycle" : "=r"(low) :: "memory");
        __asm__ volatile("csrr %0, mcycleh" : "=r"(again) :: "memory");
    } while (high != again);
    return ((uint64_t)high << 32) | low;
}

static int ecdsa_scale_ot_send(void *context, const uint8_t *data,
                               size_t length) {
    dif_uart_t *uart = (dif_uart_t *)context;
    for (size_t i = 0; i < length; ++i) {
        if (dif_uart_byte_send_polled(uart, data[i]) != kDifOk) {
            return 0;
        }
    }
    return 1;
}

static int ecdsa_scale_ot_receive(dif_uart_t *uart, uint8_t *data,
                                  size_t length) {
    size_t received = 0;
    while (received < length) {
        size_t available = 0;
        size_t count = 0;
        if (dif_uart_rx_bytes_available(uart, &available) != kDifOk) {
            return 0;
        }
        if (available == 0) {
            continue;
        }
        if (available > length - received) {
            available = length - received;
        }
        if (dif_uart_bytes_receive(uart, available, data + received, &count) !=
            kDifOk) {
            return 0;
        }
        received += count;
    }
    return 1;
}

static int ecdsa_scale_ot_sign(void *context, const uint8_t *request,
                               size_t length, uint8_t *reply) {
    uint8_t key[48];
    uint64_t start;
    uint64_t elapsed;
    int ok;
    (void)context;
    if (length != ECDSA_SCALE_REQUEST_BYTES ||
        memcmp(request, "ECS1", 4) != 0 ||
        ecdsa_scale_get32(request + 4) != 3U ||
        !ecdsa_scale_secret(3U, ecdsa_scale_get32(request + 8), key)) {
        return 0;
    }
    start = ecdsa_scale_ot_cycles();
    ok = ecdsa_sign(key, request + 12, reply + 20);
    elapsed = ecdsa_scale_ot_cycles() - start;
    memset(key, 0, sizeof(key));
    if (ok != 1) {
        return 0;
    }
    memcpy(reply, "ECR1", 4);
    memcpy(reply + 4, request + 4, 8);
    ecdsa_scale_put64(reply + 12, elapsed);
    return 1;
}

static int ecdsa_scale_ot_downstream(void *context, const uint8_t *request,
                                     size_t length, uint8_t *reply) {
    uint8_t crc[4];
    dif_uart_t *uart = (dif_uart_t *)context;
    if (!ecdsa_scale_emit(ecdsa_scale_ot_send, uart, request, length) ||
        !ecdsa_scale_ot_receive(uart, reply, ECDSA_SCALE_RESPONSE_BYTES) ||
        !ecdsa_scale_ot_receive(uart, crc, sizeof(crc))) {
        return 0;
    }
    return ecdsa_scale_get32(crc) ==
           ecdsa_scale_crc32(reply, ECDSA_SCALE_RESPONSE_BYTES);
}

static int ecdsa_scale_ot_run(dif_uart_t *verifier, const uint8_t nonce[32],
                              const uint8_t measurement[32]) {
    uint8_t preimage[82];
    uint8_t digest[48];
    dif_uart_t downstream = {0};
    uint32_t chains = ecdsa_scale_get32(nonce + 4);
    if (chains == 0) {
        chains = 10;
    }
    memcpy(preimage, "ECDSA-SCALE-v1", 14);
    ecdsa_scale_put32(preimage + 14, chains);
    memcpy(preimage + 18, nonce, 32);
    memcpy(preimage + 50, measurement, 32);
    SHA384_hash(preimage, sizeof(preimage), digest);
    attestation_uart_init(&downstream, 2);
    return ecdsa_scale_run_stream(
        chains, digest, measurement, ecdsa_scale_ot_sign, NULL,
        ecdsa_scale_ot_downstream, &downstream, ecdsa_scale_ot_send, verifier);
}

#endif
