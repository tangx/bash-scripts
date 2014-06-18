#!/bin/bash

# pptpd vpn only
# run in CentOS6.x
#
# uyinn/vpn_setup/pptp-only-centos.sh
#
# @author: uyinn.tang
# @mailto: uyinn@live.com




[ $UID -ne 0 ] && echo "run as ROOT user" && exit 1

PermDeny=$(cat /dev/ppp | grep "Operation not permitted" |wc -l)
[ $PermDeny -eq 1 ] && echo "Permission Denied: no right to setup pptp vpn"  && exit 1

# PARAMENTS
VPN_LOCAL=192.168.100.254
VPN_REMOTE=192.168.100.100-200
# use the best dns-server in your country, seperate by blank
DNS_SERVER=(208.67.222.222 112.90.143.29)

# VPN_IP can be ip or domain
VPN_IP=$(curl ifconfig.me)
VPN_USER=vpnuser
VPN_PASS=vpnpass

(

rpm -Uvh http://poptop.sourceforge.net/yum/stable/rhel6Server/pptp-release-current.noarch.rpm
yum -y install ppp pptpd iptables

##############
# pptpd config
echo "localip $VPN_LOCAL" >> /etc/pptpd.conf
echo "remoteip $VPN_REMOTE" >> /etc/pptpd.conf
for dns in $DNS_SERVER
do
	echo "ms-dns $dns" >> /etc/ppp/options.pptpd
done
# vpn user
echo "$VPN_USER   pptpd   $VPN_PASS   * " >> /etc/ppp/chap-secrets

#############
# iptable forward
echo "1" > /proc/sys/net/ipv4/ip_forward
sed -i '/net.ipv4.ip_forward/s/.*/net.ipv4.ip_forward = 1/' /etc/sysctl.conf
sysctl -p

/etc/init.d/iptables start
iptables -I INPUT -p tcp -m tcp --dport 1723 -j ACCEPT
iptables -I INPUT -p tcp -m udp --dport 53 -j ACCEPT
iptables -I INPUT -p grep -j ACCETP
# get default gateway eth
gwEth=$(route -n |grep '^0.0.0.0' |awk '{print $NF}')
iptables -t nat -I POSTROUTING -o $gwEth -j MASQUERADE 
/etc/init.d/iptables save

##############
# run pptpd-server
/etc/init.d/iptables restart
/etc/init.d/pptpd restart
chkconfig pptpd on

##############
# alert
echo -e '\E[37;44m'"\033[1m Installation Log: /tmp/ppt-vpn-install.log \033[0m"
echo -e '\E[37;44m'"\033[1m You can now connect to your VPN via your external IP ($VPN_IP)\033[0m"

echo -e '\E[37;44m'"\033[1m Username: $VPN_USER\033[0m"
echo -e '\E[37;44m'"\033[1m Password: $VPN_PASS\033[0m"


) 2>&1 |tee /tmp/ppt-vpn-install.log
