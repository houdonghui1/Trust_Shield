#caliptra signals

create_clock -period 200.000 -name jtag_ca_jtag_tck -waveform {0.000 100.000} [get_ports ca_jtag_tck]
set_clock_groups -asynchronous -group [get_clocks jtag_ca_jtag_tck]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets ca_jtag_tck_IBUF_inst/O]
set_property -dict {PACKAGE_PIN AE11 IOSTANDARD LVCMOS33} [get_ports ca_jtag_tck]
set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS33} [get_ports ca_jtag_tdi]
set_property -dict {PACKAGE_PIN AD11 IOSTANDARD LVCMOS33} [get_ports ca_jtag_tms]
set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS33} [get_ports ca_jtag_tdo]
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS33} [get_ports ca_jtag_trst_n]

set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS33} [get_ports ca_uart_tx]
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS33} [get_ports ca_uart_rx]

#caliptra TAPs
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS33} [get_ports {security_state[0]}]
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS33} [get_ports {security_state[1]}]
set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVCMOS33} [get_ports {security_state[2]}]

set_property -dict {PACKAGE_PIN AH13 IOSTANDARD LVCMOS33} [get_ports scan_mode]

#SPI SIGNALS
set_property -dict {PACKAGE_PIN U26 IOSTANDARD LVCMOS18} [get_ports ca_qspi_clk]
#SD CS
set_property -dict {PACKAGE_PIN V27 IOSTANDARD LVCMOS18} [get_ports ca_qspi_cs]
#set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS33} [get_ports {ca_qspi_cs[1]}]取消了caliptra的CS[1]
#SPI mosi
set_property -dict {PACKAGE_PIN U27 IOSTANDARD LVCMOS18} [get_ports {ca_qspi_data[0]}]
#SPI miso
set_property -dict {PACKAGE_PIN Y27 IOSTANDARD LVCMOS18} [get_ports {ca_qspi_data[1]}]
set_property -dict {PACKAGE_PIN Y26 IOSTANDARD LVCMOS18} [get_ports {ca_qspi_data[2]}]
set_property -dict {PACKAGE_PIN V28 IOSTANDARD LVCMOS18} [get_ports {ca_qspi_data[3]}]



