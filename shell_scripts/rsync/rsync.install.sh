#!/bin/bash
#
# for centos 5,6,7 
# for ubuntu 
# rsync server install
#
#

# GITHUB RAW 下载地址
GITHUB_URL=https://raw.githubusercontent.com/uyinn/bash-scripts/master/shell_scripts/rsync

PREFIX=/usr/local/rsync


function yum_rsync()
{
    yum -y install wget tree
    yum -y install rsync
    # SERVER_RELEASE=$(grep -oP '\d' /etc/redhat-release |head -n 1)
}

function apt_rsync()
{
    sudo apt-get -y install rsync wget 
}

function inst_rsync()
{
    mkdir -p $PREFIX/{etc,init.d,secret,client}

    wget -c -q $GITHUB_URL/etc/rsyncd.conf -P $PREFIX/etc/
    wget -c -q $GITHUB_URL/init.d/rsyncd.sh -P $PREFIX/init.d/
    wget -c -q $GITHUB_URL/secret/data3.scts -P $PREFIX/secret/
    wget -c -q $GITHUB_URL/client/rsync.client.sh -P $PREFIX/client/

    chmod +x $PREFIX/init.d/rsyncd.sh

    $PREFIX/init.d/rsyncd.sh

}


grep -i ubuntu /etc/issue && apt_rsync
grep -i centos /etc/issue && yum_rsync

inst_rsync
