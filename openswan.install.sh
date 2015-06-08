#!/bin/bash
#
# author: uyinn@live.com
#
# 本脚本用于两台aws ec2通过eth0网卡组网。
# 

[ $UID -ne 0 ] && echo "NOT ROOT USER" && exit 1

source /etc/profile

# source ./server.conf

REGION_1=Singapore
REGION_1_INTERNAL_IP=10.1.0.254
REGION_1_INTERNET_IP=111.111.111.111
REGION_1_INTERNAL_LAN='10.1.0.0/16'

REGION_2=Beijing
REGION_2_INTERNAL_IP=10.2.0.254
REGION_2_INTERNET_IP=222.222.222.222
REGION_2_INTERNAL_LAN='10.2.0.0/16'

REGION_CONNECTION_PASSWORD="conneting_pasword"

case $1 in 
$REGION_1)  {
	LEFT_REGION=$REGION_1
	LEFT_INTERNAL_IP=${REGION_1_INTERNAL_IP}
	LEFT_INTERNET_IP=${REGION_1_INTERNET_IP}
	LEFT_INTERNAL_LAN=${REGION_1_INTERNAL_LAN}
	
	RIGHT_REGION=$REGION_2
	RIGHT_INTERNAL_IP=${REGION_2_INTERNAL_IP}
	RIGHT_INTERNET_IP=${REGION_2_INTERNET_IP}
	RIGHT_INTERNAL_LAN=${REGION_2_INTERNAL_LAN}
	} ;;
$REGION_2) {
	LEFT_REGION=$REGION_2
	LEFT_INTERNAL_IP=${REGION_2_INTERNAL_IP}
	LEFT_INTERNET_IP=${REGION_2_INTERNET_IP}
	LEFT_INTERNAL_LAN=${REGION_2_INTERNAL_LAN}
	
	RIGHT_REGION=$REGION_1
	RIGHT_INTERNAL_IP=${REGION_1_INTERNAL_IP}
	RIGHT_INTERNET_IP=${REGION_1_INTERNET_IP}
	RIGHT_INTERNAL_LAN=${REGION_1_INTERNAL_LAN}
	} ;;
*)
	echo "To run openswan-install-script with your current region:"
	echo "$0 [ $REGION_1 | $REGION_2 ]" 
	exit 9
	;;
esac

# install
yum -y install openssl-devel openssh-devel
yum -y install openswan 

[ $? -ne 0 ] && echo "openswan install error" && exit 9


cat > /etc/ipsec.d/${LEFT_REGION}_${RIGHT_REGION}.conf <<EOF
conn ${LEFT_REGION}_${RIGHT_REGION}
	# preshared key
	authby=secret
	# load connection and initiate it on startup
	auto=start
	# connection type
	type=tunnel
	# encrypt infomations
	ike=aes256-sha1;modp2048
	phase2=esp
	phase2alg=aes256-sha1;modp2048
	
	# openswan local server infomations
	# use %defaultroute to find our local IP, since it is dynamic
	left=${LEFT_INTERNAL_IP}
	# set our ID to our elastic IP
	leftid=${LEFT_INTERNET_IP}
	# local subnet, usually use vpc in aws
	leftsubnet=${LEFT_INTERNAL_LAN}
	# local source ip to connect remote public ip
	# (it must be local-ip in aws ec2)
	leftsourceip=${LEFT_INTERNAL_IP}
	
	# remote server public (elastic ip in aws)
	right=${RIGHT_INTERNET_IP}
	# remote subnet, usually use vpc in aws
	rightsubnet=${RIGHT_INTERNAL_LAN}
EOF

sed -i "/${LEFT_REGION}_${RIGHT_REGION}.conf/d" /etc/ipsec.conf
echo "include /etc/ipsec.d/${LEFT_REGION}_${RIGHT_REGION}.conf " >> /etc/ipsec.conf

sed -i "s@%v4:${LEFT_INTERNAL_LAN}@@" /etc/ipsec.conf
sed -i "s@%v4:${RIGHT_INTERNAL_LAN}@@" /etc/ipsec.conf
sed -i 's/,\{2,\}/,/' /etc/ipsec.conf
sed -i "s@virtual_private=.*@&,%v4:${LEFT_INTERNAL_LAN},%v4:${RIGHT_INTERNAL_LAN}@" /etc/ipsec.conf

# sed -i "/$LEFT_INTERNET_IP $RIGHT_INTERNET_IP/d"  /etc/ipsec.secrets
echo  "$LEFT_INTERNET_IP $RIGHT_INTERNET_IP: PSK \"${REGION_CONNECTION_PASSWORD}\"" > /etc/ipsec.d/${LEFT_REGION}_${RIGHT_REGION}.secrets


/etc/init.d/ipsec reload

