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

## 3.开发环境

三级可信根主要参考开源项目Opentitan设计，提供本项目所使用的[开发环境](./opentitan/)。用户可在此环境下进行RTL开发、SOC集成、硬件仿真以及FPGA构建。

总结了几个开发过程中常用的流程，可快速上手。详细用法和步骤可参考[opentitan原文档](https://opentitan.org/)

[opentitan软件编写测试](./optt_doc/opentitan软件编写测试.pdf)

[opentitan硬件HW开发](./optt_doc/opentitan硬件HW开发.pdf)

[opentitan综合](./optt_doc/opentitan综合.pdf)

[VCU129的综合策略](./optt_doc/notice/)

> *注意！本人已对原始opentitan进行二次开发，opentitan原文档仅作参考。如有疑问请在Issues中提出*

## 4.硬件RTL

已将三级可信根SOC全部[硬件源码](/Third_rot/lowrisc_systems_chip_earlgrey_cw310_0.1/src/)公开

## 5.FPGA工程

[AMD官方 VCU129 FPGA开发板](https://www.amd.com/en/products/adaptive-socs-and-fpgas/evaluation-boards/vcu129.html)为二级可信根的实现提供了快速平台。
提供一个[已构建的FPGA工程](/Third_rot/lowrisc_systems_chip_earlgrey_cw310_0.1/synth-vivado/)，请使用vivado 2021.1打开。

## 6.相关 ##

- 三级可信根需要VCU129开发板外接辅助硬件电路“SAM3X”，[原理图在此](/doc/sam3x.pdf)

> *注意！SAM3X需要烧写cw310板子上的SAM3X的官方固件，请参阅以下资料。*

- opentitan 原始实现平台是cw310 board。 [官方网站](https://rtfm.newae.com/Targets/CW310%20Bergen%20Board/) [参考资料](https://github.com/newaetech/cw310-bergen-board)

## 6.视频教程

视频教程参见[三级可信根专栏](https://space.bilibili.com/388320274/lists/5131095?type=series)