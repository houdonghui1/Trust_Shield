#ifndef BLS_OPENTITAN_H_
#define BLS_OPENTITAN_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

enum {
  kOtBlsSecretKeyBytes = 32,
  kOtBlsPublicKeyBytes = 48,
  kOtBlsSignatureBytes = 96,
  kOtBlsMinIkmBytes = 32,
};

#define OT_BLS_BASIC_DST_BYTES \
  "BLS_SIG_BLS12381G2_XMD:SHA-256_SSWU_RO_NUL_"

/*
 * Online cluster attestation signs one common challenge.  It therefore uses
 * the IETF proof-of-possession (PoP) variant, not the Basic variant above.
 */
#define OT_BLS_POP_SIGNATURE_DST_BYTES \
  "BLS_SIG_BLS12381G2_XMD:SHA-256_SSWU_RO_POP_"
#define OT_BLS_POP_PROOF_DST_BYTES \
  "BLS_POP_BLS12381G2_XMD:SHA-256_SSWU_RO_POP_"

/* Kept as a compatibility alias for existing Basic-scheme callers. */
#define OT_BLS_DST_BYTES OT_BLS_BASIC_DST_BYTES

/**
 * Derives a BLS secret key and its compressed G1 public key from IKM.
 *
 * IKM must be generated from a cryptographically secure entropy source and
 * contain at least kOtBlsMinIkmBytes bytes.
 */
bool ot_bls_keygen(const uint8_t *ikm, size_t ikm_len,
                   uint8_t sk[kOtBlsSecretKeyBytes],
                   uint8_t pk[kOtBlsPublicKeyBytes]);

/** Derives the protocol key ID: SHA-256("CLUSTER-BLS-key-id-v1\\0" || PK)[0:16]. */
bool ot_bls_key_id_from_public_key(
    const uint8_t pk[kOtBlsPublicKeyBytes], uint8_t key_id[16]);

/**
 * Creates a compressed G2 signature for msg using a serialized secret key.
 */
bool ot_bls_sign(const uint8_t sk[kOtBlsSecretKeyBytes],
                 const uint8_t *msg, size_t msg_len,
                 uint8_t sig[kOtBlsSignatureBytes]);

/**
 * Verifies a compressed G2 signature with a compressed G1 public key.
 *
 * This function uses the IETF BLS Basic scheme. A valid signature returns
 * true; malformed inputs and verification failures return false.
 */
bool ot_bls_verify(const uint8_t pk[kOtBlsPublicKeyBytes],
                   const uint8_t sig[kOtBlsSignatureBytes],
                   const uint8_t *msg, size_t msg_len);

/**
 * Proof-of-possession scheme used by the cluster protocol.  A PoP is created
 * once during certificate enrollment and verified before a public key is put
 * into an active key list.  The proof and the online signatures are both G2
 * compressed points, but use distinct IETF ciphersuite DSTs.
 */
bool ot_bls_pop_sign(const uint8_t sk[kOtBlsSecretKeyBytes],
                     const uint8_t *msg, size_t msg_len,
                     uint8_t sig[kOtBlsSignatureBytes]);
bool ot_bls_pop_verify(const uint8_t pk[kOtBlsPublicKeyBytes],
                       const uint8_t proof[kOtBlsSignatureBytes]);
bool ot_bls_pop_prove(const uint8_t sk[kOtBlsSecretKeyBytes],
                      uint8_t proof[kOtBlsSignatureBytes]);

/** Aggregates compressed points after strict subgroup/infinity checks. */
bool ot_bls_aggregate_public_keys(const uint8_t *pks, size_t count,
                                  uint8_t aggregate_pk[kOtBlsPublicKeyBytes]);
bool ot_bls_aggregate_signatures(const uint8_t *sigs, size_t count,
                                 uint8_t aggregate_sig[kOtBlsSignatureBytes]);

/**
 * Validates one same-message aggregate proof.  Every public key must have had
 * a valid PoP at enrollment; duplicate serialized public keys are rejected.
 */
bool ot_bls_fast_aggregate_verify(const uint8_t *pks, size_t count,
                                  const uint8_t *msg, size_t msg_len,
                                  const uint8_t aggregate_sig[kOtBlsSignatureBytes]);

/**
 * Verifies Basic-scheme signatures from different public keys and *distinct*
 * messages in one pairing operation.  It is intentionally unsuitable for the
 * cluster challenge because that challenge is identical for every member.
 * The caller owns pairing_ctx and must provide at least
 * ot_bls_pairing_context_size() bytes of storage.
 */
size_t ot_bls_pairing_context_size(void);
bool ot_bls_aggregate_verify(
    const uint8_t *pks, const uint8_t *sigs, const uint8_t *const *msgs,
    const size_t *msg_lens, size_t count, void *pairing_ctx,
    size_t pairing_ctx_len);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // BLS_OPENTITAN_H_
