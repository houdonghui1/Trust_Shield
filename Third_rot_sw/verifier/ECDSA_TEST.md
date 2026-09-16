# BLS/ECDSA三级证书验证对照测试

该测试保留现有BLS聚合路径；ECDSA分支先完成硬件挑战和Quote验证，再执行传统X.509证书逐个验签。

统一测试入口：

```bash
python3 test.py bls 1000 --repeats 1
python3 test.py ecdsa 1000 --repeats 1
```

`ecdsa`不再直接运行本地微基准。验证方等待L3的`0xa5`，发送包含规模的
32字节`ECQ1`挑战；L3向L2取得当前物理L3/L2/L1证书，并生成绑定nonce、
PCR、测试模式和成员数量的ML-DSA Quote。验证方先验证Quote和实际三层证书链，
再开始传统ECDSA P-384/SHA-384逐证书计时。

N条证书链对应N个逻辑L1证书、N/10个逻辑L2证书和1个L3根证书，
每轮传统ECDSA证书验签数量是：

```text
ECDSA验证次数 = N + N/10 + 1
```

因此1000条链验证1101张逻辑证书，10000条链验证11001张逻辑证书。默认硬件
模式使用L3实时返回的物理证书链，并通过重复验签模拟相同拓扑规模。

```bash
cd ~/work/verifier
python3 test.py ecdsa 10 --port /dev/ttyUSB2
python3 test.py ecdsa 100 --repeats 10 --port /dev/ttyUSB2
python3 test.py ecdsa 1000 --repeats 10 --port /dev/ttyUSB2
python3 test.py ecdsa 10000 --repeats 10 --port /dev/ttyUSB2
```

只有显式指定`--offline`时才允许不连接硬件的本地微基准：

```bash
python3 test.py ecdsa 1000 --offline
```

ECDSA结果中的`quote`是挑战发出至Quote完成验证的时间；`verify`只包含逐证书
签名验证时间。证书传输、Quote生成和证书准备不混入`verify`。默认模式需要重新
编译并烧录三级`attestation-bls/attestation_smoketest.c`；一级和二级的签发、
聚合代码不需要因为这次修正而重编。
