#!/bin/bash
export APOLLO="-Dapollo.meta=http://192.168.110.110:8083"
export JVM_OPTS="-Xms512m -Xmx512m"
PROG=kgms
PROG_JAR="/work/jar/kgms.jar"
LOGDIR=/work/logs/${PROG}
JVM_OPTS="-Xms512m -Xmx512m -Xmn256m"
HEAP_DUMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$LOGDIR"
JAVA_OPTS="$APOLLO $JVM_OPTS $HEAP_DUMP_OPTS"

PID=$(ps -ef|grep kgms|grep -v grep|awk '{print $2}')
if [ -z $PID ]; then
	echo "process kgms not exist"
	exit
else
	echo "process id: $PID"
	kill -9 ${PID}
	echo "process kgms killed"
fi

nohup java  $JAVA_OPTS -jar $PROG_JAR > $LOGDIR/kgms.log 2>&1
