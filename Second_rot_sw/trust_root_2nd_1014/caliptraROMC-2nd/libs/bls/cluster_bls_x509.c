#include "cluster_bls_x509.h"

#include <string.h>

enum {
  kDerSequence = 0x30,
  kDerInteger = 0x02,
  kDerOctetString = 0x04,
  kDerUtf8String = 0x0c,
  kDerObjectId = 0x06,
  kDerContextExtensions = 0xa3,
  /* 4KiB input TBS plus the ~230-byte PoP extension and DER growth. */
  kClusterBlsMaxTbsBytes = 4608,
};

static const uint8_t kClusterBlsOid[] = {
    0x2b, 0x06, 0x01, 0x04, 0x01, 0x83, 0xb2, 0x03, 0x01, 0x01,
};
static const uint8_t kCiphersuite[] = CLUSTER_BLS_CIPHERSUITE_ID;

static bool der_read_length(const uint8_t *data, size_t available,
                            size_t *length, size_t *length_len) {
  uint8_t first;
  size_t count;
  size_t value = 0;
  if (data == NULL || length == NULL || length_len == NULL || available == 0) {
    return false;
  }
  first = data[0];
  if ((first & 0x80) == 0) {
    *length = first;
    *length_len = 1;
    return *length <= available - 1;
  }
  count = first & 0x7f;
  if (count == 0 || count > sizeof(size_t) || available < count + 1 ||
      data[1] == 0) {
    return false;
  }
  for (size_t i = 0; i < count; ++i) {
    value = (value << 8) | data[1 + i];
  }
  if (value < 128 || value > available - count - 1) {
    return false;
  }
  *length = value;
  *length_len = count + 1;
  return true;
}

static bool der_tlv(const uint8_t *data, size_t available, uint8_t *tag,
                    const uint8_t **value, size_t *value_len,
                    size_t *encoded_len) {
  size_t length_len;
  if (data == NULL || available < 2 || tag == NULL || value == NULL ||
      value_len == NULL || encoded_len == NULL ||
      !der_read_length(data + 1, available - 1, value_len, &length_len)) {
    return false;
  }
  *tag = data[0];
  *value = data + 1 + length_len;
  *encoded_len = 1 + length_len + *value_len;
  return true;
}

static size_t der_length_size(size_t length) {
  if (length < 128) return 1;
  if (length <= 0xff) return 2;
  if (length <= 0xffff) return 3;
  return 0;
}

static bool der_write_length(uint8_t **cursor, uint8_t *end, size_t length) {
  size_t count;
  if (cursor == NULL || *cursor == NULL || end == NULL ||
      (size_t)(end - *cursor) < der_length_size(length) ||
      der_length_size(length) == 0) {
    return false;
  }
  if (length < 128) {
    *(*cursor)++ = (uint8_t)length;
    return true;
  }
  count = length <= 0xff ? 1 : 2;
  *(*cursor)++ = (uint8_t)(0x80 | count);
  for (size_t i = 0; i < count; ++i) {
    *(*cursor)++ = (uint8_t)(length >> (8 * (count - 1 - i)));
  }
  return true;
}

static bool der_write_tlv(uint8_t **cursor, uint8_t *end, uint8_t tag,
                          const uint8_t *value, size_t value_len) {
  size_t header_len = 1 + der_length_size(value_len);
  if (cursor == NULL || *cursor == NULL || end == NULL || value == NULL ||
      header_len == 1 || (size_t)(end - *cursor) < header_len + value_len) {
    return false;
  }
  *(*cursor)++ = tag;
  if (!der_write_length(cursor, end, value_len)) return false;
  memcpy(*cursor, value, value_len);
  *cursor += value_len;
  return true;
}

static bool extension_list_has_cluster_bls_oid(const uint8_t *extensions,
                                               size_t extensions_len) {
  size_t offset = 0;
  while (offset < extensions_len) {
    uint8_t tag;
    const uint8_t *entry;
    const uint8_t *entry_value;
    size_t entry_len;
    size_t entry_tlv_len;
    const uint8_t *oid;
    size_t oid_len;
    size_t oid_tlv_len;
    if (!der_tlv(extensions + offset, extensions_len - offset, &tag, &entry_value,
                 &entry_len, &entry_tlv_len) || tag != kDerSequence ||
        !der_tlv(entry_value, entry_len, &tag, &oid, &oid_len, &oid_tlv_len) ||
        tag != kDerObjectId) {
      return true;  /* malformed extensions fail closed */
    }
    entry = extensions + offset;
    (void)entry;
    if (oid_len == sizeof(kClusterBlsOid) &&
        memcmp(oid, kClusterBlsOid, sizeof(kClusterBlsOid)) == 0) {
      return true;
    }
    offset += entry_tlv_len;
  }
  return offset != extensions_len;
}

bool cluster_bls_x509_append_binding(
    const uint8_t *tbs_der, size_t tbs_der_len,
    const cluster_bls_registration_t *registration, uint8_t *out,
    size_t *out_len) {
  uint8_t tag;
  const uint8_t *tbs_content;
  size_t tbs_content_len;
  size_t tbs_tlv_len;
  size_t offset = 0;
  size_t extension_field_offset = 0;
  size_t extension_field_tlv_len = 0;
  const uint8_t *existing_extensions;
  size_t existing_extensions_len;
  size_t existing_extensions_tlv_len;
  uint8_t binding_fields[256];
  uint8_t binding[256];
  uint8_t extension_contents[512];
  uint8_t extension[512];
  uint8_t version = kClusterBlsProtocolVersion;
  uint8_t *cursor;
  size_t out_capacity;
  size_t binding_fields_len;
  size_t binding_len;
  size_t extension_contents_len;
  size_t extension_len;
  size_t new_extensions_len;
  size_t new_wrapper_len;
  size_t new_content_len;
  size_t new_tbs_len;
  uint8_t *rebuild_cursor;
  uint8_t *rebuild_end;

  if (tbs_der == NULL || registration == NULL || out == NULL || out_len == NULL ||
      !cluster_bls_registration_verify(registration) ||
      !der_tlv(tbs_der, tbs_der_len, &tag, &tbs_content, &tbs_content_len,
               &tbs_tlv_len) || tag != kDerSequence || tbs_tlv_len != tbs_der_len) {
    return false;
  }
  out_capacity = *out_len;
  while (offset < tbs_content_len) {
    const uint8_t *field_value;
    size_t field_len;
    size_t field_tlv_len;
    if (!der_tlv(tbs_content + offset, tbs_content_len - offset, &tag,
                 &field_value, &field_len, &field_tlv_len)) return false;
    if (tag == kDerContextExtensions) {
      if (extension_field_tlv_len != 0 ||
          !der_tlv(field_value, field_len, &tag, &existing_extensions,
                   &existing_extensions_len, &existing_extensions_tlv_len) ||
          tag != kDerSequence || existing_extensions_tlv_len != field_len ||
          extension_list_has_cluster_bls_oid(existing_extensions,
                                             existing_extensions_len)) {
        return false;
      }
      extension_field_offset = offset;
      extension_field_tlv_len = field_tlv_len;
    }
    offset += field_tlv_len;
  }
  if (extension_field_tlv_len == 0 || offset != tbs_content_len) return false;

  cursor = binding_fields;
  if (!der_write_tlv(&cursor, binding_fields + sizeof(binding_fields), kDerInteger,
                     &version, 1) ||
      !der_write_tlv(&cursor, binding_fields + sizeof(binding_fields),
                     kDerUtf8String, kCiphersuite, sizeof(kCiphersuite) - 1) ||
      !der_write_tlv(&cursor, binding_fields + sizeof(binding_fields),
                     kDerOctetString, registration->key_id,
                     kClusterBlsKeyIdBytes) ||
      !der_write_tlv(&cursor, binding_fields + sizeof(binding_fields),
                     kDerOctetString, registration->public_key,
                     kOtBlsPublicKeyBytes) ||
      !der_write_tlv(&cursor, binding_fields + sizeof(binding_fields),
                     kDerOctetString, registration->proof_of_possession,
                     kOtBlsSignatureBytes)) return false;
  binding_fields_len = (size_t)(cursor - binding_fields);
  cursor = binding;
  if (!der_write_tlv(&cursor, binding + sizeof(binding), kDerSequence,
                     binding_fields, binding_fields_len)) return false;
  binding_len = (size_t)(cursor - binding);

  cursor = extension_contents;
  if (!der_write_tlv(&cursor, extension_contents + sizeof(extension_contents),
                     kDerObjectId, kClusterBlsOid, sizeof(kClusterBlsOid)) ||
      !der_write_tlv(&cursor, extension_contents + sizeof(extension_contents),
                     kDerOctetString, binding, binding_len)) return false;
  extension_contents_len = (size_t)(cursor - extension_contents);
  cursor = extension;
  if (!der_write_tlv(&cursor, extension + sizeof(extension), kDerSequence,
                     extension_contents, extension_contents_len)) return false;
  extension_len = (size_t)(cursor - extension);

  new_extensions_len = existing_extensions_len + extension_len;
  new_wrapper_len = 1 + der_length_size(new_extensions_len) + new_extensions_len;
  new_content_len = tbs_content_len - extension_field_tlv_len +
                    1 + der_length_size(new_wrapper_len) + new_wrapper_len;
  new_tbs_len = 1 + der_length_size(new_content_len) + new_content_len;
  if (new_wrapper_len == 1 || new_tbs_len == 1 ||
      new_tbs_len > kClusterBlsMaxTbsBytes || new_tbs_len > out_capacity)
    return false;

  rebuild_cursor = out;
  rebuild_end = out + out_capacity;
  *rebuild_cursor++ = kDerSequence;
  if (!der_write_length(&rebuild_cursor, rebuild_end, new_content_len)) return false;
  memcpy(rebuild_cursor, tbs_content, extension_field_offset);
  rebuild_cursor += extension_field_offset;
  *rebuild_cursor++ = kDerContextExtensions;
  if (!der_write_length(&rebuild_cursor, rebuild_end, new_wrapper_len)) return false;
  *rebuild_cursor++ = kDerSequence;
  if (!der_write_length(&rebuild_cursor, rebuild_end, new_extensions_len)) return false;
  memcpy(rebuild_cursor, existing_extensions, existing_extensions_len);
  rebuild_cursor += existing_extensions_len;
  memcpy(rebuild_cursor, extension, extension_len);
  rebuild_cursor += extension_len;
  memcpy(rebuild_cursor, tbs_content + extension_field_offset + extension_field_tlv_len,
         tbs_content_len - extension_field_offset - extension_field_tlv_len);
  rebuild_cursor += tbs_content_len - extension_field_offset - extension_field_tlv_len;
  if ((size_t)(rebuild_cursor - out) != new_tbs_len) return false;
  *out_len = new_tbs_len;
  return true;
}
