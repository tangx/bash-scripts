#!/bin/bash

yum -y install bash perl tree 
yum -y install wget nc nmap lrzsz
yum -y install unzip  dos2unix
yum -y install lsof iftop iotop 
yum -y install ntpdate ntp
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
chkconfig iptables off
chkconfig ip6tables off
sed --follow-symlinks -i '/SELINUX/s/enforcing/disabled/' /etc/sysconfig/selinux


cat >> /etc/profile <<'EOF'
HISTTIMEFORMAT="[ %Y-%m-%d %H:%M:%S ] " 
PS1="\[\033[1;36m\][\[\033[0m\]$(date +%F)_\t \[\033[1;36m\]\u\[\033[0m\]@\[\033[1;32m\]\h\[\033[0m\]:\[\033[1;31m\]\W\[\033[0m\]\[\033[1;36m\]]\[\033[33;1m\]\\$ \[\033[0m\]" 

alias grep='grep --color=auto '

# ulimit -SHn 65535
EOF

