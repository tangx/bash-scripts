#!/bin/bash
#
# wget https://raw.githubusercontent.com/uyinn/bash-scripts/master/shell_scripts/shadowsocks/shadowsocks.install.sh &&　shadowsocks.install.sh
  which pip > /dev/null 2>&1 || {
    wget -c https://bootstrap.pypa.io/get-pip.py
    python get-pip.py 
  }
  
  pip install shadowsocks


# 获取配置文件
  # mkdir -p /etc/shadowsocks/
  SHADOW_DIR=/usr/local/shadowscoks/
  mkdir -p $SHADOW_DIR
  cd $_
  wget https://raw.githubusercontent.com/uyinn/bash-scripts/master/shell_scripts/shadowsocks/ss.json.conf

  PUB_IP=$(curl -s ip.cn | grep -oP '(\d+\.)+\d+')
  sed -i "s/PUBLIC_IP/$PUB_IP/" ss.json.conf 

  # mv ss.json.conf /etc/shadowsocks/

  
  
# 获取启动文件
  wget https://raw.githubusercontent.com/uyinn/bash-scripts/master/shell_scripts/shadowsocks/shadowsocksd.sh
  chmod +x shadowsocksd.sh
  sed -i "s@SSSERVER_BIN@$(which ssserver)@" shadowsocksd.sh 
  sed -i "s@CONFIG_DIR@$SHADOW_DIR@" shadowsocksd.sh 
  mv shadowsocksd.sh /etc/init.d/
  
  
