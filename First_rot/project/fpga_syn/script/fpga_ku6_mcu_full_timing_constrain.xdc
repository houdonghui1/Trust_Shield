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
create_clock -name {jtag_ca_jtag_tck} -period 200.000 -waveform {0.000 100.000} [get_ports {ca_jtag_tck}]

derive_pll_clocks

###caliptra SPI host
#create_generated_clock -name clk_ca_spi_host -source [get_pins u_fp_domain/u_apb3_caliptra_sync/caliptra_top_dut/cg/caliptra_icg/clk_cg] -divide_by 2 -add -master_clock [get_clocks -of_objects [get_pins u_fp_domain/u_apb3_caliptra_sync/caliptra_top_dut/cg/caliptra_icg/clk_cg]] [get_ports ca_qspi_clk]

## Multi-cycle path to adjust the hold edge, since launch and capture edges are
## opposite in the SPI_HOST_CLK domain.
#set_multicycle_path -setup -start -from [get_clocks -of_objects [get_pins u_fp_domain/u_apb3_caliptra_sync/caliptra_top_dut/cg/caliptra_icg/clk_cg]] -to [get_clocks clk_ca_spi_host] 1
#set_multicycle_path -hold -start -from [get_clocks -of_objects [get_pins u_fp_domain/u_apb3_caliptra_sync/caliptra_top_dut/cg/caliptra_icg/clk_cg]] -to [get_clocks clk_ca_spi_host] 1

## set multicycle path for data going from SPI_HOST_CLK to logic
## the SPI host logic will read these paths at "full cycle"
#set_multicycle_path -setup -end -from [get_clocks clk_ca_spi_host] -to [get_clocks -of_objects [get_pins u_fp_domain/u_apb3_caliptra_sync/caliptra_top_dut/cg/caliptra_icg/clk_cg]] 2
#set_multicycle_path -hold -end -from [get_clocks clk_ca_spi_host] -to [get_clocks -of_objects [get_pins u_fp_domain/u_apb3_caliptra_sync/caliptra_top_dut/cg/caliptra_icg/clk_cg]] 2

#set_output_delay -clock clk_ca_spi_host -min -add_delay -3.500 [get_ports {ca_qspi_data[0] ca_qspi_data[1] ca_qspi_data[2] ca_qspi_data[3] ca_qspi_cs[0] ca_qspi_cs[1]}]
#set_output_delay -clock clk_ca_spi_host -max -add_delay 3.500 [get_ports {ca_qspi_data[0] ca_qspi_data[1] ca_qspi_data[2] ca_qspi_data[3] ca_qspi_cs[0] ca_qspi_cs[1]}]
#set_input_delay -clock clk_ca_spi_host -clock_fall -min -add_delay 0.000 [get_ports {ca_qspi_data[0] ca_qspi_data[1] ca_qspi_data[2] ca_qspi_data[3]}]
#set_input_delay -clock clk_ca_spi_host -clock_fall -max -add_delay 10.200 [get_ports {ca_qspi_data[0] ca_qspi_data[1] ca_qspi_data[2] ca_qspi_data[3]}]


set_clock_groups -async -group [get_clocks {clk_out1_pll_50m}]
set_clock_groups -async -group [get_clocks {clk_out2_pll_50m}]
set_clock_groups -async -group [get_clocks {clk_out3_pll_50m}]
set_clock_groups -async -group [get_clocks {hse}]
set_clock_groups -async -group [get_clocks {jtag_tck}]
set_clock_groups -async -group [get_clocks {jtag_ca_jtag_tck}]

set_false_path -from [get_ports RSTN]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets TCK_IBUF]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets ca_jtag_tck_IBUF]

