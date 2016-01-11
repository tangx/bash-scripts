#!/bin/sh
#
# Author: uyinn
# mailto: uyinn@live.com
# datetime: 23:03 2014/3/13
# 
# scripts name: user.SendEmail.sh
#

# Sender Information
EmailAddr=
# if you don't wanna sign in ,leave next 3 parament blank 
EmailPasswd=
SmtpServer=
# SmtpPort=:25

# Mail To Whom
MailtoAddr=
# Mail Content
mailSubject=" A mail From $EmailAddr "

# MsgContent=" \
# if you have a MsgFile, Must leave MsgContent blank, \
# start a new line with a slash<Enter> \
# just like this \
# "
MsgContent=
MsgFile=/some/path/a/file
Attachment=/some/path/a/attachment

# HERE go to Send your email
SenderInfo=" -f $EmailAddr -xu $EmailAddr -xp $EmailPasswd -s $SmtpServer$SmtpPort "
[ "$MailtoAddr" ] &&  MailtoAddr=" -t $MailtoAddr " || exit
[ "$mailSubject" ] && mailSubject=" -u $mailSubject " 
[ "$MsgContent" ] && MsgContent=" -m $MsgContent " 
[ "$MsgFile" ] && [ -e "$MsgFile" ] && MsgFile=" -o message-content-type=text -o message-file=$MsgFile "
[ "$Attachment" ] && [ -e "$Attachment" ] && Attachment=" -a $Attachment " 


/usr/bin/sendEmail $SenderInfo  $MailtoAddr $mailSubject $MsgContent $MsgFile $Attachment 
