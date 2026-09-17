#include "cluster_bls_l1.h"

#include <string.h>

bool cluster_bls_l1_init(cluster_bls_l1_service_t *service,
                         const uint8_t *cdi_derived_ikm, size_t ikm_len) {
    if (service == NULL) {
        return false;
    }
    memset(service, 0, sizeof(*service));
    return cluster_bls_signer_init(&service->signer, cdi_derived_ikm, ikm_len);
}

bool cluster_bls_l1_registration(const cluster_bls_l1_service_t *service,
                                 cluster_bls_registration_t *registration) {
    return service != NULL &&
           cluster_bls_registration_from_signer(&service->signer, registration);
}

bool cluster_bls_l1_build_certificate_request(
    const cluster_bls_l1_service_t *service, const uint8_t *tbs_der,
    size_t tbs_der_len, uint8_t *out, size_t *out_len) {
    cluster_bls_registration_t registration;
    return service != NULL &&
           cluster_bls_l1_registration(service, &registration) &&
           cluster_bls_certificate_request_encode(&registration, tbs_der,
                                                  tbs_der_len, out, out_len);
}

bool cluster_bls_l1_sign_challenge(
    const cluster_bls_l1_service_t *service,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    uint8_t signature[kOtBlsSignatureBytes]) {
    return service != NULL &&
           cluster_bls_sign_challenge(&service->signer, challenge_digest,
                                      signature);
}

bool cluster_bls_l1_persistent_state_init(
    cluster_bls_l1_persistent_state_t *state, const uint8_t *cdi_derived_ikm,
    size_t ikm_len) {
    if (state == NULL) {
        return false;
    }
    memset(state, 0, sizeof(*state));
    if (!cluster_bls_l1_init(&state->service, cdi_derived_ikm, ikm_len)) {
        return false;
    }
    state->magic = kClusterBlsL1PersistentStateMagic;
    return true;
}

bool cluster_bls_l1_persistent_state_valid(
    const cluster_bls_l1_persistent_state_t *state) {
    return state != NULL && state->magic == kClusterBlsL1PersistentStateMagic &&
           state->service.signer.initialized;
}
