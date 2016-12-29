#!/bin/bash
#
# install pip
#

yum -y install python
# wget -c https://raw.github.com/pypa/pip/master/contrib/get-pip.py
wget -c https://bootstrap.pypa.io/get-pip.py
python get-pip.py 

mkdir -p .pip/

cat > .pip/pip.conf <<EOF
[global]
index-url = https://mirrors.ustc.edu.cn/pypi/web/simple
format = columns
EOF

