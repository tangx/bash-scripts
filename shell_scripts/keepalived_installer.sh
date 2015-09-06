#!/bin/bash
# author: sean.tangx
# mailto: uyinn@live.com

# function: install keepalived 
# success on CentOS 6.4 x64

# checking for openssl/ssl.h... no
# configure: error: 
# !!! OpenSSL is not properly installed on your system. !!!
# !!! Can not include OpenSSL headers files.            !!!
  
# checking for poptGetContext in -lpopt... no
# configure: error: Popt libraries is required

# Script Privilege
[ $UID -ne 0 ] && echo "run as ROOT" && exit 9

function net_check()
{
	# Network Enable Check
	/bin/ping -c 1 122.225.217.192 > /dev/null 2>&1
	[ $? -ne 0 ] && echo "Network doesn't work" && exit 10
}

function install()
{
	mkdir -p /opt/src/ && cd /opt/src/
	
	net_check
	
	yum -y install make gcc gcc-c++ openssl openssl-devel popt-devel
	
	wget -c http://www.keepalived.org/software/keepalived-1.2.13.tar.gz || exit 9
	tar zxf keepalived-1.2.13.tar.gz && cd keepalived-1.2.13
	./configure --prefix=/usr/local/keepalived && make && make install

	ln -s /usr/local/keepalived/bin/genhash /usr/local/bin/genhash
	ln -s /usr/local/keepalived/sbin/keepalived /usr/local/sbin/keepalived
	ln -s /usr/local/keepalived/etc/keepalived/ /etc/keepalived/
	ln -s /usr/local/keepalived/etc/rc.d/init.d/keepalived /etc/init.d/keepalived
	ln -s /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/keepalived

	echo -e "\033\n[47;30m $(which keepalived) \n\033[0m"
}
function uninstall()
{
	DATE=$(date +%F)
	tar zcf /usr/local/keepalived.conf.save_$DATE.tgz -C /usr/local/keepalived/etc/ keepalived/ \
		&& echo "keepalived conf save: /usr/local/keepalived.conf.save_$DATE.tgz"
	rm -rf /usr/local/keepalived
	rm -f /usr/local/bin/genhash
	rm -f /usr/local/sbin/keepalived
	rm -f /etc/keepalived/
	rm -f /etc/init.d/keepalived
	rm -f /etc/sysconfig/keepalived
}

case $1 in
install) install ;;
uninstall) uninstall ;;
*) echo -e "\033[40;37m\n Usage: $0 [install|uninstall] \n\033[0m" ;;
esac
