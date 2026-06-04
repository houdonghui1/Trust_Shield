# ------------------------- Base Clocks --------------------
create_clock -period 5.000 -name sys_clock [get_ports sys_clock_p]
set_input_jitter sys_clock 0.500
# ------------------------- Clock Groups -------------------
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins mig/island/blackbox/c0_ddr4_ui_clk]] -group [get_clocks -of_objects [get_pins harnessSysPLL/clk_out1]]

# ------------------------- False Paths --------------------
set_false_path -through [get_pins fpga_power_on/power_on_reset]
# ------------------------- IO Timings ---------------------

