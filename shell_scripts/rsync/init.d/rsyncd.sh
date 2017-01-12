#!/bin/bash
#
# rsync init.d
#

# [ -f /etc/init.d/functions ] && . /etc/init.d/functions

## 2017-01-12
# + 修改了脚本，现在也可以用在 ubuntu 系统下

BASEDIR=$(dirname $(which rsync))
# BASEDIR=/usr/bin
PIDFILE=/var/run/rsyncd.pid
CONF_FILE=/usr/local/rsync/etc/rsyncd.conf


function status()
{
    sleep 2
    pid=$(ps -ef | egrep -v "$0|grep" | grep rsync | awk '{print $2}')
    # pid_in_file=$(cat $PIDFILE)
    
    [ -n "$pid" ] && \
        echo "rsync is running [ $pid ]!" || \
        echo "rsync is stopped! " && rm -f $PIDFILE
}


function start()
{
  sleep 4
  
  [ -z "$CONF_FILE" ] && CONF_FILE=/etc/rsyncd.conf
  [ -e "$PIDFILE" ]  || $BASEDIR/rsync --config=$CONF_FILE --daemon  
  
  status 
  
}


function stop()
{
  sleep 4
  
  [ -e "$PIDFILE" ] &&  \
    {
        kill -15 $(cat $PIDFILE) 
        rm -f $PIDFILE 
    } ||  \
    {
        kill -15 $(ps -ef | egrep -v "$0|grep" | grep rsync | awk '{print $2}')
    }
    
  status
  
}

case $1 in 
start)  start ;;
stop)  stop ;;
restart) stop && sleep 2 ;start ;;
status)  status ;;
*)    echo "Usage: $0 [start|stop|restart|status]" ;;
esac
  