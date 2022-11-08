#!/bin/bash
export APOLLO="-Dapollo.meta=http://192.168.110.110:8083"
export JVM_OPTS="-Xms512m -Xmx512m"
PROG=kg-services-semantic
PROG_JAR="/work/jar/kg-services-semantic.jar"
LOGDIR=/work/logs/${PROG}
JVM_OPTS="-Xms512m -Xmx512m -Xmn256m"
HEAP_DUMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$LOGDIR"
JAVA_OPTS="$APOLLO $JVM_OPTS $HEAP_DUMP_OPTS"

PID=$(ps -ef|grep kg-services-semantic|grep -v grep|awk '{print $2}')
if [ -z $PID ]; then
	echo "process kg-services-semantic not exist"
	exit
else
	echo "process id: $PID"
	kill -9 ${PID}
	echo "process kg-services-semantic killed"
fi

nohup java  $JAVA_OPTS -jar $PROG_JAR > $LOGDIR/kg-services-semantic.log 2>&1
