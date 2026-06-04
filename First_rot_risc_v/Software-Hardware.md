# 软件加载到固件：

### SoC端Bootrom代码：

- 在`/mnt/data/Desktop/Soc/chipyard/fpga/src/main/scala/ku060/Configs.scala`中，可以找到
  `p.copy(hang = 0x10000, contentFileName = s"./fpga/src/main/resources/ku060/socboot/build/bootrom.bin")`这行。修改后的bootrom代码要存放在后者路径中，保证与之一致。

- 在`/mnt/data/Desktop/Soc/chipyard/fpga/src/main/scala/ku060/Configs.scala`中增加代码：

- ````
  class BootromRocketKU060Config extends Config(
    new WithKU060Tweaks ++
    new chipyard.CaliptraAPB32RocketConfig
  )
  ````

- 在终端中运行：

- ````
  source /mnt/data/Desktop/Vivado/Vivado/2022.2/settings64.sh && cd /mnt/data/Desktop/Soc/chipyard && source ./env.sh
  cd fpga && make SUB_PROJECT=ku060 CONFIG=BootromRocketKU060Config bitstream
  ````

- 运行时打开`/home/foolfish/Soc/chipyard/fpga/generated-src/chipyard.fpga.ku060.KU060FPGATestHarness.BootromRocketKU060Config`路径。当终端中出现vivado字样时，在该路径中能够搜索到TLROM.sv文件，此时可终止运行。

- vivado中，用上面的文件替换掉`/mnt/data/Desktop/Soc/chipyard/fpga/generated-src/chipyard.fpga.ku060.KU060FPGATestHarness.CaliptraAPB32RocketKU060Config/gen-collateral/TLROM.sv`。

### Caliptra端rom代码：

- 固化在imem ip中，打开vivado IP resources可找到。

### firmware：

- SD卡中存放，将由SoC Bootrom加载到片内存储。