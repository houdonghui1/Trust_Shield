create_clock -period 5000.000 -name {caliptra_fpga_project_bd_i/zynq_ultra_ps_e_0/inst/emio_gpio_o[0]} -waveform {0.000 2500.000} [get_pins {caliptra_fpga_project_bd_i/zynq_ultra_ps_e_0/inst/PS8_i/EMIOGPIOO[0]}]
set_clock_groups -asynchronous -group [get_clocks {caliptra_fpga_project_bd_i/zynq_ultra_ps_e_0/inst/emio_gpio_o[0]}]

set_property PACKAGE_PIN G8       [get_ports uart_rx_0]
set_property IOSTANDARD  LVCMOS33 [get_ports uart_rx_0]

set_property PACKAGE_PIN H8       [get_ports uart_tx_0]
set_property IOSTANDARD  LVCMOS33 [get_ports uart_tx_0]