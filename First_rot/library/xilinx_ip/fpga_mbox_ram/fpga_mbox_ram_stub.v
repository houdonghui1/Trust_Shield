// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
// Date        : Fri May 16 10:32:18 2025
// Host        : secure-Precision-3660 running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/houdonghui/cm3_ahbmtx_mcu/project/fpga_syn/fpga_ku6_mcu_full_vivado/mcu_top.gen/sources_1/ip/fpga_mbox_ram/fpga_mbox_ram_stub.v
// Design      : fpga_mbox_ram
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku060-ffva1156-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *)
module fpga_mbox_ram(clka, ena, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[14:0],dina[38:0],douta[38:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [14:0]addra;
  input [38:0]dina;
  output [38:0]douta;
endmodule
