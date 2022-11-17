## 安装编译环境和依赖

本文部分教程来源于网络，如有侵权，联系 2112888100@qq.com 删

``` html
亲测全程使用白鲸加速器速度很快，新用户免费试用30天；官网：https://www.bjchuhai.com/
极光加速器也可以用，永久免费，体验了几天，速度一般，编译过程偶尔会出错（也不一定是加速器问题，可选）

openwrt编译教程：
  https://www.jianshu.com/p/6d9a8612c5d9

git使用方法(菜鸟教程)：
  https://www.runoob.com/git/git-basic-operations.html
```

``` bash
sudo apt-get update -y    #更新软件列表
sudo apt-get install g++ -y
sudo apt-get install libncurses5-dev -y
sudo apt-get install zlib1g-dev -y
sudo apt-get install bison -y
sudo apt-get install flex -y
sudo apt-get install unzip -y
sudo apt-get install autoconf -y
sudo apt-get install gawk -y
sudo apt-get install make -y
sudo apt-get install gettext -y
sudo apt-get install gcc -y
sudo apt-get install binutils -y
sudo apt-get install patch -y
sudo apt-get install bzip2 -y
sudo apt-get install libz-dev -y
sudo apt-get install subversion -y
sudo apt-get install asciidoc -y  #这个软件400M会下载好久
```
## 下载源代码

###### openwrt默认是不允许用root编译的，所以请使用非root用户下载，以免后期出错
``` bash
git clone -b 分支
或者
wget https://github.com/openwrt/openwrt/archive/master.zip
sudu apt-get install zip
unzip master.zip

git clone https://github.com/ricemices/openwrt_mice.git openwrt
```
#### 进入目录

``` bash
cd openwrt
```
## 更新下载并安装所有可用的 feeds

``` bash
./scripts/feeds update -a
./scripts/feeds install -a
```
## 或者使用sh脚本循环执行

``` bash
#!/bin/bash

while [ 1 ]
do
  ./scripts/feeds update -a
  ./scripts/feeds install -a
done
```
## 检查还有哪些包没有安装,根据提示安装缺少的软件包

``` bash
make defconfig
make prereq
```
## 打开配置菜单

``` bash
make menuconfig
```

## 操作规则

Enter 进入子菜单/确定 空格切换软件包的状态 【*】表示编译进固件包，【M】表示编译成安装文件，【】为不做操作
<br />
左右键切换最下面的 《Select》 《 Exit 》 《 Help 》 《 Save 》 《 Load 》
<br />
< Exit > 返回上级菜单/退出
  <br />
 
## 环境（不输这行会报错）
来源：https://post.smzdm.com/p/a0d6gmzr/
<br />
``` bash
source /etc/environment
```
<br />
## 编译

``` bash
make -j8 download V=s
make -j8 V=s  #第一次更推荐你输入 make -j1 V=s 进行编译 二次编译可使用 make -j$(($(nproc) + 1)) V=s 加快编译速度
```

## 编译时遇到的问题
<p>编译失败提示</p>
<br />
``` bash
{standardinput}: Fatal error: can't close fs/namespace.o: No space left on device
```
找到出错源头，可发现时空间不足
打开ubuntu，ubuntu也提示磁盘不足，验证想法正确，对虚拟机进行扩大磁盘操作解决
<br />

``` bash
make menuconfig
->
$make menuconfig
Your display is toosmall to run Menuconfig!
```
###### 观察提示，是ssh连接的ubuntu，xshell的窗口太小了，显示不全配置菜单，放大窗口就可以了

#### 在使用ubuntu apt-get 时，我遇到过下列错误提示

``` bash
E: 无法获得锁 /var/lib/dpkg/lock - open (11: 资源暂时不可用)E: 无法锁定管理目录(/var/lib/dpkg/)，是否有其他进程正占用它？
```
###### 通过下列方法解决

``` bash
sudo rm /var/cache/apt/archives/locksudo rm /var/lib/dpkg/lock
```
#### 再次install软件，提示：

``` bash
E: dpkg 被中断，您必须手工运行 sudo dpkg --configure -a 解决此问题
```
###### 执行

``` bash
sudo dpkg --configure -a
```

## 第二次编译

记得先要输source /etc/environment

### 如果不需要更改配置：

``` bash
source /etc/environment
cd lede
git pull
./scripts/feeds update -a && ./scripts/feeds install -a
make defconfig
make -j8 download V=s
make -j$(($(nproc) + 1)) V=s
```
### 如果需要更改：

``` bash
source /etc/environment
cd lede
git pull
./scripts/feeds update -a && ./scripts/feeds install -a
rm -rf ./tmp && rm -rf .config
make menuconfig
make -j8 download V=s
make -j$(($(nproc) + 1)) V=s
```



## 主题配置
#### 如何编译Openwrt主题源码
#### 进入 OpenWRT/package/lean 或者其他目录

#### Lean源码

``` bash
cd lede/package/lean
rm -rf luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git
make menuconfig #choose LUCI->Theme->Luci-theme-argon
make -j1 V=s
```
#### Openwrt 官方源码

``` bash
cd openwrt/package
git clone https://github.com/jerrykuku/luci-theme-argon.git
make menuconfig #choose LUCI->Theme->Luci-theme-argon
make -j1 V=s
```
### 如何安装
#### Lean源码

``` bash
wget --no-check-certificate https://github.com/jerrykuku/luci-theme-argon/releases/download/v1.7.0/luci-theme-argon_1.7.0-20200909_all.ipk
opkg install luci-theme-argon*.ipk
```

#### For openwrt official 19.07 Snapshots LuCI master

``` bash
wget --no-check-certificate https://github.com/jerrykuku/luci-theme-argon/releases/download/v2.2.5/luci-theme-argon_2.2.5-20200914_all.ipk
opkg install luci-theme-argon*.ipk
```



