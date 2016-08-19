#!/bin/bash
#
# centos 6.8 安装 zabbix 3.0.4
#
# zabbix 3.0.4 要修php必须在5.4以上
#
# 2016-08-19
#
#


# 安装编译环境
  yum -y install wget lrzsz nmap tree dos2unix
  yum -y install make gcc gcc-c++ openssl-devel

# 安装zabbix 3.0.4
  mkdir -p /opt/src/zabbix
  cd $_
  rz -y
  tar zxf zabbix-3.0.4.tar.gz 
  cd zabbix-3.0.4
  ./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2 --prefix=/usr/local/zabbix
  make install

# 安装 mysql
  yum -y install mysql-server
  /etc/init.d/mysqld start
  mysql -uzabbix -pzabbix -hlocalhost -e" grant all on zabbix.* to 'zabbix'@'localhost' identified by 'zabbix';"

  cd /opt/src/zabbix/zabbix-3.0.4/database/mysql/
  mysql zabbix < schema.sql 
  mysql zabbix < images.sql 
  mysql zabbix < data.sql 

   
# 安装 httpd
  yum -y install httpd 
  /etc/init.d/httpd start
  
# 安装 php 
  for php_package in `rpm -qa |grep php`; do rpm -e $php_package --nodeps ; done
  rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
  rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
  yum install php56w php56w-opcache  
  yum -y install php56w php56w-mysql php56w-devel php56w-gd php56w-pecl-memcache php56w-pspell php56w-snmp php56w-xmlrpc php56w-xml php56w-ldap
  yum -y install php56w-mbstring php56w-bcmath
  yum -y install  php56w-fpm
  

# 部署 web 控制台
  mkdir -p /var/www/html/zabbix
  cd /opt/src/zabbix/zabbix-3.0.4/frontends/php/
  cp -a . /var/www/html/zabbix/
  /etc/init.d/iptables stop
  cd /var/www/html/
  chown -R apache:apache ./*

# 启动 zabbix_server
  /usr/local/zabbix/sbin/zabbix_server -c /usr/local/etc/zabbix_server.conf
  /usr/local/zabbix/sbin/zabbix_agentd
  
  /etc/init.d/httpd restart
  /etc/init.d/php-fpm restart
  