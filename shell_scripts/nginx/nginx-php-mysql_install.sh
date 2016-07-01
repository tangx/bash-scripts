#!/bin/bash
#
# wget https://raw.githubusercontent.com/uyinn/bash-scripts/master/shell_scripts/nginx/nginx-php-mysql_install.sh && sh nginx-php-mysql_install.sh
yum -y install wget lrzsz dos2unix gcc gcc-g++ make 


# 安装nginx
#  wget https://raw.githubusercontent.com/uyinn/bash-scripts/master/shell_scripts/nginx/nginx.base.install.sh 
#  sh nginx.base.install.sh



# 安装配置 php
yum -y install php-cli php spawn-fcgi wget
[ -f /usr/bin/spawn-fcgi ] || rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/spawn-fcgi-1.6.3-1.el6.x86_64.rpm

cat > /usr/bin/php-fastcgi<<EOF
#!/bin/sh

if [ `grep -c "nginx" /etc/passwd` = "1" ]; then 
   FASTCGI_USER=nginx
elif [ `grep -c "www-data" /etc/passwd` = "1" ]; then 
   FASTCGI_USER=www-data
elif [ `grep -c "http" /etc/passwd` = "1" ]; then 
   FASTCGI_USER=http
else 
# Set the FASTCGI_USER variable below to the user that 
# you want to run the php-fastcgi processes as

FASTCGI_USER=www
fi

/usr/bin/spawn-fcgi -a 127.0.0.1 -p 9000 -C 6 -u $FASTCGI_USER -f /usr/bin/php-cgi
EOF
chmod +x /usr/bin/php-fastcgi

cat > /etc/init.d/php-fastcgi <<'EOF'
#!/bin/sh

# php-fastcgi - Use php-fastcgi to run php applications
#
# chkconfig: - 85 15
# description: Use php-fastcgi to run php applications
# processname: php-fastcgi

if [ `grep -c "nginx" /etc/passwd` = "1" ]; then 
   OWNER=nginx
elif [ `grep -c "www-data" /etc/passwd` = "1" ]; then 
   OWNER=www-data
elif [ `grep -c "http" /etc/passwd` = "1" ]; then 
   OWNER=http
else 
# Set the OWNER variable below to the user that 
# you want to run the php-fastcgi processes as

OWNER=www
fi

PATH=/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/bin/php-fastcgi

NAME=php-fastcgi
DESC=php-fastcgi

test -x $DAEMON || exit 0

# Include php-fastcgi defaults if available
if [ -f /etc/default/php-fastcgi ] ; then
    . /etc/default/php-fastcgi
fi

set -e

case "$1" in
  start)
    echo -n "Starting $DESC: "
    sudo -u $OWNER $DAEMON
    echo "$NAME."
    ;;
  stop)
    echo -n "Stopping $DESC: "
    killall -9 php-cgi
    echo "$NAME."
    ;;
  restart)
    echo -n "Restarting $DESC: "
    killall -9 php-cgi
    sleep 1
    sudo -u $OWNER $DAEMON
    echo "$NAME."
    ;;
      *)
        N=/etc/init.d/$NAME
        echo "Usage: $N {start|stop|restart}" >&2
        exit 1
        ;;
esac
exit 0
EOF
chmod +x /etc/init.d/php-fastcgi
service php-fastcgi start
chkconfig --add php-fastcgi
chkconfig php-fastcgi on

