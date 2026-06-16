// SPDX-License-Identifier: Apache-2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifndef TRNG_H
  #define TRNG_H
  
#include "caliptra_defines.h"
#include "caliptra_reg.h"
#include "riscv_hw_if.h"

void enable_csrng();

int run_entropy_source_seed_test();

int run_smoke_test();

int generate_random_numbers(int num_randoms, uint8_t *output);
#endif
