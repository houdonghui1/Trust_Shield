#include "cluster_bls_bridge.h"

#include <string.h>

#include "mailbox.h"

enum {
    CLUSTER_BLS_CBR1_HEADER_BYTES = 7,
    CLUSTER_BLS_CBR1_REGISTRATION_BYTES = 162,
    CLUSTER_BLS_ROM_MEASUREMENT_BYTES = 64,
    CLUSTER_BLS_FRAME_HEADER_BYTES = 8,
    CLUSTER_BLS_FRAME_CRC_BYTES = 4,
    CLUSTER_BLS_UART_FRAME_TIMEOUT = 1000000,
    ECDSA_SCALE_REQUEST_BYTES = 60,
    ECDSA_SCALE_RESPONSE_BYTES = 116,
};

#define OP_ECDSA_SCALE_SIGN ((enum mailbox_command)0x44C0FFE6U)

static const uint8_t kFrameMagic[4] = {'C', 'B', 'P', '1'};
static const uint8_t kCbr1Magic[4] = {'C', 'B', 'R', '1'};

/* The caller supplies one reusable transfer buffer.  The bootloader already
 * owns a large firmware receive buffer, so keeping another 4096-byte object in
 * this translation unit would overflow the CM3's 12 KiB RAM. */
static uint8_t __attribute__((aligned(4))) g_mailbox_reply[4];
static uint8_t __attribute__((aligned(4))) g_empty_request[4];

static uint32_t crc32_update(uint32_t crc, const uint8_t *data, size_t len)
{
    size_t i;
    while (len-- != 0) {
        crc ^= *data++;
        for (i = 0; i < 8; ++i) {
            crc = (crc & 1u) ? ((crc >> 1) ^ 0xedb88320u) : (crc >> 1);
        }
    }
    return crc;
}

static uint32_t crc32_frame(const uint8_t *header, const uint8_t *payload,
                            size_t payload_len)
{
    uint32_t crc = crc32_update(0xffffffffu, header,
                                CLUSTER_BLS_FRAME_HEADER_BYTES);
    if (payload_len != 0) {
        crc = crc32_update(crc, payload, payload_len);
    }
    return crc ^ 0xffffffffu;
}

static bool uart_write_all(UART_HandleTypeDef *uart, const uint8_t *data,
                           size_t len)
{
    while (len != 0) {
        uint8_t chunk = len > UINT8_MAX ? UINT8_MAX : (uint8_t)len;
        drv_uart_putchars(uart, (uint8_t *)data, chunk);
        data += chunk;
        len -= chunk;
    }
    return true;
}

static bool uart_read_byte(UART_HandleTypeDef *uart, uint8_t *byte,
                           bool bounded)
{
    if (!bounded) {
        return drv_uart_getchar(uart, byte) == 0;
    }
    return drv_uart_getchar_timeout(uart, byte,
                                    CLUSTER_BLS_UART_FRAME_TIMEOUT) == 0;
}

static bool uart_read_exact(UART_HandleTypeDef *uart, uint8_t *data,
                            size_t len)
{
    while (len-- != 0) {
        if (!uart_read_byte(uart, data++, true)) {
            return false;
        }
    }
    return true;
}

static cluster_bls_bridge_status_t frame_send(
    UART_HandleTypeDef *uart, cluster_bls_bridge_frame_type_t type,
    const uint8_t *payload, size_t payload_len)
{
    uint8_t header[CLUSTER_BLS_FRAME_HEADER_BYTES];
    uint8_t crc_bytes[CLUSTER_BLS_FRAME_CRC_BYTES];
    uint32_t crc;

    if (uart == NULL || payload_len > CLUSTER_BLS_BRIDGE_MAX_PAYLOAD ||
        (payload_len != 0 && payload == NULL)) {
        return CLUSTER_BLS_BRIDGE_LENGTH_ERROR;
    }

    memcpy(header, kFrameMagic, sizeof(kFrameMagic));
    header[4] = CLUSTER_BLS_BRIDGE_PROTOCOL_VERSION;
    header[5] = (uint8_t)type;
    header[6] = (uint8_t)(payload_len >> 8);
    header[7] = (uint8_t)payload_len;
    crc = crc32_frame(header, payload, payload_len);
    crc_bytes[0] = (uint8_t)(crc >> 24);
    crc_bytes[1] = (uint8_t)(crc >> 16);
    crc_bytes[2] = (uint8_t)(crc >> 8);
    crc_bytes[3] = (uint8_t)crc;

    if (!uart_write_all(uart, header, sizeof(header)) ||
        (payload_len != 0 && !uart_write_all(uart, payload, payload_len)) ||
        !uart_write_all(uart, crc_bytes, sizeof(crc_bytes))) {
        return CLUSTER_BLS_BRIDGE_UART_ERROR;
    }
    return CLUSTER_BLS_BRIDGE_OK;
}

static cluster_bls_bridge_status_t frame_receive(
    UART_HandleTypeDef *uart, cluster_bls_bridge_frame_type_t *type,
    uint8_t *payload, size_t payload_capacity, size_t *payload_len,
    bool first_magic_byte_consumed)
{
    uint8_t header[CLUSTER_BLS_FRAME_HEADER_BYTES];
    uint8_t crc_bytes[CLUSTER_BLS_FRAME_CRC_BYTES];
    uint8_t byte;
    size_t matched = first_magic_byte_consumed ? 1u : 0u;
    size_t length;
    uint32_t expected_crc;
    uint32_t actual_crc;

    if (uart == NULL || type == NULL || payload == NULL || payload_len == NULL) {
        return CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR;
    }

    /* UART0 also carries boot diagnostics.  Scan until the binary frame magic
     * is seen, rather than interpreting those diagnostics as a protocol frame. */
    while (matched < sizeof(kFrameMagic)) {
        if (!uart_read_byte(uart, &byte,
                            matched != 0 || first_magic_byte_consumed)) {
            return CLUSTER_BLS_BRIDGE_UART_ERROR;
        }
        if (byte == kFrameMagic[matched]) {
            ++matched;
        } else {
            matched = byte == kFrameMagic[0] ? 1u : 0u;
        }
    }
    memcpy(header, kFrameMagic, sizeof(kFrameMagic));
    if (!uart_read_exact(uart, header + sizeof(kFrameMagic),
                         CLUSTER_BLS_FRAME_HEADER_BYTES -
                             sizeof(kFrameMagic))) {
        return CLUSTER_BLS_BRIDGE_UART_ERROR;
    }

    if (header[4] != CLUSTER_BLS_BRIDGE_PROTOCOL_VERSION) {
        return CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR;
    }
    length = ((size_t)header[6] << 8) | header[7];
    if (length > payload_capacity || length > CLUSTER_BLS_BRIDGE_MAX_PAYLOAD) {
        return CLUSTER_BLS_BRIDGE_LENGTH_ERROR;
    }
    if (length != 0 && !uart_read_exact(uart, payload, length)) {
        return CLUSTER_BLS_BRIDGE_UART_ERROR;
    }
    if (!uart_read_exact(uart, crc_bytes, sizeof(crc_bytes))) {
        return CLUSTER_BLS_BRIDGE_UART_ERROR;
    }

    expected_crc = ((uint32_t)crc_bytes[0] << 24) |
                   ((uint32_t)crc_bytes[1] << 16) |
                   ((uint32_t)crc_bytes[2] << 8) | crc_bytes[3];
    actual_crc = crc32_frame(header, payload, length);
    if (actual_crc != expected_crc) {
        return CLUSTER_BLS_BRIDGE_CRC_ERROR;
    }

    *type = (cluster_bls_bridge_frame_type_t)header[5];
    *payload_len = length;
    return CLUSTER_BLS_BRIDGE_OK;
}

static void frame_send_error(UART_HandleTypeDef *uart,
                             cluster_bls_bridge_status_t status)
{
    uint8_t error[4] = {0, 0, 0, (uint8_t)status};
    (void)frame_send(uart, CLUSTER_BLS_FRAME_ERROR, error, sizeof(error));
}

static cluster_bls_bridge_status_t mailbox_request_response(
    enum mailbox_command command, const uint8_t *request, size_t request_len,
    uint8_t *response, size_t response_capacity, size_t *response_len)
{
    struct parcel parcel;
    uint32_t actual_len;
    int status;

    if (response == NULL || response_len == NULL ||
        request_len > UINT32_MAX || response_capacity > UINT32_MAX) {
        return CLUSTER_BLS_BRIDGE_LENGTH_ERROR;
    }

    parcel.command = command;
    parcel.tx_buffer = request == NULL ? g_empty_request : (uint8_t *)request;
    parcel.tx_bytes = request_len;
    parcel.rx_buffer = response;
    parcel.rx_bytes = response_capacity;
    status = pack_and_execute_command(&parcel, false);
    if (status != 0) {
        return CLUSTER_BLS_BRIDGE_MAILBOX_ERROR;
    }

    actual_len = caliptra_mbox_last_response_size();
    if (actual_len > response_capacity) {
        return CLUSTER_BLS_BRIDGE_LENGTH_ERROR;
    }
    *response_len = actual_len;
    return CLUSTER_BLS_BRIDGE_OK;
}

enum {
    CLUSTER_BLS_L1_PARENT_KEY_BYTES = 96,
    CLUSTER_BLS_L1_INSTALL_HEADER_BYTES = 4 + CLUSTER_BLS_L1_PARENT_KEY_BYTES,
};

static const uint8_t kL1InstallMagic[4] = {'L', '1', 'C', '1'};

static cluster_bls_bridge_status_t mailbox_send_install_package(
    const uint8_t *package, size_t package_len)
{
    size_t response_len = 0;
    uint32_t firmware_status = MBOX_FAILED;
    cluster_bls_bridge_status_t status;

    if (package == NULL || package_len <= CLUSTER_BLS_L1_INSTALL_HEADER_BYTES ||
        package_len > CLUSTER_BLS_BRIDGE_MAX_PAYLOAD) {
        return CLUSTER_BLS_BRIDGE_LENGTH_ERROR;
    }
    status = mailbox_request_response(OP_RECV_CLP_CTX, package,
                                      package_len, g_mailbox_reply,
                                      sizeof(g_mailbox_reply), &response_len);
    if (status != CLUSTER_BLS_BRIDGE_OK ||
        response_len != sizeof(firmware_status)) {
        return status == CLUSTER_BLS_BRIDGE_OK
                   ? CLUSTER_BLS_BRIDGE_MAILBOX_ERROR
                   : status;
    }
    memcpy(&firmware_status, g_mailbox_reply, sizeof(firmware_status));
    return firmware_status == MBOX_SUCCESS ? CLUSTER_BLS_BRIDGE_OK
                                           : CLUSTER_BLS_BRIDGE_MAILBOX_ERROR;
}

static bool valid_cbr1_request(const uint8_t *request, size_t request_len)
{
    const size_t prefix_len = CLUSTER_BLS_CBR1_HEADER_BYTES +
                              CLUSTER_BLS_CBR1_REGISTRATION_BYTES;
    size_t tbs_len;

    if (request == NULL || request_len < prefix_len ||
        memcmp(request, kCbr1Magic, sizeof(kCbr1Magic)) != 0 ||
        request[4] != 1) {
        return false;
    }
    tbs_len = ((size_t)request[5] << 8) | request[6];
    return tbs_len != 0 && request_len == prefix_len + tbs_len;
}

static bool valid_der_certificate(const uint8_t *certificate,
                                  size_t certificate_len)
{
    size_t body_len;
    size_t header_len;

    if (certificate == NULL || certificate_len < 2 || certificate[0] != 0x30) {
        return false;
    }
    if ((certificate[1] & 0x80u) == 0) {
        header_len = 2;
        body_len = certificate[1];
    } else if (certificate[1] == 0x81 && certificate_len >= 3) {
        header_len = 3;
        body_len = certificate[2];
    } else if (certificate[1] == 0x82 && certificate_len >= 4) {
        header_len = 4;
        body_len = ((size_t)certificate[2] << 8) | certificate[3];
    } else {
        return false;
    }
    return header_len + body_len == certificate_len;
}

static bool valid_l1_install_package(const uint8_t *package,
                                     size_t package_len)
{
    if (package == NULL ||
        package_len <= CLUSTER_BLS_L1_INSTALL_HEADER_BYTES ||
        memcmp(package, kL1InstallMagic, sizeof(kL1InstallMagic)) != 0) {
        return false;
    }
    return valid_der_certificate(package + CLUSTER_BLS_L1_INSTALL_HEADER_BYTES,
                                 package_len -
                                     CLUSTER_BLS_L1_INSTALL_HEADER_BYTES);
}

/*
 * Preserve the existing measured-boot gate.  L1 does not derive its CDI or
 * expose CBR1 until the L2 side has explicitly approved the ROM measurement.
 */
static cluster_bls_bridge_status_t wait_for_l2_boot_approval(
    UART_HandleTypeDef *uart, uint8_t *scratch, size_t scratch_capacity)
{
    cluster_bls_bridge_frame_type_t type;
    size_t measurement_len = 0;
    size_t approval_len = 0;
    size_t response_len = 0;
    uint32_t mailbox_status;
    cluster_bls_bridge_status_t status;

    status = mailbox_request_response(OP_GET_ROM_MEASURE_VALUE, NULL, 0,
                                      scratch, scratch_capacity,
                                      &measurement_len);
    if (status != CLUSTER_BLS_BRIDGE_OK ||
        measurement_len != CLUSTER_BLS_ROM_MEASUREMENT_BYTES) {
        return status == CLUSTER_BLS_BRIDGE_OK
                   ? CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR
                   : status;
    }
    status = frame_send(uart, CLUSTER_BLS_FRAME_L1_ROM_MEASUREMENT,
                        scratch, measurement_len);
    if (status != CLUSTER_BLS_BRIDGE_OK) {
        return status;
    }
    status = frame_receive(uart, &type, scratch, scratch_capacity,
                           &approval_len, false);
    if (status != CLUSTER_BLS_BRIDGE_OK ||
        type != CLUSTER_BLS_FRAME_L2_BOOT_APPROVAL || approval_len != 1 ||
        scratch[0] != 1) {
        return status == CLUSTER_BLS_BRIDGE_OK
                   ? CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR
                   : status;
    }

    status = mailbox_request_response(OP_SEND_INITIATE, NULL, 0,
                                      g_mailbox_reply, sizeof(g_mailbox_reply),
                                      &response_len);
    if (status != CLUSTER_BLS_BRIDGE_OK || response_len != sizeof(mailbox_status)) {
        return status == CLUSTER_BLS_BRIDGE_OK
                   ? CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR
                   : status;
    }
    memcpy(&mailbox_status, g_mailbox_reply, sizeof(mailbox_status));
    return mailbox_status == MBOX_SUCCESS ? CLUSTER_BLS_BRIDGE_OK
                                          : CLUSTER_BLS_BRIDGE_MAILBOX_ERROR;
}

cluster_bls_bridge_status_t cluster_bls_bridge_enroll(
    UART_HandleTypeDef *uart, uint8_t *scratch, size_t scratch_capacity)
{
    cluster_bls_bridge_frame_type_t type;
    size_t request_len = 0;
    size_t install_package_len = 0;
    cluster_bls_bridge_status_t status;

    if (uart == NULL || scratch == NULL ||
        scratch_capacity < CLUSTER_BLS_BRIDGE_MAX_PAYLOAD) {
        return CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR;
    }

    status = wait_for_l2_boot_approval(uart, scratch, scratch_capacity);
    if (status != CLUSTER_BLS_BRIDGE_OK) {
        frame_send_error(uart, status);
        return status;
    }

    status = mailbox_request_response(OP_RECV_CLP_CSR, NULL, 0,
                                      scratch, scratch_capacity,
                                      &request_len);
    if (status != CLUSTER_BLS_BRIDGE_OK || !valid_cbr1_request(scratch,
                                                                request_len)) {
        status = status == CLUSTER_BLS_BRIDGE_OK
                     ? CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR
                     : status;
        frame_send_error(uart, status);
        return status;
    }
    status = frame_send(uart, CLUSTER_BLS_FRAME_L1_CERTIFICATE_REQUEST,
                        scratch, request_len);
    if (status != CLUSTER_BLS_BRIDGE_OK) {
        return status;
    }

    status = frame_receive(uart, &type, scratch, scratch_capacity,
                           &install_package_len, false);
    if (status != CLUSTER_BLS_BRIDGE_OK ||
        type != CLUSTER_BLS_FRAME_L1_SIGNED_CERTIFICATE ||
        !valid_l1_install_package(scratch, install_package_len)) {
        status = status == CLUSTER_BLS_BRIDGE_OK
                     ? CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR
                     : status;
        frame_send_error(uart, status);
        return status;
    }

    status = mailbox_send_install_package(scratch, install_package_len);
    if (status != CLUSTER_BLS_BRIDGE_OK) {
        frame_send_error(uart, status);
    }
    return status;
}

static void cluster_bls_bridge_serve_internal(UART_HandleTypeDef *uart,
                                              uint8_t *scratch,
                                              size_t scratch_capacity,
                                              bool first_magic_byte_consumed,
                                              bool serve_forever)
{
    cluster_bls_bridge_frame_type_t type;
    size_t request_len;
    size_t response_len;
    cluster_bls_bridge_status_t status;

    if (uart == NULL || scratch == NULL ||
        scratch_capacity < CLUSTER_BLS_BRIDGE_MAX_PAYLOAD) {
        return;
    }

    while (1) {
        status = frame_receive(uart, &type, scratch, scratch_capacity,
                               &request_len, first_magic_byte_consumed);
        first_magic_byte_consumed = false;
        if (status != CLUSTER_BLS_BRIDGE_OK) {
            if (status != CLUSTER_BLS_BRIDGE_UART_ERROR) {
                frame_send_error(uart, status);
            }
            if (!serve_forever) {
                drv_uart_logic_reset(uart);
                return;
            }
            continue;
        }

        if (type == CLUSTER_BLS_FRAME_GET_L1_REGISTRATION &&
            request_len == 0) {
            status = mailbox_request_response(OP_BLS_GET_REGISTRATION, NULL, 0,
                                              scratch, scratch_capacity,
                                              &response_len);
            if (status == CLUSTER_BLS_BRIDGE_OK &&
                response_len == CLUSTER_BLS_BRIDGE_REGISTRATION_BYTES) {
                status = frame_send(uart, CLUSTER_BLS_FRAME_L1_REGISTRATION,
                                    scratch, response_len);
            } else if (status == CLUSTER_BLS_BRIDGE_OK) {
                status = CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR;
            }
        } else if (type == CLUSTER_BLS_FRAME_CHALLENGE &&
                   request_len == ECDSA_SCALE_REQUEST_BYTES &&
                   memcmp(scratch, "ECS1", 4) == 0) {
            status = mailbox_request_response(OP_ECDSA_SCALE_SIGN, scratch,
                                              request_len, scratch,
                                              scratch_capacity,
                                              &response_len);
            if (status == CLUSTER_BLS_BRIDGE_OK &&
                response_len == ECDSA_SCALE_RESPONSE_BYTES) {
                status = frame_send(uart, CLUSTER_BLS_FRAME_L1_SIGNATURE,
                                    scratch, response_len);
            } else if (status == CLUSTER_BLS_BRIDGE_OK) {
                status = CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR;
            }
        } else if (type == CLUSTER_BLS_FRAME_CHALLENGE &&
                   (request_len == CLUSTER_BLS_BRIDGE_CHALLENGE_BYTES
#if CLUSTER_BLS_SCALE_TEST_ENABLE
                    ||
                    request_len ==
                        CLUSTER_BLS_BRIDGE_SCALE_CHALLENGE_BYTES
#endif
                    )) {
            status = mailbox_request_response(OP_BLS_SIGN_CHALLENGE,
                                              scratch, request_len,
                                              scratch, scratch_capacity,
                                              &response_len);
            if (status == CLUSTER_BLS_BRIDGE_OK &&
                response_len ==
                    (request_len == CLUSTER_BLS_BRIDGE_CHALLENGE_BYTES
                         ? CLUSTER_BLS_BRIDGE_SIGNATURE_BYTES
                         : CLUSTER_BLS_BRIDGE_SCALE_SIGNATURE_BYTES)) {
                status = frame_send(uart, CLUSTER_BLS_FRAME_L1_SIGNATURE,
                                    scratch, response_len);
            } else if (status == CLUSTER_BLS_BRIDGE_OK &&
                       response_len == 4U) {
                status = frame_send(uart, CLUSTER_BLS_FRAME_ERROR,
                                    scratch, response_len);
            } else if (status == CLUSTER_BLS_BRIDGE_OK) {
                status = CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR;
            }
        } else {
            status = CLUSTER_BLS_BRIDGE_PROTOCOL_ERROR;
        }

        if (status != CLUSTER_BLS_BRIDGE_OK) {
            frame_send_error(uart, status);
        }
        if (!serve_forever) {
            return;
        }
    }
}

void cluster_bls_bridge_serve(UART_HandleTypeDef *uart, uint8_t *scratch,
                              size_t scratch_capacity)
{
    cluster_bls_bridge_serve_internal(uart, scratch, scratch_capacity, false,
                                      true);
}

void cluster_bls_bridge_serve_prefixed(UART_HandleTypeDef *uart,
                                       uint8_t *scratch,
                                       size_t scratch_capacity)
{
    cluster_bls_bridge_serve_internal(uart, scratch, scratch_capacity, true,
                                      false);
}
