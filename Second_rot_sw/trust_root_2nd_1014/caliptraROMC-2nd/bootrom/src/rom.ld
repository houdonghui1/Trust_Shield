/*
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
OUTPUT_ARCH( "riscv" )
ENTRY(_start)
MEMORY {
    ROM     (rx) : ORIGIN = 0x0, LENGTH = 48K
    ICCM    (rx) : ORIGIN = 0x40000000, LENGTH = 128K
    DCCM    (rw) : ORIGIN = 0x50010000, LENGTH = 64K
}

SECTIONS {
  . = 0x0;
  .text.init : { *(.text.init) }
  .text   : { *(.text*) }

  .eh_frame : { *(.eh_frame) }
  /* DCCM as VMA */
  /* Data is bundled with ROM image in iMem */
  /* Align data to 4-bytes to allow LSU access to work
   * when copying to DCCM */
  /* Only upper half of DCCM is used for ROM image */
  _data_lma_start = ALIGN(4);
  _data_vma_start = 0x50010000;
  .data _data_vma_start : AT(_data_lma_start) {
    *(.data .data.*)
    *(.sdata .sdata.*)
    *(.rodata .rodata.*)
    *(.srodata .srodata.*)
    . = ALIGN(4);
  } =0x0000,

  _data_lma_end = _data_lma_start + SIZEOF(.data);
  _data_vma_end = _data_vma_start + SIZEOF(.data);
  _bss_vma_start = _data_vma_end;
  .bss _bss_vma_start (NOLOAD) : {
    *(.sbss .sbss.*)
    *(.bss .bss.*)
    . = ALIGN(4);
  } =0x0000,
  _bss_vma_end = _bss_vma_start + SIZEOF(.bss);
  _bss_lma_start = _bss_vma_start;
  _bss_lma_end   = _bss_vma_end;
  _end = _data_lma_end;
  ASSERT( _end <= 0x0000C000, "ERROR: ROM size exceeds the 48KiB hardware ROM")

  /* DCCM as VMA and LMA */
  . = _bss_vma_end;
  _dccm_lma_start = _bss_vma_end; /* ----\___ SAME */
  _dccm_vma_start = _bss_vma_end; /* ----/         */
  .dccm _dccm_vma_start (NOLOAD): AT(_dccm_lma_start) { *(.dccm*) . = ALIGN(4); } =0x0000,
  iccm_code0_start = .;

  /* ICCM as VMA */
  /* All of these sections start at the base address of ICCM, and cannot coexist */
  /* The code in these sections will be loaded to DCCM alongside .data and later
   * copied into ICCM for execution.
   * NOTE: none of these sections will be used by the val image/FMC/RT flows */
  .data_iccm0 0x40000000 : AT(iccm_code0_start) {*(.data_iccm0) ; . = ALIGN(4); } =0x0000, /* iccm_code0_start, after .data, as LMA */
  iccm_code0_end = iccm_code0_start + SIZEOF(.data_iccm0);
  iccm_code1_start = ALIGN(iccm_code0_end,4);
  .data_iccm1 0x40000000 : AT(iccm_code1_start) {*(.data_iccm1) ; . = ALIGN(4); } =0x0000, /* iccm_code1_start, after .data, as LMA */
  iccm_code1_end = iccm_code1_start + SIZEOF(.data_iccm1);
  iccm_code2_start = ALIGN(iccm_code1_end,4);
  .data_iccm2 0x40000000 : AT(iccm_code2_start) {*(.data_iccm2) ; . = ALIGN(4); } =0x0000, /* iccm_code2_start, after .data, as LMA */
  iccm_code2_end = iccm_code2_start + SIZEOF(.data_iccm2);

  /* Four bounded 2KiB certificate slots. */
  _cert_store_start = 0x5001D000;
  _cert_store_end = 0x5001F020;

  _tbs_der_store_start = 0x5001F040;
  _tbs_der_store_end = 0x5001F040;

  /* L2 owns a larger state record because it tracks up to 16 direct L1
   * registrations.  Keep the final 0xF00 bytes of the physical DCCM bank for
   * that record and leave a guard gap after the TBS store. */
  _cluster_bls_state_start = 0x5001F100;
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

  ASSERT(SIZEOF(.cert_store) <= (_cert_store_end - _cert_store_start),
         "ERROR: certificate store exceeds its reserved DCCM range")
  ASSERT(SIZEOF(.tbs_der_store) <=
         (_tbs_der_store_end - _tbs_der_store_start),
         "ERROR: TBS store exceeds its reserved DCCM range")
  ASSERT(SIZEOF(.cluster_bls_state) <=
         (_cluster_bls_state_end - _cluster_bls_state_start),
         "ERROR: L2 BLS state exceeds its reserved DCCM range")

  /* Stack is at the end of DCCM after .data_iccm2 */
  . = ALIGN(iccm_code2_end,16);
  STACK = ALIGN(16) + 0x4000;
  ASSERT(STACK < _cert_store_start,
         "ERROR: stack overlaps the reserved certificate/BLS stores")
  ASSERT( (STACK < 0x50020000), "ERROR: Stack overflows the upper 64KiB DCCM bank")
}
