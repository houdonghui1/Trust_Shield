## **二级可信根源代码** ##
```
trust_root_2nd_1014/
├── caliptraROMC-2nd
│   ├── bootrom             主程序源代码
│   ├── build		     中间文件
│   ├── inc		     硬件平台头文件
│   ├── libs		     功能库文件
│   ├── output		     输出文件
│   ├── Makefile	     编译脚本
│   └── txt2coe.sh	     生成Xilinx FPGA COE格式文件脚本
└── test
    ├── caliptra_io         内核驱动
    ├── caliptra_rom        烧写CaliptraROM的软件源码
    ├── caliptra-sw         PL端的bin文件和烧写脚本
    ├── secure_boot         安全启动、证书链软件源码/开机自启动脚本
    ├── qemu-virt-tpm       最小虚拟机镜像
    ├── start.sh            自动化启动脚本
    └── mainloop_patch.patch	SWTPM的补丁
```
> *注意：qemu-virt-tpm 最小虚拟机镜像文件太大，单独放入百度网盘中。链接: https://pan.baidu.com/s/1fBKcjLoIBRTiUkgzx1Izag?pwd=xc2j 提取码: xc2j*