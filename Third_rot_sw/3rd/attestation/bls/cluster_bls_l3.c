#include "cluster_bls_l3.h"

#include <string.h>

bool cluster_bls_l3_init(cluster_bls_l3_service_t *service,
                         const uint8_t *cdi_derived_ikm, size_t ikm_len) {
  if (service == NULL) {
    return false;
  }
  memset(service, 0, sizeof(*service));
  return cluster_bls_signer_init(&service->signer, cdi_derived_ikm, ikm_len);
}

bool cluster_bls_l3_registration(const cluster_bls_l3_service_t *service,
                                 cluster_bls_registration_t *registration) {
  return service != NULL &&
         cluster_bls_registration_from_signer(&service->signer, registration);
}

bool cluster_bls_l3_register_child(cluster_bls_l3_service_t *service,
                                   const cluster_bls_registration_t *registration) {
  if (service == NULL || registration == NULL ||
      !cluster_bls_registration_verify(registration)) {
    return false;
  }
  for (size_t i = 0; i < kClusterBlsL3MaxDirectChildren; ++i) {
    cluster_bls_l3_child_t *child = &service->children[i];
    if (!child->active) {
      continue;
    }
    if (memcmp(child->registration.key_id, registration->key_id,
               kClusterBlsKeyIdBytes) == 0 ||
        memcmp(child->registration.public_key, registration->public_key,
               kOtBlsPublicKeyBytes) == 0) {
      /* Replaying the exact enrolled registration is idempotent; key changes
       * require explicit revocation so an epoch transition cannot be hidden. */
      return memcmp(&child->registration, registration,
                    sizeof(*registration)) == 0;
    }
  }
  for (size_t i = 0; i < kClusterBlsL3MaxDirectChildren; ++i) {
    cluster_bls_l3_child_t *child = &service->children[i];
    if (!child->active) {
      child->registration = *registration;
      child->active = true;
      return true;
    }
  }
  return false;
}

bool cluster_bls_l3_revoke_child(
    cluster_bls_l3_service_t *service,
    const uint8_t key_id[kClusterBlsKeyIdBytes]) {
  if (service == NULL || key_id == NULL) {
    return false;
  }
  for (size_t i = 0; i < kClusterBlsL3MaxDirectChildren; ++i) {
    cluster_bls_l3_child_t *child = &service->children[i];
    if (child->active && memcmp(child->registration.key_id, key_id,
                                kClusterBlsKeyIdBytes) == 0) {
      memset(&child->registration, 0, sizeof(child->registration));
      child->active = false;
      return true;
    }
  }
  return false;
}

size_t cluster_bls_l3_active_child_count(const cluster_bls_l3_service_t *service) {
  size_t count = 0;
  if (service == NULL) {
    return 0;
  }
  for (size_t i = 0; i < kClusterBlsL3MaxDirectChildren; ++i) {
    count += service->children[i].active ? 1U : 0U;
  }
  return count;
}

bool cluster_bls_l3_sign_challenge(
    const cluster_bls_l3_service_t *service,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    uint8_t signature[kOtBlsSignatureBytes]) {
  return service != NULL &&
         cluster_bls_sign_challenge(&service->signer, challenge_digest,
                                    signature);
}

bool cluster_bls_l3_aggregate_challenge(
    const cluster_bls_l3_service_t *service,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    const uint8_t *child_aggregate_signatures, size_t child_signature_count,
    uint8_t aggregate_signature[kOtBlsSignatureBytes]) {
  uint8_t signatures[(kClusterBlsL3MaxDirectChildren + 1) *
                     kOtBlsSignatureBytes];
  size_t active_children;

  if (service == NULL || challenge_digest == NULL || aggregate_signature == NULL) {
    return false;
  }
  active_children = cluster_bls_l3_active_child_count(service);
  if (child_signature_count != active_children ||
      (active_children != 0 && child_aggregate_signatures == NULL) ||
      !cluster_bls_l3_sign_challenge(service, challenge_digest, signatures)) {
    return false;
  }
  if (active_children != 0) {
    memcpy(signatures + kOtBlsSignatureBytes, child_aggregate_signatures,
           active_children * kOtBlsSignatureBytes);
  }
  return cluster_bls_aggregate(signatures, active_children + 1,
                               aggregate_signature);
}
