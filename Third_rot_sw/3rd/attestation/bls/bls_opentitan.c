#include "bls_opentitan.h"

#include <string.h>

#include "blst.h"
#include "blst_aux.h"

/*
 * IETF BLS signature ciphersuite:
 * public keys in G1 (48 bytes), signatures in G2 (96 bytes).
 *
 * The host and device must use exactly the same ciphersuite/DST.
 */
static const uint8_t kBlsBasicDst[] = OT_BLS_BASIC_DST_BYTES;
static const uint8_t kBlsPopSignatureDst[] = OT_BLS_POP_SIGNATURE_DST_BYTES;
static const uint8_t kBlsPopProofDst[] = OT_BLS_POP_PROOF_DST_BYTES;

static bool sign_with_dst(const uint8_t sk[kOtBlsSecretKeyBytes],
                          const uint8_t *msg, size_t msg_len,
                          const uint8_t *dst, size_t dst_len,
                          uint8_t sig[kOtBlsSignatureBytes]);
static bool verify_with_dst(const uint8_t pk[kOtBlsPublicKeyBytes],
                            const uint8_t sig[kOtBlsSignatureBytes],
                            const uint8_t *msg, size_t msg_len,
                            const uint8_t *dst, size_t dst_len);

/* Avoid passing a NULL message pointer into third-party code for an empty msg. */
static const uint8_t kEmptyMessage[1] = {0};

/*
 * Wipe secret material without allowing the compiler to optimize it away.
 * Replace with a platform-approved secure wipe primitive if one is available.
 */
static void secure_wipe(void *data, size_t len) {
  volatile uint8_t *ptr = (volatile uint8_t *)data;

  while (len-- != 0) {
    *ptr++ = 0;
  }
}

static const uint8_t *message_or_empty(const uint8_t *msg, size_t msg_len) {
  if (msg_len == 0) {
    return kEmptyMessage;
  }
  return msg;
}

bool ot_bls_keygen(const uint8_t *ikm, size_t ikm_len,
                   uint8_t sk[kOtBlsSecretKeyBytes],
                   uint8_t pk[kOtBlsPublicKeyBytes]) {
  if (ikm == NULL || sk == NULL || pk == NULL ||
      ikm_len < kOtBlsMinIkmBytes) {
    return false;
  }

  blst_scalar secret_key;
  blst_p1 public_key;

  blst_keygen(&secret_key, ikm, ikm_len, NULL, 0);

  if (!blst_sk_check(&secret_key)) {
    secure_wipe(&secret_key, sizeof(secret_key));
    return false;
  }

  blst_bendian_from_scalar(sk, &secret_key);
  blst_sk_to_pk_in_g1(&public_key, &secret_key);
  blst_p1_compress(pk, &public_key);

  secure_wipe(&secret_key, sizeof(secret_key));
  return true;
}

bool ot_bls_sign(const uint8_t sk[kOtBlsSecretKeyBytes],
                 const uint8_t *msg, size_t msg_len,
                 uint8_t sig[kOtBlsSignatureBytes]) {
  return sign_with_dst(sk, msg, msg_len, kBlsBasicDst,
                       sizeof(kBlsBasicDst) - 1, sig);
}

bool ot_bls_verify(const uint8_t pk[kOtBlsPublicKeyBytes],
                   const uint8_t sig[kOtBlsSignatureBytes],
                   const uint8_t *msg, size_t msg_len) {
  return verify_with_dst(pk, sig, msg, msg_len, kBlsBasicDst,
                         sizeof(kBlsBasicDst) - 1);
}

bool ot_bls_pop_sign(const uint8_t sk[kOtBlsSecretKeyBytes],
                     const uint8_t *msg, size_t msg_len,
                     uint8_t sig[kOtBlsSignatureBytes]) {
  return sign_with_dst(sk, msg, msg_len, kBlsPopSignatureDst,
                       sizeof(kBlsPopSignatureDst) - 1, sig);
}

bool ot_bls_pop_prove(const uint8_t sk[kOtBlsSecretKeyBytes],
                      uint8_t proof[kOtBlsSignatureBytes]) {
  if (sk == NULL || proof == NULL) {
    return false;
  }

  blst_scalar secret_key;
  blst_p1 public_key;
  uint8_t serialized_pk[kOtBlsPublicKeyBytes];
  bool result;

  blst_scalar_from_bendian(&secret_key, sk);
  if (!blst_sk_check(&secret_key)) {
    secure_wipe(&secret_key, sizeof(secret_key));
    return false;
  }
  blst_sk_to_pk_in_g1(&public_key, &secret_key);
  blst_p1_compress(serialized_pk, &public_key);
  secure_wipe(&secret_key, sizeof(secret_key));

  result = sign_with_dst(sk, serialized_pk, sizeof(serialized_pk),
                         kBlsPopProofDst, sizeof(kBlsPopProofDst) - 1, proof);
  secure_wipe(serialized_pk, sizeof(serialized_pk));
  return result;
}

bool ot_bls_pop_verify(const uint8_t pk[kOtBlsPublicKeyBytes],
                       const uint8_t proof[kOtBlsSignatureBytes]) {
  return verify_with_dst(pk, proof, pk, kOtBlsPublicKeyBytes, kBlsPopProofDst,
                         sizeof(kBlsPopProofDst) - 1);
}

bool ot_bls_aggregate_public_keys(const uint8_t *pks, size_t count,
                                  uint8_t aggregate_pk[kOtBlsPublicKeyBytes]) {
  if (pks == NULL || aggregate_pk == NULL || count == 0) {
    return false;
  }

  blst_p1 aggregate;
  for (size_t i = 0; i < count; ++i) {
    blst_p1_affine public_key;
    const uint8_t *serialized = pks + i * kOtBlsPublicKeyBytes;
    if (blst_p1_uncompress(&public_key, serialized) != BLST_SUCCESS ||
        !blst_p1_affine_in_g1(&public_key) ||
        blst_p1_affine_is_inf(&public_key)) {
      return false;
    }
    if (i == 0) {
      blst_p1_from_affine(&aggregate, &public_key);
    } else {
      blst_p1_add_or_double_affine(&aggregate, &aggregate, &public_key);
    }
  }

  blst_p1_affine aggregate_affine;
  blst_p1_to_affine(&aggregate_affine, &aggregate);
  if (!blst_p1_affine_in_g1(&aggregate_affine) ||
      blst_p1_affine_is_inf(&aggregate_affine)) {
    return false;
  }
  blst_p1_affine_compress(aggregate_pk, &aggregate_affine);
  return true;
}

bool ot_bls_aggregate_signatures(const uint8_t *sigs, size_t count,
                                 uint8_t aggregate_sig[kOtBlsSignatureBytes]) {
  if (sigs == NULL || aggregate_sig == NULL || count == 0) {
    return false;
  }

  blst_p2 aggregate;
  for (size_t i = 0; i < count; ++i) {
    blst_p2_affine signature;
    const uint8_t *serialized = sigs + i * kOtBlsSignatureBytes;
    if (blst_p2_uncompress(&signature, serialized) != BLST_SUCCESS ||
        !blst_p2_affine_in_g2(&signature) ||
        blst_p2_affine_is_inf(&signature)) {
      return false;
    }
    if (i == 0) {
      blst_p2_from_affine(&aggregate, &signature);
    } else {
      blst_p2_add_or_double_affine(&aggregate, &aggregate, &signature);
    }
  }

  blst_p2_affine aggregate_affine;
  blst_p2_to_affine(&aggregate_affine, &aggregate);
  if (!blst_p2_affine_in_g2(&aggregate_affine) ||
      blst_p2_affine_is_inf(&aggregate_affine)) {
    return false;
  }
  blst_p2_affine_compress(aggregate_sig, &aggregate_affine);
  return true;
}

bool ot_bls_fast_aggregate_verify(
    const uint8_t *pks, size_t count, const uint8_t *msg, size_t msg_len,
    const uint8_t aggregate_sig[kOtBlsSignatureBytes]) {
  if (pks == NULL || aggregate_sig == NULL || count == 0 ||
      (msg == NULL && msg_len != 0)) {
    return false;
  }
  for (size_t i = 0; i < count; ++i) {
    for (size_t j = 0; j < i; ++j) {
      if (memcmp(pks + i * kOtBlsPublicKeyBytes,
                 pks + j * kOtBlsPublicKeyBytes,
                 kOtBlsPublicKeyBytes) == 0) {
        return false;
      }
    }
  }

  uint8_t aggregate_pk[kOtBlsPublicKeyBytes];
  if (!ot_bls_aggregate_public_keys(pks, count, aggregate_pk)) {
    return false;
  }
  return verify_with_dst(aggregate_pk, aggregate_sig, msg, msg_len,
                         kBlsPopSignatureDst,
                         sizeof(kBlsPopSignatureDst) - 1);
}

size_t ot_bls_pairing_context_size(void) {
  return blst_pairing_sizeof();
}

bool ot_bls_aggregate_verify(
    const uint8_t *pks, const uint8_t *sigs, const uint8_t *const *msgs,
    const size_t *msg_lens, size_t count, void *pairing_ctx,
    size_t pairing_ctx_len) {
  if (pks == NULL || sigs == NULL || msgs == NULL || msg_lens == NULL ||
      pairing_ctx == NULL || count == 0 ||
      pairing_ctx_len < blst_pairing_sizeof()) {
    return false;
  }

  blst_pairing *ctx = (blst_pairing *)pairing_ctx;
  blst_pairing_init(ctx, true, kBlsBasicDst, sizeof(kBlsBasicDst) - 1);

  for (size_t i = 0; i < count; ++i) {
    if (msgs[i] == NULL && msg_lens[i] != 0) {
      return false;
    }
    /* The Basic scheme forbids repeated messages.  Online cluster proofs use
     * ot_bls_fast_aggregate_verify() after PoP registration instead. */
    for (size_t j = 0; j < i; ++j) {
      if (msg_lens[i] == msg_lens[j] &&
          memcmp(message_or_empty(msgs[i], msg_lens[i]),
                 message_or_empty(msgs[j], msg_lens[j]), msg_lens[i]) == 0) {
        return false;
      }
    }

    blst_p1_affine public_key;
    blst_p2_affine signature;
    if (blst_p1_uncompress(&public_key,
                          pks + i * kOtBlsPublicKeyBytes) != BLST_SUCCESS ||
        blst_p2_uncompress(&signature,
                          sigs + i * kOtBlsSignatureBytes) != BLST_SUCCESS ||
        !blst_p1_affine_in_g1(&public_key) ||
        !blst_p2_affine_in_g2(&signature) ||
        blst_pairing_chk_n_aggr_pk_in_g1(
            ctx, &public_key, false, &signature, false,
            message_or_empty(msgs[i], msg_lens[i]), msg_lens[i], NULL, 0) !=
            BLST_SUCCESS) {
      return false;
    }
  }

  blst_pairing_commit(ctx);
  return blst_pairing_finalverify(ctx, NULL);
}

static bool sign_with_dst(const uint8_t sk[kOtBlsSecretKeyBytes],
                          const uint8_t *msg, size_t msg_len,
                          const uint8_t *dst, size_t dst_len,
                          uint8_t sig[kOtBlsSignatureBytes]) {
  if (sk == NULL || sig == NULL || dst == NULL || dst_len == 0 ||
      (msg == NULL && msg_len != 0)) {
    return false;
  }

  blst_scalar secret_key;
  blst_p2 message_point;
  blst_p2 signature;

  blst_scalar_from_bendian(&secret_key, sk);
  if (!blst_sk_check(&secret_key)) {
    secure_wipe(&secret_key, sizeof(secret_key));
    return false;
  }

  blst_hash_to_g2(&message_point, message_or_empty(msg, msg_len), msg_len,
                  dst, dst_len, NULL, 0);
  blst_sign_pk_in_g1(&signature, &message_point, &secret_key);
  blst_p2_compress(sig, &signature);
  secure_wipe(&secret_key, sizeof(secret_key));
  return true;
}

bool ot_bls_key_id_from_public_key(
    const uint8_t pk[kOtBlsPublicKeyBytes], uint8_t key_id[16]) {
  static const uint8_t kKeyIdDomain[] = "CLUSTER-BLS-key-id-v1\x00";
  uint8_t input[sizeof(kKeyIdDomain) - 1 + kOtBlsPublicKeyBytes];
  uint8_t digest[32];
  blst_p1_affine public_key;

  if (pk == NULL || key_id == NULL ||
      blst_p1_uncompress(&public_key, pk) != BLST_SUCCESS ||
      !blst_p1_affine_in_g1(&public_key) ||
      blst_p1_affine_is_inf(&public_key)) {
    return false;
  }
  memcpy(input, kKeyIdDomain, sizeof(kKeyIdDomain) - 1);
  memcpy(input + sizeof(kKeyIdDomain) - 1, pk, kOtBlsPublicKeyBytes);
  blst_sha256(digest, input, sizeof(input));
  memcpy(key_id, digest, 16);
  secure_wipe(input, sizeof(input));
  secure_wipe(digest, sizeof(digest));
  return true;
}

static bool verify_with_dst(const uint8_t pk[kOtBlsPublicKeyBytes],
                            const uint8_t sig[kOtBlsSignatureBytes],
                            const uint8_t *msg, size_t msg_len,
                            const uint8_t *dst, size_t dst_len) {
  if (pk == NULL || sig == NULL || dst == NULL || dst_len == 0 ||
      (msg == NULL && msg_len != 0)) {
    return false;
  }

  blst_p1_affine public_key;
  blst_p2_affine signature;
  if (blst_p1_uncompress(&public_key, pk) != BLST_SUCCESS ||
      blst_p2_uncompress(&signature, sig) != BLST_SUCCESS ||
      !blst_p1_affine_in_g1(&public_key) ||
      !blst_p2_affine_in_g2(&signature) ||
      blst_p1_affine_is_inf(&public_key) ||
      blst_p2_affine_is_inf(&signature)) {
    return false;
  }

  return blst_core_verify_pk_in_g1(
             &public_key, &signature, true, message_or_empty(msg, msg_len),
             msg_len, dst, dst_len, NULL, 0) == BLST_SUCCESS;
}
