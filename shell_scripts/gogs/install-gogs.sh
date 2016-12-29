#!/bin/bash
#
# install gogs git management server on CentOS 7
#
#

# import enviroment 
  [ -f ./install-gogs.cfg ] &&  source ./install-gogs.cfg || exit 1


# install tools
  yum -y install wget unzip 


# install mysql for centos7
  yum -y install http://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
  yum -y install mysql-community-server
  service mysqld start


# MYSQL SET
  # + get mysql temporary password
  MYSQL57_ROOT_TMP_PWD=$(grep "A temporary password" /var/log/mysqld.log |awk '{print $NF}')

  # + update root password and create gogs usesr
  MYSQL_PWD=${MYSQL57_ROOT_TMP_PWD} mysql -u root --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PWD}' ;"
  MYSQL_PWD=${MYSQL_ROOT_PWD} mysql -u root -e "grant all on gogs.* to '${MYSQL_GOGS_USER}'@'127.0.0.1' identified by '${MYSQL_GOGS_PWD}';"
  MYSQL_PWD=${MYSQL_ROOT_PWD} mysql -u root -e "grant all on gogs.* to '${MYSQL_GOGS_USER}'@'localhost' identified by '${MYSQL_GOGS_PWD}';"
  MYSQL_PWD=${MYSQL_ROOT_PWD} mysql -u root -e "DROP DATABASE IF EXISTS ${MYSQL_GOGS_DBNAME};"
  MYSQL_PWD=${MYSQL_ROOT_PWD} mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_GOGS_DBNAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"


# Install gogs 
  mkdir -p /opt/gogs  && cd $_
  wget -c http://7d9nal.com2.z0.glb.qiniucdn.com/gogs_v0.9.113_linux_amd64.tar.gz
  [ ! -d gogs ] && tar zxf gogs_v0.9.113_linux_amd64.tar.gz 
  cd gogs

# start gogs web service
  ./gogs web &


# goto webpage to configure gogs
