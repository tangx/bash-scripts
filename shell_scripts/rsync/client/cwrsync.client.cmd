REM rsync for windows

set RSYNC_BIN=rsync.exe

set LOCAL_PATH=./www/
set LOCAL_PASSWORD_FILE=./pass.srcs 

SET REMOTE_USER=user3
set REMOTE_HOST=127.0.0.1
set REMOTE_BUCKET=data3
set REMOTE_PORT=8888



REM rsync -arHz --port %PORT_NUMBER% %LOCAL_PATH% %REMOTE_USER%@%REMOTE_HOST%::%REMOTE_BUCKET%  --progress

%RSYNC_BIN% -rHz --port %REMOTE_PORT% %REMOTE_USER%@%REMOTE_HOST%::%REMOTE_BUCKET%  %LOCAL_PATH% --progress --password-file=%PASSWORD_FILE%

@pause

