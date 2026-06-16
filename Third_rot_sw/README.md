# 三级可信根相关材料

## 1.文档 ##

- [三级可信根硬件设计报告](../Third_rot/三级可信根硬件设计报告.md)
- [三级可信根软件设计报告](三级可信根软件设计报告.md)
- [三级远程证明源代码解析](./三级远程证明源代码解析.md)

## 2.仓库 ##

三级可信根分为两个仓库

|      仓库     | 描述 |
| ------------ | ----------- |
| [主硬件RTL仓库](../Third_rot/)  | RTL数字逻辑设计、SIM仿真验证、FPGA原型验证。包括全部system verilog代码，EDA自动化仿真脚本，FPGA构建脚本...... |
| [软件代码仓库](../Third_rot_sw/) | 包括SOC板级支持包、bootroom、远程证明源码、PKI证书体系源码 |

## 3.相关 ##

三级可信根主要参考开源项目Opentitan设计，详细内容可参考[opentitan原文档](https://opentitan.org/)

## 4.源代码文件目录

> *使用的Oentitan源码 commit ： ebf2af73c5e6e707dce86aef1e5a931d018f36ee*

### 三级可信根运行代码
```

3rd/
├── attestation					三级可信根远程证明测试源码
└── attestation_smoketest_prog_fpga_cw310.bin		三级可信根远程证明测试编译出来的bin文件

```
### 可信第三方测试工具
```
privacy_CA/
├── build_ak_pubkey.py                     		解析AK公钥的脚本
├── build_ek_cert.py                     		解析EK证书的脚本
├── build_mldsa_pubkey.py				解析MLDSA公钥的脚本
├── ca                     				生成的CA证书
├── create_ca_root.sh                     		生成CA证书的脚本
├── dev_pubkey_whitelist.txt				EK证书白名单
├── serial_capture_ak_ek.py                     	串口接收脚本
├── serial_send_ak_cert.py                     	串口发送脚本
├── sign_ak_cert_by_ca.sh				CA签发AK证书的脚本
└── start.sh			 			一键测试脚本

```

### 验证者测试工具
```
verifier/
├── ca_root.crt                     			可信第三方部署的CA证书
├── libmldsa_verify.so                     		native-mldsa软件动态库
├── pcr_expect.txt                     		PCR白名单
└── verifier.py					一键测试脚本

```
