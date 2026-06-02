# 三级可信根相关材料

## 1.文档 ##

- [三级可信根硬件设计报告](三级可信根硬件设计报告.md)
- [三级可信根软件设计报告](../Third_rot_sw/三级可信根软件设计报告.md)

## 2.仓库 ##

三级可信根分为两个仓库

|      仓库     | 描述 |
| ------------ | ----------- |
| [主硬件RTL仓库](../Third_rot/)  | RTL数字逻辑设计、SIM仿真验证、FPGA原型验证。包括全部system verilog代码，EDA自动化仿真脚本，FPGA构建脚本...... |
| [软件代码仓库](../Third_rot_sw/) | 包括SOC板级支持包、bootroom、远程证明源码、PKI证书体系源码 |

## 3.RTL源码

已将三级可信根SOC全部[硬件源码](/Third_rot/lowrisc_systems_chip_earlgrey_cw310_0.1/src/)公开

## 4.FPGA工程

[AMD官方 VCU129 FPGA开发板](https://www.amd.com/en/products/adaptive-socs-and-fpgas/evaluation-boards/vcu129.html)为二级可信根的实现提供了快速平台。
提供一个[已构建的FPGA工程](/Third_rot/lowrisc_systems_chip_earlgrey_cw310_0.1/synth-vivado/)，请使用vivado 2021.1打开。

## 5.相关 ##

- 三级可信根主要参考开源项目Opentitan设计，详细内容可参考[opentitan原文档](https://opentitan.org/)

- 三级可信根需要VCU129开发板外接辅助硬件电路“SAM3X”，[原理图在此](/doc/sam3x.pdf)

> *注意！SAM3X需要烧写cw310板子上的SAM3X的官方固件，请参阅以下资料。*

- opentitan 原始实现平台是cw310 board。 [官方网站](https://rtfm.newae.com/Targets/CW310%20Bergen%20Board/) [参考资料](https://github.com/newaetech/cw310-bergen-board)

## 6.视频教程

视频教程参见[三级可信根专栏](https://space.bilibili.com/388320274/lists/5131095?type=series)