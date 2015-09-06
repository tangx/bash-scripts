#!/bin/bash
# author: sean.tangx
# mailto: uyinn@live.com

# NTP SERVER 配置文件
NTPCONF=/etc/ntp.conf

# 添加本地配置
# 设置本地限制方式,每行一个（一般可以不用）
#SUBNET=(
#10.0.10.0
#10.0.0.0
#)

# 设置上级时间服务器,每行一个
#PARENT_SERVER=(
#10.0.10.1
#)
# 是否将本机加入上级时间服务器
# 当其他服务器同步失败的时候
# 解决下级服务器同步本机时出现no server suitable for synchronization found 的错误
# 0 : 清除当前设置（如果存在）
# 1 : 使用本机作为上级服务器
# 其他 : 保持当前
PARENT_SELF=-1

# 是否禁用全网同步
# 
# 0 清除禁用规则, 1 执行禁用规则, 其他值为保持现在的情况
WILD_IGNORE=-1
#
# 设置监听网络,每行一个
# 如果WILDCARD=1需要开启此选项
# IP地址为本机网卡地址
#LISTEN_NET=(
#10.0.10.11
#)

# 用户执行权限
[ $UID -ne 0 ] && echo "Run scripts as root" && exit 1

# 安装ntp服务器
echo -n "  Install ntp by yum ...  "
ping -c 1 122.225.217.192  > /dev/null
[ $? -ne 0 ] && echo "Network does not work" && echo -e "\033[41;37m FAILED \033[0m" && exit 1
yum -y install ntp > /dev/null
[ $? -eq 0 ] && echo -e "\033[42;37m OK \033[0m" || echo -e "\033[41;37m FAILED \033[0m"

# 服务器配置
\cp $NTPCONF{,_$(date +%F_%H-%M-%S)}

# 添加限制子网
echo -n "  Set restrict subnet ...  "
for subnet in ${SUBNET[@]}
do
	[ -n $subnet ] && sed -i "/restrict 192.168.1.0/a  restrict $subnet mask 255.255.255.0 nomodify" $NTPCONF
done
[ $? -eq 0 ] && echo -e "\033[42;37m OK \033[0m" || echo -e "\033[41;37m FAILED \033[0m"


# 添加上级时间服务器
echo -n "  Set PARENT ntp server ... "
for parent_server in ${PARENT_SERVER[@]}
do
	sed -i "/server $parent_server/d" $NTPCONF
	sed -i "/consider joining/a server $parent_server" $NTPCONF
done
[ $? -eq 0 ] && echo -e "\033[42;37m OK \033[0m" || echo -e "\033[41;37m FAILED \033[0m"


# 使用本机作为上级服务器
echo -n "  Set localhost/127.0.0.1 as PARENT ntp server ... "
sed -i '/www.uyinn.com_parent-self-set/d' $NTPCONF
if [ $PARENT_SELF -eq 1 ]
then
	sed -i '/www.uyinn.com_parent-self-set/d' $NTPCONF
	sed -i "/3.centos.pool.ntp.org/a fudge 127.0.0.1 stratum 8 \t\# www.uyinn.com_parent-self-set" $NTPCONF
	sed -i "/3.centos.pool.ntp.org/a server 127.0.0.1          \t\# www.uyinn.com_parent-self-set" $NTPCONF
elif [ $PARENT_SELF -eq 0 ]
then
	sed -i '/www.uyinn.com_parent-self-set/d' $NTPCONF
fi
[ $? -eq 0 ] && echo -e "\033[42;37m OK \033[0m" || echo -e "\033[41;37m FAILED \033[0m"


# 限制监听网卡
echo -n "  Set listen interface ... "
if [ $WILD_IGNORE -eq 1 ]
then
	sed -i '/www.uyinn.com_ignore-wildcard/d' $NTPCONF
	sed -i '$ a \# listen subnet  \# www.uyinn.com_ignore-wildcard' $NTPCONF
	sed -i '$ a \# NTP Server access server  \# www.uyinn.com_ignore-wildcard' $NTPCONF
	# 
	sed -i '/NTP Server access server/a  interface listen 127.0.0.1  \# www.uyinn.com_ignore-wildcard' $NTPCONF
	sed -i '/NTP Server access server/a  interface ignore wildcard   \# www.uyinn.com_ignore-wildcard ' $NTPCONF
	
	for listen_net in ${LISTEN_NET[@]}
	do
		[ -n $listen_net ] && sed -i "/listen subnet/a interface listen $listen \# www.uyinn.com_ignore-wildcard" $NTPCONF
	done
elif [ $WILD_IGNORE -eq 0 ]
then
	sed -i '/www.uyinn.com_ignore-wildcard/d' $NTPCONF
fi
[ $? -eq 0 ] && echo -e "\033[42;37m OK \033[0m" || echo -e "\033[41;37m FAILED \033[0m"

echo -e "  chkconfig ntpd on ... \033[42;37m OK \033[0m" 
chkconfig ntpd on

echo -e "\n\nUse command \033[42m/etc/init.d/ntpd restart\033[0m to restart you ntpd server"
