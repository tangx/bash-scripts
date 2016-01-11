#!/bin/sh
#
# Author: uyinn
# mailto: uyinn@live.com
# datetime: 2014/3/13
#
#

[ $UID -ne 0 ] && echo "Run as ROOT " && exit

yum -y install perl wget || exit
wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz

tar zxf sendEmail-v1.56.tar.gz
mv sendEmail-v1.56/sendEmail /usr/bin/ 

/usr/bin/sendEmail

