#!/bin/bash
#vim /etc/zabbix/scripts/chk_mysql.sh
# 填写如下内容：
#------------------------------------------------------------------------------------------------------------
# Filename: chk_mysql.sh
# Revision: 1.0
# Date: 2016-02-03
# Author: jacky.li
# Email: yoyojacky2009@gmail.com
# website: www.yoyojacky.com
# Descrition:   zabbix monitor
# Notes: ~
#------------------------------------------------------------------------------------------------------------
# CopyLeft: @YOYOjacky
# License:    GPL

#username
MYSQL_USER='root'

#password
MYSQL_PWD='whatthefuckOMG'

#hostip
MYSQL_HOST='127.0.0.1'

#port
MYSQL_PORT='3306'

#Date connection
# MYSQL_CONN="/usr/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT}"

# work for mysql5.7
# http://stackoverflow.com/questions/20751352/suppress-warning-messages-using-mysql-from-within-terminal-but-password-writte
MYSQL_CONN="MYSQL_PWD=${MYSQL_PWD} /usr/bin/mysqladmin -u root -h${MYSQL_HOST} -P${MYSQL_PORT}"


# arguments check
if [ $# -ne "1" ];
   then
    echo "Arguments ERROR!"
fi

#GET DATA
case $1 in
   Uptime)
      result=`${MYSQL_CONN} status|cut -f2 -d":"|cut -f1 -d"T"`
      echo $result
      ;;
   Com_update)
      result=`${MYSQL_CONN} extended-status | grep -w "Com_update"|cut -d"|" -f3`
      echo $result
      ;;
   Slow_queries)
      result=`${MYSQL_CONN} status |awk '{print $9}'`
      echo $result
      ;;
    Com_select)
      result=`${MYSQL_CONN} extended-status |grep -w "Com_select"|cut -d"|" -f3`
      echo $result
      ;;
    Com_rollback)
      result=`${MYSQL_CONN} extended-status |grep -w "Com_rollback"|cut -d"|" -f3`
      echo $result
      ;;
    Questions)
      result=`${MYSQL_CONN} status |cut -f4 -d":"|cut -f1 -d"S"`
      echo $result
      ;;
    Com_insert)
      result=`${MYSQL_CONN} extended-status |grep -w "Com_insert"|cut -d"|" -f3`
      echo $result
      ;;
    Com_delete)
      result=`${MYSQL_CONN} extended-status |grep -w "Com_delete"|cut -d"|" -f3`
      echo $result
      ;;
    Com_commit)
      result=`${MYSQL_CONN} extended-status |grep -w "Com_commit"|cut -d"|" -f3`
      echo $result
      ;;
    Bytes_sent)
      result=`${MYSQL_CONN} extended-status |grep -w "Bytes_sent"|cut -d"|" -f3`
      echo $result
      ;;
    Bytes_received)
      result=`${MYSQL_CONN} extended-status |grep -w "Bytes_received"|cut -d"|" -f3`
      echo $result
      ;;
    Com_begin)
      result=`${MYSQL_CONN} extended-status |grep -w "Com_begin"|cut -d"|" -f3`
      echo $result
      ;;
    *)
     echo "Usage:$0(Uptime|Com_update|Slow_queries|Com_select|Com_rollback|Questions|Com_insert|Com_delete|Com_commit|Bytes_sent|Bytes_received|Com_begin)"
esac
# 保存并退出。
# 然后赋予执行权限。
#chmod  +x  /etc/zabbix/scripts/chk_mysql.sh
