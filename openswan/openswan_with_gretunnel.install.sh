#!/bin/bash
#
# author: uyinn@live.com
#
# 本脚本用于使用了GRE_TUNNEL通道进行公网优化的网络。
# 其中172.11.100.1 和 172.22.100.1 为 GRE_TUNNEL的提供的本地地址。同样也是tunnel之间连接的对外IP。
# 在配置文件中rightsourceip的值必须为aws ec2的本地IP
# 
#

[ $UID -ne 0 ] && echo "NOT ROOT USER" && exit 1

source /etc/profile

# source ./server.conf

REGION_1=SingaporeOnline
REGION_1_INTERNAL_IP=172.11.100.1
REGION_1_INTERNET_IP=172.11.100.1
REGION_1_INTERNAL_LAN='10.11.0.0/24'
REGION_1_AWS_LAN_IP=10.11.1.100

REGION_2=BeijingOnline
REGION_2_INTERNAL_IP=172.22.100.1
REGION_2_INTERNET_IP=172.22.100.1
REGION_2_INTERNAL_LAN='10.21.0.0/16'
REGION_2_AWS_LAN_IP=10.22.1.100


REGION_CONNECTION_PASSWORD="connetct_password"

case $1 in 
$REGION_1)  {
    LEFT_REGION=$REGION_1
    LEFT_INTERNAL_IP=${REGION_1_INTERNAL_IP}
    LEFT_INTERNET_IP=${REGION_1_INTERNET_IP}
    LEFT_INTERNAL_LAN=${REGION_1_INTERNAL_LAN}
    LEFT_AWS_LAN_IP=${REGION_1_AWS_LAN_IP}
    
    RIGHT_REGION=$REGION_2
    RIGHT_INTERNAL_IP=${REGION_2_INTERNAL_IP}
    RIGHT_INTERNET_IP=${REGION_2_INTERNET_IP}
    RIGHT_INTERNAL_LAN=${REGION_2_INTERNAL_LAN}
    RIGHT_AWS_LAN_IP=${REGION_2_AWS_LAN_IP}
    } ;;
$REGION_2) {
    LEFT_REGION=$REGION_2
    LEFT_INTERNAL_IP=${REGION_2_INTERNAL_IP}
    LEFT_INTERNET_IP=${REGION_2_INTERNET_IP}
    LEFT_INTERNAL_LAN=${REGION_2_INTERNAL_LAN}
    LEFT_AWS_LAN_IP=${REGION_2_AWS_LAN_IP}
    
    RIGHT_REGION=$REGION_1
    RIGHT_INTERNAL_IP=${REGION_1_INTERNAL_IP}
    RIGHT_INTERNET_IP=${REGION_1_INTERNET_IP}
    RIGHT_INTERNAL_LAN=${REGION_1_INTERNAL_LAN}
    RIGHT_AWS_LAN_IP=${REGION_1_AWS_LAN_IP}
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
    leftsourceip=${LEFT_AWS_LAN_IP}
    
    # openswan local server infomations
    # use %defaultroute to find our local IP, since it is dynamic
    right=${RIGHT_INTERNAL_IP}
    # set our ID to our elastic IP
    rightid=${RIGHT_INTERNET_IP}
    # local subnet, usually use vpc in aws
    rightsubnet=${RIGHT_INTERNAL_LAN}
    # local source ip to connect remote public ip
    # (it must be local-ip in aws ec2)
    rightsourceip=${RIGHT_AWS_LAN_IP}
    
EOF

sed -i "/${LEFT_REGION}_${RIGHT_REGION}.conf/d" /etc/ipsec.conf
echo "include /etc/ipsec.d/${LEFT_REGION}_${RIGHT_REGION}.conf " >> /etc/ipsec.conf

sed -i "s@%v4:${LEFT_INTERNAL_LAN}@@" /etc/ipsec.conf
sed -i "s@%v4:${RIGHT_INTERNAL_LAN}@@" /etc/ipsec.conf
sed -i 's/,\{2,\}/,/' /etc/ipsec.conf
sed -i "s@virtual_private=.*@&,%v4:${LEFT_INTERNAL_LAN},%v4:${RIGHT_INTERNAL_LAN}@" /etc/ipsec.conf

# sed -i "/$LEFT_INTERNET_IP $RIGHT_INTERNET_IP/d"  /etc/ipsec.secrets
echo  "$LEFT_INTERNET_IP $RIGHT_INTERNET_IP: PSK \"${REGION_CONNECTION_PASSWORD}\"" > /etc/ipsec.d/${LEFT_REGION}_${RIGHT_REGION}.secrets
#sed -i "/${LEFT_REGION}_${RIGHT_REGION}.secrets/d" /etc/ipsec.secrets
#echo "include /etc/ipsec.d/${LEFT_REGION}_${RIGHT_REGION}.secrets " >> /etc/ipsec.secrets


/etc/init.d/ipsec restart

ipsec whack --status


