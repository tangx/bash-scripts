#!/bin/bash
#
# mailto: uyinn@live.com
#
# zabbix.2.4.5.install.sh
#

# paraments
#
openssl rand -base64 32|cut -c 1-30
MYSQL_ROOT_PASSOWRD=$(openssl rand -base64 32|cut -c 5-25)

MYSQL_ZABBIX_USER=zabbix
MYSQL_ZABBIX_PASSWD=$(openssl rand -base64 32|cut -c 10-20)


alias sed='sed --follow-symlinks '

echo '  '
echo $(date +%F)  >> /tmp/zabbix.log
echo "MYSQL_ROOT_PASSOWRD=$MYSQL_ROOT_PASSOWRD" >> /tmp/zabbix.log
echo "MYSQL_ZABBIX_USER=$MYSQL_ZABBIX_USER" >> /tmp/zabbix.log
echo "MYSQL_ZABBIX_PASSWD=$MYSQL_ZABBIX_PASSWD" >> /tmp/zabbix.log


yum -y install bash perl lrzsz wget


##### install mysql ######
yum -y install mysql mysql-server mysql-devel

/etc/init.d/mysqld start
/usr/bin/mysqladmin -u root password "$MYSQL_ROOT_PASSOWRD"
mysql -uroot -p"$MYSQL_ROOT_PASSOWRD" -e"create database zabbix character set utf8;"
mysql -uroot -p"$MYSQL_ROOT_PASSOWRD" -e"grant all privileges on zabbix.* to $MYSQL_ZABBIX_USER@localhost identified by '$MYSQL_ZABBIX_PASSWD';"
mysql -uroot -p"$MYSQL_ROOT_PASSOWRD" -e "flush privileges;"


##### install php & apache ######
yum -y install httpd php php-mysql httpd-manual mod_ssl mod_perl mod_auth_mysql php-gd php-xml php-mbstring php-ldap php-pear php-xmlrpc php-bcmath mysql-connector-odbc libdbi-dbd-mysql net-snmp-devel curl-devel 

#config php.ini
sed -i "s/;date.timezone =/date.timezone = Asia\/Shanghai/g" /etc/php.ini
sed -i "s#max_execution_time = 30#max_execution_time = 300#g" /etc/php.ini
sed -i "s#post_max_size = 8M#post_max_size = 32M#g" /etc/php.ini
sed -i "s#max_input_time = 60#max_input_time = 300#g" /etc/php.ini
sed -i "s#memory_limit = 128M#memory_limit = 128M#g" /etc/php.ini
# sed -i "/;mbstring.func_overload = 0/mbstring.func_overload = 2\n" /etc/php.ini
sed -i "/mbstring.func_overload = 0/;mbstring.func_overload = 2/" /etc/php.ini
chkconfig httpd on
/etc/init.d/httpd restart


#########  安装 zabbix ##########

yum -y install make gcc gcc-c++ autoconf 
#useradd zabbix
id zabbix > /dev/null 2>&1 || useradd -s /sbin/nologin zabbix

mkdir -p /opt/src/zabbix_`date +%F` && cd $_
# wget -c  http://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.4.5/zabbix-2.4.5.tar.gz
wget http://nchc.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.4.8/zabbix-2.4.8.tar.gz

tar zxf zabbix-2.4.8.tar.gz && cd zabbix-2.4.8
./configure --prefix=/mnt/app/zabbix --enable-server --enable-proxy --enable-agent --with-mysql=/usr/bin/mysql_config --with-net-snmp --with-libcurl && make install

mysql -u$MYSQL_ZABBIX_USER -p$MYSQL_ZABBIX_PASSWD zabbix< ./database/mysql/schema.sql 
mysql -u$MYSQL_ZABBIX_USER -p$MYSQL_ZABBIX_PASSWD zabbix< ./database/mysql/images.sql 
mysql -u$MYSQL_ZABBIX_USER -p$MYSQL_ZABBIX_PASSWD zabbix< ./database/mysql/data.sql 


mkdir /mnt/app/zabbix/log -p
ln -s /mnt/app/zabbix/log /var/log/zabbix
chown zabbix:zabbix /var/log/zabbix
chown zabbix:zabbix /mnt/app/zabbix/log


cp misc/init.d/fedora/core/zabbix_* /etc/init.d/
chmod 755 /etc/init.d/zabbix_*
sed -i 's#BASEDIR=/usr/local#BASEDIR=/mnt/app/zabbix#g' /etc/init.d/zabbix_server
sed -i 's#BASEDIR=/usr/local#BASEDIR=/mnt/app/zabbix#g' /etc/init.d/zabbix_agentd

ln -s /mnt/app/zabbix/etc/ /etc/zabbix
mkdir -p /var/log/zabbix/
chown -R zabbix:zabbix /var/log/zabbix
sed -i "s/DBUser\=root/DBUser=$MYSQL_ZABBIX_USER/g" /etc/zabbix/zabbix_server.conf
sed -i "s/# DBPassword=/DBPassword=$MYSQL_ZABBIX_PASSWD/g" /etc/zabbix/zabbix_server.conf
sed -i 's#LogFile=/tmp/zabbix_server.log#LogFile=/var/log/zabbix/zabbix_server.log#g' /etc/zabbix/zabbix_server.conf
# sed -i 's/# ListenPort=10051/ListenPort=30657/g' /etc/zabbix/zabbix_server.conf

ZABBIX_SERVER_HOST=$(ifconfig eth0 |grep 'inet addr' |awk -F':| B' '{print $2}')
sed -i "s/Server\=127.0.0.1/Server\=127.0.0.1,$ZABBIX_SERVER_HOST/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive\=127.0.0.1/ServerActive\=127.0.0.1,$ZABBIX_SERVER_HOST/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s#LogFile=/tmp/zabbix_agentd.log#LogFile=/var/log/zabbix/zabbix_agentd.log#g" /etc/zabbix/zabbix_agentd.conf
sed -i 's@# UnsafeUserParameters=0@UnsafeUserParameters=1@g' /etc/zabbix/zabbix_agentd.conf



cp -ar /var/www /mnt/
mv /var/www /var/www.bak
ln -s /mnt/www /var/www
cp -r ./frontends/php/ /var/www/html/zabbix
chown -R apache:apache /mnt/www /var/www


chkconfig zabbix_server on
chkconfig zabbix_agentd on
/etc/init.d/zabbix_server start
/etc/init.d/zabbix_agentd start


