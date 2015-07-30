#!/bin/bash
#
# author: uyinn@live.com
#
# download_url: https://raw.githubusercontent.com/uyinn/bash-scripts/master/nginx/nginx.base.install.sh
# 
# @@@@@@@@@@@@@@@@@@@@@
# 
# 更新记录
# 2015-07-30
#   - 模块化 /etc/init.d/nginxd , 注释新建nginxd段代码, 通过下载获取

# @@@@@@@@@@@@@@@@@@@@@
# 参数设置
  NGINX_PREFIX=/usr/local/nginx
  NGINX_USER=www
  NGINX_GROUP=$NGINX_USER
  
# 安装依赖包
  yum -y install gcc gcc-c++ make 
  yum -y install wget lrzsz dos2unix nc nmap unzip bash
  yum -y install zlib-devel openssl-devel 

  mkdir -p /opt/src/nginx && cd $_

# 安装pcre
  wget -c http://downloads.sourceforge.net/project/pcre/pcre/8.33/pcre-8.33.tar.bz2
  tar jxf pcre-8.33.tar.bz2 
  # cd pcre-8.33
  # ./configure && make && make install
  # cd ..
  # echo "/usr/local/lib/" >> /etc/ld.so.conf
  # echo "/usr/local/lib64/" >> /etc/ld.so.conf
  # ldconfig

# 安装nginx
  # 新建nginx运行账户
  id www > /dev/null 2>&1 || useradd -s /sbin/nologin www
  
  wget -c http://nginx.org/download/nginx-1.7.8.tar.gz
  tar zxf nginx-1.7.8.tar.gz && cd nginx-1.7.8
  ./configure --user=$NGINX_USER --group=$NGINX_GROUP --prefix=$NGINX_PREFIX \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-cc-opt='-O2' \
    --without-http_empty_gif_module \
    --with-poll_module \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-pcre=../pcre-8.33/  \
    && make && make install && echo "nginx done by uyinn"
    
# cat > /etc/init.d/nginxd <<'EOF'
# #!/bin/bash

#nginx controller script


# NGINX_PREFIX=$NGINX_PREFIX
# NGINX=$NGINX_PREFIX/sbin/nginx
# NGINX_CONF=$NGINX_PREFIX/conf/nginx.conf
# NGINX_PID=$NGINX_PREFIX/logs/nginx.pid 

# NGINX_ACTION=$1

# function start()
# {
  # $NGINX -c $NGINX_CONF
# }

# function stop()
# {
  # $NGINX -s stop
  # [ $0 -eq 0 ] && { [ ! -f $NGINX_PID ] && echo "Nginx is stoped! " ; }
# }

# function status()
# {
  # if [ -f  $NGINX_PID ] 
  # then
  # {
    # NGINX_PID_NUMBER=$(cat $NGINX_PID )
    # echo "Nginx is Running at [ $NGINX_PID_NUMBER ] ! "
  # }
  # else 
  # {
    # echo "Nginx is stoped!"
  # }
  # fi
# }

# function test()
# {
  # $NGINX -t $NGINX_CONF
# }

# function version()
# {
  # $NGINX -v
  # ecoh ' '
  # $NGINX -V
# }


# case $NGINX_ACTION in 
# start|stop|test|status|version)
  # $NGINX_ACTION ;;
# restart)
  # stop && start ;;
# *)
  # echo "Usage: $0 [ start|stop|restart|test|status|version ]"
  # ;;
# esac
# EOF


# 下载 /etc/init.d/nginxd 脚本

wget https://raw.githubusercontent.com/uyinn/bash-scripts/master/nginx/nginxd -O /etc/init.d/nginxd
sed -i "s@NGINX_PREFIX=\$NGINX_PREFIX@NGINX_PREFIX=$NGINX_PREFIX@" /etc/init.d/nginxd
chmod +x /etc/init.d/nginxd

chkconfig nginxd on


