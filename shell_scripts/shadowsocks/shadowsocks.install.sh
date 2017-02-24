#!/bin/bash
#
# author
# shadowscoks installer
#

# 安装命令

  # wget https://raw.githubusercontent.com/octowhale/bash-scripts/master/shell_scripts/shadowsocks/shadowsocks.install.sh 
  # sh shadowsocks.install.sh [ec2]

# windows-client
  # https://github.com/shadowsocks/shadowsocks-windows/releases
  
################

  timestamp=$(date+ %s)

# 安装pip
  which pip > /dev/null 2>&1 || {
    wget -c https://bootstrap.pypa.io/get-pip.py
    python get-pip.py 
  }
  
  pip install shadowsocks


# 获取配置文件
  # mkdir -p /etc/shadowsocks/
  SHADOW_DIR=/usr/local/shadowscoks
  GTIHUB_URL=https://raw.githubusercontent.com/octowhale/bash-scripts/master/shell_scripts
  mkdir -p $SHADOW_DIR
  cd $_
  
  [ -f ss.json.conf ] && mv ss.json.conf{,.ori_$timestamp}
  wget -c -q $GTIHUB_URL/shadowsocks/ss.json.conf


  # mv ss.json.conf /etc/shadowsocks/

  case $1 in 
  ec2)
    PUB_IP=$(ifconfig eth0 |grep -oP '(\d+\.)+\d+' | head -n 1)
    ;;
  *)
    PUB_IP=$(curl -s ip.cn | grep -oP '(\d+\.)+\d+')
    ;;
  sed -i "s/PUBLIC_IP/$PUB_IP/" ss.json.conf 
  
# 获取启动文件
  
  wget -c -q $GTIHUB_URL/shadowsocks/shadowsocksd.sh
  chmod +x shadowsocksd.sh
  sed -i "s@SSSERVER_BIN@$(which ssserver)@" shadowsocksd.sh 
  sed -i "s@CONFIG_DIR@$SHADOW_DIR@" shadowsocksd.sh 
  
  which dos2unix && dos2unix ./*
  
  [ -f /etc/init.d/shadowsocksd.sh ] && mv /etc/init.d/shadowsocksd.sh{,.ori_$timestamp}
  cp shadowsocksd.sh /etc/init.d/
  
  
echo "Usage: "
echo "  /etc/init.d/shadowsocksd.sh [start|stop|restart]"