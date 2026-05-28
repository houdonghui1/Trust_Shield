file mkdir ./checkpoint
set FPGA_NAME xcku060-ffva1156-2-i
#set FPGA_NAME xc7z020clg400-2
set PROJECT_NAME PROJECT_NAME_TEMP 
set caliptra_rtl_dir /home/houdonghui/cm3_ahbmtx_mcu/user/verilog/Caliptra/caliptra-rtl
set caliptra_fpga_spec_rtl_dir /home/houdonghui/cm3_ahbmtx_mcu/user/verilog/Caliptra/fpga_rtl

if {[ catch {create_project $PROJECT_NAME -part $FPGA_NAME} ]} {
	open_project $PROJECT_NAME
}

read_verilog design_define.v
source fpga_7020_ip.tcl
source fpga_7020_dut.tcl
source cm3_base_dut.tcl



#add caliptra source 
# Add VEER Headers
add_files $caliptra_rtl_dir/src/riscv_core/veer_el2/rtl/el2_param.vh
add_files $caliptra_rtl_dir/src/riscv_core/veer_el2/rtl/pic_map_auto.h
add_files $caliptra_rtl_dir/src/riscv_core/veer_el2/rtl/el2_pdef.vh

# Add VEER sources
add_files [ glob $caliptra_rtl_dir/src/riscv_core/veer_el2/rtl/*.sv ]
add_files [ glob $caliptra_rtl_dir/src/riscv_core/veer_el2/rtl/*/*.sv ]
add_files [ glob $caliptra_rtl_dir/src/riscv_core/veer_el2/rtl/*/*.v ]

# Add Caliptra Headers
add_files [ glob $caliptra_rtl_dir/src/*/rtl/*.svh ]
# Add Caliptra Sources
add_files [ glob $caliptra_rtl_dir/src/*/rtl/*.sv ]
add_files [ glob $caliptra_rtl_dir/src/*/rtl/*.v ]

# Remove spi_host files that aren't used yet and are flagged as having syntax errors
# TODO: Re-include these files when spi_host is used.
# remove_files [ glob $caliptra_rtl_dir/src/spi_host/rtl/*.sv ]

# Remove Caliptra files that need to be replaced by FPGA specific versions
# Replace RAM with FPGA block ram
remove_files [ glob $caliptra_rtl_dir/src/ecc/rtl/ecc_ram_tdp_file.sv ]
# Key Vault is very large. Replacing KV with a version with the minimum number of entries.
remove_files [ glob $caliptra_rtl_dir/src/keyvault/rtl/kv_reg.sv ]

# Add FPGA specific sources
add_files [ glob $caliptra_fpga_spec_rtl_dir/*.sv]
#add_files [ glob $caliptra_fpga_spec_rtl_dir/*.v]

# Mark all Verilog sources as SystemVerilog because some of them have SystemVerilog syntax.
set_property file_type SystemVerilog [get_files *.v]

set_property include_dirs $caliptra_rtl_dir/src/integration/rtl [current_fileset]



source FPGA_CFG_TEMP
read_xdc PIN_TEMP
read_xdc SDC_TEMP

#generate_target
synth_ip [get_ips]

update_compile_order

synth_design -top $PROJECT_NAME
write_checkpoint -force ./checkpoint/synthesis

report_utilization -file ./checkpoint/synthesis_util.rpt
report_utilization -hierarchical -hierarchical_depth 3 -file ./checkpoint/synthesis_hier.rpt
report_clocks -file ./checkpoint/synthesis_clk.rpt

opt_design
write_checkpoint -force ./checkpoint/opt

place_design
write_checkpoint -force ./checkpoint/place
phys_opt_design
phys_opt_design -aggressive_hold_fix
write_checkpoint -force ./checkpoint/phy_opt

route_design
write_checkpoint -force ./checkpoint/route

set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
write_bitstream -bin_file -force ./bitstream

write_xdc -no_fixed_only -force ./checkpoint/implementation_clk.xdc


report_timing_summary -file ./checkpoint/sta_summary.rpt
report_timing -sort_by group -max_paths 1000 -path_type summary -file ./checkpoint/sta.rpt
report_utilization -file ./checkpoint/implementation_util.rpt
report_utilization -hierarchical -hierarchical_depth 3 -file ./checkpoint/implementation_hier.rpt
report_clock_utilization -quiet -write_xdc /checkpoint/implementation_clk.xdc
report_clocks -file ./checkpoint/implementation_clk.rpt
report_drc -file ./checkpoint/implementation_drc.rpt

