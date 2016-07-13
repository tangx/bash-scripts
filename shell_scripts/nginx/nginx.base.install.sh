#!/bin/bash
#
# author: uyinn@live.com
#
# download_url: 
#    wget https://raw.githubusercontent.com/uyinn/bash-scripts/master/shell_scripts/nginx/nginx.base.install.sh && sh nginx.base.install.sh
# 
# @@@@@@@@@@@@@@@@@@@@@
# 
# 更新记录
# @2016-07-01
#   + 自动获取nginx与pcre版本
# @2015-07-30
#   - 模块化 /etc/init.d/nginxd , 注释新建nginxd段代码, 通过下载获取

## NGINX 在GITHUB 上的https 地址
  NGINX_GITHUB_URL=https://raw.githubusercontent.com/uyinn/bash-scripts/master/shell_scripts/nginx

# @@@@@@@@@@@@@@@@@@@@@
# 参数设置
  NGINX_PREFIX=/usr/local/nginx
  NGINX_USER=www
  NGINX_GROUP=$NGINX_USER
  
# 安装包变量
  VAR_NGINX_FILE=$(curl -s https://nginx.org/en/download.html |grep -oP 'nginx-([0-9]+\.)+tar\.gz'   |head -n 1)
  VAR_NGINX_VER=$(echo $VAR_NGINX_FILE | grep  -oP '([0-9]+\.)+[0-9]+')
  VAR_NGINX_URL=https://nginx.org/download/$VAR_NGINX_FILE
  
  #https://sourceforge.net/projects/pcre/
  
  # VAR_PCRE_FILE=$(curl -s https://sourceforge.net/projects/pcre/files/pcre/ |grep -m 1 'Looking for the latest version' -A 1 |grep -oP 'pcre-\d+\.\d+.tar.bz2')
  VAR_PCRE_FILE=pcre-8.39.tar.gz
  VAR_PCRE_VER=$(echo $VAR_PCRE_FILE | grep -oP '\d+\.\d+')
  VAR_PCRE_URL=http://vorboss.dl.sourceforge.net/project/pcre/pcre/${VAR_PCRE_VER}/$VAR_PCRE_FILE
  # VAR_PCRE_URL=http://downloads.sourceforge.net/project/pcre/pcre/8.39/pcre-8.39.tar.bz2
  
# 安装依赖包
  yum -y install gcc gcc-c++ make 
  yum -y install wget lrzsz dos2unix nc nmap unzip bash
  yum -y install zlib-devel openssl-devel 

  mkdir -p /opt/src/nginx && cd $_

# 安装pcre
  wget -c $VAR_PCRE_URL
  tar zxf pcre-${VAR_PCRE_VER}.tar.gz
  # cd pcre-8.33
  # ./configure && make && make install
  # cd ..
  # echo "/usr/local/lib/" >> /etc/ld.so.conf
  # echo "/usr/local/lib64/" >> /etc/ld.so.conf
  # ldconfig

# 安装nginx
  # 新建nginx运行账户
  id www > /dev/null 2>&1 || useradd -s /sbin/nologin www
  
  wget -c $VAR_NGINX_URL
  tar zxf $VAR_NGINX_FILE && cd nginx-${VAR_NGINX_VER}
  ./configure --user=$NGINX_USER --group=$NGINX_GROUP --prefix=$NGINX_PREFIX \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-cc-opt='-O2' \
    --without-http_empty_gif_module \
    --with-poll_module \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-pcre=../pcre-${VAR_PCRE_VER}/  \
    && make && make install && echo "nginx done by uyinn"



# 下载配置文件
wget $NGINX_GITHUB_URL/conf/proxy.conf -O $NGINX_PREFIX/conf/
wget $NGINX_GITHUB_URL/conf/fastcgi.conf -O $NGINX_PREFIX/conf/


# 下载 /etc/init.d/nginxd 脚本
wget $NGINX_GITHUB_URL/nginxd -O /etc/init.d/nginxd
sed -i "s@NGINX_PREFIX=\$NGINX_PREFIX@NGINX_PREFIX=$NGINX_PREFIX@" /etc/init.d/nginxd
chmod +x /etc/init.d/nginxd

chkconfig nginxd on


