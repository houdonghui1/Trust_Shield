#include "cluster_bls_protocol.h"

#include <string.h>

static void put_u64_be(uint8_t output[8], uint64_t value) {
  for (size_t i = 0; i < 8; ++i) {
    output[7 - i] = (uint8_t)(value >> (i * 8));
  }
}

bool cluster_bls_signer_init(cluster_bls_signer_t *signer,
                             const uint8_t *ikm, size_t ikm_len) {
  if (signer == NULL || ikm == NULL || ikm_len < kOtBlsMinIkmBytes) {
    return false;
  }
  memset(signer, 0, sizeof(*signer));
  if (!ot_bls_keygen(ikm, ikm_len, signer->secret_key, signer->public_key) ||
      !ot_bls_pop_prove(signer->secret_key, signer->proof_of_possession) ||
      !ot_bls_key_id_from_public_key(signer->public_key, signer->key_id)) {
    cluster_bls_signer_wipe(signer);
    return false;
  }
  signer->initialized = true;
  return true;
}

void cluster_bls_signer_wipe(cluster_bls_signer_t *signer) {
  if (signer == NULL) {
    return;
  }
  volatile uint8_t *bytes = (volatile uint8_t *)signer;
  for (size_t i = 0; i < sizeof(*signer); ++i) {
    bytes[i] = 0;
  }
}

bool cluster_bls_registration_from_signer(
    const cluster_bls_signer_t *signer, cluster_bls_registration_t *registration) {
  if (signer == NULL || registration == NULL || !signer->initialized) {
    return false;
  }
  memset(registration, 0, sizeof(*registration));
  registration->protocol_version = kClusterBlsProtocolVersion;
  registration->ciphersuite = kClusterBlsCiphersuitePop;
  memcpy(registration->key_id, signer->key_id, sizeof(registration->key_id));
  memcpy(registration->public_key, signer->public_key,
         sizeof(registration->public_key));
  memcpy(registration->proof_of_possession, signer->proof_of_possession,
         sizeof(registration->proof_of_possession));
  return true;
}

bool cluster_bls_registration_verify(const cluster_bls_registration_t *registration) {
  if (registration == NULL ||
      registration->protocol_version != kClusterBlsProtocolVersion ||
      registration->ciphersuite != kClusterBlsCiphersuitePop) {
    return false;
  }
  uint8_t expected_key_id[kClusterBlsKeyIdBytes];
  return ot_bls_key_id_from_public_key(registration->public_key,
                                       expected_key_id) &&
         memcmp(expected_key_id, registration->key_id,
                kClusterBlsKeyIdBytes) == 0 &&
         ot_bls_pop_verify(registration->public_key,
                           registration->proof_of_possession);
}

bool cluster_bls_registration_encode(
    const cluster_bls_registration_t *registration,
    uint8_t out[kClusterBlsRegistrationWireBytes]) {
  uint8_t expected_key_id[kClusterBlsKeyIdBytes];
  if (registration == NULL || out == NULL ||
      registration->protocol_version != kClusterBlsProtocolVersion ||
      registration->ciphersuite != kClusterBlsCiphersuitePop ||
      !ot_bls_key_id_from_public_key(registration->public_key,
                                     expected_key_id) ||
      memcmp(expected_key_id, registration->key_id, kClusterBlsKeyIdBytes) != 0) {
    return false;
  }
  out[0] = registration->protocol_version;
  out[1] = registration->ciphersuite;
  memcpy(out + 2, registration->key_id, kClusterBlsKeyIdBytes);
  memcpy(out + 2 + kClusterBlsKeyIdBytes, registration->public_key,
         kOtBlsPublicKeyBytes);
  memcpy(out + 2 + kClusterBlsKeyIdBytes + kOtBlsPublicKeyBytes,
         registration->proof_of_possession, kOtBlsSignatureBytes);
  return true;
}

bool cluster_bls_registration_decode(
    const uint8_t encoded[kClusterBlsRegistrationWireBytes],
    cluster_bls_registration_t *registration) {
  if (encoded == NULL || registration == NULL) {
    return false;
  }
  memset(registration, 0, sizeof(*registration));
  registration->protocol_version = encoded[0];
  registration->ciphersuite = encoded[1];
  memcpy(registration->key_id, encoded + 2, kClusterBlsKeyIdBytes);
  memcpy(registration->public_key, encoded + 2 + kClusterBlsKeyIdBytes,
         kOtBlsPublicKeyBytes);
  memcpy(registration->proof_of_possession,
         encoded + 2 + kClusterBlsKeyIdBytes + kOtBlsPublicKeyBytes,
         kOtBlsSignatureBytes);
  return cluster_bls_registration_verify(registration);
}

bool cluster_bls_certificate_request_encode(
    const cluster_bls_registration_t *registration, const uint8_t *tbs_der,
    size_t tbs_der_len, uint8_t *out, size_t *out_len) {
  size_t needed = kClusterBlsCertificateRequestHeaderBytes +
                  kClusterBlsRegistrationWireBytes + tbs_der_len;
  if (registration == NULL || tbs_der == NULL || out == NULL || out_len == NULL ||
      tbs_der_len == 0 || tbs_der_len > UINT16_MAX || *out_len < needed ||
      !cluster_bls_registration_encode(
          registration, out + kClusterBlsCertificateRequestHeaderBytes)) {
    return false;
  }
  out[0] = 'C';
  out[1] = 'B';
  out[2] = 'R';
  out[3] = '1';
  out[4] = kClusterBlsProtocolVersion;
  out[5] = (uint8_t)(tbs_der_len >> 8);
  out[6] = (uint8_t)tbs_der_len;
  memcpy(out + kClusterBlsCertificateRequestHeaderBytes +
             kClusterBlsRegistrationWireBytes,
         tbs_der, tbs_der_len);
  *out_len = needed;
  return true;
}

bool cluster_bls_certificate_request_decode(
    const uint8_t *encoded, size_t encoded_len,
    cluster_bls_registration_t *registration, const uint8_t **tbs_der,
    size_t *tbs_der_len) {
  const size_t tbs_offset = kClusterBlsCertificateRequestHeaderBytes +
                            kClusterBlsRegistrationWireBytes;
  size_t declared_tbs_len;
  if (encoded == NULL || registration == NULL || tbs_der == NULL ||
      tbs_der_len == NULL || encoded_len < tbs_offset || encoded[0] != 'C' ||
      encoded[1] != 'B' || encoded[2] != 'R' || encoded[3] != '1' ||
      encoded[4] != kClusterBlsProtocolVersion) {
    return false;
  }
  declared_tbs_len = ((size_t)encoded[5] << 8) | encoded[6];
  if (declared_tbs_len == 0 || encoded_len != tbs_offset + declared_tbs_len ||
      !cluster_bls_registration_decode(
          encoded + kClusterBlsCertificateRequestHeaderBytes, registration)) {
    return false;
  }
  *tbs_der = encoded + tbs_offset;
  *tbs_der_len = declared_tbs_len;
  return true;
}

static bool cluster_bls_der_length(const uint8_t **cursor, const uint8_t *end,
                                   size_t *length) {
  size_t count;
  size_t value = 0;
  uint8_t first;
  if (cursor == NULL || *cursor == NULL || end == NULL || length == NULL ||
      *cursor >= end) {
    return false;
  }
  first = *(*cursor)++;
  if ((first & 0x80) == 0) {
    value = first;
  } else {
    count = first & 0x7f;
    if (count == 0 || count > sizeof(size_t) ||
        (size_t)(end - *cursor) < count || (*cursor)[0] == 0) {
      return false;
    }
    for (size_t i = 0; i < count; ++i) {
      value = (value << 8) | *(*cursor)++;
    }
    if (value < 128) {
      return false;
    }
  }
  if (value > (size_t)(end - *cursor)) {
    return false;
  }
  *length = value;
  return true;
}

static bool cluster_bls_der_field(uint8_t expected_tag,
                                  const uint8_t **cursor,
                                  const uint8_t *end,
                                  const uint8_t **value,
                                  size_t *value_len) {
  if (cursor == NULL || *cursor == NULL || *cursor >= end ||
      *(*cursor)++ != expected_tag ||
      !cluster_bls_der_length(cursor, end, value_len)) {
    return false;
  }
  *value = *cursor;
  *cursor += *value_len;
  return true;
}

static bool cluster_bls_binding_at(const uint8_t *oid_tlv,
                                   const uint8_t *end,
                                   cluster_bls_registration_t *registration) {
  static const uint8_t kCiphersuite[] = CLUSTER_BLS_CIPHERSUITE_ID;
  const uint8_t *cursor = oid_tlv + 12;
  const uint8_t *binding_der;
  const uint8_t *binding;
  const uint8_t *binding_end;
  const uint8_t *field;
  size_t binding_der_len;
  size_t binding_len;
  size_t field_len;
  cluster_bls_registration_t decoded;

  if (!cluster_bls_der_field(0x04, &cursor, end, &binding_der,
                             &binding_der_len)) {
    return false;
  }
  cursor = binding_der;
  if (!cluster_bls_der_field(0x30, &cursor, binding_der + binding_der_len,
                             &binding, &binding_len) ||
      cursor != binding_der + binding_der_len) {
    return false;
  }
  memset(&decoded, 0, sizeof(decoded));
  cursor = binding;
  binding_end = binding + binding_len;
  if (!cluster_bls_der_field(0x02, &cursor, binding_end, &field, &field_len) ||
      field_len != 1) {
    return false;
  }
  decoded.protocol_version = field[0];
  if (!cluster_bls_der_field(0x0c, &cursor, binding_end, &field, &field_len) ||
      field_len != sizeof(kCiphersuite) - 1 ||
      memcmp(field, kCiphersuite, field_len) != 0) {
    return false;
  }
  decoded.ciphersuite = kClusterBlsCiphersuitePop;
  if (!cluster_bls_der_field(0x04, &cursor, binding_end, &field, &field_len) ||
      field_len != sizeof(decoded.key_id)) {
    return false;
  }
  memcpy(decoded.key_id, field, field_len);
  if (!cluster_bls_der_field(0x04, &cursor, binding_end, &field, &field_len) ||
      field_len != sizeof(decoded.public_key)) {
    return false;
  }
  memcpy(decoded.public_key, field, field_len);
  if (!cluster_bls_der_field(0x04, &cursor, binding_end, &field, &field_len) ||
      field_len != sizeof(decoded.proof_of_possession) ||
      cursor != binding_end) {
    return false;
  }
  memcpy(decoded.proof_of_possession, field, field_len);
  if (!cluster_bls_registration_verify(&decoded)) {
    return false;
  }
  *registration = decoded;
  return true;
}

bool cluster_bls_certificate_binding_decode(
    const uint8_t *tbs_der, size_t tbs_der_len,
    cluster_bls_registration_t *registration) {
  static const uint8_t kOidTlv[] = {
      0x06, 0x0a, 0x2b, 0x06, 0x01, 0x04,
      0x01, 0x83, 0xb2, 0x03, 0x01, 0x01,
  };
  cluster_bls_registration_t decoded;
  size_t matches = 0;

  if (tbs_der == NULL || registration == NULL ||
      tbs_der_len < sizeof(kOidTlv)) {
    return false;
  }
  for (size_t i = 0; i + sizeof(kOidTlv) <= tbs_der_len; ++i) {
    if (memcmp(tbs_der + i, kOidTlv, sizeof(kOidTlv)) == 0 &&
        cluster_bls_binding_at(tbs_der + i, tbs_der + tbs_der_len,
                               &decoded)) {
      if (++matches != 1) {
        return false;
      }
      *registration = decoded;
    }
  }
  return matches == 1;
}


bool cluster_bls_encode_challenge(const cluster_bls_challenge_t *challenge,
                                  uint8_t *out, size_t *out_len) {
  static const uint8_t kDomain[] = CLUSTER_BLS_CHALLENGE_DOMAIN;
  static const uint8_t kCiphersuite[] = CLUSTER_BLS_CIPHERSUITE_ID;
  size_t needed;
  uint8_t *cursor;

  if (challenge == NULL || out == NULL || out_len == NULL ||
      challenge->protocol_version != kClusterBlsProtocolVersion ||
      challenge->ciphersuite != kClusterBlsCiphersuitePop ||
      challenge->cluster_id_len == 0 ||
      challenge->cluster_id_len > kClusterBlsMaxClusterIdBytes ||
      sizeof(kCiphersuite) - 1 > UINT8_MAX) {
    return false;
  }
  needed = (sizeof(kDomain) - 1) + 1 + 1 + (sizeof(kCiphersuite) - 1) +
           1 + challenge->cluster_id_len + 8 + kClusterBlsNonceBytes +
           kClusterBlsDigestBytes + kClusterBlsDigestBytes;
  if (*out_len < needed) {
    return false;
  }
  cursor = out;
  memcpy(cursor, kDomain, sizeof(kDomain) - 1);
  cursor += sizeof(kDomain) - 1;
  *cursor++ = challenge->protocol_version;
  *cursor++ = (uint8_t)(sizeof(kCiphersuite) - 1);
  memcpy(cursor, kCiphersuite, sizeof(kCiphersuite) - 1);
  cursor += sizeof(kCiphersuite) - 1;
  *cursor++ = challenge->cluster_id_len;
  memcpy(cursor, challenge->cluster_id, challenge->cluster_id_len);
  cursor += challenge->cluster_id_len;
  put_u64_be(cursor, challenge->epoch);
  cursor += 8;
  memcpy(cursor, challenge->nonce, kClusterBlsNonceBytes);
  cursor += kClusterBlsNonceBytes;
  memcpy(cursor, challenge->measurement_digest, kClusterBlsDigestBytes);
  cursor += kClusterBlsDigestBytes;
  memcpy(cursor, challenge->member_list_digest, kClusterBlsDigestBytes);
  cursor += kClusterBlsDigestBytes;
  *out_len = (size_t)(cursor - out);
  return true;
}

bool cluster_bls_sign_challenge(
    const cluster_bls_signer_t *signer,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    uint8_t signature[kOtBlsSignatureBytes]) {
  if (signer == NULL || challenge_digest == NULL || signature == NULL ||
      !signer->initialized) {
    return false;
  }
  return ot_bls_pop_sign(signer->secret_key, challenge_digest,
                         kClusterBlsDigestBytes, signature);
}

bool cluster_bls_aggregate(const uint8_t *signatures, size_t signature_count,
                           uint8_t aggregate_signature[kOtBlsSignatureBytes]) {
  return ot_bls_aggregate_signatures(signatures, signature_count,
                                     aggregate_signature);
}

bool cluster_bls_verify_aggregate(
    const uint8_t *public_keys, size_t public_key_count,
    const uint8_t challenge_digest[kClusterBlsDigestBytes],
    const uint8_t aggregate_signature[kOtBlsSignatureBytes]) {
  if (challenge_digest == NULL) {
    return false;
  }
  return ot_bls_fast_aggregate_verify(public_keys, public_key_count,
                                      challenge_digest,
                                      kClusterBlsDigestBytes,
                                      aggregate_signature);
}
