#!/bin/bash
#
# 


[ $UID -ne 0 ] && exit 1 ;

# SSSERVER=/usr/bin/ssserver
SSSERVER=ssserver
CONF_FILE=/etc/shadowsocks/ss.json.conf
PID_FILE=/var/run/ssserver.pid


function status()
{
  sleep 1 
  [ ! -f $PID_FILE ] && echo " ShadowSocks is stop!"
  [ -f $PID_FILE ] &&  {
    SS_PID=$(cat $PID_FILE)
    echo " ShadowSocks is running [ $SS_PID ]"
  }
  
}

function start()
{
  $SSSERVER -c $CONF_FILE --pid-file $PID_FILE -d start
}

function stop()
{
  $SSSERVER -d stop && rm -f $PID_FILE
}

function restart()
{
  stop ;
  sleep 1 ;
  start ;
}


case $1 in 
start|stop|restart)
  $1 ;
  status ;;
*)
  echo "Usage: $0 [start|stop|restart]" ;;
esac

