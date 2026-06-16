# 二级可信根相关材料

## 1.文档 ##

- [二级可信根硬件设计报告](../Second_rot/二级可信根硬件设计报告.md)
- [二级可信根软件设计报告](二级可信根软件设计报告.md)
- [二级可信根软件环境搭建](./二级可信根软件环境搭建.md)
- [二级可信根软件测试报告](./二级可信根软件测试报告.md)

## 2.仓库 ##

二级可信根分为两个仓库

|      仓库     | 描述 |
| ------------ | ----------- |
| [主硬件RTL仓库](../Second_rot/)  | RTL数字逻辑设计、FPGA原型验证。包括全部system verilog代码，EDA自动化仿真脚本，FPGA构建脚本...... |
| [软件代码仓库](../Second_rot_sw/) | 包括SOC板级支持包、bootroom、虚拟机源码、PS端linux镜像、内核驱动 |

## 3.相关 ##

- 二级可信根主要参考开源项目Caliptra 1.0的FPGA设计，详细内容可参考[caliptra原文档](https://github.com/chipsalliance/Caliptra/blob/main/doc/caliptra_1x/Caliptra.md#introduction/)

## 4.二级可信根源代码目录
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
    ├── qemu-virt-tpm       最小虚拟机镜像
    ├── start.sh            自动化启动脚本
    └── mainloop_patch.patch	SWTPM的补丁
```
> *注意：qemu-virt-tpm 最小虚拟机镜像文件太大，单独放入百度网盘中。链接: https://pan.baidu.com/s/1fBKcjLoIBRTiUkgzx1Izag?pwd=xc2j 提取码: xc2j*