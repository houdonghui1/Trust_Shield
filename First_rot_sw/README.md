
# **Trust_arm_soc_rot_sw** #

## **1 简介** ##

这是Trust_arm_soc_rot的软件设计仓库，主要完成SOC安全启动和DICE身份认证功能，包括了ARM及安全协处理器的rom固件，外设板级支持包，待校验运行时固件。

<div align="center">
<img src="doc/image/sw_full.png" alt="alt" width="100%" />
</div>
<div align="center">
SOC安全启动和身份认证流程图
</div>


## 2 文档 ##


- [安全软件源代码解析](doc/安全软件源代码解析.md)
- [SD卡和Debug说明](doc/SD卡和Debug说明.md)
- [FPGA运行测试说明](doc/FPGA运行测试说明.md)

## 3 相关仓库 ##

本SOC设计分为两个仓库

|      仓库     | 描述 |
| ------------ | ----------- |
| [主硬件RTL仓库](../First_rot/)  | RTL数字逻辑设计、SIM仿真验证、FPGA原型验证。包括全部system verilog代码，EDA自动化仿真脚本，FPGA构建脚本...... |
| [软件代码仓库](../First_rot_sw)| 包括SOC板级支持包、bootroom、runtime源码、SD卡image |

## 4 开发和维护 ##
软件代码由邓杰开发

软件仓库由侯冬辉维护