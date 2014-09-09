#!/bin/bash
# author: sean.tangx
# mailto: uyinn@live.com
# 
# function: install keepalived, CentOS 6.4 x64
#

[ $UID -ne 0 ] && echo "run as ROOT" && exit 9

/bin/ping -c 1 122.225.217.192 > /dev/null 2>&1
[ $? -ne 0 ] && echo "Network doesn't work" && exit 10


yum -y intstall make gcc gcc-c++ openssl openssl-devel
# http://www.keepalived.org/download.html
mkdir -p /opt/src && cd /opt/src
wget -c http://www.keepalived.org/software/keepalived-1.2.13.tar.gz 
[ $? -ne 0 ] && echo "Download keepalived.tar.gz failed" && exit 10
tar zxf keepalived-1.2.13.tar.gz && cd keepalived-1.2.13
./configure --prefix=/usr/local/keepalived && make && make install && echo "keepalived Install success"


[ -f /etc/keepalived/keepalived.conf ] && cp -a /etc/keepalived/keepalived.conf{,.bak_$(date +%F_%H-%M-%S)}
\cp -a /usr/local/keepalived/{bin,sbin,share} /usr/
\cp -a /usr/local/keepalived/etc/ /

which keepalived
echo "keepalived.conf: /etc/keepalived/keepalived.conf"
echo "usage: /etc/init.d/keepalived start"
