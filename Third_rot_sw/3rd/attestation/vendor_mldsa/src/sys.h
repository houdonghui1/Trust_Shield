#ifndef MLD_SYS_H
#define MLD_SYS_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#define mld_memcpy memcpy
#define mld_memset memset

#define mld_malloc(sz) NULL
#define mld_free(p) ((void)p)

#endif // MLD_SYS_H
