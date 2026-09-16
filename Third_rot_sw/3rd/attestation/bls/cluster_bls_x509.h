#ifndef CLUSTER_BLS_X509_H_
#define CLUSTER_BLS_X509_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "cluster_bls_protocol.h"

/* Append the non-critical cluster-BLS binding to an existing v3 TBS DER. */
bool cluster_bls_x509_append_binding(
    const uint8_t *tbs_der, size_t tbs_der_len,
    const cluster_bls_registration_t *registration, uint8_t *out,
    size_t *out_len);

#endif  /* CLUSTER_BLS_X509_H_ */
