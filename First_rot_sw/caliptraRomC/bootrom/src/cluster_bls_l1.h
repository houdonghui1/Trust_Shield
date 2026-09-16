#ifndef CLUSTER_BLS_L1_H_
#define CLUSTER_BLS_L1_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "cluster_bls_protocol.h"

typedef struct cluster_bls_l1_service {
    cluster_bls_signer_t signer;
} cluster_bls_l1_service_t;

/*
 * This record lives in a dedicated NOLOAD DCCM section shared by ROM and RT.
 * The secret was derived while the IDevID CDI was available, so RT must reuse
 * this protected state instead of deriving a different key after CDI evolves
 * through the later DICE stages.
 */
enum { kClusterBlsL1PersistentStateMagic = 0x43424c53U };
typedef struct cluster_bls_l1_persistent_state {
    uint32_t magic;
    bool certificate_installed;
    uint8_t reserved[3];
    cluster_bls_l1_service_t service;
} cluster_bls_l1_persistent_state_t;

bool cluster_bls_l1_init(cluster_bls_l1_service_t *service,
                         const uint8_t *cdi_derived_ikm, size_t ikm_len);
bool cluster_bls_l1_registration(const cluster_bls_l1_service_t *service,
                                 cluster_bls_registration_t *registration);
bool cluster_bls_l1_build_certificate_request(
    const cluster_bls_l1_service_t *service, const uint8_t *tbs_der,
    size_t tbs_der_len, uint8_t *out, size_t *out_len);
bool cluster_bls_l1_sign_challenge(
    const cluster_bls_l1_service_t *service,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    uint8_t signature[kOtBlsSignatureBytes]);

bool cluster_bls_l1_persistent_state_init(
    cluster_bls_l1_persistent_state_t *state, const uint8_t *cdi_derived_ikm,
    size_t ikm_len);
bool cluster_bls_l1_persistent_state_valid(
    const cluster_bls_l1_persistent_state_t *state);

#endif  /* CLUSTER_BLS_L1_H_ */
