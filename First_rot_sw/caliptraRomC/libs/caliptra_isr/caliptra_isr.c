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
#include "caliptra_isr.h"
#include "caliptra_defines.h"
//#include <string.h>
#include "riscv-csr.h"
#include "veer-csr.h"
#include "riscv-interrupts.h"
#include "printf.h"
#include "riscv_hw_if.h"

#ifndef MIP_MEIP
#define MIP_MEIP (1 << 11)
#endif

#ifndef MIP_MTIP
#define MIP_MTIP (1 << 7)
#endif

extern volatile uint32_t intr_count;
#ifdef RV_EXCEPTION_STRUCT
extern volatile rv_exception_struct_s exc_flag;
#endif

//////////////////////////////////////////////////////////////////////////////
// Function Declarations
//

// Initial ISR for first redirection following an external intr trap (pointed to by mtvec)
// Machine mode interrupt service routine
// Force the alignment for mtvec.BASE.
static void std_rv_isr(void) __attribute__ ((interrupt ("machine"), aligned(4)));

void std_rv_mtvec_exception(void) __attribute__ ((interrupt ("machine"), aligned(4)));

// Nop handlers for unimplemented events "Software" and "Timer" Interrupts
// "External Interrupts" are also included in this unimplemented list, just because the
// std_rv_isr_vector_table should never reroute to External Interrupts -- Fast
// Redirect takes care of that separately
void std_rv_nop_machine(void)     __attribute__ ((interrupt ("machine") , aligned(4)));
void std_rv_mtvec_mei(void)       __attribute__ ((interrupt ("machine") , aligned(4) , weak, alias("std_rv_nop_machine") ));
void std_rv_mtvec_msi(void)       __attribute__ ((interrupt ("machine") , aligned(4) , weak, alias("std_rv_nop_machine") ));
void std_rv_mtvec_mti(void)       __attribute__ ((interrupt ("machine") , aligned(4) ));
void std_rv_mtvec_sei(void)       __attribute__ ((interrupt ("machine") , aligned(4) , weak, alias("std_rv_nop_machine") ));
void std_rv_mtvec_ssi(void)       __attribute__ ((interrupt ("machine") , aligned(4) , weak, alias("std_rv_nop_machine") ));
void std_rv_mtvec_sti(void)       __attribute__ ((interrupt ("machine") , aligned(4) , weak, alias("std_rv_nop_machine") ));
void nonstd_veer_mtvec_miti0(void)__attribute__ ((interrupt ("machine") , aligned(4) ));
void nonstd_veer_mtvec_mcei(void) __attribute__ ((interrupt ("machine") , aligned(4) ));


// VeeR Per-Source Vectored ISR functions
static void nonstd_veer_isr_doe_error     (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_doe_notif     (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_ecc_error     (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_ecc_notif     (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_hmac_error    (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_hmac_notif    (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_kv_error      (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_kv_notif      (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_sha512_error  (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_sha512_notif  (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_sha256_error  (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_sha256_notif  (void) __attribute__ ((interrupt ("machine")));
//static void nonstd_veer_isr_qspi_error    (void) __attribute__ ((interrupt ("machine")));
//static void nonstd_veer_isr_qspi_notif    (void) __attribute__ ((interrupt ("machine")));
//static void nonstd_veer_isr_uart_error    (void) __attribute__ ((interrupt ("machine")));
//static void nonstd_veer_isr_uart_notif    (void) __attribute__ ((interrupt ("machine")));
//static void nonstd_veer_isr_i3c_error     (void) __attribute__ ((interrupt ("machine")));
//static void nonstd_veer_isr_i3c_notif     (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_soc_ifc_error (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_soc_ifc_notif (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_sha512_acc_error (void) __attribute__ ((interrupt ("machine")));
static void nonstd_veer_isr_sha512_acc_notif (void) __attribute__ ((interrupt ("machine")));

// Could be much more fancy with C preprocessing to pair up the ISR with Vector
// numbers as defined in caliptra_defines.h.... TODO
static void          nonstd_veer_isr_0   (void) __attribute__ ((interrupt ("machine"))); // Empty function instead of function pointer for Vec 0
static void (* const nonstd_veer_isr_1 ) (void) = nonstd_veer_isr_doe_error   ;    // -------.
static void (* const nonstd_veer_isr_2 ) (void) = nonstd_veer_isr_doe_notif   ;    //        |
static void (* const nonstd_veer_isr_3 ) (void) = nonstd_veer_isr_ecc_error   ;    //        |
static void (* const nonstd_veer_isr_4 ) (void) = nonstd_veer_isr_ecc_notif   ;    //        |
static void (* const nonstd_veer_isr_5 ) (void) = nonstd_veer_isr_hmac_error  ;    //        |
static void (* const nonstd_veer_isr_6 ) (void) = nonstd_veer_isr_hmac_notif  ;    //        |
static void (* const nonstd_veer_isr_7 ) (void) = nonstd_veer_isr_kv_error    ;    //        |
static void (* const nonstd_veer_isr_8 ) (void) = nonstd_veer_isr_kv_notif    ;    //        |
static void (* const nonstd_veer_isr_9 ) (void) = nonstd_veer_isr_sha512_error;    // Definitions come
static void (* const nonstd_veer_isr_10) (void) = nonstd_veer_isr_sha512_notif;    // from the param'd
static void (* const nonstd_veer_isr_11) (void) = nonstd_veer_isr_sha256_error;    // macro "nonstd_veer_isr"
static void (* const nonstd_veer_isr_12) (void) = nonstd_veer_isr_sha256_notif;    // below
static void (* const nonstd_veer_isr_13) (void) = std_rv_nop_machine          ;    //        |    nonstd_veer_isr_qspi_error ---.
static void (* const nonstd_veer_isr_14) (void) = std_rv_nop_machine          ;    //        |    nonstd_veer_isr_qspi_notif    |
static void (* const nonstd_veer_isr_15) (void) = std_rv_nop_machine          ;    //        |    nonstd_veer_isr_uart_error    | Unimplemented to
static void (* const nonstd_veer_isr_16) (void) = std_rv_nop_machine          ;    //        |    nonstd_veer_isr_uart_notif    | save code space
static void (* const nonstd_veer_isr_17) (void) = std_rv_nop_machine          ;    //        |    nonstd_veer_isr_i3c_error     |
static void (* const nonstd_veer_isr_18) (void) = std_rv_nop_machine          ;    //        |    nonstd_veer_isr_i3c_notif  ---'
static void (* const nonstd_veer_isr_19) (void) = nonstd_veer_isr_soc_ifc_error;   //        |
static void (* const nonstd_veer_isr_20) (void) = nonstd_veer_isr_soc_ifc_notif;   //        |
static void (* const nonstd_veer_isr_21) (void) = nonstd_veer_isr_sha512_acc_error;//        |
static void (* const nonstd_veer_isr_22) (void) = nonstd_veer_isr_sha512_acc_notif;// -------'
static void (* const nonstd_veer_isr_23) (void) = std_rv_nop_machine; // --------|
static void (* const nonstd_veer_isr_24) (void) = std_rv_nop_machine; //         |
static void (* const nonstd_veer_isr_25) (void) = std_rv_nop_machine; //         |
static void (* const nonstd_veer_isr_26) (void) = std_rv_nop_machine; // Unimplemented ISR
static void (* const nonstd_veer_isr_27) (void) = std_rv_nop_machine; //         |
static void (* const nonstd_veer_isr_28) (void) = std_rv_nop_machine; //         |
static void (* const nonstd_veer_isr_29) (void) = std_rv_nop_machine; //         |
static void (* const nonstd_veer_isr_30) (void) = std_rv_nop_machine; //         |
static void (* const nonstd_veer_isr_31) (void) = std_rv_nop_machine; // --------'

// Table defines the VeeR non-standard vectored entries as an array of
// function pointers.
// The entries in this table are entered depending on the Ext. Interrupt ID
// E.g., Interrupt ID 2 routes to the ISR defined at offset 2*4 of this table
//       Interrupt ID 0 is (by definition) not assigned, and routes to an empty ISR
// Note that each function pointer (i.e. each entry in the vector table) must
// be 4-byte aligned per the VeeR PRM, and the base address of the table (i.e.
// the value of meivt) must be 1024-byte aligned, also per the PRM
// For support of Fast Interrupt Redirect feature, this should be in DCCM
static void (* __attribute__ ((aligned(4))) nonstd_veer_isr_vector_table [RV_PIC_TOTAL_INT_PLUS1]) (void) __attribute__ ((aligned(1024),section (".dccm.nonstd_isr.vec_table"))) = {
    nonstd_veer_isr_0,
    nonstd_veer_isr_1,
    nonstd_veer_isr_2,
    nonstd_veer_isr_3,
    nonstd_veer_isr_4,
    nonstd_veer_isr_5,
    nonstd_veer_isr_6,
    nonstd_veer_isr_7,
    nonstd_veer_isr_8,
    nonstd_veer_isr_9,
    nonstd_veer_isr_10,
    nonstd_veer_isr_11,
    nonstd_veer_isr_12,
    nonstd_veer_isr_13,
    nonstd_veer_isr_14,
    nonstd_veer_isr_15,
    nonstd_veer_isr_16,
    nonstd_veer_isr_17,
    nonstd_veer_isr_18,
    nonstd_veer_isr_19,
    nonstd_veer_isr_20,
    nonstd_veer_isr_21,
    nonstd_veer_isr_22,
    nonstd_veer_isr_23,
    nonstd_veer_isr_24,
    nonstd_veer_isr_25,
    nonstd_veer_isr_26,
    nonstd_veer_isr_27,
    nonstd_veer_isr_28,
    nonstd_veer_isr_29,
    nonstd_veer_isr_30,
    nonstd_veer_isr_31
};

// Table defines the RV standard vectored entries pointed to by mtvec
// The entries in this table are entered depending on mcause
// I.e. Exceptions and External Interrupts route to entries of this table
// This table is only consulted when MTVEC[1:0] indicates a vectored mode
static void std_rv_isr_vector_table(void) __attribute__ ((naked));

// TODO args to control per-component enables
void init_interrupts(void) {
    volatile uint32_t * const mpiccfg = (uint32_t*) VEER_MM_PIC_MPICCFG;
    volatile uint32_t * const meigwctrls = (uint32_t*) VEER_MM_PIC_MEIGWCTRLS;
    volatile uint32_t * const meigwclrs = (uint32_t*) VEER_MM_PIC_MEIGWCLRS;
    volatile uint32_t * const mtimecmp_l = (uint32_t*) CLP_SOC_IFC_REG_INTERNAL_RV_MTIMECMP_L;
    volatile uint32_t * const mtimecmp_h = (uint32_t*) CLP_SOC_IFC_REG_INTERNAL_RV_MTIMECMP_H;

    csr_clr_bits_mstatus(MSTATUS_MIE_BIT_MASK);

    csr_write_mtvec((uint_xlen_t) std_rv_isr_vector_table | 1);
    //printf("MTVEC set to: 0x%08x\n", csr_read_mtvec());

    __asm__ volatile ("la t0, %0; csrw %1, t0" :: "i" (&nonstd_veer_isr_vector_table), "i" (VEER_CSR_MEIVT) : "t0");
    uint_xlen_t meivt;
    __asm__ volatile ("csrr %0, %1" : "=r" (meivt) : "i" (VEER_CSR_MEIVT));
    //printf("MEIVT set to: 0x%08x\n", meivt);

    *mpiccfg = 0x0;
    __asm__ volatile ("fence");

    for (uint8_t vec = 1; vec <= RV_PIC_TOTAL_INT; vec++) {
        meigwctrls[vec] = 0;
        meigwclrs[vec] = 0;
        __asm__ volatile ("fence");
    }

    *mtimecmp_l = 0xFFFFFFFF;
    *mtimecmp_h = 0xFFFFFFFF;
    csr_clr_bits_mie(MIE_MTI_BIT_MASK);

    uint_xlen_t mip = csr_read_mip();
    //printf("Pending interrupts (MIP): 0x%08x\n", (uint32_t)mip);
    if (mip & (MIP_MEIP | MIP_MTIP)) {
        //printf("Clearing pending interrupts (MIP=0x%08x)\n", mip);
        
        if (mip & MIP_MTIP) {
            *mtimecmp_l = 0xFFFFFFFF;
            *mtimecmp_h = 0xFFFFFFFF;
            csr_clr_bits_mie(MIE_MTI_BIT_MASK);
        }
        
        if (mip & MIP_MEIP) {
            for (uint8_t vec = 1; vec <= RV_PIC_TOTAL_INT; vec++) {
                meigwclrs[vec] = 0;
                __asm__ volatile ("fence");
            }
        }
        
        mip = csr_read_mip();
        //printf("MIP after clear: 0x%08x\n", mip);
    }

    for (uint8_t vec = 1; vec <= VEER_INTR_VEC_MAX_ASSIGNED; vec++) {
        meigwctrls[vec] = VEER_MEIGWCTRL_ACTIVE_HI_LEVEL;
        __asm__ volatile ("fence");
    }

    __asm__ volatile ("csrw %0, %1" :: "i" (VEER_CSR_MEICIDPL), "i" (0));
    __asm__ volatile ("csrw %0, %1" :: "i" (VEER_CSR_MEICURPL), "i" (0));

    csr_set_bits_mie(MIE_MEI_BIT_MASK | MIE_MCEI_BIT_MASK);
    //printf("MIE set to: 0x%08x\n", csr_read_mie());

    csr_set_bits_mstatus(MSTATUS_MIE_BIT_MASK);
    //printf("Global interrupts enabled (MSTATUS=0x%08x)\n", csr_read_mstatus());
}

void std_rv_nop_machine(void)  {
    // Nop machine mode interrupt.
     //printf("mcause:%ld\n", csr_read_mcause());
    return;
}

void std_rv_mtvec_mti(void) {
    volatile uint32_t * const mtimecmp_l     = (uint32_t*) CLP_SOC_IFC_REG_INTERNAL_RV_MTIMECMP_L;
    volatile uint32_t * const mtimecmp_h     = (uint32_t*) CLP_SOC_IFC_REG_INTERNAL_RV_MTIMECMP_H;

    // Set mtimecmp to max value to avoid further timer interrupts
    *mtimecmp_l = 0xFFFFFFFF;
    *mtimecmp_h = 0xFFFFFFFF;

    //printf( "Done handling machine-mode TIMER interrupt\n");
}

void nonstd_veer_mtvec_miti0(void) {
    //uint_xlen_t value;
    //Disable internal timer 0 count en to service intr
    __asm__ volatile ("csrwi %0, %1" \
                      : /* output : none */ \
                      : "i" (0x7d4), "i" (0x00) /* input : immediate */ \
                      : /* clobbers : none */);

}

void nonstd_veer_mtvec_mcei(void) {
    uint32_t mask = 0x07FFFFFF;
     //printf("Cor Error Local ISR\n");
    __asm__ volatile ("csrc    %0, %1"
                      : /* output: none */
                      : "i" (VEER_CSR_MICECT),   "r" (mask) /* input : immediate, register */
                      : /* clobbers: none */);
    __asm__ volatile ("csrc    %0, %1"
                      : /* output: none */
                      : "i" (VEER_CSR_MICCMECT), "r" (mask) /* input : immediate, register */
                      : /* clobbers: none */);
    __asm__ volatile ("csrc    %0, %1"
                      : /* output: none */
                      : "i" (VEER_CSR_MDCCMECT), "r" (mask) /* input : immediate, register */
                      : /* clobbers: none */);
}

static void __attribute__((unused)) std_rv_isr(void) {
    void (* isr) (void); // Function pointer to source-specific ISR
    uint_xlen_t this_cause = csr_read_mcause();
    ////printf("In:Std ISR\nmcause:%x\n", this_cause);
    if (this_cause &  MCAUSE_INTERRUPT_BIT_MASK) {
        this_cause &= 0xFF;
        // Known exceptions
        switch (this_cause) {
        case RISCV_INT_MASK_MTI :
            // Timer exception, keep up the one second tick.
            //mtimer_set_raw_time_cmp(MTIMER_SECONDS_TO_CLOCKS(1));
            //timestamp = mtimer_get_raw_time();
            break;
        case RISCV_INT_MASK_MEI :
            // Read MIP register - should have MEIP set
            // Read MEIPX register - should != 0
            //uint32_t * const meipx      = (uint32_t*) VEER_MM_PIC_MEIPX;      // FIXME
            // External Interrupt, branch to the VeeR handler
            // (TODO) in a loop until all interrupts at current priority level
            // are handled (aka Interrupt Chaining is supported)
            //   * NOTE: incompatible with Fast Redirect
            do {
                // Capture the priority and ID
                __asm__ volatile ("csrwi    %0, 0" \
                                  : /* output: none */        \
                                  : "i" (VEER_CSR_MEICPCT) /* input : immediate */ \
                                  : /* clobbers: none */);
                // Look up the handler address in MEIHAP
                __asm__ volatile ("csrr    %0, %1"
                                  : "=r" (isr)  /* output : register */
                                  : "i" (VEER_CSR_MEIHAP) /* input : immediate */
                                  : /* clobbers: none */);
                // Call the ID-specific handler
                isr(); // ISR here is a function pointer indexed into the meivt table
                    // For Interrupt NESTING support, the handler should:
                    //  * Save meicurpl
                    //  * Read meicidpl
                    //  * Set current Priority in meicurpl
                    //  * enable mstatus.mei
                    //  * Restore meicurpl prev. value
                    //  * disable mstatus.mei
                // Re-read MIP.MEIP
                // Check MIE.MEIE
                // Re-read MEIPX
                // Check MEIES
            } while (0); // FIXME
            break;
        }
    } else {
        switch (this_cause) {
        case RISCV_EXCP_LOAD_ACCESS_FAULT :
            // mscause
            __asm__ volatile ("csrr    %0, %1"
                              : "=r" (this_cause)  /* output : register */
                              : "i" (VEER_CSR_MSCAUSE) /* input : immediate */
                              : /* clobbers: none */);
            //printf("mscause:%x\n",this_cause);
            // mepc
            this_cause = csr_read_mepc();
            //printf("mepc:%x\n",this_cause);
            // mtval
            this_cause = csr_read_mtval();
            //printf("mtval:%x\n",this_cause);
            break;
        }
    }
    return;
}

// This vector table (should be) only indexed into when MTVEC.MODE = Vectored
// based on the value of mcause when the trap occurs
// For MTVEC.MODE = Direct, trap events always route straight to the base value
// of MTVEC, which should be pointing at the std_rv_isr() routine above.
static void std_rv_isr_vector_table(void) {
    // see https://five-embeddev.com/baremetal/vectored_interrupts/ for example
    __asm__ volatile (
        ".org  std_rv_isr_vector_table + 0*4;"
        "jal   zero,std_rv_mtvec_exception;"  /* 0  */
        ".org  std_rv_isr_vector_table + 1*4;"
        "jal   zero,std_rv_mtvec_ssi;"  /* 1  */
        ".org  std_rv_isr_vector_table + 3*4;"
        "jal   zero,std_rv_mtvec_msi;"  /* 3  */
        ".org  std_rv_isr_vector_table + 5*4;"
        "jal   zero,std_rv_mtvec_sti;"  /* 5  */
        ".org  std_rv_isr_vector_table + 7*4;"
        "jal   zero,std_rv_mtvec_mti;"  /* 7  */
        ".org  std_rv_isr_vector_table + 9*4;"
        "jal   zero,std_rv_mtvec_sei;"  /* 9  */
        ".org  std_rv_isr_vector_table + 11*4;"
        "jal   zero,std_rv_mtvec_mei;"  /* 11 */
        ".org  std_rv_isr_vector_table + 29*4;"
        "jal   zero,nonstd_veer_mtvec_miti0;" /* 29 */
        ".org  std_rv_isr_vector_table + 30*4;"
        "jal   zero,nonstd_veer_mtvec_mcei;" /* 30 */
//        #ifndef VECTOR_TABLE_MTVEC_PLATFORM_INTS
//        ".org  std_rv_isr_vector_table + 16*4;"
//        "jal   std_rv_mtvec_platform_irq0;"
//        "jal   std_rv_mtvec_platform_irq1;"
//        "jal   std_rv_mtvec_platform_irq2;"
//        "jal   std_rv_mtvec_platform_irq3;"
//        "jal   std_rv_mtvec_platform_irq4;"
//        "jal   std_rv_mtvec_platform_irq5;"
//        "jal   std_rv_mtvec_platform_irq6;"
//        "jal   std_rv_mtvec_platform_irq7;"
//        "jal   std_rv_mtvec_platform_irq8;"
//        "jal   std_rv_mtvec_platform_irq9;"
//        "jal   std_rv_mtvec_platform_irq10;"
//        "jal   std_rv_mtvec_platform_irq11;"
//        "jal   std_rv_mtvec_platform_irq12;"
//        "jal   std_rv_mtvec_platform_irq13;"
//        "jal   std_rv_mtvec_platform_irq14;"
//        "jal   std_rv_mtvec_platform_irq15;"
//        #endif
        : /* output: none */
        : /* input : immediate */
        : /* clobbers: none */
    );
}

// Exception handler for Standard RISC-V Vectored operation
void std_rv_mtvec_exception(void) {
    uint_xlen_t this_cause = csr_read_mcause();
    //printf("In:Std Excptn\nmcause:%x\n", this_cause);
    if (this_cause &  MCAUSE_INTERRUPT_BIT_MASK) {
        //printf("Unexpected Intr bit:%x\n", 0xFFFFFFFF);
    } else {
        uint_xlen_t tmp_reg;

        // mscause
        __asm__ volatile ("csrr    %0, %1"
                          : "=r" (tmp_reg)  /* output : register */
                          : "i" (VEER_CSR_MSCAUSE) /* input : immediate */
                          : /* clobbers: none */);
        //printf("mscause:%x\n",tmp_reg);
        #ifdef RV_EXCEPTION_STRUCT
        __asm__ volatile ("fence.i");
        exc_flag.exception_hit = 1;
        exc_flag.mcause = this_cause;
        exc_flag.mscause = tmp_reg;
        #endif
        // mepc
        tmp_reg = csr_read_mepc();
        //printf("mepc:%x\n",tmp_reg);
        // mtval
        tmp_reg = csr_read_mtval();
        //printf("mtval:%x\n",tmp_reg);

        switch (this_cause) {
        case RISCV_EXCP_LOAD_ACCESS_FAULT :
            #ifdef RV_EXCEPTION_STRUCT
            if (exc_flag.mscause == RISC_EXCP_MSCAUSE_DCCM_LOAD_UNC_ECC_ERR) {
                // Increment mepc before returning, because repeating the previously
                // failing command will cause an infinite loop back to this ISR.
                tmp_reg = csr_read_mepc();
                csr_write_mepc(tmp_reg + 4); // FIXME this has no guarantee of working. E.g. Compressed instructions are 2, not 4, bytes...

                // Bail immediately instead of killing the sim.
                // Caliptra RESET is expected due to FATAL Error, but if it's
                // masked the originating test should decide what to do.
                return;
            }
            #endif
            break;
        case RISCV_EXCP_STORE_AMO_ACCESS_FAULT :
            #ifdef RV_EXCEPTION_STRUCT
            if (exc_flag.mscause == RISC_EXCP_MSCAUSE_DCCM_STOR_UNC_ECC_ERR) {
                // Bail immediately instead of killing the sim.
                // Caliptra RESET is expected due to FATAL Error, but if it's
                // masked the originating test should decide what to do.
                return;
            }
            #endif
            break;
        case RISCV_EXCP_INSTRUCTION_ACCESS_FAULT :
            #ifdef RV_EXCEPTION_STRUCT
            if (exc_flag.mscause == RISC_EXCP_MSCAUSE_ICCM_INST_UNC_ECC_ERR) {

                // Reset uC instead of killing the sim.
                // Caliptra RESET is expected due to FATAL Error, but if it's
                // masked the originating test won't be able to make progress
                // after this routine returns.

                // If the FATAL Error bit for ICCM ECC Error is masked, manually trigger firmware reset
                if (lsu_read_32(CLP_SOC_IFC_REG_INTERNAL_HW_ERROR_FATAL_MASK) & SOC_IFC_REG_INTERNAL_HW_ERROR_FATAL_MASK_MASK_ICCM_ECC_UNC_MASK) {
                    //printf( "ICCM ECC FATAL_ERROR bit is masked, no reset expected from TB: resetting the core manually!\n");
                    lsu_write_32(CLP_SOC_IFC_REG_INTERNAL_FW_UPDATE_RESET, SOC_IFC_REG_INTERNAL_FW_UPDATE_RESET_CORE_RST_MASK);
                // Otherwise, wait for core reset
                } else {
                    //printf( "ICCM ECC FATAL_ERROR bit is not masked, waiting for reset from TB!\n");
                    while(1);
                }

            }
            #endif
            break;
        case RISCV_EXCP_ILLEGAL_INSTRUCTION :
            break;
        default :
            break;
        }
    }
    return;
}

// Non-Standard Vectored Interrupt Handler (vector 0)
// ISR 0 is, by definition, not implemented and simply returns
static void nonstd_veer_isr_0 (void) {
    //printf( "In:0\n");
    return;
}

// Macro used to lay down mostly equivalent ISR for each of the supported
// interrupt sources.
// The only unique functionality for each ISR is provided by the service_xxx_intr
// inline function.
// Using inline functions for event-specific handling reduces the overhead from
// context switches (which is critical in an ISR) relative to regular function
// calls
#define stringify(text) #text
#define nonstd_veer_isr(name) static void nonstd_veer_isr_##name (void) {                           \
                                                                                                      \
    /* Print msg before enabling nested interrupts so it                                              \
     * completes printing and is legible                                                              \
     */                                                                                               \
    printf( "In:"stringify(name)"\n");                                                        \
                                                                                                      \
    /* Save Context to Stack */                                                                       \
    uint32_t meicidpl;                                                                                \
    uint32_t prev_meicurpl;                                                                           \
    uint_xlen_t prev_mepc;                                                                            \
    uint_xlen_t prev_mstatus;                                                                         \
    uint_xlen_t prev_mie;                                                                             \
    __asm__ volatile ("csrr    %0, %1"                                                                \
                      : "=r" (meicidpl)  /* output : register */                                      \
                      : "i" (VEER_CSR_MEICIDPL) /* input : immediate */                              \
                      : /* clobbers: none */);                                                        \
    __asm__ volatile ("csrr    %0, %1"                                                                \
                      : "=r" (prev_meicurpl)  /* output : register */                                 \
                      : "i" (VEER_CSR_MEICURPL) /* input : immediate */                              \
                      : /* clobbers: none */);                                                        \
    prev_mepc    = csr_read_mepc();                                                                   \
    prev_mstatus = csr_read_mstatus();                                                                \
    prev_mie     = csr_read_mie();                                                                    \
                                                                                                      \
    /* Set the priority threshold to current priority */                                              \
    __asm__ volatile ("csrw    %0, %1"                                                                \
                      : /* output: none */                                                            \
                      : "i" (VEER_CSR_MEICURPL), "r" (meicidpl)  /* input : immediate  */            \
                      : /* clobbers: none */);                                                        \
                                                                                                      \
    /* Reenable interrupts (nesting) */                                                               \
    csr_set_bits_mstatus(MSTATUS_MIE_BIT_MASK);                                                       \
                                                                                                      \
    /* Service the interrupt (clear the interrupt source) */                                          \
    intr_count++;                                                                                     \
    printf("cnt_"stringify(name)":%08x\n",(unsigned int)intr_count);                                          \
     /* Fill in with macro contents, e.g. "service_soc_ifc_error_intr" */                              \
    /* This will match one macro from this list:                                                      \
     * service_doe_error_intr                                                                         \
     * service_doe_notif_intr                                                                         \
     * service_ecc_error_intr                                                                         \
     * service_ecc_notif_intr                                                                         \
     * service_hmac_error_intr                                                                        \
     * service_hmac_notif_intr                                                                        \
     * service_kv_error_intr                                                                          \
     * service_kv_notif_intr                                                                          \
     * service_sha512_error_intr                                                                      \
     * service_sha512_notif_intr                                                                      \
     * service_sha256_error_intr                                                                      \
     * service_sha256_notif_intr                                                                      \
     * service_qspi_error_intr                                                                        \
     * service_qspi_notif_intr                                                                        \
     * service_uart_error_intr                                                                        \
     * service_uart_notif_intr                                                                        \
     * service_i3c_error_intr                                                                         \
     * service_i3c_notif_intr                                                                         \
     * service_soc_ifc_error_intr                                                                     \
     * service_soc_ifc_notif_intr                                                                     \
     * service_sha512_acc_error_intr                                                                  \
     * service_sha512_acc_notif_intr                                                                  \
     */                                                                                               \
    service_##name##_intr();                                                                          \
                                                                                                      \
    /* Disable interrupts */                                                                          \
    csr_clr_bits_mstatus(MSTATUS_MIE_BIT_MASK);                                                       \
                                                                                                      \
    /* Restore Context from Stack */                                                                  \
    __asm__ volatile ("csrw    %0, %1"                                                                \
                      : /* output: none */                                                            \
                      : "i" (VEER_CSR_MEICURPL), "r" (prev_meicurpl)  /* input : immediate  */       \
                      : /* clobbers: none */);                                                        \
    csr_write_mepc(prev_mepc);                                                                        \
    csr_set_bits_mstatus(prev_mstatus & (MSTATUS_MPIE_BIT_MASK | MSTATUS_MPP_BIT_MASK));              \
    csr_set_bits_mie(prev_mie & (MIE_MSI_BIT_MASK | MIE_MTI_BIT_MASK | MIE_MEI_BIT_MASK));            \
                                                                                                      \
    /* Done */                                                                                        \
    return;                                                                                           \
}

////////////////////////////////////////////////////////////////////////////////
// Auto define ISR for each interrupt source using a macro
// Resulting defined functions are, e.g. "nonstd_veer_isr_doe_error" (for Vector 1)

// Non-Standard Vectored Interrupt Handler (DOE Error = Vector 1)
nonstd_veer_isr(doe_error)
// Non-Standard Vectored Interrupt Handler (DOE Notification = vector 2)
nonstd_veer_isr(doe_notif)
// Non-Standard Vectored Interrupt Handler (ECC Error = vector 3)
nonstd_veer_isr(ecc_error)
// Non-Standard Vectored Interrupt Handler (ECC Notification = vector 4)
nonstd_veer_isr(ecc_notif)
// Non-Standard Vectored Interrupt Handler (HMAC Error = vector 5)
nonstd_veer_isr(hmac_error)
// Non-Standard Vectored Interrupt Handler (HMAC Notification = vector 6)
nonstd_veer_isr(hmac_notif)
// Non-Standard Vectored Interrupt Handler (KeyVault Error = vector 7)
nonstd_veer_isr(kv_error)
// Non-Standard Vectored Interrupt Handler (KeyVault Notification = vector 8)
nonstd_veer_isr(kv_notif)
// Non-Standard Vectored Interrupt Handler (SHA512 Error = vector 9)
nonstd_veer_isr(sha512_error)
// Non-Standard Vectored Interrupt Handler (SHA512 Notification = vector 10)
nonstd_veer_isr(sha512_notif)
// Non-Standard Vectored Interrupt Handler (SHA256 Error = vector 11)
nonstd_veer_isr(sha256_error)
// Non-Standard Vectored Interrupt Handler (SHA256 Notification = vector 12)
nonstd_veer_isr(sha256_notif)
/********************** Save FW image space by omitting these unused ISR ******
 * // Non-Standard Vectored Interrupt Handler (QSPI Error = vector 13)          //
 * nonstd_veer_isr(qspi_error)                                                  //
 * // Non-Standard Vectored Interrupt Handler (QSPI Notification = vector 14)   //
 * nonstd_veer_isr(qspi_notif)                                                  //
 * // Non-Standard Vectored Interrupt Handler (UART Error = vector 15)          //
 * nonstd_veer_isr(uart_error)                                                  //
 * // Non-Standard Vectored Interrupt Handler (UART Notification = vector 16)   //
 * nonstd_veer_isr(uart_notif)                                                  //
 * // Non-Standard Vectored Interrupt Handler (I3C Error = vector 17)           //
 * nonstd_veer_isr(i3c_error)                                                   //
 * // Non-Standard Vectored Interrupt Handler (I3C Notification = vector 18)    //
 * nonstd_veer_isr(i3c_notif)                                                   //
******************************************************************************/
// Non-Standard Vectored Interrupt Handler (SOC_IFC Error = vector 19)
nonstd_veer_isr(soc_ifc_error)
// Non-Standard Vectored Interrupt Handler (SOC_IFC Notification = vector 20)
nonstd_veer_isr(soc_ifc_notif)
// Non-Standard Vectored Interrupt Handler (SHA Error = vector 21)
nonstd_veer_isr(sha512_acc_error)
// Non-Standard Vectored Interrupt Handler (SHA Notification = vector 22)
nonstd_veer_isr(sha512_acc_notif)

