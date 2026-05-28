-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
-- Date        : Mon Aug 11 10:41:07 2025
-- Host        : secure-Precision-3660 running 64-bit Ubuntu 20.04.6 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/houdonghui/cm3_ahbmtx_mcu/library/xilinx_ip/fpga_imem/fpga_imem_stub.vhdl
-- Design      : fpga_imem
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcku060-ffva1156-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fpga_imem is
  Port ( 
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 7 downto 0 );
    addra : in STD_LOGIC_VECTOR ( 12 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 63 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 63 downto 0 )
  );

end fpga_imem;

architecture stub of fpga_imem is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,ena,wea[7:0],addra[12:0],dina[63:0],douta[63:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_4,Vivado 2021.1";
begin
end;
