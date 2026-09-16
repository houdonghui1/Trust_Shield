#ifndef CLUSTER_BLS_PROTOCOL_H_
#define CLUSTER_BLS_PROTOCOL_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "bls_opentitan.h"

/* Values transported in certificates, key lists, and challenge frames. */
enum {
  kClusterBlsProtocolVersion = 1,
  kClusterBlsCiphersuitePop = 1,
  kClusterBlsKeyIdBytes = 16,
  kClusterBlsNonceBytes = 32,
  kClusterBlsDigestBytes = 32,
  kClusterBlsMaxClusterIdBytes = 128,
  kClusterBlsRegistrationWireBytes = 1 + 1 + kClusterBlsKeyIdBytes +
      kOtBlsPublicKeyBytes + kOtBlsSignatureBytes,
  kClusterBlsCertificateRequestHeaderBytes = 7,
};

#define CLUSTER_BLS_CHALLENGE_DOMAIN "CLUSTER-BLS-ATTEST-v1\x00"
#define CLUSTER_BLS_CIPHERSUITE_ID "BLS12381G2_XMD:SHA-256_SSWU_RO_POP_"

/* A platform fills IKM from a DICE CDI using its own secure KDF. */
typedef struct cluster_bls_signer {
  uint8_t secret_key[kOtBlsSecretKeyBytes];
  uint8_t public_key[kOtBlsPublicKeyBytes];
  uint8_t proof_of_possession[kOtBlsSignatureBytes];
  uint8_t key_id[kClusterBlsKeyIdBytes];
  bool initialized;
} cluster_bls_signer_t;

typedef struct cluster_bls_challenge {
  uint8_t protocol_version;
  uint8_t ciphersuite;
  uint8_t cluster_id_len;
  uint8_t cluster_id[kClusterBlsMaxClusterIdBytes];
  uint64_t epoch;
  uint8_t nonce[kClusterBlsNonceBytes];
  uint8_t measurement_digest[kClusterBlsDigestBytes];
  uint8_t member_list_digest[kClusterBlsDigestBytes];
} cluster_bls_challenge_t;

typedef struct cluster_bls_registration {
  uint8_t protocol_version;
  uint8_t ciphersuite;
  uint8_t key_id[kClusterBlsKeyIdBytes];
  uint8_t public_key[kOtBlsPublicKeyBytes];
  uint8_t proof_of_possession[kOtBlsSignatureBytes];
} cluster_bls_registration_t;

/**
 * Derives a signer only from a caller-provided CDI-derived IKM.  This helper
 * never falls back to a fixed seed or fresh RNG: an unavailable CDI must fail
 * closed at the platform integration layer.  The resulting PoP is verified by
 * the enrolling parent, rather than locally, so an L1 signer need not link a
 * pairing verifier merely to create its registration.
 */
bool cluster_bls_signer_init(cluster_bls_signer_t *signer,
                             const uint8_t *ikm, size_t ikm_len);
void cluster_bls_signer_wipe(cluster_bls_signer_t *signer);

bool cluster_bls_registration_from_signer(
    const cluster_bls_signer_t *signer, cluster_bls_registration_t *registration);
bool cluster_bls_registration_verify(const cluster_bls_registration_t *registration);

/* Fixed-width network representation; never transmit a padded C struct. */
bool cluster_bls_registration_encode(
    const cluster_bls_registration_t *registration,
    uint8_t out[kClusterBlsRegistrationWireBytes]);
bool cluster_bls_registration_decode(
    const uint8_t encoded[kClusterBlsRegistrationWireBytes],
    cluster_bls_registration_t *registration);

/*
 * Certificate request transport: ``CBR1 || version || tbsLength(u16be) ||
 * registration || tbsDer``.  The parent validates the decoded registration
 * and inserts exactly one BLS binding extension before signing the TBS.
 */
bool cluster_bls_certificate_request_encode(
    const cluster_bls_registration_t *registration, const uint8_t *tbs_der,
    size_t tbs_der_len, uint8_t *out, size_t *out_len);
bool cluster_bls_certificate_request_decode(
    const uint8_t *encoded, size_t encoded_len,
    cluster_bls_registration_t *registration, const uint8_t **tbs_der,
    size_t *tbs_der_len);

/* Extract and validate the single cluster-BLS binding from a signed TBS. */
bool cluster_bls_certificate_binding_decode(
    const uint8_t *tbs_der, size_t tbs_der_len,
    cluster_bls_registration_t *registration);

/**
 * Encodes the preimage that all devices SHA-256 before BLS signing.  The
 * result exactly matches ``cluster_bls.protocol.build_challenge_message`` up
 * to the final SHA-256 operation and uses network byte order for ``epoch``.
 */
bool cluster_bls_encode_challenge(const cluster_bls_challenge_t *challenge,
                                  uint8_t *out, size_t *out_len);

bool cluster_bls_sign_challenge(const cluster_bls_signer_t *signer,
                                const uint8_t challenge_digest[kClusterBlsDigestBytes],
                                uint8_t signature[kOtBlsSignatureBytes]);
bool cluster_bls_aggregate(const uint8_t *signatures, size_t signature_count,
                           uint8_t aggregate_signature[kOtBlsSignatureBytes]);
bool cluster_bls_verify_aggregate(const uint8_t *public_keys,
                                  size_t public_key_count,
                                  const uint8_t challenge_digest[kClusterBlsDigestBytes],
                                  const uint8_t aggregate_signature[kOtBlsSignatureBytes]);

#endif  // CLUSTER_BLS_PROTOCOL_H_
