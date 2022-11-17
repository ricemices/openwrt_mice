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


## 添加插件说明
### LuCI ---> Applications 添加插件应用说明

#### 进入编译选项配置界面,.按照需要配置.( ‘*’ 代表编入固件，‘M’ 表示编译成模块或者IPK包， ‘空’不编译 )

##### 选择LuCI 配置 添加插件应用：常用
``` bash
-----------------------------------------------------------------------------------------
LuCI ---> Applications ---> luci-app-accesscontrol  #访问时间控制
LuCI ---> Applications ---> luci-app-adbyby-plus   #广告屏蔽大师Plus +
LuCI ---> Applications ---> luci-app-arpbind  #IP/MAC绑定
LuCI ---> Applications ---> luci-app-autoreboot  #支持计划重启
LuCI ---> Applications ---> luci-app-ddns   #动态域名 DNS（集成阿里DDNS客户端）
LuCI ---> Applications ---> luci-app-filetransfer  #文件传输（可web安装ipk包）
LuCI ---> Applications ---> luci-app-firewall   #添加防火墙
LuCI ---> Applications ---> luci-app-flowoffload  #Turbo ACC网络加速（集成FLOW,BBR,NAT,DNS...）
LuCI ---> Applications ---> luci-app-frpc   #内网穿透 Frp
LuCI ---> Applications ---> luci-app-guest-wifi  #WiFi访客网络
LuCI ---> Applications ---> luci-app-ipsec-virtual**d  #virtual**服务器 IPSec
LuCI ---> Applications ---> luci-app-mwan3   #MWAN3负载均衡
LuCI ---> Applications ---> luci-app-mwan3helper   #MWAN3分流助手
LuCI ---> Applications ---> luci-app-nlbwmon   #网络带宽监视器
LuCI ---> Applications ---> luci-app-ramfree  #释放内存
LuCI ---> Applications ---> luci-app-samba   #网络共享（Samba）
LuCI ---> Applications ---> luci-app-sqm  #流量智能队列管理（QOS）
-------------------------------------------------------------------------------------------
LuCI ---> Applications ---> luci-app-乳酸菌饮料-plus   #乳酸菌饮料低调上网Plus+
    luci-app-乳酸菌饮料-plus ---> Include s-s v贰瑞 Plugin  #SS v贰瑞插件   *
    luci-app-乳酸菌饮料-plus ---> Include v贰瑞  #v贰瑞代理
    luci-app-乳酸菌饮料-plus ---> Include Trojan  #Trojan代理
    luci-app-乳酸菌饮料-plus ---> Include red---socks2  #red---socks2代理   *
    luci-app-乳酸菌饮料-plus ---> Include Kcptun  #Kcptun加速
    luci-app-乳酸菌饮料-plus ---> Include 违禁软件 Server  #乳酸菌饮料服务器
-------------------------------------------------------------------------------------------
LuCI ---> Applications ---> luci-app-syncdial  #多拨虚拟网卡（原macvlan）
LuCI ---> Applications ---> luci-app-unblockmusic  #解锁网易云灰色歌曲3合1新版本
LuCI ---> Applications ---> luci-app-upnp   #通用即插即用UPnP（端口自动转发）
LuCI ---> Applications ---> luci-app-vlmcsd  #KMS服务器设置
LuCI ---> Applications ---> luci-app-vsftpd  #FTP服务器
LuCI ---> Applications ---> luci-app-wifischedule  #WiFi 计划
LuCI ---> Applications ---> luci-app-wirele违禁软件egdb  #WiFi无线
LuCI ---> Applications ---> luci-app-wol   #WOL网络唤醒
LuCI ---> Applications ---> luci-app-wrtbwmon  #实时流量监测
LuCI ---> Applications ---> luci-app-xlnetacc  #迅雷快鸟
LuCI ---> Applications ---> luci-app-zerotier  #ZeroTier内网穿透
Extra packages  --->  ipv6helper  #支持 ipv6
Utilities  --->  open-vm-tools  #打开适用于VMware的VM Tools

以下是全部：                               注：应用后面标记 “ * ” 为最近新添加
------------------------------------------------------------------------------------
LuCI ---> Applications ---> luci-app-accesscontrol  #访问时间控制
LuCI ---> Applications ---> luci-app-acme  #ACME自动化证书管理环境
LuCI ---> Applications ---> luci-app-adblock   #ADB广告过滤
LuCI ---> Applications ---> luci-app-adbyby-plus  #广告屏蔽大师Plus +
LuCI ---> Applications ---> luci-app-adbyby   #广告过滤大师（已弃）
LuCI ---> Applications ---> luci-app-adkill   #广告过滤（已弃）
LuCI ---> Applications ---> luci-app-advanced-reboot  #Linksys高级重启
LuCI ---> Applications ---> luci-app-ahcp  #支持AHCPd
LuCI ---> Applications ---> luci-app-aliddns   #阿里DDNS客户端（已弃，集成至ddns）
LuCI ---> Applications ---> luci-app-amule  #aMule下载工具
LuCI ---> Applications ---> luci-app-aria2 # Aria2下载工具
LuCI ---> Applications ---> luci-app-arpbind  #IP/MAC绑定
LuCI ---> Applications ---> luci-app-asterisk  #支持Asterisk电话服务器
LuCI ---> Applications ---> luci-app-attendedsysupgrade  #固件更新升级相关
LuCI ---> Applications ---> luci-app-autoreboot  #支持计划重启
LuCI ---> Applications ---> luci-app-baidupcs-web  #百度网盘管理
LuCI ---> Applications ---> luci-app-bcp38  #BCP38网络入口过滤（不确定）
LuCI ---> Applications ---> luci-app-bird1-ipv4  #对Bird1-ipv4的支持
LuCI ---> Applications ---> luci-app-bird1-ipv6  #对Bird1-ipv6的支持
LuCI ---> Applications ---> luci-app-bird4   #Bird 4（未知）（已弃）
LuCI ---> Applications ---> luci-app-bird6   #Bird 6（未知）（已弃）
LuCI ---> Applications ---> luci-app-bmx6  #BMX6路由协议
LuCI ---> Applications ---> luci-app-bmx7  #BMX7路由协议
LuCI ---> Applications ---> luci-app-caldav  #联系人（已弃）
LuCI ---> Applications ---> luci-app-cifsd  #网络共享CIFS/SMB服务器   *
LuCI ---> Applications ---> luci-app-cjdns  #加密IPV6网络相关
LuCI ---> Applications ---> luci-app-clamav  #ClamAV杀毒软件
LuCI ---> Applications ---> luci-app-commands   #Shell命令模块
LuCI ---> Applications ---> luci-app-cshark   #CloudShark捕获工具
LuCI ---> Applications ---> luci-app-ddns   #动态域名 DNS（集成阿里DDNS客户端）
LuCI ---> Applications ---> luci-app-diag-core   #core诊断工具
LuCI ---> Applications ---> luci-app-diskman   #磁盘管理工具   *
    luci-app-diskman ---> Include btrfs-progs   #新型的写时复制 (COW)
    luci-app-diskman ---> Include lsblk   #lsblk命令 用于列出所有可用块设备的信息
    luci-app-diskman ---> Include mdadm   #mdadm命令 用于创建、管理、监控RAID设备的工具
    luci-app-diskman ---> Include kmod-md-raid456   #RAID 4,5,6 驱动程序模块
    luci-app-diskman ---> Include kmod-md-linear   #RAID 驱动程序模块
LuCI ---> Applications ---> luci-app-dnscrypt-proxy  #DNSCrypt解决DNS污染
LuCI ---> Applications ---> luci-app-dnsforwarder  #DNSForwarder防DNS污染
LuCI ---> Applications ---> luci-app-dnspod  #DNSPod动态域名解析（已弃）
LuCI ---> Applications ---> luci-app-dockerman  #Docker容器   *
LuCI ---> Applications ---> luci-app-dump1090  #民航无线频率（不确定）
LuCI ---> Applications ---> luci-app-dynapoint  #DynaPoint（未知）
LuCI ---> Applications ---> luci-app-e2guardian   #Web内容过滤器
LuCI ---> Applications ---> luci-app-familycloud   #家庭云盘
LuCI ---> Applications ---> luci-app-filetransfer  #文件传输（可web安装ipk包）
LuCI ---> Applications ---> luci-app-firewall   #添加防火墙
LuCI ---> Applications ---> luci-app-flowoffload  #Turbo ACC网络加速（集成FLOW,BBR,NAT,DNS...
LuCI ---> Applications ---> luci-app-freifunk-diagnostics   #freifunk组件 诊断（未知）
LuCI ---> Applications ---> luci-app-freifunk-policyrouting  #freifunk组件 策略路由（未知）
LuCI ---> Applications ---> luci-app-freifunk-widgets  #freifunk组件 索引（未知）
LuCI ---> Applications ---> luci-app-frpc   #内网穿透Frp客户端
LuCI ---> Applications ---> luci-app-frps   #内网穿透Frp服务端   *
LuCI ---> Applications ---> luci-app-fwknopd  #Firewall Knock Operator服务器
LuCI ---> Applications ---> luci-app-guest-wifi   #WiFi访客网络
LuCI ---> Applications ---> luci-app-gfwlist   #GFW域名列表（已弃）
LuCI ---> Applications ---> luci-app-haproxy-tcp   #HAProxy负载均衡-TCP
LuCI ---> Applications ---> luci-app-hd-idle  #硬盘休眠
LuCI ---> Applications ---> luci-app-hnet  #Homenet Status家庭网络控制协议
LuCI ---> Applications ---> luci-app-ipsec-virtual**d  #virtual**服务器 IPSec
LuCI ---> Applications ---> luci-app-kodexplorer  #KOD可道云私人网盘
LuCI ---> Applications ---> luci-app-kooldns  #virtual**服务器 ddns替代方案（已弃）
LuCI ---> Applications ---> luci-app-koolproxy  #KP去广告（已弃）
LuCI ---> Applications ---> luci-app-lxc   #LXC容器管理
LuCI ---> Applications ---> luci-app-meshwizard #网络设置向导
LuCI ---> Applications ---> luci-app-minidlna   #完全兼容DLNA / UPnP-AV客户端的服务器软件
LuCI ---> Applications ---> luci-app-mjpg-streamer   #兼容Linux-UVC的摄像头程序
LuCI ---> Applications ---> luci-app-mtwifi  #MTWiFi驱动的支持   *
LuCI ---> Applications ---> luci-app-mmc-over-gpio   #添加SD卡操作界面（已弃）
LuCI ---> Applications ---> luci-app-multiwan   #多拨虚拟网卡（已弃，移至syncdial）
LuCI ---> Applications ---> luci-app-mwan   #MWAN负载均衡（已弃）
LuCI ---> Applications ---> luci-app-mwan3   #MWAN3负载均衡
LuCI ---> Applications ---> luci-app-mwan3helper   #MWAN3分流助手
LuCI ---> Applications ---> luci-app-n2n_v2   #N2N内网穿透 N2N v2 virtual**服务
LuCI ---> Applications ---> luci-app-netdata  #Netdata实时监控（图表）
LuCI ---> Applications ---> luci-app-nft-qos  #QOS流控 Nftables版
LuCI ---> Applications ---> luci-app-ngrokc  #Ngrok 内网穿透（已弃）
LuCI ---> Applications ---> luci-app-nlbwmon   #网络带宽监视器
LuCI ---> Applications ---> luci-app-noddos  #NodDOS Clients 阻止DDoS攻击
LuCI ---> Applications ---> luci-app-nps  #内网穿透nps   *
LuCI ---> Applications ---> luci-app-ntpc   #NTP时间同步服务器
LuCI ---> Applications ---> luci-app-ocserv  #OpenConnect virtual**服务
LuCI ---> Applications ---> luci-app-olsr  #OLSR配置和状态模块
LuCI ---> Applications ---> luci-app-olsr-services  #OLSR服务器
LuCI ---> Applications ---> luci-app-olsr-viz   #OLSR可视化
LuCI ---> Applications ---> luci-app-openvirtual**  #Openvirtual**客户端
LuCI ---> Applications ---> luci-app-openvirtual**-server  #易于使用的Openvirtual**服务器 Web-UI
LuCI ---> Applications ---> luci-app-oscam   #OSCAM服务器（已弃）
LuCI ---> Applications ---> luci-app-p910nd   #打印服务器模块
LuCI ---> Applications ---> luci-app-pagekitec   #Pagekite内网穿透客户端
LuCI ---> Applications ---> luci-app-polipo  #Polipo代理(是一个小型且快速的网页缓存代理)
LuCI ---> Applications ---> luci-app-pppoe-relay  #PPPoE NAT穿透 点对点协议（PPP）
LuCI ---> Applications ---> luci-app-p p t p-server  #virtual**服务器 p p t p（已弃）
LuCI ---> Applications ---> luci-app-privoxy  #Privoxy网络代理(带过滤无缓存)
LuCI ---> Applications ---> luci-app-qbittorrent  #BT下载工具（qBittorrent）
LuCI ---> Applications ---> luci-app-qos   #流量服务质量(QoS)流控
LuCI ---> Applications ---> luci-app-radicale   #CalDAV/CardDAV同步工具
LuCI ---> Applications ---> luci-app-ramfree  #释放内存
LuCI ---> Applications ---> luci-app-rp-pppoe-server  #Roaring Penguin PPPoE Server 服务器
LuCI ---> Applications ---> luci-app-samba   #网络共享（Samba）
LuCI ---> Applications ---> luci-app-samba4   #网络共享（Samba4）
LuCI ---> Applications ---> luci-app-sfe  #Turbo ACC网络加速（flowoffload二选一）
LuCI ---> Applications ---> luci-app-s-s   #SS低调上网（已弃）
LuCI ---> Applications ---> luci-app-s-s-libes  #SS-libev服务端
LuCI ---> Applications ---> luci-app-shairplay  #支持AirPlay功能
LuCI ---> Applications ---> luci-app-siitwizard  #SIIT配置向导  SIIT-Wizzard
LuCI ---> Applications ---> luci-app-simple-adblock  #简单的广告拦截
LuCI ---> Applications ---> luci-app-smartdns  #SmartDNS本地服务器（已弃）
LuCI ---> Applications ---> luci-app-softethervirtual**  #SoftEther virtual**服务器  NAT穿透   *
LuCI ---> Applications ---> luci-app-splash  #Client-Splash是无线MESH网络的一个热点认证系统
LuCI ---> Applications ---> luci-app-sqm  #流量智能队列管理（QOS）
LuCI ---> Applications ---> luci-app-squid   #Squid代理服务器
LuCI ---> Applications ---> luci-app-乳酸菌饮料-plus   #乳酸菌饮料低调上网Plus+
    luci-app-乳酸菌饮料-plus ---> Include s-s New Version  #新SS代理（已弃）
    luci-app-乳酸菌饮料-plus ---> Include s-s Simple-obfs Plugin  #simple-obfs简单混淆工具（已弃）
    luci-app-乳酸菌饮料-plus ---> Include s-s v贰瑞 Plugin  #SS v贰瑞插件   *
    luci-app-乳酸菌饮料-plus ---> Include v贰瑞  #v贰瑞代理
    luci-app-乳酸菌饮料-plus ---> Include Trojan  #Trojan代理
    luci-app-乳酸菌饮料-plus ---> Include red---socks2  #red---socks2代理   *
    luci-app-乳酸菌饮料-plus ---> Include Kcptun  #Kcptun加速
    luci-app-乳酸菌饮料-plus ---> Include 违禁软件 Server  #乳酸菌饮料服务器
    luci-app-乳酸菌饮料-plus ---> Include DNS2SOCKS  #DNS服务器（已弃）
    luci-app-乳酸菌饮料-plus ---> Include 违禁软件 Socks and Tunnel（已弃）
    luci-app-乳酸菌饮料-plus ---> Include Socks Server  #socks代理服务器（已弃）
LuCI ---> Applications ---> luci-app-乳酸菌饮料-pro  #乳酸菌饮料-Pro（已弃）
LuCI ---> Applications ---> luci-app-乳酸菌饮料server-python  #违禁软件 Python服务器
LuCI ---> Applications ---> luci-app-statistics  #流量监控工具
LuCI ---> Applications ---> luci-app-syncdial  #多拨虚拟网卡（原macvlan）
LuCI ---> Applications ---> luci-app-tinyproxy  #Tinyproxy是 HTTP(S)代理服务器
LuCI ---> Applications ---> luci-app-transmission   #BT下载工具
LuCI ---> Applications ---> luci-app-travelmate  #旅行路由器
LuCI ---> Applications ---> luci-app-ttyd   #网页终端命令行
LuCI ---> Applications ---> luci-app-udpxy  #udpxy做组播服务器
LuCI ---> Applications ---> luci-app-uhttpd  #uHTTPd Web服务器
LuCI ---> Applications ---> luci-app-unblockmusic  #解锁网易云灰色歌曲3合1新版本
    UnblockNeteaseMusic Golang Version  #Golang版本   *
    UnblockNeteaseMusic NodeJS Version  #NodeJS版本   *
LuCI ---> Applications ---> luci-app-unblockneteasemusic-go  #解除网易云音乐（合并）
LuCI ---> Applications ---> luci-app-unblockneteasemusic-mini  #解除网易云音乐（合并）
LuCI ---> Applications ---> luci-app-unbound  #Unbound DNS解析器
LuCI ---> Applications ---> luci-app-upnp   #通用即插即用UPnP（端口自动转发）
LuCI ---> Applications ---> luci-app-usb-printer   #USB 打印服务器
LuCI ---> Applications ---> luci-app-v贰瑞-server   #v贰瑞 服务器
LuCI ---> Applications ---> luci-app-v贰瑞-pro  #v贰瑞透明代理（已弃，集成乳酸菌饮料）
LuCI ---> Applications ---> luci-app-verysync  #微力同步   *
LuCI ---> Applications ---> luci-app-vlmcsd  #KMS服务器设置
LuCI ---> Applications ---> luci-app-vnstat   #vnStat网络监控（图表）
LuCI ---> Applications ---> luci-app-virtual**bypass  #virtual** BypassWebUI  绕过virtual**设置
LuCI ---> Applications ---> luci-app-vsftpd  #FTP服务器
LuCI ---> Applications ---> luci-app-watchcat  #断网检测功能与定时重启
LuCI ---> Applications ---> luci-app-webadmin  #Web管理页面设置
LuCI ---> Applications ---> luci-app-webshell  #网页命令行终端（已弃）
LuCI ---> Applications ---> luci-app-wifischedule  #WiFi 计划
LuCI ---> Applications ---> luci-app-wireguard  #virtual**服务器 WireGuard状态
LuCI ---> Applications ---> luci-app-wirele违禁软件egdb  #WiFi无线
LuCI ---> Applications ---> luci-app-wol   #WOL网络唤醒
LuCI ---> Applications ---> luci-app-wrtbwmon  #实时流量监测
LuCI ---> Applications ---> luci-app-xlnetacc  #迅雷快鸟
LuCI ---> Applications ---> luci-app-zerotier  #ZeroTier内网穿透

---------------------------------------------------------------------------------------------------
支持 iPv6：
1、Extra packages  --->  ipv6helper  （选定这个后下面几项自动选择了）
Network  --->  odhcp6c
Network  --->  odhcpd-ipv6only
LuCI  --->  Protocols  --->  luci-proto-ipv6
LuCI  --->  Protocols  --->  luci-proto-ppp
```


