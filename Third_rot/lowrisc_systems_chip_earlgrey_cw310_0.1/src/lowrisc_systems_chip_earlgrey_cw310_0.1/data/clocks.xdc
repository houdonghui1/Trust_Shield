## Copyright lowRISC contributors.
## Licensed under the Apache License, Version 2.0, see LICENSE for details.
## SPDX-License-Identifier: Apache-2.0

## Clock Signal
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports IO_CLK]

## Rename MMCM outputs for less bug-prone parsing.
## Some auto-derived clocks can have names that include brackets.
create_generated_clock -name clk_main [get_pins clkgen/pll/CLKOUT0]
create_generated_clock -name clk_usb_48 [get_pins clkgen/pll/CLKOUT1]
create_generated_clock -name clk_aon [get_pins clkgen/pll/CLKOUT4]
create_generated_clock -name clk_io -source [get_pins clkgen/pll/CLKOUT0] -divide_by 1 -add -master_clock [get_clocks clk_main] [get_pins u_ast/u_ast_clks_byp/u_no_scan_clk_src_io_d1ord2/gen_generic.u_impl_generic/u_clk_div_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufg.bufg_i/O]

## Clock Domain Crossings

## Divided clock
## This is not really recommended per Vivado's guidelines, but hopefully these clocks are slow enough and their
## destination flops few enough.

create_generated_clock -name clk_io_div2 -source [get_pins u_ast/u_ast_clks_byp/u_no_scan_clk_src_io_d1ord2/gen_generic.u_impl_generic/u_clk_div_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufg.bufg_i/O] -divide_by 2 [get_pins {top_*/u_clkmgr_aon/u_no_scan_io_div2_div/gen_generic.u_impl_generic/gen_div2.u_div2/gen_xilinx.u_impl_xilinx/q_o[0]}]

# TODO: Use pin names explicitly exist from the source instead of the ones
# after synthesis.
create_generated_clock -name clk_io_div4 -source [get_pins top_*/u_clkmgr_aon/u_no_scan_io_div4_div/gen_generic.u_impl_generic/gen_div.clk_int_reg/C] -divide_by 4 [get_pins top_*/u_clkmgr_aon/u_no_scan_io_div4_div/gen_generic.u_impl_generic/gen_div.clk_int_reg/Q]


#create_generated_clock -name clk_src_io -divide_by 1 -source [get_pins ${u_pll}/CLKOUT0] #  [get_pins ${ast_src_io}/gen_div2.u_div2/gen_xilinx.u_impl_xilinx/q_o[0]]

set_clock_sense -positive [get_pins -filter {DIRECTION == OUT && IS_LEAF} -of_objects [get_nets -segments -of_objects [get_pins u_ast/u_ast_clks_byp/u_no_scan_clk_src_io_d1ord2/gen_generic.u_impl_generic/u_clk_div_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufg.bufg_i/I]]]

# the step-down mux is implemented with a LUT right now and the mux switches on the falling edge.
# therefore, Vivado propagates both clock edges down the clock network.
# this implementation is not ideal - but we can at least tell Vivado to only honour the rising edge for
# timing analysis.
set_clock_sense -positive [get_pins -filter {DIRECTION == OUT && IS_LEAF} -of_objects [get_nets -segments -of_objects [get_pins top_*/u_clkmgr_aon/u_no_scan_io_div2_div/gen_generic.u_impl_generic/u_clk_div_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufg.bufg_i/I]]]

## Muxed I/Os

## JTAG clocks and I/O delays
# Create clocks for the various TAPs.
create_clock -period 100.000 -name jtag_tck -waveform {0.000 50.000} -add [get_ports IOR3]
create_generated_clock -name lc_jtag_tck -source [get_ports IOR3] -divide_by 1 [get_pins top_*/u_pinmux_aon/u_pinmux_strap_sampling/u_pinmux_jtag_buf_lc/prim_clock_buf_tck/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufg.bufg_i/O]
create_generated_clock -name rv_jtag_tck -source [get_ports IOR3] -divide_by 1 [get_pins top_*/u_pinmux_aon/u_pinmux_strap_sampling/u_pinmux_jtag_buf_rv/prim_clock_buf_tck/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufg.bufg_i/O]


set_clock_sense -negative [get_pins -filter {DIRECTION == OUT && IS_LEAF} -of_objects [get_nets -segments -of_objects [get_pins top_earlgrey/u_pinmux_aon/u_pinmux_strap_sampling/u_pinmux_jtag_buf_lc/prim_clock_buf_tck/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufg.bufg_i/I]]]
set_clock_sense -negative [get_pins -filter {DIRECTION == OUT && IS_LEAF} -of_objects [get_nets -segments -of_objects [get_pins top_earlgrey/u_pinmux_aon/u_pinmux_strap_sampling/u_pinmux_jtag_buf_rv/prim_clock_buf_tck/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufg.bufg_i/I]]]

# Assign input and output delays.
# Note that incidental combinatorial paths through the pinmux do not get removed
# from timing below, but the half cycle timing for JTAG leaves a fairly generous
# requirement. If the JTAG constraints need to be tightened and overly constrain
# the combinational port-to-port paths,
#   set_max_delay -datapath_only
# may be used to apply timing exceptions for those paths.
# However, remember that the input and output delays contribute to the path
# delay for such a case, so the constraint value for set_max_delay must
# accommodate them. In other words, for the constraint
#   set_max_delay -datapath_only -from [get_ports] -through ${combo_path_pin} #                 -to [get_ports] ${max_delay_value}
# ${max_delay_value} =
#     ${max_input_delay} + ${max_output_delay} + ${max_port_to_port_delay}
set_output_delay -clock jtag_tck -clock_fall -max -add_delay 10.000 [get_ports IOR1]
set_output_delay -clock jtag_tck -clock_fall -min -add_delay -5.000 [get_ports IOR1]
set_input_delay -clock jtag_tck -clock_fall -min -add_delay 0.000 [get_ports {IOR0 IOR2}]
set_input_delay -clock jtag_tck -clock_fall -max -add_delay 15.000 [get_ports {IOR0 IOR2}]

## SPI clocks
# Max board skew between signals
# Max board delay
# Board skew affects input path for sampling
# The board delay affects time remaining on the output path.

create_clock -period 100.000 -name clk_spi -waveform {0.000 50.000} -add [get_ports SPI_DEV_CLK]
# CSB must act as a clock, in addition to data and a reset.
# The waveform is semi-arbitrary: This choice shows that both edges happen near
# the falling edge of clk_spi. The source clock latency constraints then
# function like set_input_delay where SPI_DEV_CS_L acts as data.
create_clock -period 100.000 -name clk_spid_csb -waveform {50.000 51.000} [get_ports SPI_DEV_CS_L]
set_clock_latency -min -source -2.500 [get_ports SPI_DEV_CS_L]
set_clock_latency -max -source 3.500 [get_ports SPI_DEV_CS_L]

set_input_delay -clock clk_spi -clock_fall -min -add_delay -2.500 [get_ports {SPI_DEV_D0 SPI_DEV_D1 SPI_DEV_D2 SPI_DEV_D3}]
set_input_delay -clock clk_spi -clock_fall -max -add_delay 3.500 [get_ports {SPI_DEV_D0 SPI_DEV_D1 SPI_DEV_D2 SPI_DEV_D3}]

## For half-cycle
#set_output_delay -clock clk_spi -min ${spi_dev_out_hold}  ${spi_dev_data} -add_delay
#set_output_delay -clock clk_spi -max ${spi_dev_out_setup} ${spi_dev_data} -add_delay

## For full-cycle
set_output_delay -clock clk_spi -clock_fall -min -add_delay -5.000 [get_ports {SPI_DEV_D0 SPI_DEV_D1 SPI_DEV_D2 SPI_DEV_D3}]
set_output_delay -clock clk_spi -clock_fall -max -add_delay 6.200 [get_ports {SPI_DEV_D0 SPI_DEV_D1 SPI_DEV_D2 SPI_DEV_D3}]

## set clock sense on the input to spi buffers to help the tool understand the
## clocks are shifted versions of each other

set_clock_sense -negative -clocks clk_spi [get_pins -filter {DIRECTION == OUT && IS_LEAF} -of_objects [get_nets -segments -of_objects [get_pins top_earlgrey/u_spi_device/u_clk_spi_out_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufr.bufr_i/I]]]

set_clock_sense -positive -clocks clk_spi [get_pins -filter {DIRECTION == OUT && IS_LEAF} -of_objects [get_nets -segments -of_objects [get_pins top_earlgrey/u_spi_device/u_clk_spi_in_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufr.bufr_i/I]]]

create_generated_clock -name clk_spi_in -source [get_ports SPI_DEV_CLK] -divide_by 1 [get_pins top_*/u_spi_device/u_clk_spi_in_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufr.bufr_i/O]
create_generated_clock -name clk_spi_out -source [get_ports SPI_DEV_CLK] -divide_by 1 -invert [get_pins top_*/u_spi_device/u_clk_spi_out_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufr.bufr_i/O]

## SPI TPM constraints
create_clock -period 125.000 -name clk_spi_tpm -add [get_ports SPI_DEV_CLK]

set_clock_sense -negative -clocks clk_spi_tpm [get_pins -filter {DIRECTION == OUT && IS_LEAF} -of_objects [get_nets -segments -of_objects [get_pins top_earlgrey/u_spi_device/u_clk_spi_out_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufr.bufr_i/I]]]

set_clock_sense -positive -clocks clk_spi_tpm [get_pins -filter {DIRECTION == OUT && IS_LEAF} -of_objects [get_nets -segments -of_objects [get_pins top_earlgrey/u_spi_device/u_clk_spi_in_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufr.bufr_i/I]]]

set_input_delay -clock clk_spi_tpm -clock_fall -min -add_delay -2.500 [get_ports {SPI_DEV_D0 SPI_DEV_D1 SPI_DEV_D2 SPI_DEV_D3}]
set_input_delay -clock clk_spi_tpm -clock_fall -max -add_delay 3.500 [get_ports {SPI_DEV_D0 SPI_DEV_D1 SPI_DEV_D2 SPI_DEV_D3}]

# TPM CSB
set_input_delay -clock clk_spi_tpm -clock_fall -min -add_delay -2.500 [get_ports {IOA0 IOA1 IOA2 IOA3 IOA4 IOA5 IOA6 IOA7 IOA8 IOB0 IOB1 IOB10 IOB11 IOB12 IOB2 IOB3 IOB4 IOB5 IOB6 IOB7 IOB8 IOB9 IOC0 IOC1 IOC10 IOC11 IOC12 IOC2 IOC3 IOC4 IOC5 IOC6 IOC7 IOC8 IOC9 IOR0 IOR1 IOR10 IOR11 IOR12 IOR13 IOR2 IOR3 IOR4 IOR5 IOR6 IOR7}]
set_input_delay -clock clk_spi_tpm -clock_fall -max -add_delay 3.500 [get_ports {IOA0 IOA1 IOA2 IOA3 IOA4 IOA5 IOA6 IOA7 IOA8 IOB0 IOB1 IOB10 IOB11 IOB12 IOB2 IOB3 IOB4 IOB5 IOB6 IOB7 IOB8 IOB9 IOC0 IOC1 IOC10 IOC11 IOC12 IOC2 IOC3 IOC4 IOC5 IOC6 IOC7 IOC8 IOC9 IOR0 IOR1 IOR10 IOR11 IOR12 IOR13 IOR2 IOR3 IOR4 IOR5 IOR6 IOR7}]

# Use half-cycle sampling to comply with TPM spec.
set_output_delay -clock clk_spi_tpm -min -add_delay -5.000 [get_ports {SPI_DEV_D0 SPI_DEV_D1 SPI_DEV_D2 SPI_DEV_D3}]
set_output_delay -clock clk_spi_tpm -max -add_delay 6.200 [get_ports {SPI_DEV_D0 SPI_DEV_D1 SPI_DEV_D2 SPI_DEV_D3}]

create_generated_clock -name clk_spi_tpm_in -source [get_ports SPI_DEV_CLK] -divide_by 1 -add -master_clock clk_spi_tpm [get_pins top_*/u_spi_device/u_clk_spi_in_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufr.bufr_i/O]
create_generated_clock -name clk_spi_tpm_out -source [get_ports SPI_DEV_CLK] -divide_by 1 -invert -add -master_clock clk_spi_tpm [get_pins top_*/u_spi_device/u_clk_spi_out_buf/gen_xilinx.u_impl_xilinx/gen_fpga_buf.gen_bufr.bufr_i/O]

## SPI Passthrough constraints
create_generated_clock -name clk_spi_pt -source [get_ports SPI_DEV_CLK] -divide_by 1 [get_ports SPI_HOST_CLK]


set_output_delay -clock clk_spi_pt -min -add_delay -3.500 [get_ports {SPI_HOST_D0 SPI_HOST_D1 SPI_HOST_D2 SPI_HOST_D3}]
set_output_delay -clock clk_spi_pt -max -add_delay 3.500 [get_ports {SPI_HOST_D0 SPI_HOST_D1 SPI_HOST_D2 SPI_HOST_D3}]
set_output_delay -clock clk_spi_pt -min -add_delay -3.500 [get_ports SPI_HOST_CS_L]
set_output_delay -clock clk_spi_pt -max -add_delay 3.500 [get_ports SPI_HOST_CS_L]

set_input_delay -clock clk_spi_pt -clock_fall -min -add_delay 0.000 [get_ports {SPI_HOST_D0 SPI_HOST_D1 SPI_HOST_D2 SPI_HOST_D3}]
set_input_delay -clock clk_spi_pt -clock_fall -max -add_delay 10.200 [get_ports {SPI_HOST_D0 SPI_HOST_D1 SPI_HOST_D2 SPI_HOST_D3}]


## SPI Host constraints
# SPI Host clock origin buffer

create_generated_clock -name clk_spi_host0 -source [get_pins top_earlgrey/u_clkmgr_aon/u_clk_io_peri_cg/gen_xilinx.u_impl_xilinx/gen_gate.gen_bufgce.u_bufgce/O] -divide_by 2 -add -master_clock [get_clocks -of_objects [get_pins top_earlgrey/u_clkmgr_aon/u_clk_io_peri_cg/gen_xilinx.u_impl_xilinx/gen_gate.gen_bufgce.u_bufgce/O]] [get_ports SPI_HOST_CLK]

# Multi-cycle path to adjust the hold edge, since launch and capture edges are
# opposite in the SPI_HOST_CLK domain.
set_multicycle_path -setup -start -from [get_clocks -of_objects [get_pins top_earlgrey/u_clkmgr_aon/u_clk_io_peri_cg/gen_xilinx.u_impl_xilinx/gen_gate.gen_bufgce.u_bufgce/O]] -to [get_clocks clk_spi_host0] 1
set_multicycle_path -hold -start -from [get_clocks -of_objects [get_pins top_earlgrey/u_clkmgr_aon/u_clk_io_peri_cg/gen_xilinx.u_impl_xilinx/gen_gate.gen_bufgce.u_bufgce/O]] -to [get_clocks clk_spi_host0] 1

# set multicycle path for data going from SPI_HOST_CLK to logic
# the SPI host logic will read these paths at "full cycle"
set_multicycle_path -setup -end -from [get_clocks clk_spi_host0] -to [get_clocks -of_objects [get_pins top_earlgrey/u_clkmgr_aon/u_clk_io_peri_cg/gen_xilinx.u_impl_xilinx/gen_gate.gen_bufgce.u_bufgce/O]] 2
set_multicycle_path -hold -end -from [get_clocks clk_spi_host0] -to [get_clocks -of_objects [get_pins top_earlgrey/u_clkmgr_aon/u_clk_io_peri_cg/gen_xilinx.u_impl_xilinx/gen_gate.gen_bufgce.u_bufgce/O]] 2

set_output_delay -clock clk_spi_host0 -min -add_delay -3.500 [get_ports {SPI_HOST_D0 SPI_HOST_D1 SPI_HOST_D2 SPI_HOST_D3 SPI_HOST_CS_L}]
set_output_delay -clock clk_spi_host0 -max -add_delay 3.500 [get_ports {SPI_HOST_D0 SPI_HOST_D1 SPI_HOST_D2 SPI_HOST_D3 SPI_HOST_CS_L}]
set_input_delay -clock clk_spi_host0 -clock_fall -min -add_delay 0.000 [get_ports {SPI_HOST_D0 SPI_HOST_D1 SPI_HOST_D2 SPI_HOST_D3 SPI_HOST_CS_L}]
set_input_delay -clock clk_spi_host0 -clock_fall -max -add_delay 10.200 [get_ports {SPI_HOST_D0 SPI_HOST_D1 SPI_HOST_D2 SPI_HOST_D3 SPI_HOST_CS_L}]

## Set asynchronous clock groups
set_clock_groups -asynchronous -group clk_main -group clk_usb_48 -group clk_aon -group {clk_io clk_spi_host0} -group clk_io_div2 -group clk_io_div4 -group [get_clocks -include_generated_clocks jtag_tck] -group {clk_spi clk_spi_in clk_spi_out clk_spi_pt clk_spid_csb clk_spi_tpm clk_spi_tpm_in clk_spi_tpm_out} -group sys_clk_pin

# TPM and non-TPM modes can't be active simultaneously
set_clock_groups -physically_exclusive -group {clk_spi clk_spi_in clk_spi_out clk_spi_pt clk_spid_csb} -group {clk_spi_tpm clk_spi_tpm_in clk_spi_tpm_out}

# CSB to SPI_DEV output enables. Primarily affects generic mode with CPHA=0
# and the first bit.
# Because SPI_DEV_CS_L is a clock pin, various constraint styles will not take.
# Use output delay to constrain the allowed CSB-to-Q outputs.
set_output_delay -clock clk_spid_csb -min -add_delay 5.000 [get_ports {SPI_DEV_D0 SPI_DEV_D1 SPI_DEV_D2 SPI_DEV_D3}]
set_output_delay -clock clk_spid_csb -max -add_delay 70.000 [get_ports {SPI_DEV_D0 SPI_DEV_D1 SPI_DEV_D2 SPI_DEV_D3}]

# Then mark the paths using other clocks as false paths. CSB does not actually
# sample these clocks.
set_clock_groups -logically_exclusive -group clk_spi -group clk_spid_csb
set_false_path -from [get_clocks {clk_spi_in clk_spi_out clk_spi_pt}] -through [get_ports {SPI_DEV_D0 SPI_DEV_D1 SPI_DEV_D2 SPI_DEV_D3}] -to [get_clocks clk_spid_csb]

# clk_spid_csb is not active with clk_spi_out, and it should not switch
# passthrough off while SPI_HOST is active. However, delays need to be limited
# to avoid blocking passthrough on the first bit.
set_max_delay -datapath_only -from [get_clocks clk_spid_csb] -to [get_clocks clk_spi_host0] 25.000

# CSB-clocked status bits to various negedge-triggered flops, especially in the
# serializer. Also may include the path to something for passthrough...
# Advance the hold edge by one cycle, since CSB changes nominally on the same
# edge as clk_spi_out, but clk_spi_out isn't actually toggling.
set_multicycle_path -hold -end -from [get_clocks clk_spid_csb] -to [get_clocks clk_spi_out] 1
set_multicycle_path -hold -end -from [get_clocks clk_spi_tpm] -through [get_ports {IOA0 IOA1 IOA2 IOA3 IOA4 IOA5 IOA6 IOA7 IOA8 IOB0 IOB1 IOB10 IOB11 IOB12 IOB2 IOB3 IOB4 IOB5 IOB6 IOB7 IOB8 IOB9 IOC0 IOC1 IOC10 IOC11 IOC12 IOC2 IOC3 IOC4 IOC5 IOC6 IOC7 IOC8 IOC9 IOR0 IOR1 IOR10 IOR11 IOR12 IOR13 IOR2 IOR3 IOR4 IOR5 IOR6 IOR7}] -to [get_clocks clk_spi_tpm_out] 1


## The usb calibration handling inside ast is assumed to be async to the outside world
## even though its interface is also a usb clock.
set_false_path -from [get_clocks -of_objects [get_pins clkgen/pll/CLKOUT1]] -to [get_pins {u_ast/u_usb_clk/u_ref_pulse_sync/u_sync*/u_sync_1/gen_*/q_o_reg[0]/D}]

## USB input delay to accommodate T_FST (full-speed transition time) and the
## PHY's sampling logic. The PHY expects to only see up to one transient / fake
## SE0. The phase relationship with the PHY's sampling clock is arbitrary, but
## for simplicity, constrain the maximum path delay to something smaller than
## `T_sample - T_FST(max)` to help keep the P/N skew from slipping beyond one
## sample period.
set_input_delay -clock [get_clocks -of_objects [get_pins clkgen/pll/CLKOUT1]] -min 3.000 [get_ports {IO_USB_DP_RX IO_USB_DN_RX IO_USB_D_RX}]
set_input_delay -clock [get_clocks -of_objects [get_pins clkgen/pll/CLKOUT1]] -max -add_delay 17.000 [get_ports {IO_USB_DP_RX IO_USB_DN_RX IO_USB_D_RX}]

## USB output max skew constraint
## Use the output-enable as a "clock" and time the P/N relative to it. Keep the skew within T_FST.
create_generated_clock -name usb_embed_out_clk -source [get_pins clkgen/pll/CLKOUT1] -multiply_by 1 [get_ports IO_USB_OE_N]
set_false_path -from [get_clocks -include_generated_clocks clk_io_div4] -to [get_generated_clocks usb_embed_out_clk]
set_output_delay -clock [get_generated_clocks usb_embed_out_clk] -min 7.000 [get_ports {IO_USB_DP_TX IO_USB_DN_TX}]
set_output_delay -clock [get_generated_clocks usb_embed_out_clk] -max -add_delay 14.000 [get_ports {IO_USB_DP_TX IO_USB_DN_TX}]



