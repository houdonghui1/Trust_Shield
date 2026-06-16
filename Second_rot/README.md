# 二级可信根相关材料

## 1.文档 ##

- [二级可信根硬件设计报告](二级可信根硬件设计报告.md)
- [二级可信根软件设计报告](../Second_rot_sw/二级可信根软件设计报告.md)

## 2.仓库 ##

二级可信根分为两个仓库

|      仓库     | 描述 |
| ------------ | ----------- |
| [主硬件RTL仓库](../Second_rot/)  | RTL数字逻辑设计、FPGA原型验证。包括全部system verilog代码，EDA自动化仿真脚本，FPGA构建脚本...... |
| [软件代码仓库](../Second_rot_sw/) | 包括SOC板级支持包、bootroom、虚拟机源码、PS端linux镜像、内核驱动 |

## 3.相关 ##

- 二级可信根主要参考开源项目Caliptra 1.0的FPGA设计，详细内容可参考[caliptra原文档](https://github.com/chipsalliance/Caliptra/blob/main/doc/caliptra_1x/Caliptra.md#introduction/)
- [二级可信根视频](https://space.bilibili.com/388320274/lists/5136178?type=series)

## 4.在FPGA上进行测试

FPGA 为二级可信根的实现提供了快速环境。
FPGA 构建步骤和更多详细信息请参阅
[此 README](/Second_rot/fpga/README.md)

加载 FPGA 镜像并运行测试：
