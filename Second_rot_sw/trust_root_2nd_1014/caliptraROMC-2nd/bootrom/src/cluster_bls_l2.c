#include "cluster_bls_l2.h"

#include <string.h>

#include "blst.h"

bool cluster_bls_l2_init(cluster_bls_l2_service_t *service,
                         const uint8_t *cdi_derived_ikm, size_t ikm_len) {
    if (service == NULL) {
        return false;
    }
    memset(service, 0, sizeof(*service));
    return cluster_bls_signer_init(&service->signer, cdi_derived_ikm, ikm_len);
}

bool cluster_bls_l2_registration(const cluster_bls_l2_service_t *service,
                                 cluster_bls_registration_t *registration) {
    return service != NULL &&
           cluster_bls_registration_from_signer(&service->signer, registration);
}

bool cluster_bls_l2_register_l1(cluster_bls_l2_service_t *service,
                                const cluster_bls_registration_t *registration) {
    size_t i;
    if (service == NULL || registration == NULL ||
        !cluster_bls_registration_verify(registration)) {
        return false;
    }
    for (i = 0; i < kClusterBlsL2MaxDirectChildren; ++i) {
        cluster_bls_l2_child_t *child = &service->children[i];
        if (!child->active) {
            continue;
        }
        if (memcmp(child->registration.key_id, registration->key_id,
                   kClusterBlsKeyIdBytes) == 0 ||
            memcmp(child->registration.public_key, registration->public_key,
                   kOtBlsPublicKeyBytes) == 0) {
            /* Exact replay is safe and idempotent; a replacement needs an
             * explicit revoke so the L3 epoch update cannot be bypassed. */
            return memcmp(&child->registration, registration,
                          sizeof(*registration)) == 0;
        }
    }
    for (i = 0; i < kClusterBlsL2MaxDirectChildren; ++i) {
        cluster_bls_l2_child_t *child = &service->children[i];
        if (!child->active) {
            child->registration = *registration;
            child->active = true;
            return true;
        }
    }
    return false;
}

bool cluster_bls_l2_revoke_l1(
    cluster_bls_l2_service_t *service,
    const uint8_t key_id[kClusterBlsKeyIdBytes]) {
    size_t i;
    if (service == NULL || key_id == NULL) {
        return false;
    }
    for (i = 0; i < kClusterBlsL2MaxDirectChildren; ++i) {
        cluster_bls_l2_child_t *child = &service->children[i];
        if (child->active && memcmp(child->registration.key_id, key_id,
                                    kClusterBlsKeyIdBytes) == 0) {
            memset(&child->registration, 0, sizeof(child->registration));
            child->active = false;
            return true;
        }
    }
    return false;
}

size_t cluster_bls_l2_active_child_count(const cluster_bls_l2_service_t *service) {
    size_t i;
    size_t count = 0;
    if (service == NULL) {
        return 0;
    }
    for (i = 0; i < kClusterBlsL2MaxDirectChildren; ++i) {
        count += service->children[i].active ? 1U : 0U;
    }
    return count;
}

bool cluster_bls_l2_sign_challenge(
    const cluster_bls_l2_service_t *service,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    uint8_t signature[kOtBlsSignatureBytes]) {
    return service != NULL &&
           cluster_bls_sign_challenge(&service->signer, challenge_digest,
                                      signature);
}

uint32_t cluster_bls_l2_aggregate_challenge(
    const cluster_bls_l2_service_t *service,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    const uint8_t *l1_signatures, size_t l1_signature_count,
    uint8_t aggregate_signature[kOtBlsSignatureBytes]) {
    uint8_t signatures[2 * kOtBlsSignatureBytes];
    uint8_t checked_signature[kOtBlsSignatureBytes];
    blst_p2_affine l1_signature;
    BLST_ERROR decode_status;
    if (service == NULL || challenge_digest == NULL ||
        aggregate_signature == NULL || l1_signatures == NULL ||
        l1_signature_count == 0U) {
        return kClusterBlsL2AggregateErrorArgument;
    }
    if (l1_signature_count != cluster_bls_l2_active_child_count(service) ||
        l1_signature_count != 1U) {
        return kClusterBlsL2AggregateErrorChildCount;
    }
    if (!cluster_bls_l2_sign_challenge(service, challenge_digest,
                                       signatures)) {
        return kClusterBlsL2AggregateErrorSigning;
    }
    if (!cluster_bls_aggregate(signatures, 1U, checked_signature)) {
        return kClusterBlsL2AggregateErrorL2Point;
    }
    decode_status = blst_p2_uncompress(&l1_signature, l1_signatures);
    if (decode_status != BLST_SUCCESS) {
        return kClusterBlsL2AggregateErrorL1Decode;
    }
    if (!blst_p2_affine_in_g2(&l1_signature)) {
        return kClusterBlsL2AggregateErrorL1Subgroup;
    }
    if (blst_p2_affine_is_inf(&l1_signature)) {
        return kClusterBlsL2AggregateErrorL1Infinity;
    }
    if (!cluster_bls_aggregate(l1_signatures, 1U, checked_signature)) {
        return kClusterBlsL2AggregateErrorL1Aggregate;
    }
    memcpy(signatures + kOtBlsSignatureBytes, l1_signatures,
           kOtBlsSignatureBytes);
    if (!cluster_bls_aggregate(signatures, 2U, aggregate_signature)) {
        return kClusterBlsL2AggregateErrorCombinedPoint;
    }
    return kClusterBlsL2AggregateOk;
}
