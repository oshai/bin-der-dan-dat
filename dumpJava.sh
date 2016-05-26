#!/bin/bash

PROC_ID=$1
LOG_DIR=$2
OUT_DIR=$3

echo "working on pid $PROC_ID with log dir $LOG_DIR"
mkdir -p $OUT_DIR
echo "dumping threads"
jstack $PROC_ID > $OUT_DIR/jstack.log
if [ "$?" -gt "0" ]; then
    echo "failed running jstack, trying -F"
    jstack -F $PROC_ID > $OUT_DIR/jstack.force.log
fi
echo "dumping lsof"
lsof > $OUT_DIR/lsof.log
echo "dumping netstat"
netstat > $OUT_DIR/netstat.log
echo "dumping file descriptors"
ls -l /proc/$PROC_ID/fd
echo "dumping memory"
jmap -histo:live $PROC_ID > $OUT_DIR/jmap.histo.log
if [ "$?" -gt "0" ]; then
    echo "failed jmap histo, trying -F"
    jmap -histo -F $PROC_ID > $OUT_DIR/jmap.histo.force.log
fi
echo "now full dump" 
jmap -dump:live,format=b,file=$OUT_DIR/memory.bin $PROC_ID
if [ "$?" -gt "0" ]; then
    echo "dump failed, trying -F"
    jmap -F -dump:format=b,file=$OUT_DIR/memory.force.bin $PROC_ID
fi
echo "copying logs"
cp -r $LOG_DIR $OUT_DIR
chmod -R +rx $OUT_DIR
echo "done, see files in $OUT_DIR"

