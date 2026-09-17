# 三级可信根相关材料

本目录包含基于 VCU129 与 OpenTitan 的三级可信根固件、可信第三方证书签发工具和验证方程序。当前支持多级证书签发、BLS 聚合远程证明，以及 BLS 与 ECDSA 的大规模逻辑证书链对照测试。

## 1. 文档

- [三级可信根硬件设计报告](../Third_rot/三级可信根硬件设计报告.md)
- [三级可信根软件设计报告](三级可信根软件设计报告.md)
- [三级远程证明源代码解析](三级远程证明源代码解析.md)

设计报告和源码解析中部分流程、行号来自早期版本；当前运行入口、目录及测试方式以本 README 和对应代码为准。

## 2. 仓库

| 仓库 | 描述 |
| --- | --- |
| [主硬件 RTL 仓库](../Third_rot/) | RTL 数字逻辑设计、仿真验证、FPGA 原型验证及构建脚本。 |
| [软件代码仓库](../Third_rot_sw/) | OpenTitan 设备侧固件、PKI 证书管理、BLS 聚合证明及验证方测试工具。 |

## 3. 平台与主要功能

三级可信根主要参考开源项目 [OpenTitan](https://opentitan.org/) 设计。

使用的 OpenTitan 源码基线 commit：`ebf2af73c5e6e707dce86aef1e5a931d018f36ee`。

- **证书签发**：可信第三方签发三级 AK 证书，三级签发二级设备证书，二级签发一级设备证书。
- **BLS 静态绑定**：三级 AK、二级和一级设备证书增加非关键扩展 `1.3.6.1.4.1.55555.1.1`，包含协议版本、算法套件、密钥标识、48 字节 BLS 公钥及 96 字节私钥持有证明 PoP；证书仍使用 ECDSA 签发。
- **BLS 聚合证明**：各级对共同挑战摘要签名，二级完成分组聚合，三级汇总后形成 96 字节最终聚合签名。
- **Quote 认证**：三级使用 ML-DSA-87 签名；验证方检查 AK 证书、PCR、Nonce、ML-DSA 签名和所选模式的证明结果。
- **ECDSA 对照测试**：二级逐一验证一级证书，三级逐一验证二级证书，验证方验证三级 AK 证书，分级结果通过 Quote 返回。

## 4. 源代码文件目录

### 三级可信根运行代码

`3rd/` 中直接存放固件源码，完整内容部署到 OpenTitan 工程的 `sw/device/my_tests/attestation/`。

```text
3rd/
├── attestation_smoketest.c        启动、证书签发、远程证明及批量测试主流程
├── attestation.c / attestation.h  设备侧密码与通信支持
├── BUILD                         OpenTitan Bazel 构建配置
├── cluster_bls_scale_config.h    BLS 批量测试开关及默认规模
├── bls/                          BLS、证书扩展、分层聚合及 blst 库
├── x509/                         X.509 证书生成、解析与校验
├── sha/                          摘要算法源码
├── ecdsa-p384/                   ECDSA P-384 算法源码
├── vendor_mldsa/                 ML-DSA-87 软件实现
├── ecdsa_scale.h                 ECDSA 测试数据与辅助定义
├── ecdsa_scale_opentitan.h       ECDSA 独立签名测试支持
└── ecdsa_scale_stream.h          ECDSA 测试数据传输支持
```

### 可信第三方工具

```text
privacy_CA/
├── start.sh                      串口采集、AK 证书签发及回传入口
├── serial_capture_ak_ek.py        采集 EK、AK、ML-DSA 公钥和 BLS 注册信息
├── build_ek_cert.py               解析 EK 证书
├── build_ak_pubkey.py             解析 AK 公钥
├── build_mldsa_pubkey.py          解析 ML-DSA 公钥
├── create_ca_root.sh             创建根 CA；已有根证书时复用
├── sign_ak_cert_by_ca.sh          签发含 ML-DSA 和 BLS 扩展的 AK 证书
├── issue_cluster_certificate.py  BLS 注册信息检查与证书扩展处理
├── protocol.py                   BLS 编码、PoP 与证书绑定校验
├── serial_send_ak_cert.py         加密并回传 AK 证书
├── dev_pubkey_whitelist.txt       EK 公钥白名单
├── ca_root.cnf                   CA 配置
└── ca/                           CA 证书、私钥及签发状态
```

### 验证方工具

```text
verifier/
├── test.py                                  BLS / ECDSA 硬件规模测试统一入口
├── bls_test.py                              BLS 测试简化入口
├── cluster_bls_hardware_scale_benchmark.py  BLS 分组收集、聚合验签与计时
├── cluster_bls_hardware_common.py           批量协议、名单及计时辅助
├── cluster_bls_hardware_profiles_v2.json    四档预置逻辑成员公钥名单
├── generate_cluster_bls_hardware_profiles.py 生成上述测试名单
├── ecdsa_test.py                            分布式逐级 ECDSA 证书验证测试
├── attestation_scale_quote.py              两种规模测试共用的 Quote 解析与验证
├── verifier.py                             普通三级单链远程证明入口
├── cluster_bls_verifier.py                  BLS 名单与聚合证明校验支持
├── protocol.py                             BLS 协议与证书绑定校验
├── ca_root.crt                             验证方预置的可信 CA 根证书
├── pcr_expect.txt                          可信 PCR 基准值
└── libmldsa_verify.so                       主机端 ML-DSA 验签动态库
```

目录中其他测试脚本和历史输出用于调试；硬件规模对照测试统一使用 `test.py`。

## 5. 固件编译

将 `3rd/` 的完整内容放入匹配版本的 OpenTitan 工程，保留 `sha/`、`bls/`、`vendor_mldsa/` 等子目录。在 OpenTitan 工程根目录执行：

```bash
bazel build //sw/device/my_tests/attestation:attestation_smoketest --define bitstream=skip
```

沿用当前平台的下载流程，烧录本次构建成功生成的 `attestation_smoketest_prog_fpga_cw310.bin`。目标名中的 `cw310` 沿用构建配置，当前硬件平台仍为 VCU129。

三级、二级 PS 服务、二级 Caliptra、一级 CM3 与 Caliptra RT 应使用相互匹配的协议版本。更新固件后，按原有流程检查相关度量基准；仅切换已支持的测试规模或 BLS/ECDSA 模式，无需重新编译固件。

## 6. 运行准备与顺序

以下主机命令在 Linux 环境执行，目录按实际部署位置调整。

### 环境与串口

主机需要 Python 3、Bash、OpenSSL、`xxd`，以及 `pyserial`、`cryptography`、`asn1crypto` 和 `blspy`。采用 `sudo python3` 运行时，依赖也应在该解释器环境中可用：

```bash
sudo python3 -m pip install pyserial==3.5 blspy==2.0.3 cryptography asn1crypto
```

可信第三方及普通 `verifier.py` 的 `protocol.py` 还依赖 `bls-signatures/python-impl`。将配套参考实现部署在程序目录的某个上级目录下，或通过 `BLS_PYTHON_IMPL` 指定其绝对路径；仅安装 `blspy` 不能替代这部分依赖。`libmldsa_verify.so` 需与验证主机架构及运行环境匹配。

| 三级固件接口 | 用途 | 主机设置 |
| --- | --- | --- |
| UART0 | 可信第三方注册、AK 证书下发与交互打印 | 核对 `serial_capture_ak_ek.py` 和 `serial_send_ak_cert.py` 中的 `SERIAL_PORT`；当前默认 `/dev/ttyACM1`。 |
| UART1 | 验证方挑战与 Quote 返回 | 测试命令使用 `--port` 指定，或设置 `VERIFIER_SERIAL_PORT`。 |
| UART2 | 三级与二级可信根交互 | 由现有板间连接和二级 PS 程序配置决定。 |

串口波特率为 115200。固件 UART 编号不等于 Linux 的 `ttyUSB` 编号；验证方优先使用已确认对应验证通道的 `/dev/serial/by-id/` 路径，同一端口只由一个程序读取。可信第三方的采集脚本会检查枚举节点名称，两个 `SERIAL_PORT` 应填入 `python3 -m serial.tools.list_ports -v` 列出的实际设备节点。

### 启动流程

1. 在可信第三方主机进入 `privacy_CA/`，执行 `sudo ./start.sh`，出现等待串口数据提示后，再启动或复位三级设备。脚本采集本次启动的 EK、AK、ML-DSA 和 BLS 信息，签发并回传 AK 证书。已有根 CA 会复用，无需每轮重新生成。
2. 三级提示 `Press '1' to print the certificate.` 后，按原流程在 UART0 输入 `1`，继续证书解密和后续流程。
3. 二级按原有开机 `run.sh` 完成三级对二级的度量、二级证书安装，以及一级度量和证书签发。完成后启动二级 PS 的 `attestation_smoketest` 服务；若脚本已经启动该服务，不重复运行。
4. 三级进入 `Waiting to receive [nonce].`、二级服务准备就绪后，在验证方执行下一节测试命令。

如果参考实现不在自动搜索路径内，启动可信第三方时使用：

```bash
sudo env BLS_PYTHON_IMPL=/path/to/bls-signatures/python-impl ./start.sh
```

这里的路径需替换成实际部署路径。二级 PS 手动启动服务的命令为：

```bash
cd ~/work/test/secure_boot
sudo ./attestation_smoketest
```

验证前，将签发当前 AK 证书的 `privacy_CA/ca/ca_root.crt` 公共证书部署到验证方 `verifier/ca_root.crt`，并核对 `pcr_expect.txt` 中的 32 字节可信基准值（64 个十六进制字符）。

## 7. BLS 与 ECDSA 规模测试

### 测试命令

在验证方进入 `verifier/`。串口已正确配置时，使用：

```bash
sudo python3 test.py bls 10
sudo python3 test.py ecdsa 10
```

将 `10` 替换为 `100`、`1000` 或 `10000` 即可切换规模。命令中的数值表示逻辑证书链条数，链的设备层级始终为三级。

需要指定验证串口、重复次数和结果文件时，例如：

```bash
sudo python3 test.py bls 1000 --port /dev/serial/by-id/实际验证口 --repeats 3 --output bls_results_1000.json
sudo python3 test.py ecdsa 1000 --port /dev/serial/by-id/实际验证口 --repeats 3 --output ecdsa_results_1000.json
```

`实际验证口` 必须替换为本机已有的设备名称。默认路径包含开发板的设备序列号，更换主机或设备后需重新核对。

普通单链证明仍使用 `sudo python3 verifier.py`，其串口通过 `VERIFIER_SERIAL_PORT` 设置；例如 `sudo env VERIFIER_SERIAL_PORT=/dev/serial/by-id/实际验证口 python3 verifier.py`。它不会因为修改规模宏而自动执行批量测试。`ecdsa --offline` 属于显式离线测试，不用于这里的三层硬件对照。

### 规模与执行方式

每 10 个逻辑一级节点对应 1 个逻辑二级节点，三级节点为 1 个：

| 证书链数量 | 逻辑一级节点 | 逻辑二级节点 | 逻辑三级节点 | 设备总数 |
| --- | --- | --- | --- | --- |
| 10 | 10 | 1 | 1 | 12 |
| 100 | 100 | 10 | 1 | 111 |
| 1000 | 1000 | 100 | 1 | 1101 |
| 10000 | 10000 | 1000 | 1 | 11001 |

- **BLS**：每轮新挑战由物理一级生成 10 个签名，后续逻辑组复用；二级使用 10 个缓存测试密钥按组映射，同一挑战下每个使用到的密钥只签一次。每组仍实际聚合 10 个一级签名和 1 个二级签名，三级逐组合并并加入自身签名，验证方使用预置名单对应的聚合公钥完成最终验签。
- **ECDSA**：二级重复验证一级设备证书 N 次，三级重复验证二级设备证书 N/10 次，验证方验证三级 AK 证书 1 次；总次数为 N + N/10 + 1。分级验证结果由三级写入 Quote 并签名。
- **共同认证**：两种硬件测试都下发新挑战、接收 Quote，并检查 AK 证书、PCR、Nonce 和 ML-DSA 签名。BLS 模式继续检查最终聚合签名；ECDSA 模式检查分级验证状态和完成数量。

默认 BLS 规模在 `3rd/cluster_bls_scale_config.h` 中配置：

```c
#define CLUSTER_BLS_SCALE_TEST_ENABLE 1
#define CLUSTER_BLS_SCALE_CHAIN_COUNT CLUSTER_BLS_SCALE_CHAINS_10
```

宏支持 `CLUSTER_BLS_SCALE_CHAINS_10`、`_100`、`_1000`、`_10000`。通过 `test.py` 明确指定的规模优先；BLS 底层脚本使用 `--chains 0` 时才采用固件默认规模。

### Quote 与结果含义

当前规模测试的 Quote 包含 AK 证书、PCR、Nonce、138 字节认证块和 ML-DSA 签名。认证块前 42 字节记录状态、模式、链数、成员数、挑战摘要前缀和保留字节；后 96 字节在 BLS 模式保存聚合签名，在 ECDSA 模式保存分级验证结果、周期数及保留空间。该块通过串口发送时编码为 276 个 HEX 字符。

ML-DSA 签名覆盖 `SHA-256(PCR || Nonce || 完整认证块)`。两种模式当前使用相同长度的认证块，Quote 总长度还取决于实际 AK 证书长度。

| 打印项 | BLS 模式 | ECDSA 模式 |
| --- | --- | --- |
| Chains / Devices | 逻辑链数 / 逻辑设备总数 | 逻辑链数 / 逻辑设备总数 |
| Total time | 挑战发出至 Quote 验证完成，扣除三级报告的失败等待和重试间隔 | 挑战发出至 Quote 验证完成的总时间 |
| Aggregation time | 二级分组聚合时间与三级合并时间之和 | 不适用 |
| Verification time | 验证方使用缓存聚合公钥的最终 BLS 验签时间 | 二级验证一级、三级验证二级、验证方验证三级的时间之和 |

比较核心操作开销时，使用 **BLS Aggregation time + Verification time** 对比 **ECDSA Verification time**；这项比较不包含签名生成、通信和 Quote 处理时间。

设备周期数按 `--l2-clock-hz` 和 `--l3-clock-hz` 换算；当前脚本默认分别为 100 MHz 和 24 MHz，应按实际执行密码运算的 CPU 计数频率核对。BLS 默认结果写入 `hardware_scale_results_v2.json`，ECDSA 默认写入 `ecdsa_results_链数.json`；可用 `--output` 分别保存各轮结果。

### 测试边界

测试基于一个三级、一个二级和一个一级物理设备，通过逻辑节点扩展测量不同规模的运算开销。BLS 复用测试密钥及同一挑战下的签名，ECDSA 复用物理设备证书；结果反映当前串行执行条件下的性能变化，不等同于大量独立设备并行部署后的响应延迟。固定测试密钥和逻辑成员名单仅用于原型测试。

BLS 分组路径支持二级串口掉线后的重试续传，前提是设备重新枚举且相关程序状态仍可恢复；主机 USB 控制器停止响应等情况需要先恢复硬件链路。
