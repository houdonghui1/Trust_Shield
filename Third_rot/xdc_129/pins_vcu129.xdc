set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]

#opentitan TIME AND RESET
set_property -dict {PACKAGE_PIN L23 IOSTANDARD LVCMOS12} [get_ports IO_CLK]
set_property -dict {PACKAGE_PIN T34 IOSTANDARD LVCMOS18} [get_ports POR_BUTTON]

#################        ON 40P HEADER        ####################
set_property -dict {PACKAGE_PIN J33 IOSTANDARD LVCMOS18} [get_ports POR_N]


#opentitan main UART
set_property -dict {PACKAGE_PIN P36 IOSTANDARD LVCMOS18} [get_ports IOC4]
set_property -dict {PACKAGE_PIN L35 IOSTANDARD LVCMOS18} [get_ports IOC3]
#opentitan second uart connect to vcu129 FT4232HL,mabe have problems
set_property -dict {PACKAGE_PIN J32 IOSTANDARD LVCMOS18} [get_ports IOA0]
set_property -dict {PACKAGE_PIN K35 IOSTANDARD LVCMOS18} [get_ports IOA1]
# SW Straps
set_property PACKAGE_PIN L34 [get_ports IOC0]
set_property IOSTANDARD LVCMOS18 [get_ports IOC0]
set_property PULLDOWN true [get_ports IOC0]
set_property PACKAGE_PIN L33 [get_ports IOC1]
set_property IOSTANDARD LVCMOS18 [get_ports IOC1]
set_property PULLDOWN true [get_ports IOC1]
set_property PACKAGE_PIN M37 [get_ports IOC2]
set_property IOSTANDARD LVCMOS18 [get_ports IOC2]
set_property PULLDOWN true [get_ports IOC2]
# TAP Strap 1
set_property PACKAGE_PIN E22 [get_ports IOC5]
set_property IOSTANDARD LVCMOS12 [get_ports IOC5]
set_property PULLDOWN true [get_ports IOC5]
# TAP Strap 0
set_property PACKAGE_PIN C23 [get_ports IOC8]
set_property IOSTANDARD LVCMOS12 [get_ports IOC8]
set_property PULLDOWN true [get_ports IOC8]
## SPI device ����SAM3X
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVCMOS12} [get_ports SPI_DEV_CLK]
set_property -dict {PACKAGE_PIN A23 IOSTANDARD LVCMOS12} [get_ports SPI_DEV_D0]
set_property -dict {PACKAGE_PIN A24 IOSTANDARD LVCMOS12} [get_ports SPI_DEV_D1]
set_property -dict {PACKAGE_PIN B24 IOSTANDARD LVCMOS12} [get_ports SPI_DEV_D2]
set_property -dict {PACKAGE_PIN C24 IOSTANDARD LVCMOS12} [get_ports SPI_DEV_D3]
set_property -dict {PACKAGE_PIN D23 IOSTANDARD LVCMOS12} [get_ports SPI_DEV_CS_L]

#LED bottom BOARD
set_property -dict {PACKAGE_PIN AW15 IOSTANDARD LVCMOS18} [get_ports IOR6]
#GPIO RESET DISPLAY BY LED ON bottom BOARD
set_property -dict {PACKAGE_PIN AV16 IOSTANDARD LVCMOS18} [get_ports IOC12]
#LED on core board
set_property -dict {PACKAGE_PIN BA15 IOSTANDARD LVCMOS18} [get_ports IOR7]
set_property -dict {PACKAGE_PIN AY15 IOSTANDARD LVCMOS18} [get_ports IOR10]
set_property -dict {PACKAGE_PIN AV17 IOSTANDARD LVCMOS18} [get_ports IOR11]
set_property -dict {PACKAGE_PIN AU17 IOSTANDARD LVCMOS18} [get_ports IOR12]
set_property -dict {PACKAGE_PIN AY16 IOSTANDARD LVCMOS18} [get_ports IOR13]

# ChipWhisperer UART
set_property -dict {PACKAGE_PIN BA22 IOSTANDARD LVCMOS18} [get_ports IOB4]
set_property -dict {PACKAGE_PIN AY22 IOSTANDARD LVCMOS18} [get_ports IOB5]

############################  OTHERS  ##########################
#opentitan JTAG
#set_property PACKAGE_PIN AE13 [get_ports JTAG_SRST_N]
#set_property IOSTANDARD LVCMOS33 [get_ports JTAG_SRST_N]
#set_property PULLUP true [get_ports JTAG_SRST_N]

set_property PACKAGE_PIN BC36 [get_ports IOR0]
set_property IOSTANDARD LVCMOS12 [get_ports IOR0]
set_property PULLUP true [get_ports IOR0]
set_property PACKAGE_PIN BB36 [get_ports IOR1]
set_property IOSTANDARD LVCMOS12 [get_ports IOR1]
set_property PULLUP true [get_ports IOR1]
set_property PACKAGE_PIN BB37 [get_ports IOR2]
set_property IOSTANDARD LVCMOS12 [get_ports IOR2]
set_property PULLUP true [get_ports IOR2]
set_property PACKAGE_PIN BA37 [get_ports IOR3]
set_property IOSTANDARD LVCMOS12 [get_ports IOR3]
set_property PULLUP true [get_ports IOR3]

## TI TUSB1106 USB PHY usbdev testing   ����40P�ں��ڿ���Ҫ�m
set_property -dict {PACKAGE_PIN BD37 IOSTANDARD LVCMOS12} [get_ports IO_USB_DP_TX]
set_property -dict {PACKAGE_PIN BC37 IOSTANDARD LVCMOS12} [get_ports IO_USB_DN_TX]
set_property -dict {PACKAGE_PIN BD36 IOSTANDARD LVCMOS12} [get_ports IO_USB_DP_RX]
set_property -dict {PACKAGE_PIN BD35 IOSTANDARD LVCMOS12} [get_ports IO_USB_DN_RX]
set_property -dict {PACKAGE_PIN AY37 IOSTANDARD LVCMOS12} [get_ports IO_USB_CONNECT]
set_property -dict {PACKAGE_PIN BD31 IOSTANDARD LVCMOS12} [get_ports IO_USB_OE_N]
set_property -dict {PACKAGE_PIN BD34 IOSTANDARD LVCMOS12} [get_ports IO_USB_D_RX]
set_property -dict {PACKAGE_PIN BC34 IOSTANDARD LVCMOS12} [get_ports IO_USB_SPEED]
set_property -dict {PACKAGE_PIN BD33 IOSTANDARD LVCMOS12} [get_ports IO_USB_SUSPEND]
# USB VBUS Detection
set_property -dict {PACKAGE_PIN BC33 IOSTANDARD LVCMOS12} [get_ports IOC7]


#opentitan SPI sdcard
set_property -dict {PACKAGE_PIN BA33 IOSTANDARD LVCMOS12} [get_ports SPI_HOST_CLK]
set_property -dict {PACKAGE_PIN AY33 IOSTANDARD LVCMOS12 [get_ports SPI_HOST_CS_L]
set_property -dict {PACKAGE_PIN BA32 IOSTANDARD LVCMOS12} [get_ports SPI_HOST_D0]
set_property -dict {PACKAGE_PIN AY32 IOSTANDARD LVCMOS12} [get_ports SPI_HOST_D1]
set_property -dict {PACKAGE_PIN BC32 IOSTANDARD LVCMOS12} [get_ports SPI_HOST_D2]
set_property -dict {PACKAGE_PIN BB32 IOSTANDARD LVCMOS12} [get_ports SPI_HOST_D3]


################################# NO USE， CONNECT TO DDR4  ##########################
# I2C ���������ϵ�EEPROM,IOA7��clk
set_property -dict {PACKAGE_PIN AR34 IOSTANDARD LVCMOS12} [get_ports IOA7]
set_property -dict {PACKAGE_PIN AR33 IOSTANDARD LVCMOS12} [get_ports IOA8]


#��һ��RUNδ�õ���IO�ڷ���FPGA����PINS,����120P��40P��չ����?
#120P
# GPIOs
set_property -dict {PACKAGE_PIN AT35 IOSTANDARD LVCMOS12} [get_ports IOA2]
set_property -dict {PACKAGE_PIN AR35 IOSTANDARD LVCMOS12} [get_ports IOA3]
# GPIO
set_property -dict {PACKAGE_PIN AT34 IOSTANDARD LVCMOS12} [get_ports IOA6]

# Aux SPI host
set_property -dict {PACKAGE_PIN AT33 IOSTANDARD LVCMOS12} [get_ports IOB0]
set_property -dict {PACKAGE_PIN AR37 IOSTANDARD LVCMOS12} [get_ports IOB1]
set_property -dict {PACKAGE_PIN AR36 IOSTANDARD LVCMOS12} [get_ports IOB2]
set_property -dict {PACKAGE_PIN AU32 IOSTANDARD LVCMOS12} [get_ports IOB3]
# another UART
set_property -dict {PACKAGE_PIN AT32 IOSTANDARD LVCMOS12} [get_ports IOA4]
set_property -dict {PACKAGE_PIN AU37 IOSTANDARD LVCMOS12} [get_ports IOA5]
# GPIOs (DIP switches)
set_property -dict {PACKAGE_PIN AU36 IOSTANDARD LVCMOS12} [get_ports IOB6]
set_property -dict {PACKAGE_PIN AT37 IOSTANDARD LVCMOS12} [get_ports IOB7]
set_property -dict {PACKAGE_PIN AU35 IOSTANDARD LVCMOS12} [get_ports IOB8]
set_property -dict {PACKAGE_PIN AV34 IOSTANDARD LVCMOS12} [get_ports IOB9]
set_property -dict {PACKAGE_PIN AU34 IOSTANDARD LVCMOS12} [get_ports IOB10]
set_property -dict {PACKAGE_PIN AW34 IOSTANDARD LVCMOS12} [get_ports IOB11]
set_property -dict {PACKAGE_PIN AW33 IOSTANDARD LVCMOS12} [get_ports IOB12]

# PWM (PMOD2)
set_property -dict {PACKAGE_PIN AV33 IOSTANDARD LVCMOS12} [get_ports IOC6]
# GPIOs (PMOD2)
set_property -dict {PACKAGE_PIN AV32 IOSTANDARD LVCMOS12} [get_ports IOC9]
set_property -dict {PACKAGE_PIN AV37 IOSTANDARD LVCMOS12} [get_ports IOC10]
set_property -dict {PACKAGE_PIN AV36 IOSTANDARD LVCMOS12} [get_ports IOC11]

## IOR bank
set_property PACKAGE_PIN AY36 [get_ports IOR4]
set_property IOSTANDARD LVCMOS12 [get_ports IOR4]
set_property PULLUP true [get_ports IOR4]
# GPIO (LED)
set_property -dict {PACKAGE_PIN AY35 IOSTANDARD LVCMOS12} [get_ports IOR5]
set_property -dict {PACKAGE_PIN BB34 DRIVE 8 IOSTANDARD LVCMOS12} [get_ports IOR8]
set_property -dict {PACKAGE_PIN BA34 DRIVE 8 IOSTANDARD LVCMOS12} [get_ports IOR9]


## ChipWhisperer 20-Pin Connector (J14)  120P
set_property -dict {PACKAGE_PIN BB35 IOSTANDARD LVCMOS12} [get_ports IO_TRIGGER]
set_property -dict {PACKAGE_PIN BA35 IOSTANDARD LVCMOS12} [get_ports IO_CLKOUT]






