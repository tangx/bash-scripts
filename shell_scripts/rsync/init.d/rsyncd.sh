#!/bin/bash
#
# rsync init.d
#

[ -f /etc/init.d/functions ] && . /etc/init.d/functions

# BASEDIR=$(dirname $(which rsync))
BASEDIR=/usr/bin
PIDFILE=/var/run/rsyncd.pid
CONF_FILE=/usr/local/rsync/etc/rsyncd.conf


function DoAction()
{
  [ $? -eq 0 ] && \
  action "$doAct" /bin/true || \
  action "$doAct" /bin/false
}

function start()
{
  doAct="Starting Rsync Daemon  "
  [ -z "$CONF_FILE" ] && CONF_FILE=/etc/rsyncd.conf
  [ -e $PIDFILE ]  || $BASEDIR/rsync --config=$CONF_FILE --daemon  
  DoAction 
  
}

function stop()
{
  doAct="Stoping Rsync Daemon"
  [ -e $PIDFILE ] && kill -15 $(cat $PIDFILE) && rm -f $PIDFILE
  DoAction
}

function status()
{
  [ -e $PIDFILE ] && \
  echo "Rsync is Running [ $(cat $PIDFILE) ]" || \
  echo "Rsync is Stopped"
}

case $1 in 
start)  start ;;
stop)  stop ;;
restart) stop && sleep 2 ;start ;;
status)  status ;;
*)    echo "Usage: $0 [start|stop|restart|status]" ;;
esac
  
