#!/bin/bash
# author: sean.tangx
# mailto: uyinn@live.com
# 
# function: install moosefs components, CentOS 6.4 x64
#

# mfsmount compile
# configure: error: mfsmount build was forced, but fuse library is too old or not installed
# solution: http://bbs.chinaunix.net/thread-1643863-1-1.html
#export  PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

# Script Privilege
[ $UID -ne 0 ] && echo "run as ROOT" && exit 9
# Network Enable Check
/bin/ping -c 1 122.225.217.192 > /dev/null 2>&1
[ $? -ne 0 ] && echo "Network doesn't work" && exit 10

# software package store path 
SRCDIR=/opt/src

# setup MooseFS prefix and working user
MOOSEFS_PATH=/usr/local/mfs
WORKING_USER=mfs
WORKING_GROUP=mfs

# Install or not following components
# enable / disable
MFSMASTER=disable
MFSCHUNKSERVER=disable
MFSMOUNT=enable

CONFIGURE="./configure 
--prefix=${MOOSEFS_PATH}  
--with-default-user=$WORKING_USER 
--with-default-group=$WORKING_GROUP 
--${MFSMASTER}-mfsmaster 
--${MFSCHUNKSERVER}-mfschunkserver 
--${MFSMOUNT}-mfsmount 
"

# Install FUSE for mfsmount
function fuse_install()
{
	FUSE_SIGN=$(echo $CONFIGURE |grep 'enable-mfsmount' |wc -l)
	
	if [ $FUSE_SIGN -eq 1 ]
	then
		cd $SRCDIR
		wget -c http://you.uyinn.com/src/fuse-2.9.3.tar.gz
		tar zxf fuse-2.9.3.tar.gz && cd fuse-2.9.3
		./configure && make && make install
		export  PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
		cd ..
	fi
}

# Install MooseFS
function mfs_install()
{
	# create working user if doesn't exist
	/usr/bin/id -g $WORKING_GROUP > /dev/null 2>&1 || /usr/sbin/groupadd $WORKING_GROUP
	/usr/bin/id $WORKING_USER > /dev/null 2>&1 \
		&& /usr/sbin/usermod -a -G $WORKING_GROUP $WORKING_USER \
		||  /usr/sbin/useradd -g $WORKING_GROUP $WORKING_USER

	cd $SRCDIR
	wget -c http://you.uyinn.com/src/mfs-1.6.27-5.tar.gz
	tar zxf mfs-1.6.27-5.tar.gz && cd mfs-1.6.27
	$CONFIGURE
	make && make install
	cd ..
}

# Installing
# Installed Dependences
yum -y install zlib-devel make gcc gcc-c++ wget dos2unix
mkdir -p $SRCDIR && cd $SRCDIR

fuse_install $CONFIGURE
mfs_install $CONFIGURE
