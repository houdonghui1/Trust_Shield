#===============================================
#
#		File: fpga_ku6_mcu_full_timing constrain.xdc
#		Author: afterGlow,4ever
#		Group: Fall For Laboratory
#		Date: 09242023
#		Version: v1.0
#
# 	This is timing constrain for xilinx fpga.
# 	Using ku060 navigator board.
#
#===============================================

create_clock -name {hse} -period 5.000 -waveform {0.000 2.500} [get_ports {CLK}]
create_clock -name {jtag_tck} -period 200.000 -waveform {0.000 100.000} [get_ports {TCK}]

derive_pll_clocks

set_clock_groups -async -group [get_clocks {clk_out1_pll_50m}]
set_clock_groups -async -group [get_clocks {clk_out2_pll_50m}]
set_clock_groups -async -group [get_clocks {clk_out3_pll_50m}]
set_clock_groups -async -group [get_clocks {hse}]
set_clock_groups -async -group [get_clocks {jtag_tck}]

set_false_path -from [get_ports RSTN]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets TCK_IBUF]

