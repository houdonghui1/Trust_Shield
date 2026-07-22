#===============================================
#
#		File: makefile
#		Author: afterGlow,4ever
#		Group: Fall For Laboratory
#		Date: 07292023
#		Version: v1.0
#
# 	This is script top for any operation in this project.
# 	Including:
# 	1. RTL & fpga simulation
# 	2. RTL auto generation
# 	3. FW build
# 	4. cpu boot simulation
# 	5. fpga synthesis
#
#===============================================

#===============================================
# RTL & fpga simulation 
# system intergration
#===============================================

#===============================================
# firmware build
#===============================================

bootloader:
	make -f makefile.bootloader

fw:
	make -f makefile.fw

fw_test:
	make -f makefile.fw_test

fw_bin_test:
	make -f makefile.fw_bin_test

clean:
	rm -rf ../project/firmware_sdk/bootloader

#===============================================
# cpu boot simulation
#===============================================
