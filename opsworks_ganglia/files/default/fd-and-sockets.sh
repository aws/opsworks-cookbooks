#!/bin/bash

FD_FILE='/proc/sys/fs/file-nr'
SOCKET_FILE='/proc/net/sockstat'

SOCKET=`cat $SOCKET_FILE | grep sockets | awk '{print $3}'`
FD=`cat $FD_FILE | awk '{print $1}'`

echo -e "file descriptors - $FD\nsockets - $SOCKET\n"

gmetric -tuint8 -x180 -n"file_descriptors" -v$FD
gmetric -tuint8 -x180 -n"sockets_in_use" -v$SOCKET