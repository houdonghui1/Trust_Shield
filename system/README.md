# 系统整体说明

## 一、系统连接关系

<div align="center">
<img src="system_image/1.png"  />
</div>

### 1.通信接口说明：

- **一级到二级**：目前一级可信根SOC端通过uart连接到uart-usb转接板，再连接至二级PS端USB口

- **一级caliptra**：uart信号连接至KU060 uart-usb，再连接至主机查看log

- **二级caliptra_pl的log打印**：二级可信根caliptra的uart连接到uart-usb转接板，再连接至二级PS端USB口，PS端可以查看log信息

- **二级的操作控制**：二级可信根PS通过网线连接网络，HOST可以通过SSH登录二级可信根Ubuntu

- **三级到二级**：三级可信根opentitan通过uart连接到uart-usb转接板，再连接至二级PS端USB口

- **三级到HOST**：三级可信根opentitan通过SAM3X将uart信号转为usb，再连接至HOST

- **三级到verify**：三级可信根opentitan通过FT4232将uart信号转为usb，再连接至verify

- **HOST和verify**：通过网络通信

### 2. pin to pin 连接表

TODO