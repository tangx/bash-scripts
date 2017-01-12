#!/bin/bash
#
# 

# rsync [OPTION]... [USER@]HOST::SRC [DEST]

LOCAL_PATH=/path/to/local/resouce/
LOCAL_PASS_FILE=/path/to/local/pass.word

REMOTE_USER=user3
REMOTE_HOST=127.0.0.1
REMOTE_PORT=8888
REMOTE_BUCKET=data3

# SHOW_PROGRESS='--progress'

function local2remote()
{
    rsync -arHz $LOCAL_PATH $REMOTE_USER@$REMOTE_HOST::$REMOTE_BUCKET \
        --port=$REMOTE_PORT \
        --password-file=$LOCAL_PASS_FILE ${SHOW_PROGRESS}
        --progress 
}

function remote2local()
{
    rsync -arHz $REMOTE_USER@$REMOTE_HOST::$REMOTE_BUCKET $LOCAL_PATH \
        --port=$REMOTE_PORT \
        --password-file=$LOCAL_PASS_FILE ${SHOW_PROGRESS}
}

case $1 in
    local2remote) local2remote ;;
    remote2local) remote2local ;;
    *) usage ;;
esac
