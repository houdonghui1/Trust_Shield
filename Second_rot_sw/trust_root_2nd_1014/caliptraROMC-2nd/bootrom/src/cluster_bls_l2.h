#ifndef CLUSTER_BLS_L2_H_
#define CLUSTER_BLS_L2_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "cluster_bls_protocol.h"

/* L2 records direct L1 children; L3 owns the global cluster list and epoch. */
enum {
    kClusterBlsL2MaxDirectChildren = 1,
    kClusterBlsL2AggregateOk = 0,
    kClusterBlsL2AggregateErrorInit = 0x4c324000,
    kClusterBlsL2AggregateErrorRequest = 0x4c324001,
    kClusterBlsL2AggregateErrorArgument = 0x4c324002,
    kClusterBlsL2AggregateErrorChildCount = 0x4c324003,
    kClusterBlsL2AggregateErrorSigning = 0x4c324004,
    kClusterBlsL2AggregateErrorPoint = 0x4c324005,
    kClusterBlsL2AggregateErrorL1Point = 0x4c324006,
    kClusterBlsL2AggregateErrorL2Point = 0x4c324007,
    kClusterBlsL2AggregateErrorCombinedPoint = 0x4c324008,
    kClusterBlsL2AggregateErrorL1Decode = 0x4c324009,
    kClusterBlsL2AggregateErrorL1Subgroup = 0x4c32400a,
    kClusterBlsL2AggregateErrorL1Infinity = 0x4c32400b,
    kClusterBlsL2AggregateErrorL1Aggregate = 0x4c32400c,
};

typedef struct cluster_bls_l2_child {
    cluster_bls_registration_t registration;
    bool active;
} cluster_bls_l2_child_t;

typedef struct cluster_bls_l2_service {
    cluster_bls_signer_t signer;
    cluster_bls_l2_child_t children[kClusterBlsL2MaxDirectChildren];
} cluster_bls_l2_service_t;

bool cluster_bls_l2_init(cluster_bls_l2_service_t *service,
                         const uint8_t *cdi_derived_ikm, size_t ikm_len);
bool cluster_bls_l2_registration(const cluster_bls_l2_service_t *service,
                                 cluster_bls_registration_t *registration);
bool cluster_bls_l2_register_l1(cluster_bls_l2_service_t *service,
                                const cluster_bls_registration_t *registration);
bool cluster_bls_l2_revoke_l1(
    cluster_bls_l2_service_t *service,
    const uint8_t key_id[kClusterBlsKeyIdBytes]);
size_t cluster_bls_l2_active_child_count(const cluster_bls_l2_service_t *service);

bool cluster_bls_l2_sign_challenge(
    const cluster_bls_l2_service_t *service,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    uint8_t signature[kOtBlsSignatureBytes]);

/* Aggregates one signature from every active L1 plus L2's own signature. */
uint32_t cluster_bls_l2_aggregate_challenge(
    const cluster_bls_l2_service_t *service,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    const uint8_t *l1_signatures, size_t l1_signature_count,
    uint8_t aggregate_signature[kOtBlsSignatureBytes]);

#endif  /* CLUSTER_BLS_L2_H_ */
