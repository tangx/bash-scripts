#!/bin/bash

yum -y install bash perl tree 
yum -y install wget nc nmap lrzsz
yum -y install unzip  dos2unix
yum -y install lsof iftop iotop 
yum -y install ntpdate ntpd
yum -y install openssl-devel openssh-devel
yum -y install nfs-utils rpcbind

# yum -y update



# https://pip.pypa.io/en/stable/installing.html
 
# yum -y install python
# wget -c https://raw.github.com/pypa/pip/master/contrib/get-pip.py
# wget -c https://bootstrap.pypa.io/get-pip.py
# python get-pip.py 
# pip install awscli


\cp -a /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime 

chkconfig ntpd off



