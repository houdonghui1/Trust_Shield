/*
 * Bounded UART proxy between the L1 CM3 SoC side and the L2 controller.
 *
 * CM3 deliberately does not hold a BLS key or link the BLS implementation.
 * It only forwards the three narrowly-scoped operations below to the local
 * L1 Caliptra mailbox.
 */
#ifndef CLUSTER_BLS_BRIDGE_H_
#define CLUSTER_BLS_BRIDGE_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "drv_uart.h"

#ifndef CLUSTER_BLS_SCALE_TEST_ENABLE
#define CLUSTER_BLS_SCALE_TEST_ENABLE 1
#endif

#if CLUSTER_BLS_SCALE_TEST_ENABLE != 0 && CLUSTER_BLS_SCALE_TEST_ENABLE != 1
#error "CLUSTER_BLS_SCALE_TEST_ENABLE must be 0 or 1"
#endif

enum {
    CLUSTER_BLS_BRIDGE_PROTOCOL_VERSION = 1,
    CLUSTER_BLS_BRIDGE_MAX_PAYLOAD = 4096,
    CLUSTER_BLS_BRIDGE_REGISTRATION_BYTES = 162,
    CLUSTER_BLS_BRIDGE_CHALLENGE_BYTES = 32,
    CLUSTER_BLS_BRIDGE_SCALE_CHALLENGE_BYTES = 40,
    CLUSTER_BLS_BRIDGE_SIGNATURE_BYTES = 96,
    CLUSTER_BLS_BRIDGE_SCALE_SIGNATURE_BYTES = 116,
};

/*
 * Wire format (all multi-byte values are big endian):
 *
 *   "CBP1" | version:u8 | type:u8 | payloadLength:u16 | payload | crc32:u32
 *
 * The CRC detects serial corruption only.  Authenticity is supplied by the
 * certificate chain, PoP validation at L2, and the BLS proof itself.
 */
typedef enum {
    CLUSTER_BLS_FRAME_L1_CERTIFICATE_REQUEST = 1, /* CBR1 */
    CLUSTER_BLS_FRAME_L1_SIGNED_CERTIFICATE = 2,  /* L1C1 | L2 key | DER */
    CLUSTER_BLS_FRAME_GET_L1_REGISTRATION = 3,    /* empty */
    CLUSTER_BLS_FRAME_L1_REGISTRATION = 4,        /* 162 bytes */
    CLUSTER_BLS_FRAME_CHALLENGE = 5,              /* SHA-256 digest */
    CLUSTER_BLS_FRAME_L1_SIGNATURE = 6,           /* 96 bytes */
    CLUSTER_BLS_FRAME_L2_AGGREGATE_REQUEST = 7,
    CLUSTER_BLS_FRAME_L2_AGGREGATE_SIGNATURE = 8,
    CLUSTER_BLS_FRAME_L1_ROM_MEASUREMENT = 9, /* SHA-512, 64 bytes */
    CLUSTER_BLS_FRAME_L2_BOOT_APPROVAL = 10,  /* one byte: 0 or 1 */
    CLUSTER_BLS_FRAME_ERROR = 0x7f,
} cluster_bls_bridge_frame_type_t;

typedef enum {
    CLUSTER_BLS_BRIDGE_OK = 0,
    CLUSTER_BLS_BRIDGE_UART_ERROR = 1,
    CLUSTER_BLS_BRIDGE_FRAME_ERROR = 2,
    CLUSTER_BLS_BRIDGE_LENGTH_ERROR = 3,
    CLUSTER_BLS_BRIDGE_CRC_ERROR = 4,
    CLUSTER_BLS_BRIDGE_MAILBOX_ERROR = 5,
    CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR = 6,
} cluster_bls_bridge_status_t;

/*
 * Fetch the L1 CBR1 request, send it to the L2 side, receive an authenticated
 * L1C1 installation package, and install it through the L1 mailbox command.
 * The package contains the L2 P-384 public key and signed L1 DER certificate;
 * L1 Caliptra independently verifies both the parent signature and BLS
 * certificate-binding extension before accepting it.
 */
cluster_bls_bridge_status_t cluster_bls_bridge_enroll(
    UART_HandleTypeDef *uart, uint8_t *scratch, size_t scratch_capacity);

/*
 * Serve online registration and challenge requests indefinitely after
 * enrollment.  It accepts only GET_L1_REGISTRATION and CHALLENGE frames.
 */
void cluster_bls_bridge_serve(UART_HandleTypeDef *uart, uint8_t *scratch,
                              size_t scratch_capacity);

void cluster_bls_bridge_serve_prefixed(UART_HandleTypeDef *uart,
                                       uint8_t *scratch,
                                       size_t scratch_capacity);

#endif /* CLUSTER_BLS_BRIDGE_H_ */
