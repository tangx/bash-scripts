#!/bin/bash
#
# author: uyinn@live.com
#
# filename: net.tcp.discovery
#
# function: findout a port is or not listened. if true , count the ESTABLISHED number of the port.
#

# netstat -tnl | grep tcp  |awk '{print $4}' | awk -F':' '{print $NF}' |sort |uniq

[ -z $1 ] && exit
APP_PORT=$(netstat -tnl |grep -w "$1" |awk '{print $4}' | awk -F':' '{print $NF}' |sort| uniq )

# echo $APP_PORT

if [ ! -z "$APP_PORT" ] 
then 
  
  echo '{'
  echo '  "data":['
  echo '          {"{#TCP_PORT}":"'$APP_PORT'"}'
  echo '  ]'
  echo '}'

fi
