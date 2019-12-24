#!/bin/bash
export ZOOKEEPER_HOME=/app/zookeeper
export HADOOP_HOME=/app/hadoop
export HBASE_HOME=/app/hbase
export KAFKA_HOME=/app/kafka
export FLINK_HOME=/app/flink
export PATH=${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${HBASE_HOME}/bin:${FLINK_HOME}/bin:${KAFKA_HOME}/bin:${ZOOKEEPER_HOME}/bin
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
RedBG="\033[41;37m"
GreenBG="\033[42;37m"
Font="\033[0m"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"
# shellcheck disable=SC2046
# shellcheck disable=SC2034
sum=0
# shellcheck disable=SC2009
qps=$(ps -ef | grep QuorumPeerMain | grep -v grep | grep -v kill | awk '{print $2}')
ks=$(ps -ef | grep kafka | grep -v grep | grep -v kill | awk '{print $2}')
ns=$(ps -ef | grep namenode | grep -v grep | grep -v kill | awk '{print $2}')
ds=$(ps -ef | grep datanode | grep -v grep | grep -v kill | awk '{print $2}')
rs=$(ps -ef | grep resourcemanager | grep -v grep | grep -v kill | awk '{print $2}')
nms=$(ps -ef | grep nodemanager | grep -v grep | grep -v kill | awk '{print $2}')
hss=$(ps -ef | grep historyserver | grep -v grep | grep -v kill | awk '{print $2}')
hrss=$(ps -ef | grep HRegionServer | grep -v grep | grep -v kill | awk '{print $2}')
hms=$(ps -ef | grep HMaster | grep -v grep | grep -v kill | awk '{print $2}')
ssces=$(ps -ef | grep StandaloneSessionClusterEntrypoint | grep -v grep | grep -v kill | awk '{print $2}')

function stop_pid() {
  echo -e "${OK} ${Yellow} 开始检测并关闭未关闭的pid ${Font}"
  # shellcheck disable=SC2154
  if [[ -n "${qps}" ]]; then
    zkServer.sh stop
    qps2=$(ps -ef | grep QuorumPeerMain | grep -v grep | grep -v kill | awk '{print $2}')
    if [[ -n "${qps2}" ]]; then
      kill -s 9 ${qps2}
    fi
  fi
  if [[ -n "${ks}" ]]; then
    # shellcheck disable=SC2086
    /app/kafka/bin/kafka-server-stop.sh
    ks2=$(ps -ef | grep kafka | grep -v grep | grep -v kill | awk '{print $2}')
    if [[ -n "${ks2}" ]]; then
      kill -s 9 "${ks2}"
    fi
  fi
  if [[ -n "${ns}" ]]; then
    # shellcheck disable=SC2086
    kill -s 9 ${ns}
  fi
  if [[ -n "${ds}" ]]; then
    kill -s 9 "${ds}"
  fi
  if [[ -n "${rs}" ]]; then
    kill -s 9 "${rs}"
  fi
  if [[ -n "${nms}" ]]; then
    kill -s 9 "${nms}"
  fi
  if [[ -n "${hss}" ]]; then
    # shellcheck disable=SC2086
    kill -s 9 ${hss}
  fi

  if [[ -n "${hrss}" ]]; then
    # shellcheck disable=SC2086
    # shellcheck disable=SC2154

    kill -s 9 ${hrss}
  fi
  if [[ -n "${hms}" ]]; then
    # shellcheck disable=SC2086
    kill -s 9 ${hms}
    exit 3
  fi
  # shellcheck disable=SC2154
  if [[ -n "${ssces}" ]]; then
    /app/flink/bin/stop-cluster.sh
    ssces2=$(ps -ef | grep StandaloneSessionClusterEntrypoint | grep -v grep | grep -v kill | awk '{print $2}')
    if [[ -n "${ssces2}" ]]; then
      kill -s 9 "${ssces2}"
    fi
  fi
  rm -rf /tmp/*
}
function start_kafka_zookeeper() {
  quorumpeermain=$( (ps -ef | grep QuorumPeerMain | grep -v "grep" | wc -l))
  if [ "${quorumpeermain}" -eq 0 ]; then
    echo -e "${OK} ${Yellow} 开始启动zookeeper ${Font}"
    zkServer.sh start
    until zkServer.sh status; do
      sleep 0.1
    done
    echo -e "${OK} ${Yellow} 开始启动kafka ${Font}"
    is_kafka
    kafka=$( (ps -ef | grep kafka | grep -v "grep" | wc -l))
    if [ "${kafka}" -eq 0 ]; then
      echo -e "${Error} ${RedBG} 启动失败 ${Font}"
      exit 0
    fi
  else
    echo -e "${Error} ${RedBG} 启动失败 ${Font}"
    exit 5
  fi
  quorumpeermainStart=$( (ps -ef | grep QuorumPeerMain | grep -v "grep" | wc -l))
  sum=$((sum + quorumpeermainStart))
}
is_kafka() {
  # Set the external host and port
  echo "----------->${ADVERTISED_HOST}"
  if [ ! -z "$ADVERTISED_HOST" ]; then
    echo "advertised host: $ADVERTISED_HOST"
    if grep -q "^advertised.host.name" $KAFKA_HOME/config/server.properties; then
      sed -r -i "s/#(advertised.host.name)=(.*)/\1=$ADVERTISED_HOST/g" $KAFKA_HOME/config/server.properties
    else
      echo "advertised.host.name=$ADVERTISED_HOST" >>$KAFKA_HOME/config/server.properties
    fi
  fi
    echo "----------->${ADVERTISED_PORT}"
  if [ ! -z "$ADVERTISED_PORT" ]; then
    echo "advertised port: $ADVERTISED_PORT"
    if grep -q "^advertised.port" $KAFKA_HOME/config/server.properties; then
      sed -r -i "s/#(advertised.port)=(.*)/\1=$ADVERTISED_PORT/g" $KAFKA_HOME/config/server.properties
    else
      echo "advertised.port=$ADVERTISED_PORT" >>$KAFKA_HOME/config/server.properties
    fi
  fi
  # Allow specification of log retention policies
  if [ ! -z "$LOG_RETENTION_HOURS" ]; then
    echo "log retention hours: $LOG_RETENTION_HOURS"
    sed -r -i "s/(log.retention.hours)=(.*)/\1=$LOG_RETENTION_HOURS/g" $KAFKA_HOME/config/server.properties
  fi
  if [ ! -z "$LOG_RETENTION_BYTES" ]; then
    echo "log retention bytes: $LOG_RETENTION_BYTES"
    sed -r -i "s/#(log.retention.bytes)=(.*)/\1=$LOG_RETENTION_BYTES/g" $KAFKA_HOME/config/server.properties
  fi

  # Configure the default number of log partitions per topic
  if [ ! -z "$NUM_PARTITIONS" ]; then
    echo "default number of partition: $NUM_PARTITIONS"
    sed -r -i "s/(num.partitions)=(.*)/\1=$NUM_PARTITIONS/g" $KAFKA_HOME/config/server.properties
  fi
  # Enable/disable auto creation of topics
  if [ ! -z "$AUTO_CREATE_TOPICS" ]; then
    echo "auto.create.topics.enable: $AUTO_CREATE_TOPICS"
    echo "auto.create.topics.enable=$AUTO_CREATE_TOPICS" >>$KAFKA_HOME/config/server.properties
  fi
  /app/kafka/bin/kafka-server-start.sh /app/kafka/config/server.properties 1>/app/kafka/logs/kafka-server.log 2>&1 &
}
function is_start_bigdata() {
  echo -e "${OK} ${Yellow} 开始启动bigdata ${Font}"
  if [ "${sum}" -eq 1 ]; then
    su - root -c "/usr/local/bin/bootstrap.sh -d"
  fi
}
function is_flink() {
  namenode=$(ps -ef | grep namenode | grep -v "grep" | wc -l)
  datanode=$(ps -ef | grep datanode | grep -v "grep" | wc -l)
  resourcemanager=$(ps -ef | grep resourcemanager | grep -v "grep" | wc -l)
  nodemanager=$(ps -ef | grep nodemanager | grep -v "grep" | wc -l)
  historyserver=$(ps -ef | grep historyserver | grep -v "grep" | wc -l)
  sum=$((sum + namenode + datanode + resourcemanager + nodemanager + historyserver))
  if [ "${sum}" -eq 6 ]; then
    echo -e "${OK} ${Yellow} 开始启动flink ${Font}"
    start-cluster.sh
  else
    echo -e "${Error} ${RedBG} 启动flink失败 ${Font}"
    exit 6
  fi

}
function is_success() {
  # shellcheck disable=SC2009
  flink=$( (ps -ef | grep StandaloneSessionClusterEntrypoint | grep -v "grep" | wc -l))
  hregionserver=$( (ps -ef | grep HRegionServer | grep -v "grep" | wc -l))
  hmaster=$( (ps -ef | grep HMaster | grep -v "grep" | wc -l))
  sum=$((sum + flink + hregionserver + hmaster))
  if [ "${sum}" -eq 9 ]; then
    echo -e "${OK} ${GreenBG} 启动完毕 ${Font}"
    while true; do sleep 1000; done
  fi
}
function main() {
  echo -e "${OK} ${Yellow} 开始启动 ${Font}"
  stop_pid
  start_kafka_zookeeper
  is_start_bigdata
  is_flink
  is_success
}

main
