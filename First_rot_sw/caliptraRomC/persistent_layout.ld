_cert_store_start = 0x5001DE00;
_cert_store_end = 0x5001EE20;

_tbs_der_store_start = 0x5001EE40;
_tbs_der_store_end = 0x5001FE60;

_cluster_bls_state_start = 0x5001FF00;
_cluster_bls_state_end = 0x50020000;

.cert_store _cert_store_start (NOLOAD) : {
    KEEP(*(.cert_store))
    . = ALIGN(4);
} > DCCM

.tbs_der_store _tbs_der_store_start (NOLOAD) : {
    KEEP(*(.tbs_der_store))
    . = ALIGN(4);
} > DCCM

.cluster_bls_state _cluster_bls_state_start (NOLOAD) : {
    KEEP(*(.cluster_bls_state))
    . = ALIGN(4);
} > DCCM

ASSERT(ADDR(.cert_store) == _cert_store_start,
       "ERROR: certificate store address does not match the shared ABI")
ASSERT(SIZEOF(.cert_store) == 0x1020,
       "ERROR: certificate store size does not match the shared ABI")
ASSERT(ADDR(.tbs_der_store) == _tbs_der_store_start,
       "ERROR: TBS store address does not match the shared ABI")
ASSERT(SIZEOF(.tbs_der_store) == 0x1020,
       "ERROR: TBS store size does not match the shared ABI")
ASSERT(SIZEOF(.cluster_bls_state) <=
       (_cluster_bls_state_end - _cluster_bls_state_start),
       "ERROR: persistent BLS state exceeds its reserved DCCM range")
