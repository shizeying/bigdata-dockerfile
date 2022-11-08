#!/bin/bash

export APOLLO="-Dapollo.meta=http://192.168.110.110:8083"
export JVM_OPTS="-Xms512m -Xmx512m"
PROG=kganalysis
PROG_JAR="/work/jar/kganalysis.jar"
LOGDIR=/work/logs/${PROG}
JVM_OPTS="-Xms512m -Xmx512m -Xmn256m"
HEAP_DUMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$LOGDIR"
JAVA_OPTS="$APOLLO $JVM_OPTS $HEAP_DUMP_OPTS"

PID=$(ps -ef|grep kganalysis|grep -v grep|awk '{print $2}')
if [ -z $PID ]; then
	echo "process kganalysis not exist"
	exit
else
	echo "process id: $PID"
	kill -9 ${PID}
	echo "process kganalysis killed"
fi

nohup java  $JAVA_OPTS -jar $PROG_JAR > $LOGDIR/kganalysis.log 2>&1
