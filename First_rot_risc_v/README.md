# 一级可信根(RISC_V)说明

本项目中，一级可信根设计为支持两种指令集的CPU安全启动。此文件夹为经典的RISC_V CPU Rocketchip+Caliptra1.0 架构的SoC在璞致KU060 FPGA上进行验证时所需的所有源码。

**硬件部分**摘自SoC对应的Vivado工程，包括verilog/system verilog的RTL文件、Xilinx IP核与Chipyard 自定义IP核、开发板约束文件等。

**固件部分**包括Caliptra与Rocketchip SoC端的启动程序，经脚本编译为二进制文件后，加载到各自的ROM中。

## 1.文档 ##

- [一级可信根(RISC_V)设计报告](一级可信根(RISC_V)设计报告.md)
- [软件加载说明](Software-Hardware.md)

## 2.仓库 ##

一级可信根(RISC_V)分为两个文件夹

|      仓库     | 描述 |
| ------------ | ----------- |
| [主硬件代码仓库](Hardware/)  | RTL数字逻辑设计、FPGA IP。包括全部system verilog代码...... |
| [软件代码仓库](Firmware/) | 包括SOC板级支持包、bootroom |

**已构建的FPGA工程**

通过网盘分享的文件：chipyard.fpga.ku060.KU060FPGATestHarness.CaliptraAPB32RocketKU060Config.tar.xz
链接: https://pan.baidu.com/s/1-u6s4CWvEMMPNK-4O7q3xw?pwd=1234 提取码: 1234

## 3.相关 ##
- SOC设计主要参考[Chipyard开源工程](https://github.com/ucb-bar/chipyard/)
- 一级可信根主要参考开源项目Caliptra 1.0的FPGA设计，详细内容可参考[caliptra原文档](https://github.com/chipsalliance/Caliptra/blob/main/doc/caliptra_1x/Caliptra.md#introduction/)


## 4.一级可信根RISCV SOC源代码目录
```
First_rot_risc_v/
├── readme.md
├── Hardware
│   ├── Caliptra		 Caliptra文件
│   │   ├── caliptra_rtl        Caliptra RTL库
│   │   ├── caliptra_ip         Caliptra IP核
│   │   └── apb3_caliptra.sv    Rocketchip-Caliptra wrapper
│   ├── Rocketchip		 SoC主文件(Rocketchip)
│   │   ├── rocketchip_rtl      Rocketchip RTL库
│   │   ├── rocketchip_ip       Rocketchip IP核
│   │   └── regmap    		 寄存器地址映射
│   └── KU060-constraints	 KU060开发板约束文件
└── Firmware			 SoC固件 Rocketchip、Caliptra ROM固件
    ├── build      	 固件二进制文件
    ├── src      		 固件源码
    |── ...		 编译脚本
```