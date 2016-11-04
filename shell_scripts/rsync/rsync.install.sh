#!/bin/bash
#
# for centos 5,6,7 
# rsync server install
#
#

# GITHUB RAW 下载地址
GITHUB_URL=https://raw.githubusercontent.com/uyinn/bash-scripts/master/shell_scripts/rsync

PREFIX=/usr/local/rsync


SERVER_RELEASE=$(grep -oP '\d' /etc/redhat-release |head -n 1)



yum -y install wget tree
yum -y install rsync 


mkdir -p $PREFIX/{etc,init.d,secret,client}

wget $GITHUB_URL/etc/rsyncd.conf -P $PREFIX/etc/
wget -c $GITHUB_URL/init.d/rsyncd.sh -P $PREFIX/init.d/
wget -c $GITHUB_URL/secret/data3.scts -P $PREFIX/secret/
wget -c $GITHUB_URL/client/rsync.client.sh -P $PREFIX/client/

chmod +x $PREFIX/init.d/rsyncd.sh

[ $SERVER_RELEASE -ne 7 ] && cp -a $PREFIX/init.d/rsyncd.sh /etc/init.d/

# 显示用法
/etc/init.d/rsyncd.sh
$PREFIX/init.d/rsyncd.sh
