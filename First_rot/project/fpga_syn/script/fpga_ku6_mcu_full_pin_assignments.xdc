#===============================================
#
#		File: fpga_7020_mcu_full_pin_assignments.xdc
#		Author: afterGlow,4ever
#		Group: Fall For Laboratory
#		Date: 09242023
#		Version: v1.0
#
# 	This is pin assignment for xilinx fpga.
# 	Using alientek zynq 7020 navigator board.
#
#===============================================

#p4 header
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]

set_property -dict {PACKAGE_PIN D24 IOSTANDARD LVCMOS18} [get_ports CLK]
set_property -dict {PACKAGE_PIN AN9 IOSTANDARD LVCMOS33} [get_ports RSTN]

set_property -dict {PACKAGE_PIN AN13 IOSTANDARD LVCMOS33} [get_ports TXD1]
set_property -dict {PACKAGE_PIN AP13 IOSTANDARD LVCMOS33} [get_ports RXD1]
set_property -dict {PACKAGE_PIN AK13 IOSTANDARD LVCMOS33} [get_ports MDC]
set_property -dict {PACKAGE_PIN AL13 IOSTANDARD LVCMOS33} [get_ports MDIO]

set_property -dict {PACKAGE_PIN AM12 IOSTANDARD LVCMOS33} [get_ports ETH_RST]
set_property -dict {PACKAGE_PIN AN12 IOSTANDARD LVCMOS33} [get_ports ETH_TXC]
set_property -dict {PACKAGE_PIN AK12 IOSTANDARD LVCMOS33} [get_ports ETH_TXEN]
set_property -dict {PACKAGE_PIN AL12 IOSTANDARD LVCMOS33} [get_ports {ETH_TXD[0]}]
set_property -dict {PACKAGE_PIN AM11 IOSTANDARD LVCMOS33} [get_ports {ETH_TXD[1]}]
set_property -dict {PACKAGE_PIN AN11 IOSTANDARD LVCMOS33} [get_ports {ETH_TXD[2]}]
set_property -dict {PACKAGE_PIN AK10 IOSTANDARD LVCMOS33} [get_ports {ETH_TXD[3]}]

set_property -dict {PACKAGE_PIN AJ13 IOSTANDARD LVCMOS33} [get_ports TDI]
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS33} [get_ports TCK]
set_property -dict {PACKAGE_PIN AG12 IOSTANDARD LVCMOS33} [get_ports TMS]
set_property -dict {PACKAGE_PIN AE13 IOSTANDARD LVCMOS33} [get_ports TDO]
set_property -dict {PACKAGE_PIN AF13 IOSTANDARD LVCMOS33} [get_ports TRST]

set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS33} [get_ports TXD]
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS33} [get_ports RXD]


#caliptra signals

set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS33} [get_ports ca_jtag_tdi]
set_property -dict {PACKAGE_PIN AD11 IOSTANDARD LVCMOS33} [get_ports ca_jtag_tms]
set_property -dict {PACKAGE_PIN AE11 IOSTANDARD LVCMOS33} [get_ports ca_jtag_tck]
set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS33} [get_ports ca_jtag_tdo]
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS33} [get_ports ca_jtag_trst_n]

set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS33} [get_ports ca_uart_tx]
set_property -dict {PACKAGE_PIN N23 IOSTANDARD LVCMOS33} [get_ports ca_uart_rx]

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


