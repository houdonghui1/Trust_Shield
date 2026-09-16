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
#include "sw/device/my_tests/attestation/bls/cluster_bls_protocol.h"
#include "sw/device/my_tests/attestation/vendor_mldsa/mldsa_native.h"
#include "sw/device/my_tests/attestation/sha/sha256.h"
#include "sw/device/my_tests/attestation/sha/sha384.h"
#include "sw/device/my_tests/attestation/ecdsa-p384/ecc.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "hw/ip/aes/model/aes_modes.h"

#include "sw/device/my_tests/attestation/cluster_bls_scale_config.h"

#define AK_CERT_MARKER "AK_CERT:"
#define AK_CERT_MARKER_LEN 8U
#define SEND_MAX_CERT_SIZE 2048
#define LOG_CHUNK_SIZE (MLDSA87_PK_SIZE*2)
#define UART_ACK_BYTE 0x06U
#define UART_FAILURE_BYTE 0xbaU
#define UART_FIFO_SIZE 32U
#define UART_RX_TIMEOUT_TICKS 1000U
#define UART_RECV_IDLE_TIMEOUT_MS 5000U
#define ROM_TRIGGER_RETRY_INTERVAL_MS 3000U
#define ROM_RECEIVE_POLL_INTERVAL_MS 20U
#define CSR_REQUEST_RETRY_INTERVAL_MS 3000U
#define NONCE_LENGTH 32U
//#define QUOTE_BUFFER_SIZE 2048U
#define MLDSA_QUOTE_BUFFER_SIZE 22528u
//#define ECC_SIGN_LEN 64U
#define CERT_RECV_BUF_MAX 8192U
#define CERT_HEX_BUF_MAX (CERT_RECV_BUF_MAX * 2U + 1U + LOG_CHUNK_SIZE)
#define AES_BLOCK_SIZE 16U
#define AES_TIMEOUT (10 * 1000 * 1000)
#define ROM_TOTAL_SIZE        2880U
#define DATA_RECV_BUF_MAX      8192U
#define CSR_RECV_MAX_RETRY 3
#define CSR_MIN_VALID_LEN  16
#define VERIFIER_READY_BYTE 0xa5U
#define VERIFIER_READY_INTERVAL_POLLS 10U

enum {
    kClusterBlsQuoteBlockBytes = 1 + 8 + kClusterBlsDigestBytes + 1 +
                                 kOtBlsSignatureBytes,
    kClusterBlsQuoteRequestMaxBytes = 4 + 1 + kClusterBlsMaxClusterIdBytes +
                                      8 + kClusterBlsDigestBytes + 1 +
                                      kClusterBlsNonceBytes,
    kClusterBlsChallengePreimageMax = 384,
    kClusterBlsL2ChallengeRequestBytes = 4 + kClusterBlsDigestBytes,
    kClusterBlsL2AggregateResponseBytes = 4 + kOtBlsSignatureBytes,
};

#define CLUSTER_BLS_PROOF_SUCCESS 0xaaU
#define CLUSTER_BLS_PROOF_FAILURE 0xbaU
#define CLUSTER_BLS_UART_TIMEOUT_MS 120000U

static size_t g_actual_cert_byte_len = 0U;
static size_t g_actual_cert_hex_len = 0U;
static uint8_t ctx_general_buf[SEND_MAX_CERT_SIZE] = {0};
static size_t g_cert_recv_idx = 0U;
static bool g_marker_matched = false;
static size_t g_marker_match_cnt = 0U;
static bool g_ak_cert_received = false;
static uint32_t g_uart_idle_ticks = 0U;
static size_t g_quote_hex_total_len = 0U;
//static uint8_t quote_buf[QUOTE_BUFFER_SIZE] = {0};
static uint8_t firmware_hash[NONCE_LENGTH] = {0};
static uint8_t uart_rx_buf[NONCE_LENGTH] = {0};
static uint8_t nonce_bin[NONCE_LENGTH] = {0};
//static uint8_t quote_signature[ECC_SIGN_LEN] = {0};
static uint8_t mldsa_pk[MLDSA87_PK_SIZE] = {0};
static uint8_t mldsa_sk[MLDSA87_SK_SIZE] = {0};
static union {
    uint8_t data_recv_buf[DATA_RECV_BUF_MAX];
    uint8_t mldsa_sig[MLDSA87_SIG_SIZE];
} g_mldsa_io = {0};
#define g_data_recv_buf (g_mldsa_io.data_recv_buf)
#define mldsa_sig (g_mldsa_io.mldsa_sig)
static uint8_t quote_buf_mldsa[MLDSA_QUOTE_BUFFER_SIZE] = {0};
/* Certificate HEX is temporary and is regenerated from g_ak_cert_plain when
 * the quote is packed, so the final quote buffer can also be its scratch. */
#define ctx_hex_buf ((char *)quote_buf_mldsa)
static size_t  g_data_recv_idx = 0U;
static size_t  g_actual_data_byte_len = 0U;
static bool    g_data_received = false;
static uint32_t g_data_idle_ticks = 0U;
static uint8_t rom_sha256_digest[SHA256_DIGEST_SIZE] = {0};
static uint8_t verify_status = 0U;

static cluster_bls_signer_t g_l3_bls_signer = {0};
static cluster_bls_registration_t g_l3_bls_registration = {0};
static cluster_bls_registration_t g_l2_bls_registration = {0};
static cluster_bls_challenge_t g_cluster_bls_request = {0};
static uint8_t g_cluster_bls_quote_block[kClusterBlsQuoteBlockBytes] = {0};
static uint32_t g_cluster_bls_scale_profile = 0U;

static const uint8_t kClusterBlsQuoteRequestMagic[4] = {'B', 'L', 'Q', '1'};
static const uint8_t kClusterBlsL2ChallengeRequestMagic[4] = {'B', 'L', 'C', '1'};
static const uint8_t kClusterBlsL2AggregateResponseMagic[4] = {'B', 'L', 'A', '1'};
static const uint8_t kClusterBlsKeyListRequestMagic[4] = {'K', 'L', 'R', '1'};
static const uint8_t kClusterBlsL2KeyListResponseMagic[4] = {'K', 'L', 'A', '1'};
static const uint8_t kClusterBlsVerifierKeyListResponseMagic[4] = {'K', 'L', 'V', '1'};
static const uint8_t kClusterBlsKeyListDomain[] =
    "CLUSTER-BLS-KEY-LIST-WIRE-v1";
static const uint8_t kClusterBlsClusterId[] = {'C', '-', '0', '0', '1'};
static const uint8_t kClusterBlsPreprovisionedListDigest[kClusterBlsDigestBytes] = {
    0x06, 0x6a, 0xd2, 0xd0, 0x43, 0x22, 0x1b, 0xf0,
    0x2d, 0xf4, 0xf9, 0xec, 0xe7, 0x3e, 0x76, 0x62,
    0xe2, 0x06, 0xe1, 0x6e, 0x26, 0x27, 0xee, 0x78,
    0x5b, 0xa7, 0x9d, 0x7b, 0x23, 0x9b, 0xf1, 0xb6,
};
static volatile bool g_cluster_bls_dynamic_requests = false;

/* Demo only. Replace with CDI-derived IKM when the real DICE interface is
 * available. Keeping this fixed makes the pre-provisioned verifier list
 * deterministic. */
static const uint8_t kL3BlsTestIkm[kOtBlsMinIkmBytes] = {
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
};

static const uint8_t kMldsaTestSeed[MLDSA_SEEDBYTES] = {
    0xd0, 0x0d, 0x54, 0x02, 0x2b, 0xc3, 0x85, 0x54,
    0xc8, 0xe8, 0xaf, 0xd3, 0xb9, 0x32, 0x77, 0xb3,
    0x6d, 0xe1, 0xf1, 0xf8, 0x27, 0xaa, 0xdc, 0xd0,
    0x4f, 0x53, 0x7c, 0xda, 0xb9, 0xbd, 0x9f, 0x73,
};

const uint8_t trigger_msg[] = "0x5a";
const uint8_t start_2nd_msg[] = "0x6a";
const uint8_t recv_csr_msg[] = "0x7a";
const uint8_t send_cxt_msg[] = "0x8a";
const uint8_t send_verify_msg[] = "0x9a";
static const uint8_t kL2CertificateInstallMagic[4] = {'L', '2', 'C', '1'};

const uint8_t g_aes_key[32] = {
    0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,
    0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f,
    0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,
    0x18,0x19,0x1a,0x1b,0x1c,0x1d,0x1e,0x1f
};

const uint8_t g_2nd_rom_expected_val[32] = {
    0xc5,0xfb,0x8d,0xa0,0x72,0x32,0x31,0x64,
    0x4a,0xde,0x60,0x62,0x89,0x7c,0x3c,0x48,
    0xbd,0xf9,0xb2,0x92,0x26,0xbe,0x9c,0x49,
    0xa5,0x2b,0xb0,0xee,0xf2,0x56,0x59,0x7c
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
    char hex_buf[257];
    const uint8_t *input = (const uint8_t *)buffer;

    LOG_INFO("%s ,length=0x%x", label, (uint32_t)(buffer_size * 2U));
    for (size_t offset = 0U; offset < buffer_size; offset += 128U) {
        size_t chunk_bytes = buffer_size - offset;
        if (chunk_bytes > 128U) {
            chunk_bytes = 128U;
        }
        for (size_t i = 0U; i < chunk_bytes; ++i) {
            uint8_t byte = input[offset + i];
            hex_buf[i * 2U] = hex_chars[(byte >> 4U) & 0x0fU];
            hex_buf[i * 2U + 1U] = hex_chars[byte & 0x0fU];
        }
        hex_buf[chunk_bytes * 2U] = '\0';
        LOG_INFO("%s", hex_buf);
    }
}

static bool bls_write_hex(char *out, size_t out_size,
                          const uint8_t *input, size_t input_len) {
    static const char kHex[] = "0123456789abcdef";
    if (out == NULL || input == NULL || out_size < input_len * 2U + 1U) {
        return false;
    }
    for (size_t i = 0U; i < input_len; ++i) {
        out[i * 2U] = kHex[input[i] >> 4U];
        out[i * 2U + 1U] = kHex[input[i] & 0x0fU];
    }
    out[input_len * 2U] = '\0';
    return true;
}

static bool reset_l3_bls_state(void) {
    return cluster_bls_signer_init(&g_l3_bls_signer, kL3BlsTestIkm,
                                   sizeof(kL3BlsTestIkm)) &&
           cluster_bls_registration_from_signer(&g_l3_bls_signer,
                                                 &g_l3_bls_registration);
}

static int regenerate_fixed_mldsa_keypair(void) {
    return MLD_API_NAMESPACE(keypair_internal)(mldsa_pk, mldsa_sk,
                                               kMldsaTestSeed);
}

static bool init_and_publish_l3_bls_registration(void) {
    char public_key_hex[kOtBlsPublicKeyBytes * 2U + 1U] = {0};
    char pop_hex[kOtBlsSignatureBytes * 2U + 1U] = {0};

    LOG_INFO("WARNING: L3 BLS is using a fixed insecure test IKM");
    if (!reset_l3_bls_state() ||
        !bls_write_hex(public_key_hex, sizeof(public_key_hex),
                       g_l3_bls_registration.public_key,
                       sizeof(g_l3_bls_registration.public_key)) ||
        !bls_write_hex(pop_hex, sizeof(pop_hex),
                       g_l3_bls_registration.proof_of_possession,
                       sizeof(g_l3_bls_registration.proof_of_possession))) {
        LOG_ERROR("L3 BLS signer initialization failed");
        return false;
    }

    LOG_INFO("BLS_REGISTRATION:L3-001:%s:%s", public_key_hex, pop_hex);
    return true;
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
            uint8_t key_id[X509_CLUSTER_BLS_KEY_ID_BYTES];
            uint8_t public_key[kOtBlsPublicKeyBytes];
            uint8_t proof_of_possession[kOtBlsSignatureBytes];
            if (extract_cluster_bls_binding_from_cert(
                    g_ak_cert_plain, g_ak_cert_plain_len, key_id, public_key,
                    proof_of_possession) != 0 ||
                memcmp(key_id, g_l3_bls_registration.key_id,
                       sizeof(key_id)) != 0 ||
                memcmp(public_key, g_l3_bls_registration.public_key,
                       sizeof(public_key)) != 0 ||
                memcmp(proof_of_possession,
                       g_l3_bls_registration.proof_of_possession,
                       sizeof(proof_of_possession)) != 0) {
              LOG_ERROR("AK certificate has no valid matching L3 BLS binding");
              g_ak_cert_plain_len = 0U;
              return -1;
            }
            g_actual_cert_hex_len = g_ak_cert_plain_len * 2U;
            LOG_INFO("AK certificate L3 BLS binding verified");
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
        g_actual_data_byte_len = 0U;
        size_t expected_cbr1_len = 0U;
        uint32_t request_retry_elapsed_ms = 0U;

        CHECK_DIF_OK(dif_uart_bytes_send(&uart2, recv_csr_msg, sizeof(recv_csr_msg) - 1, &bytes_read));

        while (!g_data_received) {
            (void)receive_block_data(&uart2);
            sleep_ms(20);

            if (g_data_recv_idx == 0U) {
                request_retry_elapsed_ms += 20U;
                if (request_retry_elapsed_ms >=
                    CSR_REQUEST_RETRY_INTERVAL_MS) {
                    CHECK_DIF_OK(dif_uart_bytes_send(
                        &uart2, recv_csr_msg, sizeof(recv_csr_msg) - 1,
                        &bytes_read));
                    request_retry_elapsed_ms = 0U;
                }
            }

            if (expected_cbr1_len == 0U &&
                g_data_recv_idx >= kClusterBlsCertificateRequestHeaderBytes) {
                size_t tbs_len =
                    ((size_t)g_data_recv_buf[5] << 8) | g_data_recv_buf[6];
                expected_cbr1_len =
                    kClusterBlsCertificateRequestHeaderBytes +
                    kClusterBlsRegistrationWireBytes + tbs_len;
                if (memcmp(g_data_recv_buf, "CBR1", 4) != 0 ||
                    g_data_recv_buf[4] != kClusterBlsProtocolVersion ||
                    tbs_len == 0U || expected_cbr1_len > DATA_RECV_BUF_MAX) {
                    LOG_ERROR("Invalid L2 CBR1 header or length");
                    CHECK_DIF_OK(dif_uart_byte_send_polled(
                        &uart2, UART_FAILURE_BYTE));
                    return -1;
                }
            }

            if (expected_cbr1_len != 0U &&
                g_data_recv_idx >= expected_cbr1_len) {
                if (g_data_recv_idx != expected_cbr1_len) {
                    LOG_ERROR("L2 CBR1 length mismatch: got 0x%x, expected 0x%x",
                              (uint32_t)g_data_recv_idx,
                              (uint32_t)expected_cbr1_len);
                    CHECK_DIF_OK(dif_uart_byte_send_polled(
                        &uart2, UART_FAILURE_BYTE));
                    return -1;
                }
                g_data_received = true;
                g_actual_data_byte_len = expected_cbr1_len;
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
    const uint8_t *tbs_der = NULL;
    size_t tbs_len = 0U;
    size_t bound_tbs_len = sizeof(ctx_general_buf);
    cluster_bls_registration_t registration = {0};

    if (!cluster_bls_certificate_request_decode(
            g_data_recv_buf, g_actual_data_byte_len, &registration, &tbs_der,
            &tbs_len)) {
        LOG_ERROR("Rejected malformed L2 CBR1 request or invalid BLS PoP");
        CHECK_DIF_OK(dif_uart_byte_send_polled(&uart2, UART_FAILURE_BYTE));
        return -1;
    }
    memset(ctx_general_buf, 0, sizeof(ctx_general_buf));
    if (add_cluster_bls_binding_extension_to_tbs(
            tbs_der, tbs_len, registration.key_id, registration.public_key,
            registration.proof_of_possession, ctx_general_buf,
            &bound_tbs_len) != 0) {
        LOG_ERROR("Could not add the authenticated L2 BLS binding to its TBS");
        CHECK_DIF_OK(dif_uart_byte_send_polled(&uart2, UART_FAILURE_BYTE));
        return -1;
    }
    g_l2_bls_registration = registration;
    g_actual_data_byte_len = bound_tbs_len;
    LOG_INFO("Authenticated L2 CBR1 accepted; BLS-bound TBS length: 0x%x",
             (uint32_t)g_actual_data_byte_len);
    print_hex_buffer("2nd BLS-bound TBS DER", ctx_general_buf,
                     g_actual_data_byte_len);

    return 0;
}

int recv_measure_rom(dif_uart_t uart2) {
    LOG_INFO("Waiting for 2nd ROM from UART...");

    size_t bytes_written = 0U;
    uint32_t trigger_elapsed_ms = ROM_TRIGGER_RETRY_INTERVAL_MS;
    uint32_t trigger_count = 0U;
    bool rom_response_started = false;

    g_data_received = false;
    g_data_idle_ticks = 0U;
    g_data_recv_idx = 0U;
    g_actual_data_byte_len = 0U;

    while (!g_data_received) {
      if (!rom_response_started &&
          trigger_elapsed_ms >= ROM_TRIGGER_RETRY_INTERVAL_MS) {
        for (size_t i = 0; i < sizeof(trigger_msg) - 1U; ++i) {
          CHECK_DIF_OK(dif_uart_byte_send_polled(&uart2, trigger_msg[i]));
        }
        ++trigger_count;
        LOG_INFO("Sent ROM trigger 0x5a (attempt %u); retry in %u ms",
                 trigger_count, ROM_TRIGGER_RETRY_INTERVAL_MS);
        trigger_elapsed_ms = 0U;
      }

      (void)receive_block_data(&uart2);
      if (!rom_response_started && g_data_recv_idx != 0U) {
        rom_response_started = true;
        LOG_INFO("L2 ROM response detected; stop retrying 0x5a");
      }
      sleep_ms(ROM_RECEIVE_POLL_INTERVAL_MS);

      if (!rom_response_started) {
        trigger_elapsed_ms += ROM_RECEIVE_POLL_INTERVAL_MS;
        g_data_idle_ticks = 0U;
      }

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

    if (g_actual_data_byte_len != ROM_TOTAL_SIZE) {
        LOG_ERROR("Incomplete L2 ROM: got %u bytes, expected %u",
                  (uint32_t)g_actual_data_byte_len, (uint32_t)ROM_TOTAL_SIZE);
        CHECK_DIF_OK(dif_uart_byte_send_polled(&uart2, UART_FAILURE_BYTE));
        return -1;
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
        CHECK_DIF_OK(dif_uart_byte_send_polled(&uart2, UART_FAILURE_BYTE));
        return -1;
    }
    
    return 0;
}

static uint64_t cluster_bls_get_u64_be(const uint8_t in[8]) {
    uint64_t value = 0U;
    for (size_t i = 0U; i < 8U; ++i) {
        value = (value << 8U) | in[i];
    }
    return value;
}

static uint32_t cluster_bls_get_u32_be(const uint8_t in[4]) {
    return ((uint32_t)in[0] << 24U) | ((uint32_t)in[1] << 16U) |
           ((uint32_t)in[2] << 8U) | (uint32_t)in[3];
}

static void cluster_bls_put_u32_be(uint8_t out[4], uint32_t value) {
    out[0] = (uint8_t)(value >> 24U);
    out[1] = (uint8_t)(value >> 16U);
    out[2] = (uint8_t)(value >> 8U);
    out[3] = (uint8_t)value;
}

static void cluster_bls_put_u64_be(uint8_t out[8], uint64_t value) {
    for (size_t i = 0U; i < 8U; ++i) {
        out[7U - i] = (uint8_t)(value >> (i * 8U));
    }
}

static bool cluster_bls_uart_send_all(dif_uart_t *uart,
                                      const uint8_t *data, size_t length) {
    if (uart == NULL || data == NULL || length == 0U) {
        return false;
    }
    for (size_t i = 0U; i < length; ++i) {
        if (dif_uart_byte_send_polled(uart, data[i]) != kDifOk) {
            return false;
        }
    }
    return true;
}

static uint32_t g_cluster_bls_uart_idle_ms = 0U;

static bool cluster_bls_uart_receive_exact(dif_uart_t *uart, uint8_t *data,
                                           size_t length,
                                           uint32_t timeout_ms) {
    size_t received = 0U;
    uint32_t elapsed_ms = 0U;
    g_cluster_bls_uart_idle_ms = 0U;
    if (uart == NULL || data == NULL || length == 0U) {
        return false;
    }
    while (received < length &&
           (timeout_ms == 0U || elapsed_ms < timeout_ms)) {
        size_t available = 0U;
        if (dif_uart_rx_bytes_available(uart, &available) != kDifOk) {
            return false;
        }
        if (available != 0U) {
            size_t request = length - received;
            size_t actual = 0U;
            if (request > available) {
                request = available;
            }
            if (dif_uart_bytes_receive(uart, request, data + received,
                                       &actual) != kDifOk) {
                return false;
            }
            received += actual;
            continue;
        }
        sleep_ms(1U);
        ++g_cluster_bls_uart_idle_ms;
        if (timeout_ms != 0U) {
            ++elapsed_ms;
        }
    }
    return received == length;
}

/* The verifier asks L3 for the current public-key list.  L3 keeps its own
 * registration/certificate, and obtains the real L2/L1 registrations and
 * certificates from the already-running L2 PS bridge over UART2.  Existing
 * large quote/receive buffers are reused so ML-DSA key generation gets no new
 * permanent multi-kilobyte allocation. */
static bool cluster_bls_send_current_key_list(
    dif_uart_t *verifier_uart,
    const uint8_t request_nonce[kClusterBlsNonceBytes]) {
    enum {
        kL2KeyListFixedBytes = 8 + 1 + 2 * kClusterBlsRegistrationWireBytes +
                               4 + 4,
        kVerifierKeyListFixedBytes =
            8 + 1 + 1 + sizeof(kClusterBlsClusterId) + 8 +
            kClusterBlsNonceBytes + 3 * kClusterBlsRegistrationWireBytes +
            4 + 4 + 4 + kOtBlsSignatureBytes,
    };
    dif_uart_t uart2 = {0};
    uint8_t *l2_packet = g_data_recv_buf;
    uint8_t *work = quote_buf_mldsa;
    uint8_t digest[kClusterBlsDigestBytes];
    size_t l2_total;
    size_t l2_cert_len;
    size_t l1_cert_len;
    size_t l2_cert_offset = kL2KeyListFixedBytes;
    size_t response_len;
    size_t packet_start = sizeof(kClusterBlsKeyListDomain);
    size_t offset;

    if (verifier_uart == NULL || request_nonce == NULL ||
        g_ak_cert_plain_len == 0U) {
        return false;
    }

    attestation_uart_init(&uart2, 2U);
    if (dif_uart_fifo_reset(&uart2, kDifUartDatapathRx) != kDifOk ||
        !cluster_bls_uart_send_all(&uart2, kClusterBlsKeyListRequestMagic,
                                   sizeof(kClusterBlsKeyListRequestMagic)) ||
        !cluster_bls_uart_receive_exact(&uart2, l2_packet, 8U,
                                        CLUSTER_BLS_UART_TIMEOUT_MS) ||
        memcmp(l2_packet, kClusterBlsL2KeyListResponseMagic,
               sizeof(kClusterBlsL2KeyListResponseMagic)) != 0) {
        LOG_ERROR("Could not request the current L2/L1 BLS key list");
        return false;
    }
    l2_total = cluster_bls_get_u32_be(l2_packet + 4U);
    if (l2_total < kL2KeyListFixedBytes ||
        l2_total > sizeof(g_data_recv_buf) ||
        !cluster_bls_uart_receive_exact(&uart2, l2_packet + 8U,
                                        l2_total - 8U,
                                        CLUSTER_BLS_UART_TIMEOUT_MS) ||
        l2_packet[8] != kClusterBlsProtocolVersion) {
        LOG_ERROR("Invalid L2/L1 BLS key-list response");
        return false;
    }
    l2_cert_len = cluster_bls_get_u32_be(
        l2_packet + 8U + 1U + 2U * kClusterBlsRegistrationWireBytes);
    l1_cert_len = cluster_bls_get_u32_be(
        l2_packet + 8U + 1U + 2U * kClusterBlsRegistrationWireBytes + 4U);
    if (l2_cert_len == 0U || l1_cert_len == 0U ||
        l2_cert_offset + l2_cert_len + l1_cert_len != l2_total) {
        LOG_ERROR("Invalid L2/L1 certificate lengths in the BLS key list");
        return false;
    }

    response_len = kVerifierKeyListFixedBytes + g_ak_cert_plain_len +
                   l2_cert_len + l1_cert_len;
    if (packet_start + response_len > sizeof(quote_buf_mldsa)) {
        LOG_ERROR("Current Cluster-BLS key list exceeds the bounded buffer");
        return false;
    }

    memcpy(work, kClusterBlsKeyListDomain, sizeof(kClusterBlsKeyListDomain));
    offset = packet_start;
    memcpy(work + offset, kClusterBlsVerifierKeyListResponseMagic, 4U);
    offset += 4U;
    cluster_bls_put_u32_be(work + offset, (uint32_t)response_len);
    offset += 4U;
    work[offset++] = kClusterBlsProtocolVersion;
    work[offset++] = (uint8_t)sizeof(kClusterBlsClusterId);
    memcpy(work + offset, kClusterBlsClusterId,
           sizeof(kClusterBlsClusterId));
    offset += sizeof(kClusterBlsClusterId);
    cluster_bls_put_u64_be(work + offset, 1U);
    offset += 8U;
    memcpy(work + offset, request_nonce, kClusterBlsNonceBytes);
    offset += kClusterBlsNonceBytes;
    if (!cluster_bls_registration_encode(&g_l3_bls_registration,
                                          work + offset)) {
        return false;
    }
    offset += kClusterBlsRegistrationWireBytes;
    memcpy(work + offset, l2_packet + 9U,
           2U * kClusterBlsRegistrationWireBytes);
    offset += 2U * kClusterBlsRegistrationWireBytes;
    cluster_bls_put_u32_be(work + offset, (uint32_t)g_ak_cert_plain_len);
    offset += 4U;
    cluster_bls_put_u32_be(work + offset, (uint32_t)l2_cert_len);
    offset += 4U;
    cluster_bls_put_u32_be(work + offset, (uint32_t)l1_cert_len);
    offset += 4U;
    memcpy(work + offset, g_ak_cert_plain, g_ak_cert_plain_len);
    offset += g_ak_cert_plain_len;
    memcpy(work + offset, l2_packet + l2_cert_offset, l2_cert_len + l1_cert_len);
    offset += l2_cert_len + l1_cert_len;

    SHA256_hash(work, offset, digest);
    if (!cluster_bls_sign_challenge(&g_l3_bls_signer, digest,
                                    work + offset)) {
        LOG_ERROR("Could not sign the current Cluster-BLS key list");
        return false;
    }
    offset += kOtBlsSignatureBytes;
    if (offset != packet_start + response_len) {
        return false;
    }
    /* `work[0..packet_start)` is the domain separator used only when hashing
     * and signing the response.  The wire packet already starts at
     * `packet_start`, so send it directly instead of relying on memmove(),
     * which is not provided by the OpenTitan bare-metal runtime. */
    if (!cluster_bls_uart_send_all(verifier_uart, work + packet_start,
                                   response_len)) {
        LOG_ERROR("Could not return the current Cluster-BLS key list");
        return false;
    }
    LOG_INFO("Returned current signed L3/L2/L1 BLS key list");
    return true;
}

static bool cluster_bls_receive_quote_request(
    dif_uart_t *uart, cluster_bls_challenge_t *challenge,
    uint16_t *participant_count) {
    uint8_t request[kClusterBlsQuoteRequestMaxBytes] = {0};
    uint8_t request_nonce[kClusterBlsNonceBytes];
    uint8_t magic[sizeof(kClusterBlsQuoteRequestMagic)] = {0};
    size_t magic_len = 0U;
    size_t offset;
    size_t expected;

    if (uart == NULL || challenge == NULL || participant_count == NULL) {
        return false;
    }
    g_cluster_bls_scale_profile = 0U;
    if (CLUSTER_BLS_SCALE_TEST_ENABLE &&
        memcmp(nonce_bin, "HWB2", 4U) == 0) {
        uint32_t chains = ((uint32_t)nonce_bin[4] << 24) |
                          ((uint32_t)nonce_bin[5] << 16) |
                          ((uint32_t)nonce_bin[6] << 8) | nonce_bin[7];
        if (chains == 0U) {
            chains = CLUSTER_BLS_SCALE_CHAIN_COUNT;
        }
        if (chains != 10U && chains != 100U &&
            chains != 1000U && chains != 10000U) {
            return false;
        }
        g_cluster_bls_scale_profile = chains;
        memset(challenge, 0, sizeof(*challenge));
        *participant_count = (uint16_t)(chains + chains / 10U + 1U);
        return true;
    }
    if (!g_cluster_bls_dynamic_requests) {
        memset(challenge, 0, sizeof(*challenge));
        challenge->protocol_version = kClusterBlsProtocolVersion;
        challenge->ciphersuite = kClusterBlsCiphersuitePop;
        challenge->cluster_id_len = sizeof(kClusterBlsClusterId);
        memcpy(challenge->cluster_id, kClusterBlsClusterId,
               sizeof(kClusterBlsClusterId));
        challenge->epoch = 1U;
        memcpy(challenge->nonce, nonce_bin, NONCE_LENGTH);
        memcpy(challenge->member_list_digest,
               kClusterBlsPreprovisionedListDigest,
               sizeof(kClusterBlsPreprovisionedListDigest));
        *participant_count = 3U;
        return true;
    }
    for (;;) {
        uint8_t byte = 0U;
        if (!cluster_bls_uart_receive_exact(uart, &byte, 1U, 0U)) {
            LOG_ERROR("Could not receive verifier request magic");
            return false;
        }
        if (magic_len < sizeof(magic)) {
            magic[magic_len++] = byte;
        } else {
            magic[0] = magic[1];
            magic[1] = magic[2];
            magic[2] = magic[3];
            magic[3] = byte;
        }
        if (magic_len != sizeof(magic)) {
            continue;
        }
        if (memcmp(magic, kClusterBlsKeyListRequestMagic,
                   sizeof(kClusterBlsKeyListRequestMagic)) == 0) {
            if (!cluster_bls_uart_receive_exact(uart, request_nonce,
                                                sizeof(request_nonce), 0U)) {
                LOG_ERROR("Could not receive the KLR1 nonce");
                return false;
            }
            if (memcmp(request_nonce, nonce_bin, sizeof(request_nonce)) != 0) {
                LOG_ERROR("KLR1 nonce does not match the received nonce");
                return false;
            }
            LOG_INFO("Received KLR1 and 32-byte nonce from verifier");
            if (!cluster_bls_send_current_key_list(uart, request_nonce)) {
                LOG_ERROR("Could not return the current Cluster-BLS key list");
                return false;
            }
            magic_len = 0U;
            continue;
        }
        if (memcmp(magic, kClusterBlsQuoteRequestMagic,
                   sizeof(kClusterBlsQuoteRequestMagic)) != 0) {
            continue;
        }
        memcpy(request, magic, sizeof(magic));
        if (!cluster_bls_uart_receive_exact(uart, request + 4U, 1U, 0U) ||
            request[4] == 0U || request[4] > kClusterBlsMaxClusterIdBytes) {
            LOG_ERROR("Could not receive valid BLQ1 header");
            return false;
        }
        break;
    }
    expected = 5U + request[4] + 8U + kClusterBlsDigestBytes + 1U +
               kClusterBlsNonceBytes;
    if (expected > sizeof(request) ||
        !cluster_bls_uart_receive_exact(uart, request + 5U, expected - 5U,
                                        0U)) {
        LOG_ERROR("Could not receive the complete BLQ1 request");
        return false;
    }

    memset(challenge, 0, sizeof(*challenge));
    challenge->protocol_version = kClusterBlsProtocolVersion;
    challenge->ciphersuite = kClusterBlsCiphersuitePop;
    challenge->cluster_id_len = request[4];
    offset = 5U;
    memcpy(challenge->cluster_id, request + offset,
           challenge->cluster_id_len);
    offset += challenge->cluster_id_len;
    challenge->epoch = cluster_bls_get_u64_be(request + offset);
    offset += 8U;
    memcpy(challenge->member_list_digest, request + offset,
           kClusterBlsDigestBytes);
    offset += kClusterBlsDigestBytes;
    *participant_count = request[offset++];
    memcpy(challenge->nonce, request + offset, kClusterBlsNonceBytes);
    if (memcmp(challenge->nonce, nonce_bin, NONCE_LENGTH) != 0) {
        LOG_ERROR("BLQ1 nonce does not match the received nonce");
        return false;
    }
    if (*participant_count != 3U) {
        LOG_ERROR("BLQ1 must select exactly L3/L2/L1 (got %u)",
                  (uint32_t)*participant_count);
        return false;
    }
    memcpy(nonce_bin, challenge->nonce, NONCE_LENGTH);
    LOG_INFO("Received current-epoch BLQ1 request for 3 participants");
    return true;
}

static bool cluster_bls_collect_quote_proof(
    const cluster_bls_challenge_t *request, uint8_t participant_count) {
    cluster_bls_challenge_t challenge;
    uint8_t preimage[kClusterBlsChallengePreimageMax] = {0};
    size_t preimage_len = sizeof(preimage);
    uint8_t challenge_digest[kClusterBlsDigestBytes] = {0};
    uint8_t l2_request[kClusterBlsL2ChallengeRequestBytes] = {0};
    uint8_t l2_response[kClusterBlsL2AggregateResponseBytes] = {0};
    uint8_t signatures[2U * kOtBlsSignatureBytes] = {0};
    dif_uart_t uart2 = {0};

    if (request == NULL || participant_count != 3U) {
        return false;
    }
    challenge = *request;
    memcpy(challenge.measurement_digest, firmware_hash,
           kClusterBlsDigestBytes);

    memset(g_cluster_bls_quote_block, 0,
           sizeof(g_cluster_bls_quote_block));
    g_cluster_bls_quote_block[0] = CLUSTER_BLS_PROOF_FAILURE;
    cluster_bls_put_u64_be(g_cluster_bls_quote_block + 1U,
                           challenge.epoch);
    memcpy(g_cluster_bls_quote_block + 9U,
           challenge.member_list_digest, kClusterBlsDigestBytes);
    g_cluster_bls_quote_block[9U + kClusterBlsDigestBytes] =
        participant_count;

    if (!cluster_bls_encode_challenge(&challenge, preimage, &preimage_len)) {
        LOG_ERROR("Could not encode Cluster-BLS challenge");
        return false;
    }
    SHA256_hash(preimage, preimage_len, challenge_digest);

    memcpy(l2_request, kClusterBlsL2ChallengeRequestMagic,
           sizeof(kClusterBlsL2ChallengeRequestMagic));
    memcpy(l2_request + sizeof(kClusterBlsL2ChallengeRequestMagic),
           challenge_digest, sizeof(challenge_digest));
    attestation_uart_init(&uart2, 2U);
    if (dif_uart_fifo_reset(&uart2, kDifUartDatapathRx) != kDifOk ||
        !cluster_bls_uart_send_all(&uart2, l2_request,
                                   sizeof(l2_request)) ||
        !cluster_bls_uart_receive_exact(&uart2, l2_response,
                                        sizeof(l2_response),
                                        CLUSTER_BLS_UART_TIMEOUT_MS) ||
        memcmp(l2_response, kClusterBlsL2AggregateResponseMagic,
               sizeof(kClusterBlsL2AggregateResponseMagic)) != 0) {
        LOG_ERROR("Could not collect the real L1/L2 BLS aggregate on UART2");
        return false;
    }

    memcpy(signatures,
           l2_response + sizeof(kClusterBlsL2AggregateResponseMagic),
           kOtBlsSignatureBytes);
    if (!reset_l3_bls_state()) {
        LOG_ERROR("Could not restore the L3 BLS signer state");
        return false;
    }
    if (!cluster_bls_sign_challenge(
            &g_l3_bls_signer, challenge_digest,
            signatures + kOtBlsSignatureBytes) ||
        !cluster_bls_aggregate(
            signatures, 2U,
            g_cluster_bls_quote_block + 1U + 8U +
                kClusterBlsDigestBytes + 1U)) {
        LOG_ERROR("Could not add L3 to the L1/L2 BLS aggregate");
        return false;
    }
    g_cluster_bls_quote_block[0] = CLUSTER_BLS_PROOF_SUCCESS;
    LOG_INFO("Collected and aggregated real L3/L2/L1 BLS proof");
    return true;
}

static void prepare_scale_quote_block(const uint8_t mode[4],
                                      uint32_t chains,
                                      uint32_t members,
                                      const uint8_t digest[32],
                                      const uint8_t *signature,
                                      bool success) {
    memset(g_cluster_bls_quote_block, 0,
           sizeof(g_cluster_bls_quote_block));
    g_cluster_bls_quote_block[0] =
        success ? CLUSTER_BLS_PROOF_SUCCESS : CLUSTER_BLS_PROOF_FAILURE;
    memcpy(g_cluster_bls_quote_block + 1U, mode, 4U);
    scale_put_u32(g_cluster_bls_quote_block + 5U, chains);
    scale_put_u32(g_cluster_bls_quote_block + 9U, members);
    memcpy(g_cluster_bls_quote_block + 13U, digest, 28U);
    if (signature != NULL) {
        memcpy(g_cluster_bls_quote_block + 42U, signature,
               kOtBlsSignatureBytes);
    }
}

static bool cluster_bls_run_scale_profile(
    dif_uart_t *verifier_uart, const cluster_bls_challenge_t *request,
    uint32_t chains) {
    uint8_t preimage[76];
    uint8_t digest[32];
    uint8_t l2_request[40];
    uint8_t group_packet[304];
    uint8_t signatures[192];
    uint8_t result[176] = {0};
    dif_uart_t uart2 = {0};
    uint64_t start;
    uint64_t aggregate_cycles = 0U;
    uint32_t status = 1U;
    uint32_t link_recovery_ms = 0U;
    uint32_t link_retry_count = 0U;
    (void)request;

    memcpy(result, "BHR2", 4U);
    scale_put_u32(result + 8U, chains);
    scale_put_u32(result + 12U, chains / 10U);
    scale_put_u32(result + 16U, chains + chains / 10U + 1U);
    memcpy(result + 20U, firmware_hash, 32U);
    memcpy(preimage, "CBSTEST2", 8U);
    scale_put_u32(preimage + 8U, chains);
    memcpy(preimage + 12U, nonce_bin, 32U);
    memcpy(preimage + 44U, firmware_hash, 32U);
    SHA256_hash(preimage, sizeof(preimage), digest);
    if (!reset_l3_bls_state()) {
        goto finish;
    }
    start = scale_cycles();
    if (!cluster_bls_sign_challenge(&g_l3_bls_signer, digest, signatures)) {
        goto finish;
    }
    scale_put_u64(result + 148U, scale_cycles() - start);
    memcpy(l2_request, "BLS2", 4U);
    memcpy(l2_request + 8U, digest, 32U);
    attestation_uart_init(&uart2, 2U);
    if (dif_uart_fifo_reset(&uart2, kDifUartDatapathRx) != kDifOk) {
        goto finish;
    }
    for (uint32_t group = 1U; group <= chains / 10U; ++group) {
        uint64_t elapsed;
        scale_put_u32(l2_request + 4U, group);
        for (;;) {
            bool response_ok = false;
            g_cluster_bls_uart_idle_ms = 0U;
            if (dif_uart_fifo_reset(&uart2, kDifUartDatapathRx) == kDifOk &&
                cluster_bls_uart_send_all(&uart2, l2_request,
                                          sizeof(l2_request)) &&
                cluster_bls_uart_receive_exact(&uart2, group_packet, 296U,
                                               30000U)) {
                response_ok =
                    memcmp(group_packet, "BLR2", 4U) == 0 &&
                    scale_get_u32(group_packet + 8U) == group &&
                    scale_crc32(group_packet, 292U) ==
                        scale_get_u32(group_packet + 292U);
            }
            if (response_ok) {
                break;
            }
            link_recovery_ms += g_cluster_bls_uart_idle_ms;
            ++link_retry_count;
            LOG_INFO("L2 link interrupted; retrying BLS group %u", group);
            sleep_ms(1000U);
            link_recovery_ms += 1000U;
        }
        status = scale_get_u32(group_packet + 4U);
        if (status != 0U) {
            goto finish;
        }
        memcpy(signatures + 96U, group_packet + 12U, 96U);
        start = scale_cycles();
        if (!cluster_bls_aggregate(signatures, 2U, result + 52U)) {
            status = 4U;
            goto finish;
        }
        elapsed = scale_cycles() - start;
        aggregate_cycles += elapsed;
        memcpy(signatures, result + 52U, 96U);
        memcpy(group_packet, "BHG2", 4U);
        scale_put_u64(group_packet + 292U, elapsed);
        scale_put_u32(group_packet + 300U, scale_crc32(group_packet, 300U));
        if (!cluster_bls_uart_send_all(verifier_uart, group_packet,
                                       sizeof(group_packet))) {
            return false;
        }
    }
    status = 0U;
finish:
    prepare_scale_quote_block((const uint8_t *)"BLS1", chains,
                              chains + chains / 10U + 1U, digest,
                              status == 0U ? result + 52U : NULL,
                              status == 0U);
    scale_put_u32(result + 4U, status);
    scale_put_u64(result + 156U, aggregate_cycles);
    scale_put_u32(result + 164U, link_recovery_ms);
    scale_put_u32(result + 168U, link_retry_count);
    scale_put_u32(result + 172U, scale_crc32(result, 172U));
    if (!cluster_bls_uart_send_all(verifier_uart, result, sizeof(result))) {
        return false;
    }
    return status == 0U;
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
    uint8_t data_to_sign[64U + kClusterBlsQuoteBlockBytes];
    uint8_t msg[32];
    memcpy(data_to_sign, firmware_hash, 32);
    memcpy(data_to_sign + 32, nonce_bin, 32);
    memcpy(data_to_sign + 64, g_cluster_bls_quote_block,
           kClusterBlsQuoteBlockBytes);
    
    SHA256_hash(data_to_sign, sizeof(data_to_sign), msg);

    print_hex_buffer("pcr", firmware_hash, 32);

    print_hex_buffer("nonce", nonce_bin, 32);

    print_hex_buffer("cluster bls proof", g_cluster_bls_quote_block,
                     kClusterBlsQuoteBlockBytes);

    print_hex_buffer("msg", msg, 32);

    for (uint32_t attempt = 1U; attempt <= 3U; ++attempt) {
        memset(mldsa_sig, 0, sizeof(mldsa_sig));
        LOG_INFO("Signing... attempt %u", attempt);
        int sign_ret = PQCP_MLDSA_NATIVE_MLDSA87_sign(
            mldsa_sig, msg, 32, mldsa_sk);
        if (sign_ret != 0) {
            LOG_ERROR("MLDSA87 sign FAILED! ret code: %d", sign_ret);
            continue;
        }
        LOG_INFO("MLDSA87 sign SUCCESS! ret code: %d", sign_ret);
        LOG_INFO("Verifying...");
        int verify_ret = PQCP_MLDSA_NATIVE_MLDSA87_verify(
            mldsa_sig, msg, 32, mldsa_pk);
        if (verify_ret == 0) {
            LOG_INFO("MLDSA87 verify SUCCESS! ret code: %d", verify_ret);
            return 0;
        }
        LOG_ERROR("MLDSA87 verify FAILED! ret code: %d", verify_ret);
    }
    return -1;
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
    char *p = (char *)quote_buf_mldsa;
    const size_t required = strlen("#QUOTE#") + 4U + g_actual_cert_hex_len +
                            NONCE_LENGTH * 4U +
                            kClusterBlsQuoteBlockBytes * 2U +
                            MLDSA87_SIG_SIZE * 2U + strlen("#END#") + 1U;

    g_quote_hex_total_len = 0U;
    if (g_ak_cert_plain_len == 0U ||
        g_actual_cert_hex_len != g_ak_cert_plain_len * 2U ||
        required > sizeof(quote_buf_mldsa)) {
        LOG_ERROR("MLDSA quote does not fit: need %u bytes, capacity %u",
                  (uint32_t)required,
                  (uint32_t)sizeof(quote_buf_mldsa));
        return;
    }
    memset(quote_buf_mldsa, 0, sizeof(quote_buf_mldsa));

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
        size_t cert_hex_len = bin_to_hex(g_ak_cert_plain,
                                         g_ak_cert_plain_len, p);
        if (cert_hex_len != g_actual_cert_hex_len) {
            LOG_ERROR("AK certificate HEX conversion length mismatch");
            return;
        }
        p += cert_hex_len;
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

    // 6. Cluster-BLS 聚合证明
    size_t bls_hex_len = bin_to_hex(g_cluster_bls_quote_block,
                                    kClusterBlsQuoteBlockBytes, p);
    p += bls_hex_len;
    LOG_INFO("Packed Cluster-BLS proof HEX: %d bytes", bls_hex_len);

    // 7. MLDSA签名转HEX字符串
    size_t sign_hex_len = bin_to_hex(mldsa_sig, MLDSA87_SIG_SIZE, p);
    p += sign_hex_len;
    LOG_INFO("Packed Signature HEX: %d bytes", sign_hex_len);

    // 8. 结束分隔符
    strcpy(p, "#END#");
    p += strlen("#END#");

    size_t quote_hex_total_len = (size_t)(p - (char *)quote_buf_mldsa);
    g_quote_hex_total_len = quote_hex_total_len;

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

static int send_prepared_attestation_quote(dif_uart_t uart1) {
    int keypair_ret = regenerate_fixed_mldsa_keypair();
    if (keypair_ret != 0) {
        LOG_ERROR("Could not restore the MLDSA87 keypair: %d", keypair_ret);
        return -1;
    }

    if (mldsa_sign_hash_nonce() != 0) {
        LOG_ERROR("mldsa_sign_hash_nonce failed.");
        return -1;
    }

    pack_quote_mldsa();

    size_t quote_total_len = g_quote_hex_total_len;
    if (quote_total_len == 0U) {
        return -1;
    }
    LOG_INFO("Sending quote HEX package, total length: 0x%x bytes", quote_total_len);

    attestation_uart_init(&uart1, 1);
    uart_send_hex_chunked(&uart1, quote_buf_mldsa, quote_total_len, 32, 10);

    LOG_INFO("Quote package sent completely");
    return 0;
}

int remote_attestation_mldsa(dif_uart_t uart1) {

    memcpy(firmware_hash, rom_sha256_digest, 32);

    memset(g_cluster_bls_quote_block, 0,
           sizeof(g_cluster_bls_quote_block));
    g_cluster_bls_quote_block[0] = CLUSTER_BLS_PROOF_FAILURE;
    cluster_bls_put_u64_be(g_cluster_bls_quote_block + 1U,
                           g_cluster_bls_request.epoch);
    memcpy(g_cluster_bls_quote_block + 9U,
           g_cluster_bls_request.member_list_digest,
           kClusterBlsDigestBytes);
    g_cluster_bls_quote_block[9U + kClusterBlsDigestBytes] = 3U;
    if (verify_status != 0xaaU ||
        !cluster_bls_collect_quote_proof(&g_cluster_bls_request, 3U)) {
        LOG_ERROR("Cluster-BLS proof collection failed");
        return -1;
    }
    return send_prepared_attestation_quote(uart1);
}

int X509_sign_ctx(dif_uart_t uart2, uint8_t *private_key_bytes, uint8_t *public_key_bytes) {
    uint8_t signature[ECC_BYTES * 2] = {0};
    LOG_INFO("start sign 2nd certificates");
    memset(ctx_general_buf, 0, sizeof(ctx_general_buf));

    if (recv_csr() != 0) {
        return -1;
    }

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

    uint8_t cert_key_id[X509_CLUSTER_BLS_KEY_ID_BYTES];
    uint8_t cert_public_key[kOtBlsPublicKeyBytes];
    uint8_t cert_pop[kOtBlsSignatureBytes];
    if (extract_cluster_bls_binding_from_cert(
            cert_der, cert_len, cert_key_id, cert_public_key, cert_pop) != 0 ||
        memcmp(cert_key_id, g_l2_bls_registration.key_id,
               sizeof(cert_key_id)) != 0 ||
        memcmp(cert_public_key, g_l2_bls_registration.public_key,
               sizeof(cert_public_key)) != 0 ||
        memcmp(cert_pop, g_l2_bls_registration.proof_of_possession,
               sizeof(cert_pop)) != 0) {
        LOG_ERROR("Generated L2 certificate lost or changed its BLS binding");
        CHECK_DIF_OK(dif_uart_byte_send_polled(&uart2, UART_FAILURE_BYTE));
        return -1;
    }
    LOG_INFO("Generated L2 certificate contains the authenticated BLS binding");

    for (size_t i = 0; i < sizeof(send_cxt_msg) - 1U; ++i) {
        CHECK_DIF_OK(dif_uart_byte_send_polled(&uart2, send_cxt_msg[i]));
    }
    LOG_INFO("Sent L2 certificate-ready marker: 0x8a");

    print_hex_buffer("2nd Certificate DER", cert_der, cert_len);

    if (sizeof(kL2CertificateInstallMagic) + ECC_BYTES + 1U + cert_len >
        sizeof(g_data_recv_buf)) {
        LOG_ERROR("L2 certificate installation package is too large");
        CHECK_DIF_OK(dif_uart_byte_send_polled(&uart2, UART_FAILURE_BYTE));
        return -1;
    }
    memcpy(g_data_recv_buf, kL2CertificateInstallMagic,
           sizeof(kL2CertificateInstallMagic));
    memcpy(g_data_recv_buf + sizeof(kL2CertificateInstallMagic),
           public_key_bytes, ECC_BYTES + 1U);
    memcpy(g_data_recv_buf + sizeof(kL2CertificateInstallMagic) +
               ECC_BYTES + 1U,
           cert_der, cert_len);
    uart_send_hex_chunked(&uart2, g_data_recv_buf,
                          sizeof(kL2CertificateInstallMagic) +
                              ECC_BYTES + 1U + cert_len,
                          32, 10);
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

    LOG_INFO("Actual 2nd cert DER length: 0x%x bytes", g_actual_data_byte_len);
    print_hex_buffer("2nd cert DER", g_data_recv_buf, g_actual_data_byte_len);

    int ret = verify_cert(g_data_recv_buf, g_actual_data_byte_len,
                          public_key_bytes);
    uint8_t cert_key_id[X509_CLUSTER_BLS_KEY_ID_BYTES];
    uint8_t cert_public_key[kOtBlsPublicKeyBytes];
    uint8_t cert_pop[kOtBlsSignatureBytes];
    if (ret == 1) {
        if (extract_cluster_bls_binding_from_cert(
                g_data_recv_buf, g_actual_data_byte_len, cert_key_id,
                cert_public_key, cert_pop) != 0 ||
            memcmp(cert_key_id, g_l2_bls_registration.key_id,
                   sizeof(cert_key_id)) != 0 ||
            memcmp(cert_public_key, g_l2_bls_registration.public_key,
                   sizeof(cert_public_key)) != 0 ||
            memcmp(cert_pop, g_l2_bls_registration.proof_of_possession,
                   sizeof(cert_pop)) != 0) {
            LOG_ERROR("2nd cert BLS binding verify failed");
            CHECK_DIF_OK(dif_uart_byte_send_polled(&uart2,
                                                   UART_FAILURE_BYTE));
            return -1;
        }
        LOG_INFO("2nd cert signature and BLS binding verify success");
        CHECK_DIF_OK(dif_uart_bytes_send(&uart2, send_verify_msg, sizeof(send_verify_msg)-1, &bytes_read));
    } else {
        LOG_INFO("2nd cert verify failed, ret = %d", ret);
        CHECK_DIF_OK(dif_uart_byte_send_polled(&uart2, UART_FAILURE_BYTE));
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

#include "sw/device/my_tests/attestation/ecdsa_scale_opentitan.h"

static bool ecdsa_verify_l2_certificates(
    const uint8_t issuer_public_key[ECC_BYTES + 1U], uint32_t requested,
    uint32_t *completed, uint64_t *cycles) {
    enum {
        kL2KeyListFixedBytes = 8 + 1 + 2 * kClusterBlsRegistrationWireBytes +
                               4 + 4,
    };
    const uint8_t *certificate;
    size_t certificate_len;
    size_t total_len;
    uint64_t start;

    if (issuer_public_key == NULL || completed == NULL || cycles == NULL ||
        memcmp(g_data_recv_buf, kClusterBlsL2KeyListResponseMagic, 4U) != 0) {
        return false;
    }
    total_len = cluster_bls_get_u32_be(g_data_recv_buf + 4U);
    certificate_len = cluster_bls_get_u32_be(
        g_data_recv_buf + 8U + 1U +
        2U * kClusterBlsRegistrationWireBytes);
    if (total_len < kL2KeyListFixedBytes ||
        total_len > sizeof(g_data_recv_buf) || certificate_len == 0U ||
        kL2KeyListFixedBytes + certificate_len > total_len) {
        return false;
    }
    certificate = g_data_recv_buf + kL2KeyListFixedBytes;
    *completed = 0U;
    start = ecdsa_scale_ot_cycles();
    while (*completed < requested) {
        if (verify_cert(certificate, certificate_len,
                        issuer_public_key) != 1) {
            break;
        }
        ++*completed;
    }
    *cycles = ecdsa_scale_ot_cycles() - start;
    return *completed == requested;
}

static bool ecdsa_request_l2_certificate_verification(
    uint32_t chains, uint32_t *completed, uint64_t *cycles) {
    uint8_t request[12] = {0};
    uint8_t response[28] = {0};
    uint8_t ack[12] = {0};
    dif_uart_t uart2 = {0};
    uint32_t status;
    uint32_t requested;
    uint32_t received_crc;
    uint32_t calculated_crc;

    if (completed == NULL || cycles == NULL) {
        return false;
    }
    memcpy(request, "ECV2", 4U);
    scale_put_u32(request + 4U, chains);
    scale_put_u32(request + 8U, scale_crc32(request, 8U));
    attestation_uart_init(&uart2, 2U);
    if (!cluster_bls_uart_send_all(&uart2, request, sizeof(request)) ||
        !cluster_bls_uart_receive_exact(&uart2, response, sizeof(response),
                                        0U)) {
        return false;
    }
    received_crc = cluster_bls_get_u32_be(response + 24U);
    calculated_crc = scale_crc32(response, 24U);
    status = cluster_bls_get_u32_be(response + 4U);
    requested = cluster_bls_get_u32_be(response + 8U);
    *completed = cluster_bls_get_u32_be(response + 12U);
    *cycles = cluster_bls_get_u64_be(response + 16U);
    if (memcmp(response, "EVR2", 4U) != 0 ||
        received_crc != calculated_crc || requested != chains) {
        return false;
    }
    memcpy(ack, "ECA2", 4U);
    scale_put_u32(ack + 4U, chains);
    scale_put_u32(ack + 8U, scale_crc32(ack, 8U));
    (void)cluster_bls_uart_send_all(&uart2, ack, sizeof(ack));
    return status == 0U && *completed == chains;
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
 
    uint8_t *tbs_der = ctx_general_buf;
    size_t tbs_len = sizeof(ctx_general_buf);

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

    uint8_t *cert_der = quote_buf_mldsa;
    size_t cert_len = SEND_MAX_CERT_SIZE;

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
        return false;
    }
    LOG_INFO("Key Generate Success!\n");
    print_hex_buffer("ecdsa-p384 test public_key", public_key, sizeof(public_key));
    print_hex_buffer("ecdsa-p384 test private_key", private_key, sizeof(private_key));
    
    LOG_INFO("Generating MLDSA87 key pair...");
    int keypair_ret = regenerate_fixed_mldsa_keypair();
    if (keypair_ret != 0) {
        LOG_ERROR("MLDSA87 keypair FAILED! ret code: %d", keypair_ret);
        return false;
    }
    uint8_t mldsa_pk_or = 0U;
    for (size_t i = 0U; i < MLDSA87_PK_SIZE; ++i) {
        mldsa_pk_or |= mldsa_pk[i];
    }
    if (mldsa_pk_or == 0U) {
        LOG_ERROR("MLDSA87 keypair returned success but public key is all zero");
        return false;
    }
    LOG_INFO("MLDSA87 keypair SUCCESS! ret code: %d", keypair_ret);

    print_hex_buffer("MLDSA Public Key", mldsa_pk, MLDSA87_PK_SIZE);

    if (!init_and_publish_l3_bls_registration()) {
        return false;
    }

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

    LOG_INFO("Verifier UART1 ready handshake: 0xa5");
    size_t bytes_read = 0;
    while(1) {
        attestation_uart_init(&uart, 1);
        CHECK_DIF_OK(dif_uart_fifo_reset(&uart, kDifUartDatapathRx));
        memset(nonce_bin, 0, sizeof(nonce_bin));
        memset(uart_rx_buf, 0, sizeof(uart_rx_buf));
        uint16_t participant_count = 0U;
        uint32_t ready_polls = VERIFIER_READY_INTERVAL_POLLS;
        size_t nonce_received = 0U;
        LOG_INFO("Waiting to receive [nonce].");
        while (nonce_received < NONCE_LENGTH) {
            if (ready_polls >= VERIFIER_READY_INTERVAL_POLLS) {
                CHECK_DIF_OK(dif_uart_byte_send_polled(
                    &uart, VERIFIER_READY_BYTE));
                ready_polls = 0U;
            }
            size_t available = 0U;
            CHECK_DIF_OK(dif_uart_rx_bytes_available(&uart, &available));
            if (available > 0U) {
                size_t remaining = NONCE_LENGTH - nonce_received;
                size_t request = available < remaining ? available : remaining;
                bytes_read = 0U;
                CHECK_DIF_OK(dif_uart_bytes_receive(
                    &uart, request, uart_rx_buf + nonce_received,
                    &bytes_read));
                nonce_received += bytes_read;
                if (bytes_read > 0U) {
                    LOG_INFO("Received %u bytes, total %u/32",
                             (uint32_t)bytes_read,
                             (uint32_t)nonce_received);
                }
            }
            sleep_ms(100);
            ++ready_polls;
        }
        memcpy(nonce_bin, uart_rx_buf, NONCE_LENGTH);
        LOG_INFO("Received nonce:");
        for (int i = 0; i < NONCE_LENGTH; i++) {
            LOG_INFO("%02x", nonce_bin[i]);
        }
        memcpy(firmware_hash, rom_sha256_digest, sizeof(firmware_hash));
        if (memcmp(nonce_bin, "ECQ1", 4U) == 0) {
            uint32_t chains = ((uint32_t)nonce_bin[4] << 24) |
                              ((uint32_t)nonce_bin[5] << 16) |
                              ((uint32_t)nonce_bin[6] << 8) | nonce_bin[7];
            uint8_t quote_preimage[72];
            uint8_t quote_digest[32];
            uint32_t l2_completed = 0U;
            uint32_t l3_completed = 0U;
            uint64_t l2_cycles = 0U;
            uint64_t l3_cycles = 0U;
            uint32_t ecdsa_status = 0U;
            if (chains != 10U && chains != 100U &&
                chains != 1000U && chains != 10000U) {
                LOG_ERROR("Unsupported ECDSA certificate-chain count");
                continue;
            }
            if (!cluster_bls_send_current_key_list(&uart, nonce_bin)) {
                LOG_ERROR("Could not return the current certificate chain");
                continue;
            }
            memcpy(quote_preimage, "ECQ1", 4U);
            scale_put_u32(quote_preimage + 4U, chains);
            memcpy(quote_preimage + 8U, nonce_bin, 32U);
            memcpy(quote_preimage + 40U, firmware_hash, 32U);
            SHA256_hash(quote_preimage, sizeof(quote_preimage), quote_digest);
            LOG_INFO("L2 starts verifying %u L1 certificates", chains);
            if (!ecdsa_request_l2_certificate_verification(
                    chains, &l2_completed, &l2_cycles)) {
                ecdsa_status = 1U;
                LOG_ERROR("L2 did not verify all L1 certificates");
            }
            LOG_INFO("L3 starts verifying %u L2 certificates", chains / 10U);
            if (!ecdsa_verify_l2_certificates(
                    public_key, chains / 10U, &l3_completed, &l3_cycles)) {
                ecdsa_status = 2U;
                LOG_ERROR("L3 did not verify all L2 certificates");
            }
            LOG_INFO("Hierarchical ECDSA verification: L2=%u/%u, L3=%u/%u",
                     l2_completed, chains, l3_completed, chains / 10U);
            prepare_scale_quote_block(
                (const uint8_t *)"ECD1", chains,
                chains + chains / 10U + 1U, quote_digest, NULL,
                ecdsa_status == 0U);
            memcpy(g_cluster_bls_quote_block + 42U, "EVT1", 4U);
            scale_put_u32(g_cluster_bls_quote_block + 46U, ecdsa_status);
            scale_put_u32(g_cluster_bls_quote_block + 50U, l2_completed);
            scale_put_u32(g_cluster_bls_quote_block + 54U, l3_completed);
            cluster_bls_put_u64_be(g_cluster_bls_quote_block + 58U,
                                   l2_cycles);
            cluster_bls_put_u64_be(g_cluster_bls_quote_block + 66U,
                                   l3_cycles);
            LOG_INFO("Building ECDSA certificate-chain benchmark Quote");
            if (send_prepared_attestation_quote(uart) != 0) {
                LOG_ERROR("ECDSA benchmark Quote response failed");
            }
            continue;
        }
        if (memcmp(nonce_bin, "EHW1", 4U) == 0) {
            if (!ecdsa_scale_ot_run(&uart, nonce_bin, rom_sha256_digest)) {
                LOG_ERROR("ECDSA hardware scale test failed");
            }
            continue;
        }
        if (!cluster_bls_receive_quote_request(
                &uart, &g_cluster_bls_request, &participant_count)) {
            return false;
        }

        if (g_cluster_bls_scale_profile != 0U) {
            if (cluster_bls_run_scale_profile(
                    &uart, &g_cluster_bls_request,
                    g_cluster_bls_scale_profile)) {
                LOG_INFO("Building Cluster-BLS scale Quote");
                if (send_prepared_attestation_quote(uart) != 0) {
                    LOG_ERROR("Cluster-BLS scale Quote response failed");
                }
            }
            continue;
        }

        verify_status = 0xaaU;
        LOG_INFO("Starting L3/L2/L1 Cluster-BLS aggregate proof flow");
        if (remote_attestation_mldsa(uart) != 0) {
            LOG_ERROR("Remote attestation response failed");
        }
    }

    return true;
}
