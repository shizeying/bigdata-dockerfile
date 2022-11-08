#!/bin/bash
export APOLLO="-Dapollo.meta=http://192.168.110.110:8083"
export JVM_OPTS="-Xms512m -Xmx512m"
PROG=kggateway
PROG_JAR="/work/jar/kggateway.jar"
LOGDIR="/work/logs/"
JVM_OPTS="-Xms512m -Xmx512m -Xmn256m"
HEAP_DUMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$LOGDIR"
JAVA_OPTS="$APOLLO $JVM_OPTS $HEAP_DUMP_OPTS"

if [ ! -e $LOGDIR ]; then
  mkdir -p $LOGDIR
fi
PID=$(ps -ef|grep kggateway|grep -v grep|awk '{print $2}')

#不是空的
if [ ! -z "$PID" ]; then
  nohup java  $JAVA_OPTS -jar $PROG_JAR > $LOGDIR/kggateway.log 2>&1  &

  else
      echo "pid变量为空"
      echo "process id: $PID"
      kill -9 $PID
	    echo "process kguser killed"
	    echo "process kguser not exist"
	    nohup java  $JAVA_OPTS -jar $PROG_JAR > $LOGDIR/kggateway.log 2>&1  &
fi
#nohup java  $JAVA_OPTS -jar $PROG_JAR > $LOGDIR/kguser.log 2>&1  &
exit
