// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/crypto/drivers/otbn.h"
#include "sw/device/lib/crypto/drivers/entropy.h"
#include "sw/device/lib/crypto/impl/integrity.h"
#include "sw/device/lib/crypto/impl/keyblob.h"
#include "sw/device/lib/crypto/include/datatypes.h"
#include "sw/device/lib/crypto/include/ecc.h"
#include "sw/device/lib/crypto/include/hash.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/runtime/hart.h"
#include "sw/device/lib/dif/dif_aes.h"
#include "sw/device/lib/dif/dif_otp_ctrl.h" 
#include "sw/device/lib/dif/dif_csrng.h"
#include "sw/device/lib/dif/dif_pinmux.h"
#include "sw/device/lib/dif/dif_aes.h"
#include "sw/device/lib/testing/entropy_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "sw/device/lib/testing/aes_testutils.h"
#include "sw/device/lib/testing/csrng_testutils.h"
#include "sw/device/lib/testing/pinmux_testutils.h"
#include "sw/device/lib/base/hardened.h"
#include "sw/device/lib/base/abs_mmio.h"
#include "sw/device/my_tests/attestation/x509/x509.h"
#include "sw/device/my_tests/attestation/vendor_mldsa/mldsa_native.h"
#include "sw/device/my_tests/attestation/sha/sha256.h"
#include "sw/device/my_tests/attestation/sha/sha384.h"
#include "sw/device/my_tests/attestation/ecdsa-p384/ecc.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "hw/ip/aes/model/aes_modes.h"

#define AK_CERT_MARKER "AK_CERT:"
#define AK_CERT_MARKER_LEN 8U
#define SEND_MAX_CERT_SIZE 1024
#define LOG_CHUNK_SIZE (MLDSA87_PK_SIZE*2)
#define UART_ACK_BYTE 0x06U
#define UART_FIFO_SIZE 32U
#define UART_RX_TIMEOUT_TICKS 1000U
#define UART_RECV_IDLE_TIMEOUT_MS 5000U
#define NONCE_LENGTH 32U
//#define QUOTE_BUFFER_SIZE 2048U
#define MLDSA_QUOTE_BUFFER_SIZE 22528u
//#define ECC_SIGN_LEN 64U
#define CERT_RECV_BUF_MAX 8192U
#define CERT_HEX_BUF_MAX (CERT_RECV_BUF_MAX * 2U + 1U + LOG_CHUNK_SIZE)
#define AES_BLOCK_SIZE 16U
#define AES_TIMEOUT (10 * 1000 * 1000)
#define ROM_TOTAL_SIZE        2880U
#define DATA_RECV_BUF_MAX      4096U
#define CSR_RECV_MAX_RETRY 3
#define CSR_MIN_VALID_LEN  16

static size_t g_actual_cert_byte_len = 0U;
static size_t g_actual_cert_hex_len = 0U;
static char ctx_hex_buf[CERT_HEX_BUF_MAX] = {0};
static char ctx_general_buf[800] = {0};
static size_t g_cert_recv_idx = 0U;
static bool g_marker_matched = false;
static size_t g_marker_match_cnt = 0U;
static bool g_ak_cert_received = false;
static uint32_t g_uart_idle_ticks = 0U;
static size_t g_quote_hex_total_len = 0U;
static uint8_t uart_rx_buf[NONCE_LENGTH] = {0};
//static uint8_t quote_buf[QUOTE_BUFFER_SIZE] = {0};
static uint8_t firmware_hash[NONCE_LENGTH] = {0};
static uint8_t nonce_bin[NONCE_LENGTH] = {0};
//static uint8_t quote_signature[ECC_SIGN_LEN] = {0};
static uint8_t mldsa_pk[MLDSA87_PK_SIZE] = {0};
static uint8_t mldsa_sk[MLDSA87_SK_SIZE] = {0};
static uint8_t mldsa_sig[MLDSA87_SIG_SIZE] = {0};
static uint8_t quote_buf_mldsa[MLDSA_QUOTE_BUFFER_SIZE] = {0};
static char g_pack_quote_work_buf[MLDSA_QUOTE_BUFFER_SIZE] = {0};
static uint8_t g_data_recv_buf[DATA_RECV_BUF_MAX] = {0};
static size_t  g_data_recv_idx = 0U;
static size_t  g_actual_data_byte_len = 0U;
static bool    g_data_received = false;
static uint32_t g_data_idle_ticks = 0U;
static uint8_t rom_sha256_digest[SHA256_DIGEST_SIZE] = {0};
static uint8_t verify_status = 0U;

const uint8_t trigger_msg[] = "0x5a";
const uint8_t start_2nd_msg[] = "0x6a";
const uint8_t recv_csr_msg[] = "0x7a";
const uint8_t send_cxt_msg[] = "0x8a";
const uint8_t send_verify_msg[] = "0x9a";
const uint8_t error_msg[] = "0x11";

const uint8_t g_aes_key[32] = {
    0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,
    0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f,
    0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,
    0x18,0x19,0x1a,0x1b,0x1c,0x1d,0x1e,0x1f
};

const uint8_t g_2nd_rom_expected_val[32] = {
    0xaa,0xd2,0xd9,0x21,0x94,0x0c,0x54,0x9f,
    0x78,0xc3,0xb9,0xec,0xce,0x47,0x4f,0xeb,
    0xa0,0xce,0x03,0x57,0x08,0x40,0x58,0x15,
    0x1b,0x1e,0x98,0xc9,0xfa,0x3d,0x46,0x35
};

enum {
  /* Number of 32-bit words in a SHA256 digest. */
  kSha256DigestWords = 256 / 32,
  /* Number of 32-bit words in a P-256 public key. */
  kP256PublicKeyWords = 512 / 32,
  /* Number of 32-bit words in a P-256 signature. */
  kP256SignatureWords = 512 / 32,
  /* Number of bytes in a P-256 private key. */
  kP256PrivateKeyBytes = 256 / 8,
};

static const ecc_curve_t kCurveP256 = {
    .curve_type = kEccCurveTypeNistP256,
    .domain_parameter = NULL,
};

static const crypto_key_config_t kPrivateKeyConfig = {
    .version = kCryptoLibVersion1,
    .key_mode = kKeyModeEcdsa,
    .key_length = kP256PrivateKeyBytes,
    .hw_backed = kHardenedBoolFalse,
    .security_level = kSecurityLevelLow,
};

static const entropy_seed_material_t kFixedSeed = {
    .len = 2,
    .data = {0x12345678, 0x9abcdeff}
};

static const uint32_t ek_private_key[20] = {
    0xa9b8d1e4,
    0xa80247eb,
    0x37e92f93,
    0x9e52cb9e,
    0x2fbc751b,
    0x0e2869dc,
    0x9cb84967,
    0xacc44af3,
    0x00000000,
    0x00000000,
    0x1978a8ec,
    0xc14ef31d,
    0xe6781100,
    0xac835a4e,
    0xdd6a01e0,
    0x51792c7e,
    0x3d2409d6,
    0xce112baa,
    0xb85ecfa6,
    0xb75d2440
};

static const uint8_t ek_public_key[64] = {
    0x63, 0xe7, 0x39, 0xcb,
    0x22, 0xd2, 0xf3, 0xeb,
    0xe3, 0x62, 0xa7, 0x3a,
    0x7e, 0xd7, 0x7f, 0x08,
    0x52, 0x28, 0xe8, 0x2c,
    0x2f, 0x3f, 0x3b, 0x11,
    0x9e, 0xbe, 0x5f, 0xd8,
    0x8f, 0x4b, 0xb0, 0x95,
    0x45, 0xf3, 0x4c, 0x99,
    0x85, 0x1f, 0x6a, 0xea,
    0xc6, 0x45, 0x37, 0xf0,
    0xab, 0x94, 0xa9, 0x7c,
    0xd9, 0x99, 0x85, 0x0c,
    0xce, 0x2f, 0x1c, 0xf4,
    0x6e, 0xd3, 0x34, 0xff,
    0x84, 0xf1, 0xbc, 0x07
};

OTTF_DEFINE_TEST_CONFIG();

void sleep_ms(unsigned int milliseconds) {
    busy_spin_micros(milliseconds * 1000);
}

char *strstr(const char *haystack, const char *needle) {
    if (!haystack || !needle || !*needle) {
        return NULL;
    }

    for (size_t i = 0; haystack[i]; i++) {
        if (haystack[i] == needle[0]) {
            size_t j = 0;
            while (needle[j] && haystack[i + j] == needle[j]) {
                j++;
            }
            if (!needle[j]) {
                return (char *)&haystack[i];
            }
        }
    }
    return NULL;
}

char *strcpy(char *dst, const char *src) {
    if (dst == NULL || src == NULL) {
        return dst;
    }
    char *dst_ptr = dst;
    while (*src != '\0') {
        *dst_ptr = *src;
        dst_ptr++;
        src++;
    }
    *dst_ptr = '\0';
    return dst;
}

static void print_hex_buffer(const char *label, const void *buffer, size_t buffer_size) {
    const char hex_chars[] = "0123456789abcdef";
    
    size_t hex_str_len = buffer_size * 2;
    char hex_buf[hex_str_len + 1];
    memset(hex_buf, 0, sizeof(hex_buf));

    for (size_t i = 0; i < buffer_size; i++) {
        uint8_t byte = ((const uint8_t *)buffer)[i];
        hex_buf[i * 2]     = hex_chars[(byte >> 4) & 0x0F];
        hex_buf[i * 2 + 1] = hex_chars[byte & 0x0F];
    }
    hex_buf[hex_str_len] = '\0';

    LOG_INFO("%s ,length=0x%x", label, hex_str_len);
    for (size_t i = 0; i < hex_str_len; i += LOG_CHUNK_SIZE) {
        size_t remaining = hex_str_len - i;
        size_t chunk_size = (remaining > LOG_CHUNK_SIZE) ? LOG_CHUNK_SIZE : remaining;
        char temp = hex_buf[i + chunk_size];
        hex_buf[i + chunk_size] = '\0';
        LOG_INFO("%s", hex_buf + i);
        hex_buf[i + chunk_size] = temp;
    }
}

status_t generate_fixed_keypair(crypto_blinded_key_t *private_key, crypto_unblinded_key_t *public_key) {
    HARDENED_TRY(entropy_csrng_instantiate(
        kHardenedBoolTrue,  // 禁用TRNG输入
        &kFixedSeed         // 固定种子
    ));
    return otcrypto_ecdsa_keygen(&kCurveP256, private_key, public_key);
}

void attestation_uart_init(dif_uart_t *uart, uint32_t uart_num) {
    static dif_pinmux_t pinmux;

    switch (uart_num) {
      case 0://privacy ca
        CHECK_DIF_OK(dif_uart_init(mmio_region_from_addr(TOP_EARLGREY_UART0_BASE_ADDR), uart));
        CHECK(kUartBaudrate <= UINT32_MAX, "kUartBaudrate overflow");
        CHECK(kClockFreqPeripheralHz <= UINT32_MAX, "kClockFreqPeripheralHz overflow");
        CHECK_DIF_OK(dif_uart_configure(uart, (dif_uart_config_t){
            .baudrate = (uint32_t)kUartBaudrate,
            .clk_freq_hz = (uint32_t)kClockFreqPeripheralHz,
            .parity_enable = kDifToggleDisabled,
            .parity = kDifUartParityOdd,
            .tx_enable = kDifToggleEnabled,
            .rx_enable = kDifToggleEnabled,
        }));
        break;
      case 1://verifier
        CHECK_DIF_OK(dif_pinmux_init(mmio_region_from_addr(TOP_EARLGREY_PINMUX_AON_BASE_ADDR), &pinmux));
        pinmux_testutils_init(&pinmux);
        CHECK_DIF_OK(dif_uart_init(mmio_region_from_addr(TOP_EARLGREY_UART1_BASE_ADDR), uart));
        CHECK_DIF_OK(dif_pinmux_input_select(&pinmux,
                                            kTopEarlgreyPinmuxPeripheralInUart1Rx,
                                            kTopEarlgreyPinmuxInselIoa0));
        CHECK_DIF_OK(dif_pinmux_output_select(&pinmux, kTopEarlgreyPinmuxMioOutIoa0,
                                              kTopEarlgreyPinmuxOutselConstantHighZ));
        CHECK_DIF_OK(dif_pinmux_output_select(&pinmux, kTopEarlgreyPinmuxMioOutIoa1,
                                              kTopEarlgreyPinmuxOutselUart1Tx));
        CHECK(kUartBaudrate <= UINT32_MAX, "kUartBaudrate must fit in uint32_t");
        CHECK(kClockFreqPeripheralHz <= UINT32_MAX,
              "kClockFreqPeripheralHz must fit in uint32_t");
        CHECK_DIF_OK(dif_uart_configure(uart, (dif_uart_config_t){
                    .baudrate = (uint32_t)kUartBaudrate,
                    .clk_freq_hz = (uint32_t)kClockFreqPeripheralHz,
                    .parity_enable = kDifToggleDisabled,
                    .parity = kDifUartParityEven,
                    .tx_enable = kDifToggleEnabled,
                    .rx_enable = kDifToggleEnabled,
                }));
        break;
      case 2://2nd
        CHECK_DIF_OK(dif_pinmux_init(mmio_region_from_addr(TOP_EARLGREY_PINMUX_AON_BASE_ADDR), &pinmux));
        pinmux_testutils_init(&pinmux);
        CHECK_DIF_OK(dif_uart_init(mmio_region_from_addr(TOP_EARLGREY_UART2_BASE_ADDR), uart));
        CHECK_DIF_OK(dif_pinmux_input_select(&pinmux,
                                            kTopEarlgreyPinmuxPeripheralInUart2Rx,
                                            kTopEarlgreyPinmuxInselIob4));
        CHECK_DIF_OK(dif_pinmux_output_select(&pinmux, kTopEarlgreyPinmuxMioOutIob4,
                                              kTopEarlgreyPinmuxOutselConstantHighZ));
        CHECK_DIF_OK(dif_pinmux_output_select(&pinmux, kTopEarlgreyPinmuxMioOutIob5,
                                              kTopEarlgreyPinmuxOutselUart2Tx));
        CHECK(kUartBaudrate <= UINT32_MAX, "kUartBaudrate must fit in uint32_t");
        CHECK(kClockFreqPeripheralHz <= UINT32_MAX,
              "kClockFreqPeripheralHz must fit in uint32_t");
        CHECK_DIF_OK(dif_uart_configure(uart, (dif_uart_config_t){
                    .baudrate = (uint32_t)kUartBaudrate,
                    .clk_freq_hz = (uint32_t)kClockFreqPeripheralHz,
                    .parity_enable = kDifToggleDisabled,
                    .parity = kDifUartParityEven,
                    .tx_enable = kDifToggleEnabled,
                    .rx_enable = kDifToggleEnabled,
                }));
        break;
      default:
        LOG_INFO("No such serial port");
    }

    CHECK_DIF_OK(dif_uart_fifo_reset(uart, kDifUartDatapathRx));
    CHECK_DIF_OK(dif_uart_fifo_reset(uart, kDifUartDatapathTx));
    CHECK_DIF_OK(dif_uart_enable_rx_timeout(uart, UART_RX_TIMEOUT_TICKS));
}

static dif_result_t receive_block_cert(dif_uart_t *uart) {
  size_t avail_bytes = 0U;
  CHECK_DIF_OK(dif_uart_rx_bytes_available(uart, &avail_bytes));
  const size_t valid_avail = (avail_bytes > UART_FIFO_SIZE) ? UART_FIFO_SIZE : avail_bytes;

  if (valid_avail == 0U) {
    g_uart_idle_ticks++;
    return kDifOk;
  }

  g_uart_idle_ticks = 0U;
  uint8_t temp_buf[UART_FIFO_SIZE] = {0};
  size_t bytes_read = 0U;
  memset(temp_buf, 0, sizeof(temp_buf));
  CHECK_DIF_OK(dif_uart_bytes_receive(uart, valid_avail, temp_buf, &bytes_read));
  if (bytes_read == 0U) {
    return kDifOk;
  }

  LOG_INFO("Recv: %u bytes (current idx: %u)", (uint32_t)bytes_read, (uint32_t)g_cert_recv_idx);

  for (size_t i = 0U; i < bytes_read && g_cert_recv_idx < CERT_RECV_BUF_MAX; ++i) {
    const uint8_t curr_byte = temp_buf[i];
    if (!g_marker_matched) {
      if (curr_byte == AK_CERT_MARKER[g_marker_match_cnt]) {
        g_marker_match_cnt++;
        LOG_INFO("Marker match: %u/%u (0x%02x)", (uint32_t)g_marker_match_cnt, (uint32_t)AK_CERT_MARKER_LEN, curr_byte);
        if (g_marker_match_cnt == AK_CERT_MARKER_LEN) {
          g_marker_matched = true;
          g_cert_recv_idx = 0U;
          LOG_INFO("Marker matched! Start recvdata (idx reset to 0)");
        }
      } else {
        g_marker_match_cnt = 0;
        LOG_INFO("Marker mismatch (0x%02x != 0x%02x), reset cnt to 0", curr_byte, AK_CERT_MARKER[0]);
      }
    } else {
      g_data_recv_buf[g_cert_recv_idx++] = curr_byte;
      LOG_INFO("Recv byte: 0x%02x (idx: %u)", curr_byte, (uint32_t)g_cert_recv_idx);
    }
  }

  CHECK_DIF_OK(dif_uart_byte_send_polled(uart, UART_ACK_BYTE));
  LOG_INFO("Send ACK (0x%02x)", UART_ACK_BYTE);

  return kDifOk;
}

static dif_result_t receive_block_data(dif_uart_t *uart) {
  size_t avail_bytes = 0U;
  CHECK_DIF_OK(dif_uart_rx_bytes_available(uart, &avail_bytes));
  const size_t valid_avail = (avail_bytes > UART_FIFO_SIZE) ? UART_FIFO_SIZE : avail_bytes;

  if (valid_avail == 0U) {
    g_data_idle_ticks++;
    return kDifOk;
  }

  g_data_idle_ticks = 0U;
  uint8_t temp_buf[UART_FIFO_SIZE] = {0};
  size_t bytes_read = 0U;
  memset(temp_buf, 0, sizeof(temp_buf));
  CHECK_DIF_OK(dif_uart_bytes_receive(uart, valid_avail, temp_buf, &bytes_read));
  if (bytes_read == 0U) {
    return kDifOk;
  }

  LOG_INFO("Recv: %u bytes (current data idx: %u)", (uint32_t)bytes_read, (uint32_t)g_data_recv_idx);

  for (size_t i = 0; i < bytes_read && g_data_recv_idx < DATA_RECV_BUF_MAX; ++i) {
      g_data_recv_buf[g_data_recv_idx++] = temp_buf[i];
  }

  CHECK_DIF_OK(dif_uart_byte_send_polled(uart, UART_ACK_BYTE));
  LOG_INFO("Send ACK (0x%02x)", UART_ACK_BYTE);

  return kDifOk;
}


uint8_t g_ak_cert_plain[CERT_RECV_BUF_MAX] = {0};
size_t g_ak_cert_plain_len = 0U;
static size_t pkcs7_unpad(uint8_t *data, size_t len) {
  if (len == 0 || len % AES_BLOCK_SIZE != 0) {
    return len;
  }
  uint8_t pad_len = data[len - 1];
  if (pad_len < 1 || pad_len > AES_BLOCK_SIZE) {
    return len;
  }
  return len - pad_len;
}

static status_t aes_ecb256_decrypt(const uint8_t *ciphertext, size_t ciphertext_len,
                                   uint8_t *plaintext, size_t *plaintext_len) {
  if (ciphertext == NULL || plaintext == NULL || plaintext_len == NULL) {
    return INVALID_ARGUMENT();
  }

  if (ciphertext_len == 0 || ciphertext_len % AES_BLOCK_SIZE != 0) {
    *plaintext_len = 0;
    return INVALID_ARGUMENT();
  }
  dif_aes_t aes;
  dif_aes_transaction_t transaction = {
    .operation = kDifAesOperationDecrypt,
    .mode = kDifAesModeEcb,
    .key_len = kDifAesKey256,
    .key_provider = kDifAesKeySoftwareProvided,
    .mask_reseeding = kDifAesReseedPerBlock,
    .manual_operation = kDifAesManualOperationAuto,
    .reseed_on_key_change = false,
    .ctrl_aux_lock = false,
  };
  CHECK_DIF_OK(dif_aes_init(mmio_region_from_addr(TOP_EARLGREY_AES_BASE_ADDR), &aes));
  CHECK_DIF_OK(dif_aes_reset(&aes));
  dif_aes_key_share_t aes_key = {0};
  memcpy(aes_key.share0, g_aes_key, 32);
  memset(aes_key.share1, 0x00, 32);
  CHECK_DIF_OK(dif_aes_start(&aes, &transaction, &aes_key, NULL));
  size_t block_cnt = ciphertext_len / AES_BLOCK_SIZE;
  memset(plaintext, 0, ciphertext_len);
  for (size_t i = 0; i < block_cnt; i++) {
    dif_aes_data_t in_data = {0};
    dif_aes_data_t out_data = {0};

    memcpy(in_data.data, ciphertext + i * AES_BLOCK_SIZE, AES_BLOCK_SIZE);
    AES_TESTUTILS_WAIT_FOR_STATUS(&aes, kDifAesStatusInputReady, true, AES_TIMEOUT);
    CHECK_DIF_OK(dif_aes_load_data(&aes, in_data));

    AES_TESTUTILS_WAIT_FOR_STATUS(&aes, kDifAesStatusOutputValid, true, AES_TIMEOUT);
    CHECK_DIF_OK(dif_aes_read_output(&aes, &out_data));

    memcpy(plaintext + i * AES_BLOCK_SIZE, out_data.data, AES_BLOCK_SIZE);
  }
  CHECK_DIF_OK(dif_aes_end(&aes));
  *plaintext_len = pkcs7_unpad(plaintext, ciphertext_len);
  return OK_STATUS();
}

int recv_ak_cert(dif_uart_t uart0) {
    LOG_INFO("Waiting for AK certificate from UART...");
    size_t bytes_read = 0U;
    uint8_t input_buffer[32] = {0};

    g_ak_cert_received = false;
    g_uart_idle_ticks = 0U;
    while (!g_ak_cert_received) {
      (void)receive_block_cert(&uart0);
      sleep_ms(20);

      if (g_marker_matched && g_uart_idle_ticks > (UART_RECV_IDLE_TIMEOUT_MS / 20)) {
        g_ak_cert_received = true;
        g_actual_cert_byte_len = g_cert_recv_idx;
        LOG_INFO("Cert receive complete! Actual cert byte len: 0x%x", (uint32_t)g_actual_cert_byte_len);
      }

      if (g_cert_recv_idx >= CERT_RECV_BUF_MAX) {
        g_ak_cert_received = true;
        g_actual_cert_byte_len = CERT_RECV_BUF_MAX;
        LOG_WARNING("Cert buffer full! Max len: 0x%x", (uint32_t)CERT_RECV_BUF_MAX);
      }
    }

    g_actual_cert_hex_len = g_actual_cert_byte_len * 2U;
    memset(ctx_hex_buf, 0, CERT_HEX_BUF_MAX);
    LOG_INFO("Actual AK cert HEX length: 0x%x", g_actual_cert_hex_len);

    LOG_INFO("Press '1' to print the certificate.");
    while (true) {
      memset(input_buffer, 0, sizeof(input_buffer));
      CHECK_DIF_OK(dif_uart_bytes_receive(&uart0, sizeof(input_buffer), input_buffer, &bytes_read));

      if (bytes_read > 0U) {
        if (g_actual_cert_byte_len > 0) {
          const uint8_t *ciphertext = g_data_recv_buf;
          size_t ciphertext_len = g_actual_cert_byte_len;
          const char hex_chars[] = "0123456789abcdef";

          LOG_INFO("g_actual_cert_byte_len = 0x%x", (uint32_t)g_actual_cert_byte_len);
          LOG_INFO("ciphertext_len = 0x%x", (uint32_t)ciphertext_len);

          LOG_INFO("AK Cert ciphertext:");
          size_t cipher_hex_len = ciphertext_len * 2U;
          memset(ctx_hex_buf, 0, CERT_HEX_BUF_MAX);
          for (size_t i = 0U; i < ciphertext_len; ++i) {
            const uint8_t cert_byte = ciphertext[i];
            ctx_hex_buf[i*2U]   = hex_chars[(cert_byte >> 4U) & 0x0FU];
            ctx_hex_buf[i*2U+1] = hex_chars[cert_byte & 0x0FU];
          }
          ctx_hex_buf[cipher_hex_len] = '\0';
          for (size_t i = 0U; i < cipher_hex_len; i += CERT_HEX_BUF_MAX) {
            const size_t remaining = cipher_hex_len - i;
            const size_t chunk_size = (remaining > CERT_HEX_BUF_MAX) ? CERT_HEX_BUF_MAX : remaining;
            char temp = ctx_hex_buf[i + chunk_size];
            ctx_hex_buf[i + chunk_size] = '\0';
            LOG_INFO("%s", ctx_hex_buf + i);
            ctx_hex_buf[i + chunk_size] = temp;
          }

          if (status_ok(aes_ecb256_decrypt(ciphertext, ciphertext_len, g_ak_cert_plain, &g_ak_cert_plain_len))) {
            LOG_INFO("AK Cert Decrypt Success! Plain len: 0x%x bytes", (uint32_t)g_ak_cert_plain_len);

            LOG_INFO("AK Cert plaintext:");
            size_t plain_hex_len = g_ak_cert_plain_len * 2U;
            memset(ctx_hex_buf, 0, CERT_HEX_BUF_MAX);
            for (size_t i = 0U; i < g_ak_cert_plain_len; ++i) {
              const uint8_t cert_byte = g_ak_cert_plain[i];
              ctx_hex_buf[i*2U]   = hex_chars[(cert_byte >> 4U) & 0x0FU];
              ctx_hex_buf[i*2U+1] = hex_chars[cert_byte & 0x0FU];
            }
            ctx_hex_buf[plain_hex_len] = '\0';
            for (size_t i = 0U; i < plain_hex_len; i += CERT_HEX_BUF_MAX) {
              const size_t remaining = plain_hex_len - i;
              const size_t chunk_size = (remaining > CERT_HEX_BUF_MAX) ? CERT_HEX_BUF_MAX : remaining;
              char temp = ctx_hex_buf[i + chunk_size];
              ctx_hex_buf[i + chunk_size] = '\0';
              LOG_INFO("%s", ctx_hex_buf + i);
              ctx_hex_buf[i + chunk_size] = temp;
            }
            break;
          } else {
            LOG_ERROR("AK Cert Decrypt Failed!");
            g_ak_cert_plain_len = 0;
            return -1;
          }
        }
      }
      sleep_ms(100);
    }

  return 0;
}

int recv_csr(void) {
    size_t bytes_read = 0U;
    dif_uart_t uart2 = {0};

    LOG_INFO("Waiting for 2nd csr from uart2...");

    attestation_uart_init(&uart2, 2);
    CHECK_DIF_OK(dif_uart_fifo_reset(&uart2, kDifUartDatapathRx));
    CHECK_DIF_OK(dif_uart_fifo_reset(&uart2, kDifUartDatapathTx));
    CHECK_DIF_OK(dif_uart_enable_rx_timeout(&uart2, UART_RX_TIMEOUT_TICKS));
    sleep_ms(1000);

    while (1) {
        CHECK_DIF_OK(dif_uart_fifo_reset(&uart2, kDifUartDatapathRx));
        g_data_received = false;
        g_data_idle_ticks = 0U;
        g_data_recv_idx = 0U;
        size_t last_recv_idx = 0;

        CHECK_DIF_OK(dif_uart_bytes_send(&uart2, recv_csr_msg, sizeof(recv_csr_msg) - 1, &bytes_read));

        while (!g_data_received) {
            (void)receive_block_data(&uart2);
            sleep_ms(20);

            if (g_data_recv_idx == last_recv_idx) {
                g_data_idle_ticks++;
            } else {
                g_data_idle_ticks = 0;
                last_recv_idx = g_data_recv_idx;
            }

            if (g_data_idle_ticks > 500) {
                g_data_received = true;
                g_actual_data_byte_len = g_data_recv_idx;
            }

            if (g_data_recv_idx >= DATA_RECV_BUF_MAX) {
                g_data_received = true;
                g_actual_data_byte_len = g_data_recv_idx;
            }
        }

        if (g_actual_data_byte_len >= CSR_MIN_VALID_LEN) {
            LOG_INFO("CSR receive complete! Received %d bytes (0x%x)", (uint32_t)g_actual_data_byte_len, (uint32_t)g_actual_data_byte_len);
            break;
        }

        LOG_INFO("No valid CSR data yet (got 0x%x bytes), retrying...", g_actual_data_byte_len);
        sleep_ms(500);
    }
    memset(ctx_general_buf, 0, sizeof(ctx_general_buf));
    
    memcpy(ctx_general_buf, g_data_recv_buf, g_actual_data_byte_len);
    LOG_INFO("Actual 2nd CSR DER length: 0x%x bytes", g_actual_data_byte_len);
    print_hex_buffer("2nd CSR DER", ctx_general_buf, g_actual_data_byte_len);

    return 0;
}

int recv_measure_rom(dif_uart_t uart2) {
    LOG_INFO("Waiting for 2nd ROM from UART...");

    size_t bytes_written = 0U;

    LOG_INFO("Send trigger signal: 0x5a to UART...");
    CHECK_DIF_OK(dif_uart_bytes_send(&uart2, trigger_msg, sizeof(trigger_msg)-1, &bytes_written));

    g_data_received = false;
    g_data_idle_ticks = 0U;
    g_data_recv_idx = 0U;
    g_actual_data_byte_len = 0U;

    while (!g_data_received) {
      (void)receive_block_data(&uart2);
      sleep_ms(20);

      if (g_data_recv_idx >= ROM_TOTAL_SIZE) {
        g_data_received = true;
        g_actual_data_byte_len = ROM_TOTAL_SIZE;
        LOG_INFO("ROM receive complete! 2880 bytes (0x1680)");
        break;
      }

      if (g_data_idle_ticks > 5000) {
        g_data_received = true;
        g_actual_data_byte_len = g_data_recv_idx;
        LOG_INFO("ROM receive timeout! Received len: 0x%x", (uint32_t)g_actual_data_byte_len);
      }

      if (g_data_recv_idx >= DATA_RECV_BUF_MAX) {
        g_data_received = true;
        g_actual_data_byte_len = g_data_recv_idx;
      }
    }

    print_hex_buffer("Received ROM Data", g_data_recv_buf, g_actual_data_byte_len);
    LOG_INFO("Calculating ROM SHA256...");
    SHA256_hash(g_data_recv_buf, g_actual_data_byte_len, rom_sha256_digest);
    print_hex_buffer("ROM SHA256 Digest", rom_sha256_digest, SHA256_DIGEST_SIZE);

    bool measure_pass = true;

    for (int i = 0; i < SHA256_DIGEST_SIZE; i++) {
        if (rom_sha256_digest[i] != g_2nd_rom_expected_val[i]) {
            measure_pass = false;
            break;
        }
    }

    if (measure_pass) {
        LOG_INFO("ROM Measure PASS, Secondary ROM is trusted!");
        CHECK_DIF_OK(dif_uart_bytes_send(&uart2, start_2nd_msg, sizeof(start_2nd_msg)-1, &bytes_written));
    } else {
        LOG_ERROR("ROM Measure FAIL, ROM is tampered!");
        //CHECK_DIF_OK(dif_uart_bytes_send(&uart2, start_2nd_msg, sizeof(start_2nd_msg)-1, &bytes_written));
        CHECK_DIF_OK(dif_uart_bytes_send(&uart2, error_msg, sizeof(error_msg)-1, &bytes_written));
        return -1;
    }
    
    return 0;
}

/* int ecdsa_sign_hash_nonce(crypto_blinded_key_t quote_privatekey ,crypto_unblinded_key_t quote_publickey) {
    LOG_INFO("Quote Private key (keyblob, %d words):", keyblob_num_words(kPrivateKeyConfig));
    for (size_t i = 0; i < keyblob_num_words(kPrivateKeyConfig); i++) {
      LOG_INFO("  word[%d]: 0x%08x", (int)i, quote_privatekey.keyblob[i]);
    }

    LOG_INFO("Quote Public key (total %d words):", kP256PublicKeyWords);
    for (size_t i = 0; i < kP256PublicKeyWords; i++) {
      LOG_INFO("  word[%d]: 0x%08x", (int)i, quote_publickey.key[i]);
    }
    
    uint8_t data_to_sign[64];
    memcpy(data_to_sign, firmware_hash, 32);
    memcpy(data_to_sign + 32, nonce_bin, 32);
    
    crypto_const_byte_buf_t msg = {
        .len = sizeof(data_to_sign),
        .data = (unsigned char *)&data_to_sign,
    };
    uint32_t msg_digest_data[kSha256DigestWords];
    hash_digest_t msg_digest = {
        .data = msg_digest_data,
        .len = ARRAYSIZE(msg_digest_data),
        .mode = kHashModeSha256,
    };
    CHECK_STATUS_OK(otcrypto_hash(msg, &msg_digest));

    print_hex_buffer("pcr", firmware_hash, 32);

    print_hex_buffer("nonce", nonce_bin, 32);

    print_hex_buffer("msg", msg.data, msg.len);

    print_hex_buffer("msg_digest", msg_digest.data, 32);
    // Allocate space for the signature.
    uint32_t ecdsa_sig[kP256SignatureWords] = {0};

    // Generate a signature for the message.
    LOG_INFO("Signing...");
    CHECK_STATUS_OK(otcrypto_ecdsa_sign(
        &quote_privatekey, &msg_digest, &kCurveP256,
        (crypto_word32_buf_t){.data = ecdsa_sig, .len = ARRAYSIZE(ecdsa_sig)}));
    
    print_hex_buffer("signature", ecdsa_sig, sizeof(ecdsa_sig));

    for (int i = 0; i < kP256SignatureWords; i++) {
        quote_signature[i*4]   = ecdsa_sig[i] & 0xFF;
        quote_signature[i*4+1] = (ecdsa_sig[i] >> 8) & 0xFF;
        quote_signature[i*4+2] = (ecdsa_sig[i] >> 16) & 0xFF;
        quote_signature[i*4+3] = (ecdsa_sig[i] >> 24) & 0xFF;
    }

    print_hex_buffer("quote signature", quote_signature, sizeof(quote_signature));

    hardened_bool_t verificationResult;

    // Verify the signature.
    LOG_INFO("Verifying...");
    CHECK_STATUS_OK(otcrypto_ecdsa_verify(
        &quote_publickey, &msg_digest,
        (crypto_const_word32_buf_t){.data = ecdsa_sig, .len = ARRAYSIZE(ecdsa_sig)},
        &kCurveP256, &verificationResult));

    return 0;
} */

int mldsa_sign_hash_nonce(void) {
    uint8_t data_to_sign[32 + 32 + 1];
    uint8_t msg[32];
    memcpy(data_to_sign, firmware_hash, 32);
    memcpy(data_to_sign + 32, nonce_bin, 32);
    data_to_sign[64] = verify_status;
    
    SHA256_hash(data_to_sign, sizeof(data_to_sign), msg);

    print_hex_buffer("pcr", firmware_hash, 32);

    print_hex_buffer("nonce", nonce_bin, 32);

    print_hex_buffer("msg", msg, 32);

    // Generate a signature for the message.
    LOG_INFO("Signing...");
    int sign_ret = PQCP_MLDSA_NATIVE_MLDSA87_sign(mldsa_sig, msg, 32, mldsa_sk);
    if (sign_ret != 0) {
        LOG_ERROR("MLDSA87 sign FAILED! ret code: %d", sign_ret);
        return -1;
    }
    LOG_INFO("MLDSA87 sign SUCCESS! ret code: %d", sign_ret);
    //print_hex_buffer("mldsa-mldsa_sig", mldsa_sig, MLDSA87_SIG_SIZE);

    // Verify the signature.
    LOG_INFO("Verifying...");
    int verify_ret = PQCP_MLDSA_NATIVE_MLDSA87_verify(mldsa_sig, msg, 32, mldsa_pk);
    if (verify_ret != 0) {
        LOG_ERROR("MLDSA87 verify FAILED! ret code: %d", verify_ret);
        return -1;
    }
    LOG_INFO("MLDSA87 verify SUCCESS! ret code: %d", sign_ret);
    return 0;
}

size_t bin_to_hex(const uint8_t *bin, size_t bin_len, char *hex_out) {
    if (bin == NULL || hex_out == NULL || bin_len == 0) {
        return 0;
    }
    const char hex_chars[] = "0123456789abcdef";
    for (size_t i = 0; i < bin_len; i++) {
        hex_out[i*2] = hex_chars[(bin[i] >> 4) & 0x0F];
        hex_out[i*2+1] = hex_chars[bin[i] & 0x0F];
    }
    hex_out[bin_len*2] = '\0';
    return bin_len * 2;
}

/* void pack_quote(void) {
    char quote_hex_buf[QUOTE_BUFFER_SIZE * 2 + 100] = {0};
    char *p = quote_hex_buf;

    // 1. 数据头
    strcpy(p, "#QUOTE#");
    p += strlen("#QUOTE#");
    LOG_INFO("Add quote separator: #QUOTE#");

    // 2. AK证书长度
    uint16_t ak_cert_hex_len = (uint16_t)g_actual_cert_hex_len;
    char ak_len_hex[5] = {0};
    const char hex_chars[] = "0123456789abcdef";
    ak_len_hex[0] = hex_chars[(ak_cert_hex_len >> 12) & 0x0F];
    ak_len_hex[1] = hex_chars[(ak_cert_hex_len >> 8) & 0x0F];
    ak_len_hex[2] = hex_chars[(ak_cert_hex_len >> 4) & 0x0F];
    ak_len_hex[3] = hex_chars[ak_cert_hex_len & 0x0F];
    strcpy(p, ak_len_hex);
    p += 4;

    // 3. AK证书HEX
    if (g_actual_cert_hex_len > 0 && g_actual_cert_hex_len < CERT_HEX_BUF_MAX) {
        strcpy(p, ctx_hex_buf);
        p += g_actual_cert_hex_len;
        LOG_INFO("Packed AK certificate HEX: %d bytes", g_actual_cert_hex_len);
    } else {
        LOG_ERROR("Invalid AK cert HEX length: %d", g_actual_cert_hex_len);
        return;
    }

    // 4. PCR转HEX字符串
    char pcr_hex[NONCE_LENGTH * 2 + 1] = {0};
    size_t pcr_hex_len = bin_to_hex(firmware_hash, NONCE_LENGTH, pcr_hex);
    strcpy(p, pcr_hex);
    p += pcr_hex_len;
    LOG_INFO("Packed PCR HEX: %d bytes", pcr_hex_len);

    // 5. Nonce转HEX字符串
    char nonce_hex[NONCE_LENGTH * 2 + 1] = {0};
    size_t nonce_hex_len = bin_to_hex(nonce_bin, NONCE_LENGTH, nonce_hex);
    strcpy(p, nonce_hex);
    p += nonce_hex_len;
    LOG_INFO("Packed Nonce HEX: %d bytes", nonce_hex_len);

    // 6. ECDSA签名转HEX字符串
    char sign_hex[ECC_SIGN_LEN * 2 + 1] = {0};

    size_t sign_hex_len = bin_to_hex(quote_signature, ECC_SIGN_LEN, sign_hex);

    strcpy(p, sign_hex);
    p += sign_hex_len;
    LOG_INFO("Packed Signature HEX: %d bytes", sign_hex_len);

    // 7. 结束分隔符
    strcpy(p, "#END#");
    p += strlen("#END#");

    size_t quote_hex_total_len = (size_t)(p - quote_hex_buf);
    memset(quote_buf, 0, QUOTE_BUFFER_SIZE);
    memcpy(quote_buf, quote_hex_buf, quote_hex_total_len);

    LOG_INFO("Full quote HEX package: %d bytes", quote_hex_total_len);
    LOG_INFO("Quote HEX preview: %.*s", 50, quote_hex_buf);
} */

void pack_quote_mldsa(void) {
    char *p = g_pack_quote_work_buf;

    // 1. 数据头
    strcpy(p, "#QUOTE#");
    p += strlen("#QUOTE#");
    LOG_INFO("Add quote separator: #QUOTE#");

    // 2. AK证书长度
    uint16_t ak_cert_hex_len = (uint16_t)g_actual_cert_hex_len;
    char ak_len_hex[5] = {0};
    const char hex_chars[] = "0123456789abcdef";
    ak_len_hex[0] = hex_chars[(ak_cert_hex_len >> 12) & 0x0F];
    ak_len_hex[1] = hex_chars[(ak_cert_hex_len >> 8) & 0x0F];
    ak_len_hex[2] = hex_chars[(ak_cert_hex_len >> 4) & 0x0F];
    ak_len_hex[3] = hex_chars[ak_cert_hex_len & 0x0F];
    strcpy(p, ak_len_hex);
    p += 4;

    // 3. AK证书HEX
    if (g_actual_cert_hex_len > 0 && g_actual_cert_hex_len < CERT_HEX_BUF_MAX) {
        strcpy(p, ctx_hex_buf);
        p += g_actual_cert_hex_len;
        LOG_INFO("Packed AK certificate HEX: %d bytes", g_actual_cert_hex_len);
    } else {
        LOG_ERROR("Invalid AK cert HEX length: %d", g_actual_cert_hex_len);
        return;
    }

    // 4. PCR转HEX字符串
    char pcr_hex[NONCE_LENGTH * 2 + 1] = {0};
    size_t pcr_hex_len = bin_to_hex(firmware_hash, NONCE_LENGTH, pcr_hex);
    strcpy(p, pcr_hex);
    p += pcr_hex_len;
    LOG_INFO("Packed PCR HEX: %d bytes", pcr_hex_len);

    // 5. Nonce转HEX字符串
    char nonce_hex[NONCE_LENGTH * 2 + 1] = {0};
    size_t nonce_hex_len = bin_to_hex(nonce_bin, NONCE_LENGTH, nonce_hex);
    strcpy(p, nonce_hex);
    p += nonce_hex_len;
    LOG_INFO("Packed Nonce HEX: %d bytes", nonce_hex_len);

    // 6. 证书链验证状态标志
    *p++ = hex_chars[(verify_status >> 4) & 0x0F];
    *p++ = hex_chars[ verify_status       & 0x0F];
    LOG_INFO("Cert chain verify flag: 0x%02x", (uint8_t)*(p-1));

    // 7. MLDSA签名转HEX字符串
    char sign_hex[MLDSA87_SIG_SIZE * 2 + 1] = {0};
    size_t sign_hex_len = bin_to_hex(mldsa_sig, MLDSA87_SIG_SIZE, sign_hex);
    strcpy(p, sign_hex);
    p += sign_hex_len;
    LOG_INFO("Packed Signature HEX: %d bytes", sign_hex_len);

    // 8. 结束分隔符
    strcpy(p, "#END#");
    p += strlen("#END#");

    size_t quote_hex_total_len = (size_t)(p - g_pack_quote_work_buf);
    g_quote_hex_total_len = quote_hex_total_len;
    memset(quote_buf_mldsa, 0, MLDSA_QUOTE_BUFFER_SIZE);
    memcpy(quote_buf_mldsa, g_pack_quote_work_buf, quote_hex_total_len);

    LOG_INFO("Full quote HEX package: %d bytes", quote_hex_total_len);
}

void uart_send_hex_chunked(dif_uart_t *uart, const uint8_t *data, size_t len, 
                           size_t chunk_size, uint32_t delay_ms) {
    if (uart == NULL || data == NULL || len == 0 || chunk_size == 0) {
        return;
    }

    size_t sent = 0;
    while (sent < len) {
        size_t remaining = len - sent;
        size_t send_len = (remaining > chunk_size) ? chunk_size : remaining;

        size_t actual_sent = 0;
        CHECK_DIF_OK(dif_uart_bytes_send(
            uart,                // 参数1：UART句柄
            data + sent,         // 参数2：数据指针（当前块起始）
            send_len,            // 参数3：请求发送的字节数
            &actual_sent         // 参数4：实际发送的字节数
        ));
        sent += actual_sent;

        LOG_INFO("Sent %d/%d bytes (chunk: %d bytes)", (uint32_t)sent, (uint32_t)len, (uint32_t)send_len);
        
        sleep_ms(delay_ms);
    }
    LOG_INFO("All data sent: %d bytes total", (uint32_t)len);
}

int remote_attestation_mldsa(dif_uart_t uart1) {

    memcpy(firmware_hash, rom_sha256_digest, 32);

    if (mldsa_sign_hash_nonce() != 0) {
        LOG_ERROR("mldsa_sign_hash_nonce failed.");
        return -1;
    }

    pack_quote_mldsa();

    size_t quote_total_len = g_quote_hex_total_len;
    LOG_INFO("Sending quote HEX package, total length: 0x%x bytes", quote_total_len);

    uart_send_hex_chunked(&uart1, quote_buf_mldsa, quote_total_len, 32, 10);

    LOG_INFO("Quote package sent completely");
    return 0;
}

int X509_sign_ctx(dif_uart_t uart2, uint8_t *private_key_bytes, uint8_t *public_key_bytes) {
    uint8_t signature[ECC_BYTES * 2] = {0};
    size_t bytes_read = 0U;
    LOG_INFO("start sign 2nd certificates");
    memset(ctx_general_buf, 0, sizeof(ctx_general_buf));

    recv_csr();

    uint8_t msg_hash[48];

    SHA384_hash((const uint8_t *)ctx_general_buf, g_actual_data_byte_len, msg_hash);
    LOG_INFO("TBS SHA384 digest generated");
    print_hex_buffer("TBS SHA384 digest", msg_hash, sizeof(msg_hash));

    int ret = ecdsa_sign(private_key_bytes, msg_hash, signature);
    if (ret != 1) {
        LOG_ERROR("ECDSA-P384 sign failed! ret=%d", ret);
        return -1;
    }
    LOG_INFO("TBS signed with ECDSA-P384");
    print_hex_buffer("ECDSA-P384 Signature", signature, sizeof(signature));

    LOG_INFO("Verifying P-384 signature...");
    ret = ecdsa_verify(public_key_bytes, msg_hash, signature);
    if (ret != 1) {
        LOG_ERROR("ECDSA-P384 verify failed! ret=%d", ret);
        return -1;
    }
    LOG_INFO("Verify Success! P-384 signature is valid");

    const uint8_t *sig_r_bytes = &signature[0];
    const uint8_t *sig_s_bytes = &signature[ECC_BYTES];
    print_hex_buffer("sig_r", sig_r_bytes, ECC_BYTES);
    print_hex_buffer("sig_s", sig_s_bytes, ECC_BYTES);

    uint8_t cert_der[SEND_MAX_CERT_SIZE];
    size_t cert_len = sizeof(cert_der);

    int result = add_signature_to_cert_p384_sig((uint8_t *)ctx_general_buf, g_actual_data_byte_len, sig_r_bytes, sig_s_bytes, cert_der, &cert_len);
    if (result != 0) {
        LOG_ERROR("Failed to add P-384 signature to certificate, err=%d", result);
        return -1;
    }

    if (cert_len > SEND_MAX_CERT_SIZE || cert_len == 0) {
        LOG_ERROR("Invalid cert length: %d (max allowed: %d)", cert_len, SEND_MAX_CERT_SIZE);
        return -1;
    }
    LOG_INFO("Complete X509 Certificate generated, DER length=%d bytes", cert_len);

    CHECK_DIF_OK(dif_uart_bytes_send(&uart2, send_cxt_msg, sizeof(send_cxt_msg)-1, &bytes_read));

    print_hex_buffer("2nd Certificate DER", cert_der, cert_len);

    uart_send_hex_chunked(&uart2, cert_der, cert_len, 32, 10);
    return 0;
}

int verify_cert_chain(dif_uart_t uart2, uint8_t *public_key_bytes) {
    int status = 0;
    uint8_t input_buffer[32] = {0};
    size_t bytes_read = 0U;
    status = recv_measure_rom(uart2);
    if (status != 0) {
      return -1;
    }

    LOG_INFO("Waiting for 2nd certificate from UART...");

    while (1) {
        CHECK_DIF_OK(dif_uart_fifo_reset(&uart2, kDifUartDatapathRx));
        g_data_received = false;
        g_data_idle_ticks = 0U;
        g_data_recv_idx = 0U;
        size_t last_recv_idx = 0;

        while (!g_data_received) {
            (void)receive_block_data(&uart2);
            sleep_ms(20);

            if (g_data_recv_idx == last_recv_idx) {
                g_data_idle_ticks++;
            } else {
                g_data_idle_ticks = 0;
                last_recv_idx = g_data_recv_idx;
            }

            if (g_data_idle_ticks > 500) {
                g_data_received = true;
                g_actual_data_byte_len = g_data_recv_idx;
            }

            if (g_data_recv_idx >= DATA_RECV_BUF_MAX) {
                g_data_received = true;
                g_actual_data_byte_len = g_data_recv_idx;
            }
        }

        if (g_actual_data_byte_len >= CSR_MIN_VALID_LEN) {
            LOG_INFO("2nd cert receive complete! Received %d bytes (0x%x)", (uint32_t)g_actual_data_byte_len, (uint32_t)g_actual_data_byte_len);
            break;
        }

        LOG_INFO("No valid 2nd cert data yet (got 0x%x bytes), retrying...", g_actual_data_byte_len);
        sleep_ms(500);
    }

    memcpy(ctx_general_buf, g_data_recv_buf, g_actual_data_byte_len);
    LOG_INFO("Actual 2nd cert DER length: 0x%x bytes", g_actual_data_byte_len);
    print_hex_buffer("2nd cert DER", ctx_general_buf, g_actual_data_byte_len);

    int ret = verify_cert((uint8_t *)ctx_general_buf, g_actual_data_byte_len, public_key_bytes);
    if (ret == 1) {
        LOG_INFO("2nd cert verify success");
        CHECK_DIF_OK(dif_uart_bytes_send(&uart2, send_verify_msg, sizeof(send_verify_msg)-1, &bytes_read));
    } else {
        LOG_INFO("2nd cert verify failed, ret = %d", ret);
        CHECK_DIF_OK(dif_uart_bytes_send(&uart2, error_msg, sizeof(error_msg)-1, &bytes_read));
        return -1;
    }

    LOG_INFO("Waiting for 2nd verify 1st certificate ...");

    while(1) {
        memset(input_buffer, 0x0, sizeof(input_buffer));
        CHECK_DIF_OK(dif_uart_bytes_receive(&uart2, sizeof(input_buffer), input_buffer, &bytes_read));
        sleep_ms(1000); 
        if(bytes_read > 0) {
           if(input_buffer[0] == 0xaa) {
              verify_status = 0xaa;
              return 0;
           } else if (input_buffer[0] == 0xba){
              verify_status = 0xba;
              return -1;
           }
        }
    }
}

bool test_main(void) {
    int status = 0;
    dif_uart_t uart = {0};

    CHECK_STATUS_OK(entropy_complex_init());

    uint32_t ek_keyblob[keyblob_num_words(kPrivateKeyConfig)];
    crypto_blinded_key_t ek_privatekey = {
        .config = kPrivateKeyConfig,
        .keyblob_length = sizeof(ek_keyblob),
        .keyblob = ek_keyblob,
    };

    uint32_t ek_pk[kP256PublicKeyWords] = {0};
    crypto_unblinded_key_t ek_publickey = {
        .key_mode = kKeyModeEcdsa,
        .key_length = sizeof(ek_pk),
        .key = ek_pk,
    };

    memcpy(ek_privatekey.keyblob, ek_private_key, sizeof(ek_private_key));
    memcpy(ek_publickey.key, ek_public_key, sizeof(ek_public_key));

    LOG_INFO("EK Private key (keyblob, %d words):", keyblob_num_words(kPrivateKeyConfig));
    for (size_t i = 0; i < keyblob_num_words(kPrivateKeyConfig); i++) {
      LOG_INFO("  word[%d]: 0x%08x", (int)i, ek_privatekey.keyblob[i]);
    }

    LOG_INFO("EK Public key (total %d words):", kP256PublicKeyWords);
    for (size_t i = 0; i < kP256PublicKeyWords; i++) {
      LOG_INFO("  word[%d]: 0x%08x", (int)i, ek_publickey.key[i]);
    }
    const uint32_t *ek_pubkey_x = &ek_publickey.key[0];
    const uint32_t *ek_pubkey_y = &ek_publickey.key[8];

    LOG_INFO("EK Public key (X coordinates, 8 words):");
    for (size_t i = 0; i < 8; i++) {
      LOG_INFO("  word[%d]: 0x%08x", (int)i, ek_pubkey_x[i]);
    }

    LOG_INFO("EK Public key (Y coordinates, 8 words):");
    for (size_t i = 0; i < 8; i++) {
      LOG_INFO("  word[%d]: 0x%08x", (int)i, ek_pubkey_y[i]);
    }
 
    uint8_t tbs_der[2048];
    size_t tbs_len = sizeof(tbs_der);

    const char *ek_issuer_name = "3rd Root CA";
    const char *ek_subject_name = "EK Cert";

    int result = generate_intermediate_tbs_der(ek_pubkey_x, ek_pubkey_y, ek_issuer_name, ek_subject_name,tbs_der, &tbs_len, CERT_TYPE_ROOT_CA);

    if (result != 0) {
        LOG_ERROR("Failed to generate TBS DER, err=%d", result);
        return false;
    }
    LOG_INFO("TBS DER generated, length=%d bytes", tbs_len);

    uint32_t ecdsa_sig[kP256SignatureWords] = {0};

    crypto_const_byte_buf_t tbs_buf = {
        .len = tbs_len,
        .data = tbs_der,
    };
    uint32_t tbs_digest[kSha256DigestWords];
    hash_digest_t digest = {
        .data = tbs_digest,
        .len = ARRAYSIZE(tbs_digest),
        .mode = kHashModeSha256,
    };
    CHECK_STATUS_OK(otcrypto_hash(tbs_buf, &digest));
    LOG_INFO("TBS SHA256 digest generated.");
    LOG_INFO("digest.data (SHA256):");
    for (size_t i = 0; i < kSha256DigestWords; i++) {
        LOG_INFO("  word[%d]: 0x%08x", (int)i, digest.data[i]);
    }

    CHECK_STATUS_OK(otcrypto_ecdsa_sign(&ek_privatekey, &digest, &kCurveP256, (crypto_word32_buf_t){.data = ecdsa_sig, .len = ARRAYSIZE(ecdsa_sig)}));
    LOG_INFO("TBS signed with ECDSA-P256-SHA256.");

    LOG_INFO("ECDSA Signature (total %d words):", kP256SignatureWords);
    for (size_t i = 0; i < kP256SignatureWords; i++) {
      LOG_INFO("  word[%d]: 0x%08x", (int)i, ecdsa_sig[i]);
    }
    LOG_INFO("Verifying...");
    hardened_bool_t verificationResult;
    CHECK_STATUS_OK(otcrypto_ecdsa_verify(&ek_publickey, &digest, (crypto_const_word32_buf_t){.data = ecdsa_sig, .len = ARRAYSIZE(ecdsa_sig)}, &kCurveP256, &verificationResult));

    const uint32_t *sig_r = &ecdsa_sig[0];
    const uint32_t *sig_s = &ecdsa_sig[8];

    LOG_INFO("sig_r (8 words):");
    for (size_t i = 0; i < 8; i++) {
      LOG_INFO("  word[%d]: 0x%08x", (int)i, sig_r[i]);
    }

    LOG_INFO("sig_s (8 words):");
    for (size_t i = 0; i < 8; i++) {
      LOG_INFO("  word[%d]: 0x%08x", (int)i, sig_s[i]);
    }

    uint8_t cert_der[SEND_MAX_CERT_SIZE];
    size_t cert_len = sizeof(cert_der);

    result = add_signature_to_cert(tbs_der, tbs_len, sig_r, sig_s, cert_der, &cert_len);
    if (result != 0) {
        LOG_ERROR("Failed to add signature to certificate, err=%d", result);
        return false;
    }

    if (cert_len > SEND_MAX_CERT_SIZE || cert_len == 0) {
        LOG_ERROR("Invalid cert length: %d (max allowed: %d)", cert_len, SEND_MAX_CERT_SIZE);
        return false;
    }
    LOG_INFO("Complete X509 Certificate generated, DER length=%d bytes", cert_len);

    //Printing this certificate is equivalent to sending it to the privacy CA via UART0
    print_hex_buffer("EK Certificate DER", cert_der, cert_len);

    uint8_t public_key[ECC_BYTES + 1];
    uint8_t private_key[ECC_BYTES];
    int ret;
    ret = ecc_make_key(public_key, private_key);
    if (ret != 1)
    {
        LOG_INFO("Key Generate Failed!\n");
        return -1;
    }
    LOG_INFO("Key Generate Success!\n");
    print_hex_buffer("ecdsa-p384 test public_key", public_key, sizeof(public_key));
    print_hex_buffer("ecdsa-p384 test private_key", private_key, sizeof(private_key));
    
    LOG_INFO("Generating MLDSA87 key pair...");
    int keypair_ret = PQCP_MLDSA_NATIVE_MLDSA87_keypair(mldsa_pk, mldsa_sk);
    if (keypair_ret != 0) {
        LOG_ERROR("MLDSA87 sign FAILED! ret code: %d", keypair_ret);
        return -1;
    }
    LOG_INFO("MLDSA87 keypair SUCCESS! ret code: %d", keypair_ret);

    print_hex_buffer("MLDSA Public Key", mldsa_pk, MLDSA87_PK_SIZE);

    attestation_uart_init(&uart, 0);
    status = recv_ak_cert(uart);
    if (status != 0) {
        return false;
    }
    
    attestation_uart_init(&uart, 2);
    status = recv_measure_rom(uart);
    if (status != 0) {
        return false;
    }

    status = X509_sign_ctx(uart, private_key, public_key);
    if (status != 0) {
        return false;
    }

    attestation_uart_init(&uart, 1);
    size_t bytes_read = 0;
    while(1) {
        memset(nonce_bin, 0, sizeof(nonce_bin));
        LOG_INFO("Waiting to receive [nonce].");
        do {
            memset(uart_rx_buf, 0x0, sizeof(uart_rx_buf));
            CHECK_DIF_OK(dif_uart_bytes_receive(&uart, sizeof(uart_rx_buf), uart_rx_buf, &bytes_read));
            sleep_ms(100); 
            if(bytes_read > 0) {
                LOG_INFO("Received %u bytes", bytes_read);
            }
            
            if (bytes_read == NONCE_LENGTH) {
                memcpy(nonce_bin, uart_rx_buf, NONCE_LENGTH);
                LOG_INFO("Received nonce:");
                for (int i = 0; i < 32; i++) {
                    LOG_INFO("%02x", nonce_bin[i]);
                }
            }
        } while(bytes_read != NONCE_LENGTH);

        attestation_uart_init(&uart, 2);
        status = verify_cert_chain(uart, public_key);
        if(status != 0) {
            LOG_ERROR("Multi-level Trusted Root Certificate chain verification failed");
        } else {
            LOG_ERROR("Multi-level Trusted Root Certificate chain verification success");
        }

        attestation_uart_init(&uart, 1);
        remote_attestation_mldsa(uart);
    }

    return true;
}
