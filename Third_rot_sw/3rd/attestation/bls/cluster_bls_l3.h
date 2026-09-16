#ifndef CLUSTER_BLS_L3_H_
#define CLUSTER_BLS_L3_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "cluster_bls_protocol.h"

/* Direct children are L2 aggregation roots, not every L1 leaf. */
enum { kClusterBlsL3MaxDirectChildren = 16 };

typedef struct cluster_bls_l3_child {
  cluster_bls_registration_t registration;
  bool active;
} cluster_bls_l3_child_t;

typedef struct cluster_bls_l3_service {
  cluster_bls_signer_t signer;
  cluster_bls_l3_child_t children[kClusterBlsL3MaxDirectChildren];
} cluster_bls_l3_service_t;

bool cluster_bls_l3_init(cluster_bls_l3_service_t *service,
                         const uint8_t *cdi_derived_ikm, size_t ikm_len);
bool cluster_bls_l3_registration(const cluster_bls_l3_service_t *service,
                                 cluster_bls_registration_t *registration);

/* Enrolment is PoP-gated and rejects replacement without explicit revocation. */
bool cluster_bls_l3_register_child(cluster_bls_l3_service_t *service,
                                   const cluster_bls_registration_t *registration);
bool cluster_bls_l3_revoke_child(
    cluster_bls_l3_service_t *service,
    const uint8_t key_id[kClusterBlsKeyIdBytes]);
size_t cluster_bls_l3_active_child_count(const cluster_bls_l3_service_t *service);

bool cluster_bls_l3_sign_challenge(
    const cluster_bls_l3_service_t *service,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    uint8_t signature[kOtBlsSignatureBytes]);

/*
 * Aggregates exactly one verified transport signature from every active L2
 * plus L3's own signature.  L2 aggregate signatures are still checked by the
 * verifier against the signed global member list before the proof is trusted.
 */
bool cluster_bls_l3_aggregate_challenge(
    const cluster_bls_l3_service_t *service,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    const uint8_t *child_aggregate_signatures, size_t child_signature_count,
    uint8_t aggregate_signature[kOtBlsSignatureBytes]);

#endif  // CLUSTER_BLS_L3_H_
