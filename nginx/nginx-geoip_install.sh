#!/bin/bash

# author: uyinn@live.com


yum -y install gcc gcc-g++ make 
yum -y install wget lrzsz dos2unix nc nmap unzip bash
yum -y install openssl-devel openssl-devel
yum -y update


# rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
# yum update     
# yum install nginx sudo

# 安装pcre
wget -c http://you.uyinn.com/src/nginx/pcre-8.33.tar.bz2
tar jxf pcre-8.33.tar.bz2 && cd pcre-8.33
./configure && make && make install &&  echo "prec done by tang"


# 安装 geoip 库
# wget -c http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz
# tar zxf GeoIP.tar.gz 
# cd GeoIP-1.4.8
# ./configure && make && make install

echo "/usr/local/lib/" >> /etc/ld.so.conf
echo "/usr/local/lib64/" >> /etc/ld.so.conf
ldconfig

# 安装nginx
id www > /dev/null 2>&1 || useradd -s /sbin/nologin www
yum -y install wget zlib-devel openssl-devel gcc gcc-g++ make 

wget -c http://nginx.org/download/nginx-1.7.8.tar.gz
tar zxf nginx-1.7.8.tar.gz && cd nginx-1.7.8
./configure --user=www --group=www --prefix=/usr/local/nginx \
	--with-http_stub_status_module \
	--with-http_ssl_module \
	--with-cc-opt='-O2' \
	--without-http_empty_gif_module \
	--with-poll_module \
	--with-http_stub_status_module \
	--with-http_ssl_module \
	--with-http_geoip_module  \
	&& make && make install && echo "nginx done by tang"
