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



rsync -arHz --port=$REMOTE_PORT --password-file=$LOCAL_PASS_FILE --progress \
        $LOCAL_PATH $REMOTE_USER@$REMOTE_HOST::$REMOTE_BUCKET 
