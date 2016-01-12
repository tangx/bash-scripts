#!/bin/bash
#
# rsync server install
#
#

# GITHUB RAW 下载地址
GITHUB_URL=https://raw.githubusercontent.com/uyinn/bash-scripts/master/shell_scripts/rsync

PREFIX=/usr/local/rsync

yum -y install wget tree
yum -y install rsync 


mkdir -p $PREFIX/{etc,init.d,secret}

wget $GITHUB_URL/etc/rsyncd.conf -O $PREFIX/etc/
wget $GITHUB_URL/init.d/rsyncd.sh -O $PREFIX/init.d/
wget $GITHUB_URL/secret/data3.scts -O $PREFIX/secret/

chmod +x $PREFIX/init.d/rsyncd.sh
cp -a $PREFIX/init.d/rsyncd.sh /etc/init.d/

/etc/init.d/rsyncd.sh
