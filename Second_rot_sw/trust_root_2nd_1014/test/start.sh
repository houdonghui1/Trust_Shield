#/bin/bash

CUR_PATH=$(pwd)
WORK_PATH="$HOME/work"
PL_PATH="$WORK_PATH/caliptra-sw/hw/fpga"

#烧写PL端，加载caliptra kernel modules
cd "$PL_PATH" 

sudo ./setup_fpga.sh caliptra_fpga.bin

#烧写CaliptraROM，并配置启动
cd "$CUR_PATH/caliptra_rom"

./caliptra_rom_program

sudo /usr/bin/devmem2 0x80000030 w 0x1C
sudo /usr/bin/devmem2 0x80000030 w 0x1D
sudo /usr/bin/devmem2 0x80000038 w 0xFFFFFFFF
sudo /usr/bin/devmem2 0x80000030 w 0x1F

for i in {0..1024}; do
	timestamp=$(date +%s)
	hex_time=$(printf "%08x" $timestamp)
	sudo /usr/bin/devmem2 0x80001008 w 0x$hex_time
done

sudo /usr/bin/devmem2 0x900300B0 w 0x1

#创建Caliptra_dev字符设备
cd "$CUR_PATH/caliptra_io"

sudo insmod caliptra_dev.ko

if [ "$1" = "qemu" ]; then
#创建和运行SWTPM
cd "$CUR_PATH/qemu-virt-tpm"

sudo rm -rf /tmp/mytpm1
sudo rm -f /dev/vtpm0

sudo mkdir -p /tmp/mytpm1
sudo chown -R ubuntu:ubuntu /tmp/mytpm1

sudo swtpm_setup --tpm-state /tmp/mytpm1 --createek
export TPM_PATH=/tmp/mytpm1

sudo mknod /dev/vtpm0 c 10 224
sudo chown tss:root /dev/vtpm0
sudo chmod 0660 /dev/vtpm0

sudo swtpm socket \
	--tpm2 \
	--tpmstate dir=/tmp/mytpm1 \
      	--ctrl type=unixio,path=/tmp/mytpm1/swtpm-sock \
      	--log level=20 &

sleep 1
sudo chown ubuntu:ubuntu /tmp/mytpm1/swtpm-sock
sudo chmod 660 /tmp/mytpm1/swtpm-sock

#启动虚拟机
./start_minimal_ubuntu.sh
fi

