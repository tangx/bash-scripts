#!/bin/bash
# author: sean.tangx
# mailto: uyinn@live.com
# 
# function: install moosefs components, CentOS 6.4 x64
#

# mfsmount compile
# configure: error: mfsmount build was forced, but fuse library is too old or not installed
# 解决方法 http://bbs.chinaunix.net/thread-1643863-1-1.html
#export  PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

#
# note:
# 当mfsmaster非正常关闭后，changelogs没有存进metadata.mfs。
# 此时直接启动mfsmaster会报错，
#
# 解决方法： mfsmetarestore -a 
# 合并之后logs之后，即可正常启动

[ $UID -ne 0 ] && echo "run as ROOT" && exit 9
/bin/ping -c 1 122.225.217.192 > /dev/null 2>&1
[ $? -ne 0 ] && echo "Network doesn't work" && exit 10

yum -y install zlib-devel make gcc gcc-c++ wget dos2unix
mkdir -p /opt/src && cd /opt/src

# install mfsmount dependence: fuse
wget -c http://you.uyinn.com/src/fuse-2.9.3.tar.gz
tar zxf fuse-2.9.3.tar.gz && cd fuse-2.9.3
./configure && make && make install && echo "fuse install done"
export  PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
cd ..

# install all moosefs components
/usr/bin/id mfs > /dev/null 2>&1  ||  /usr/sbin/useradd mfs
wget -c http://you.uyinn.com/src/mfs-1.6.27-5.tar.gz
tar zxf mfs-1.6.27-5.tar.gz && cd mfs-1.6.27
./configure --prefix=/usr/local/mfs --with-default-user=mfs --with-default-group=mfs && echo "configure mfs done by tang"
make && make install && echo "install moosefs components done by tang"
echo "export PATH=$PATH:/usr/local/mfs/bin:/usr/local/mfs/sbin" >> /etc/profile && . /etc/profile
cd ..

