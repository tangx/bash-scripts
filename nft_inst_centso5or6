#!/bin/bash
#
# NFS install

[ $UID -ne 0 ] && echo "Run as ROOT" && exit 99

echo -e "$(date)\nStart to nfs install"|tee $0.log
. /etc/init.d/functions

# release of CentOS
echo -e "Check that CentOS Release" |tee -a $0.log
[ -f /etc/redhat-release ] \
	&& xRelease=$(cat /etc/redhat-release |awk -F'[. ]' '{print $3}') \
	|| read -t 10 -p "Please Enter you CentOS Release with 10s [5|6]: " xRelease

case $xRelease in
5) appRpc=portmap;;
6) appRpc=rpcbind;;
*) echo "Wrong CentOS Realse" && exit 99 ;;
esac
echo -e "Your Release is ${xRelease}.x" |tee -a $0.log && sleep 2

# check that network is aviliable
echo -e "Check that network aviliable" |tee -a $0.log
ping -c 3 www.baidu.com > /dev/null 2>&1
[ $? -ne 0 ] && echo -e "\tNetwork is unaviliable" && exit 97

# nfs install
echo -e "Install nfs-utils and $appRpc by yum" |tee -a $0.log
yum -y install nfs-utils $appRpc
# 虽然客户端挂载网络硬盘不需要启动nfs服务
# 但是也必须安装 nfs-utils 组件来识别nfs文件系统。

# nfs服务端配置文件格式 /etc/exports file
echo -e "Give Usage Tips to /etc/pxports" |tee -a $0.log
[ -f /etc/exports ] && cp -a /etc/exports{,_$(date +%F_%H).save}
echo -e "# absolute path of share directory\t\tclient(parament[,para1,para2])" > /etc/exports 

# nfs启动脚本修改
# 启动nfs前检测并启动portmap或rpcbind
echo -e "Add $appRpc start before nfs start" |tee -a $0.log
sed -i '/www.uyinn.com/d' /etc/init.d/nfs
sed -i "/\bstart)/a \\\t[ \$\? -ne 0 ] && /etc/init.d/$appRpc start\\t#www.uyinn.com" /etc/init.d/nfs
sed -i "/\bstart)/a \\\t/etc/init.d/$appRpc status\\t#www.uyinn.com" /etc/init.d/nfs
sed -i "/\bstart)/a \\\t# Check that $appRpc is up.\\t#www.uyinn.com" /etc/init.d/nfs



# # 设置防火墙
# #portmap
# /sbin/iptables -A INPUT -s 192.168.1.0/254 -p tcp --dport 111 -j ACCEPT
# /sbin/iptables -A INPUT -s 192.168.1.0/254 -p udp --dport 111 -j ACCEPT
# #nfsd
# /sbin/iptables -A INPUT -s 192.168.1.0/254 -p tcp --dport 2049 -j ACCEPT
# /sbin/iptables -A INPUT -s 192.168.1.0/254 -p udp --dport 2049 -j ACCEPT
# #mountd
# /sbin/iptables -A INPUT -s 192.168.1.0/254 -p tcp --dport 1011 -j ACCEPT
# /sbin/iptables -A INPUT -s 192.168.1.0/254 -p udp --dport 1011 -j ACCEPT
# #rquotad
# /sbin/iptables -A INPUT -s 192.168.1.0/254 -p tcp --dport 1012 -j ACCEPT
# /sbin/iptables -A INPUT -s 192.168.1.0/254 -p udp --dport 1012 -j ACCEPT 

# /sbin/iptables save
# /sbin/iptables restart



# mount -t nfs 10.0.10.10:/mnt/tang dir20/
# mount -t nfs 10.0.10.10:/mnt/tangx dirt/


echo -e "nfs install done \n$(date)" |tee -a $0.log
