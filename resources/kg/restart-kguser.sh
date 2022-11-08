#!/bin/bash

export APOLLO="-Dapollo.meta=http://192.168.110.110:8080"
export JVM_OPTS="-Xms512m -Xmx512m"

PROG=kguser
PROG_JAR="/work/jar/kguser.jar"
LOGDIR=/work/logs/${PROG}
JVM_OPTS="-Xms512m -Xmx512m -Xmn256m"
HEAP_DUMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$LOGDIR"
JAVA_OPTS="$APOLLO $JVM_OPTS "

if [ ! -e $LOGDIR ]; then
  mkdir -p $LOGDIR
fi
PID=$(ps -ef|grep kguser|grep -v grep|awk '{print $2}')

#不是空的
if [ ! -z "$PID" ]; then
  nohup java  $JAVA_OPTS -jar $PROG_JAR > $LOGDIR/kguser.log 2>&1  &

  else
      echo "pid变量为空"
      echo "process id: $PID"
      kill -9 $PID
	    echo "process kguser killed"
	    echo "process kguser not exist"
	    nohup java  $JAVA_OPTS -jar $PROG_JAR > $LOGDIR/kguser.log 2>&1  &
fi
#nohup java  $JAVA_OPTS -jar $PROG_JAR > $LOGDIR/kguser.log 2>&1  &
exit

