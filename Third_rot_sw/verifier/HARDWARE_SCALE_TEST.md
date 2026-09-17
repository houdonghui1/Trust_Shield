# 真实硬件虚拟节点批量测试 v2

默认10条三层链；“链数”是叶节点数量，层数始终为3。

| 链数 | 逻辑L1 | 逻辑L2 | 物理L1签名 | 物理L2签名 | L2分组聚合 | L3合并 |
|---|---:|---:|---:|---:|---:|---:|
| 10 | 10 | 1 | 10 | 1 | 1 | 1 |
| 100 | 100 | 10 | 10 | 10 | 10 | 10 |
| 1000 | 1000 | 100 | 10 | 10 | 100 | 100 |
| 10000 | 10000 | 1000 | 10 | 10 | 1000 | 1000 |

每个L2执行一次11个签名输入的聚合。L3只有一个聚合阶段，但为限制内存，它逐组调用“两签名合并”；1000条链时L3实际调用100次。缓存会复用签名值，但不会省略这些聚合调用。

## 恢复范围

原来的批量测试使用“预先相加的私钥”，已从运行路径移除，旧的两个 scale_l1_keys / scale_l2_keys 头文件已移除。修改前文件保存在工作区 artifacts/bls_scale_before_20260907，可以恢复。保留原有正常单链挑战、证书签发、低栈乘法、启动度量和UART/mailbox底层库。

v1测试协议、旧 profiles.json 与本版不兼容。普通 verifier.py 没有修改，本版用独立的 cluster_bls_hardware_scale_benchmark.py。

## 宏定义

修改三级 attestation-bls/cluster_bls_scale_config.h：

```c
#define CLUSTER_BLS_SCALE_CHAIN_COUNT CLUSTER_BLS_SCALE_CHAINS_10
```

可换成 CLUSTER_BLS_SCALE_CHAINS_100、CLUSTER_BLS_SCALE_CHAINS_1000 或 CLUSTER_BLS_SCALE_CHAINS_10000。非法档位编译报错。

验证脚本默认 --chains 0，采用三级固件宏定义。也支持 --chains 10/100/1000/10000 临时选择，无需重新烧录。一级和二级自动按请求中的节点编号/组号工作。

CLUSTER_BLS_SCALE_TEST_ENABLE 默认1；一级RT、CM3桥接头文件、二级ROM测试头文件、三级配置头文件均可设0关闭各自批量入口。所有虚拟私钥都是公开可重复生成的测试密钥。

## 实际执行

1. 完成原有设备启动、度量和证书签发，PS运行原来的 attestation_smoketest 服务。
2. 验证方等待三级0xA5就绪，发送32字节 HWB2 测试nonce。
3. 三级先签名，然后逐组请求二级。每个新nonce只让物理L1执行10次签名，二级PS把这10个签名缓存到内存，后续逻辑组循环复用，不再访问PORT3。
4. 物理L2从10个静态测试私钥中按组号循环选取一个；同一nonce下每个私钥只签一次。每个逻辑组仍真实执行一次“10个L1签名+1个L2签名”的聚合并返回子树签名和计时。
5. 三级流式合并每组签名，逐组把计时传给验证方，最后把最终聚合签名、规模和测量值写入Quote扩展块。
6. 三级用ML-DSA对PCR、nonce和扩展块签名，发送完整`#QUOTE#...#END#`包；验证方验证AK证书、nonce、ML-DSA Quote和最终BLS聚合签名后才报告成功。

批量路径支持二级PS侧CH343断线恢复。三级按当前组号持续重发，不把链路超时作为整轮失败；二级PS按challenge和组号缓存成功响应，设备节点重新出现后可直接回放当前组并从下一组继续。30秒是重发间隔，不是终止超时。

各级不会存储上万个私钥。L1和L2各使用10个固定测试私钥并循环映射到逻辑成员，公钥在主机离线生成。签名缓存只在同一nonce内有效，nonce变化后会重新生成20个物理签名。固定标量、重复身份和签名复用仅用于隔离测试聚合与最终验签性能，不代表11000个独立设备的在线签名吞吐量，也不是生产密钥派生方案。

本测试验证的是固定虚拟成员名单上的共同nonce证明及BLS聚合性能。没有签发或解析10000张X.509证书，也不计入完整证书路径策略/有效期/吊销检查。虚拟名单作为可信的预部署测试数据，不能当成生产环境的证书认证来源。

## 需要复制和编译的文件

路径相对于此工作区根目录。应同时部署本版两端协议文件，不混用v1。

| 所在工程 | 文件 | 编译/部署 |
|---|---|---|
| 二级 caliptraRomC-2nd | bootrom/src/main.c、bootrom/src/cluster_bls_scale_test.h | 编译二级ROM |
| 二级 test/caliptra_io | caliptra_io.c | 编译并按原有流程更新驱动；仅扩展测试请求/响应长度 |
| 二级 test/secure_boot | cluster_bls_relay.c | 原Makefile编译attestation_smoketest |
| 三级 attestation-bls | attestation_smoketest.c | 编译三级测试固件；最终结果中增加链路恢复时间和重试次数 |
| 验证方 verifier | attestation_scale_quote.py、cluster_bls_hardware_common.py、cluster_bls_hardware_scale_benchmark.py、generate_cluster_bls_hardware_profiles.py、cluster_bls_hardware_profiles_v2.json | Python运行 |

本次USB恢复时间扣除只要求重新编译三级测试固件，并更新验证方cluster_bls_hardware_common.py和cluster_bls_hardware_scale_benchmark.py；一级、二级的签名和聚合逻辑不变。若三级仍使用旧的168字节结果包，验证方会明确提示无法扣除恢复时间。

准确文件名以同目录实际文件和改动清单为准。run.sh、链接文件、FMC源码和镜像大小上限没有修改。RT/CM3镜像内容改变后，原系统中任何固定度量参考值都应按原流程更新；不跳过度量，不自动修改FMC策略。

本机没有用户的RISC-V GCC、ARM GCC、完整OpenTitan构建环境和真实板卡，本轮未完成目标C编译与链接。主机密码学测试不能证明镜像满足现有大小上限，也不能代替目标make/bazel链接和栈水位测试，必须以目标编译结果为准，未通过大小检查时不要烧录旧bin。

## 运行

验证方安装依赖（本地测试用了 blspy 2.0.3、pyserial 3.5）：

```bash
python3 -m pip install blspy==2.0.3 pyserial==3.5
python3 generate_cluster_bls_hardware_profiles.py --chains all
python3 bls_test.py 10
```

已经附带四档 cluster_bls_hardware_profiles_v2.json，密钥生成规则不变时无需重生成。串口使用你已确认连接三级验证UART的稳定路径，不硬编码USB1/USB2。不要同时让串口终端占用该口。

要输出并行估算毫秒数，提供三颗实际执行签名的Caliptra/三级CPU的mcycle计数频率。不是PS/CM3主频，也不是UART波特率：

```bash
python3 bls_test.py 1000 \
  --port /dev/serial/by-id/实际验证口 --chains 1000 --repeats 100 \
  --l1-clock-hz 实际L1频率 --l2-clock-hz 实际L2频率 --l3-clock-hz 实际L3频率
```

不知道主频时省略三个频率参数，脚本保存原始周期数和实测验证耗时，不伪造并行毫秒数。ready-timeout和response-timeout默认0无限等待，可设置秒数限制。先测10条，再逐档扩大；10000条只在线生成10个L1、10个L2和1个L3签名，但仍执行1000次L2分组聚合、1000次L3合并并传回1000组计时。

## 计时口径

- Pipeline：从发送nonce到收到最终结果的墙钟时间，减去失败响应等待和重试间隔；保留正常通信、签名与聚合时间。
- USB recovery excluded：三级检测到失败响应后等待恢复及重试的累计时间，不计入Pipeline。
- Final BLS verification：验证方使用预部署聚合公钥进行一次最终验签的时间。
- 提供三颗实际时钟频率时，额外输出Parallel compute estimate；JSON仍保存逐组原始周期数，方便复核。
- 多次运行只输出各项平均值，不再统计P50、P95、P99，也不再执行或统计full-member verify。

并行计算公式（周期数先除各自主频）：

```text
每组就绪时间 = max(该组10个L1签名时间的最大值, 该L2签名时间) + 该L2聚合时间
并行估算时间 = max(所有组就绪时间的最大值, L3自身签名时间) + L3逐组合并时间之和
```

这是“各组并行、L3单设备串行、等全部组就绪后合并”的估算。它不是大规模真实部署的实测并行延迟，也不包含网络拥塞、异构主频、排队和流水线重叠效果。

ECDSA对照应使用相同成员数、相同挑战语义、同一验证机和同一计时边界。当前附带的是BLS测试，不会自动把ECDSA证书验签结果当成本次对照数据。

## 内存

L1固定40字节请求和116字节回复；CM3复用原有缓冲区。L2复用原证书请求全局缓冲区，保存一组10个L1签名及1个L2签名。L3只保存当前组、累积签名和一个结果包。数组尺寸不随档位增长，增加的是循环次数及主机侧结果文件大小。

签名/解压/子群检查内部仍使用既有低栈库。当前设计只保证应用层没有按规模增长的栈数组；最坏调用链栈占用仍需目标编译的栈报告及真实硬件水位验证。

## 主机自测

```bash
python3 test_hardware_scale.py
```

覆盖四档循环密钥名单与分层聚合、nonce篡改和缺失成员拒绝、原L3公钥已知向量、Python参考实现与native输出一致、CRC拒绝、分片串口解析、连续两轮不同nonce，以及并行公式。主机模拟串口结果不代表真实板卡延迟。
