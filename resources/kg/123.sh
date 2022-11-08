#!/bin/bash
PROG=kganalysis
PROG_JAR="/work/kganalysis.jar"
LOGDIR=/work/logs/${PROG}
JVM_OPTS="-Xms512m -Xmx512m -Xmn256m"
HEAP_DUMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$LOGDIR"
JAVA_OPTS="$APOLLO $JVM_OPTS $HEAP_DUMP_OPTS"

PID=$(ps -ef|grep kgdefence|grep -v grep|awk '{print $2}')
if [ -z $PID ]; then
	echo "process kgdefence not exist"
	exit
else
	echo "process id: $PID"
	kill -9 ${PID}
	echo "process kgdefence killed"
fi
