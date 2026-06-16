// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#ifndef SECURITY_UTIL_LITE_SHA256_H__
#define SECURITY_UTIL_LITE_SHA256_H__

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

struct HASH_CTX;  // forward decl

typedef struct HASH_VTAB {
  void (* const init)(struct HASH_CTX*);
  void (* const update)(struct HASH_CTX*, const void*, size_t);
  const uint8_t* (* const final)(struct HASH_CTX*);
  const uint8_t* (* const hash)(const void*, size_t, uint8_t*);
  unsigned int size;
} HASH_VTAB;

typedef struct HASH_CTX {
  const HASH_VTAB * f;
  uint64_t count;
#ifndef SHA512_SUPPORT
  uint8_t buf[64];
  uint32_t state[8];  // upto SHA2-256
#else
  uint8_t buf[128];
  uint64_t state[8];  // upto SHA2-512
#endif
} HASH_CTX;

typedef HASH_CTX LITE_SHA256_CTX;

void SHA256_init(LITE_SHA256_CTX* ctx);
void SHA256_update(LITE_SHA256_CTX* ctx, const void* data, size_t len);
const uint8_t* SHA256_final(LITE_SHA256_CTX* ctx);

// Convenience method. Returns digest address.
const uint8_t* SHA256_hash(const void* data, size_t len, uint8_t* digest);

#define SHA256_DIGEST_SIZE 32

#ifdef __cplusplus
}
#endif // __cplusplus

#endif  // SECURITY_UTIL_LITE_SHA256_H__
