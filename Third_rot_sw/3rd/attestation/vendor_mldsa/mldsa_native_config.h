#ifndef MLDSA_NATIVE_CONFIG_H
#define MLDSA_NATIVE_CONFIG_H

#define MLD_INLINE inline
#define MLD_ALWAYS_INLINE __attribute__((always_inline)) inline
#define MLD_CONFIG_NO_INLINE_ASM 1
#define MLD_SYS_RISCV32 1

#define MLD_ALIGN __attribute__((aligned(4)))
#define MLD_MUST_CHECK_RETURN_VALUE __attribute__((warn_unused_result))
#define MLD_RESTRICT restrict
#define MLD_STATIC_TESTABLE static
#define MLD_CET_ENDBR

#define MLD_CT_TESTING_DECLASSIFY(ptr, len)  do { (void)ptr; (void)len; } while(0)
#define MLD_CT_TESTING_SECRET(ptr, len)      do { (void)ptr; (void)len; } while(0)

#define MLD_CONFIG_PARAMETER_SET 87
#undef MLD_CONFIG_USE_NATIVE_BACKEND_ARITH
#undef MLD_CONFIG_USE_NATIVE_BACKEND_FIPS202
#define MLD_CONFIG_SERIAL_FIPS202 1
#define MLD_CONFIG_REDUCE_RAM 1
#undef MLD_CONFIG_DEBUG
#undef CBMC
#define MLD_CONFIG_NO_STDLIB_MALLOC 1
#define MLD_CONFIG_LITTLE_ENDIAN 1
#define MLD_CONFIG_CUSTOM_ZEROIZE 1

#define MLD_CONFIG_MONOBUILD_KEEP_SHARED_HEADERS 1
#undef MLD_CONFIG_MULTILEVEL_BUILD

#endif // MLDSA_NATIVE_CONFIG_H
