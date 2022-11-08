#!/bin/bash
export APOLLO="-Dapollo.meta=http://192.168.110.110:8083"
export JVM_OPTS="-Xms512m -Xmx512m"
PROG=kgdw
PROG_JAR="/work/jar/kgdw.jar"
LOGDIR=/work/logs/${PROG}
JVM_OPTS="-Xms512m -Xmx512m -Xmn256m"
HEAP_DUMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$LOGDIR"
JAVA_OPTS="$APOLLO $JVM_OPTS $HEAP_DUMP_OPTS"

PID=$(ps -ef|grep kgdw|grep -v grep|awk '{print $2}')
if [ -z $PID ]; then
	echo "process kgdw not exist"
	exit
else
	echo "process id: $PID"
	kill -9 ${PID}
	echo "process kgdw killed"
fi

nohup java  $JAVA_OPTS -jar $PROG_JAR > $LOGDIR/kgdw.log 2>&1
