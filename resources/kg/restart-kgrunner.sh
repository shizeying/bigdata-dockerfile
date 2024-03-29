#!/bin/bash
export APOLLO="-Dapollo.meta=http://192.168.110.110:8083"
export JVM_OPTS="-Xms512m -Xmx512m"
PROG=kgrunner
PROG_JAR="/work/jar/kgrunner.jar"
LOGDIR=/work/logs/${PROG}
JVM_OPTS="-Xms512m -Xmx512m -Xmn256m"
HEAP_DUMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$LOGDIR"
JAVA_OPTS="$APOLLO $JVM_OPTS $HEAP_DUMP_OPTS"

PID=$(ps -ef|grep kgrunner|grep -v grep|awk '{print $2}')
if [ -z $PID ]; then
	echo "process kgrunner not exist"
	exit
else
	echo "process id: $PID"
	kill -9 ${PID}
	echo "process kgrunner killed"
fi

nohup java  $JAVA_OPTS -jar $PROG_JAR > $LOGDIR/kgrunner.log 2>&1
