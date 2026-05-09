# UU OpenWrt插件
UU加速器OpenWrt安装包

## 安装
OpenWrt 25.12及以后：
```shell
cd /tmp
pkg_name=uuplugin-latest-$(grep '^DISTRIB_ARCH' /etc/openwrt_release | awk -F "'" '{print $2}').apk
wget "https://github.com/ttc0419/uuplugin/releases/download/latest/$pkg_name" && apk add --allow-untrusted $pkg_name || echo "You router is not supported!"
```

OpenWrt 25.12之前：
```shell
cd /tmp
pkg_name=uuplugin_latest-1_$(grep '^DISTRIB_ARCH' /etc/openwrt_release | awk -F "'" '{print $2}').ipk
wget "https://github.com/ttc0419/uuplugin/releases/download/latest/$pkg_name" && opkg install $pkg_name || echo "You router is not supported!"
```

## 架构支持
目前网易官方支持aarch64, arm, mpisel和x86_64。前三种架构官方没有说明哪几种子架构支持。
如果你认为插件支持额外子架构或某些子架构其实不支持，请创建新的issue说明。
当前支持列表根据objdump所用的指令为依据。

以下几种情况不提供支持：
1. 最新发布版本无此架构
2. 架构所支持的路由器在中国使用率过少
3. 架构不在OpenWrt官方支持列表中

## 系统支持
加速器现阶段还是使用```iptables```配置防火墙规则，理论上只支持OpenWrt 21及之前的系统版本，22及之后的版本可以尝试安装```iptables-nft```来兼容。

## 捐助
开源不易，如果项目有帮到你，能投喂一下嘛 😉

| [![PayPal](/images/paypal.svg)](https://www.paypal.me/ttc0419)<br/>Click [here](https://www.paypal.me/ttc0419) to donate | ![Wechat Pay](/images/wechat.jpg)<br/>Wechat Pay | ![Alipay](/images/alipay.jpg) Alipay |
|--------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------|--------------------------------------|
