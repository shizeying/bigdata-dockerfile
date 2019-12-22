#!/bin/bash
export ZOOKEEPER_HOME=/app/zookeeper
export PATH=${PATH}${ZOOKEEPER_HOME}/bin
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
RedBG="\033[41;37m"
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


function stop_pid() {
  echo -e "${OK} ${Yellow} 开始检测并关闭未关闭的pid ${Font}"
  # shellcheck disable=SC2154
  if [[ -n "${qps}" ]]; then
    kill -9 "${qps}"
  fi
  if [[ -n "${ks}" ]]; then
    # shellcheck disable=SC2086
    kill -9 ${ks}
  fi
  if [[ -n "${ns}" ]]; then
    # shellcheck disable=SC2086
    kill -9 ${ns}
  fi
  if [[ -n "${ds}" ]]; then
    kill -9 "${ds}"
  fi
  if [[ -n "${rs}" ]]; then
    kill -9 "${rs}"
  fi
  if [[ -n "${nms}" ]]; then
    kill -9 "${nms}"
  fi
  if [[ -n "${hss}" ]]; then
    # shellcheck disable=SC2086
    kill -9 ${hss}
  fi

  if [[ -n "${hrss}" ]]; then
    # shellcheck disable=SC2086
    # shellcheck disable=SC2154
    kill -9 ${hrss}
  fi
  if [[ -n "${hms}" ]]; then
    # shellcheck disable=SC2086
    kill -9 ${hms}
  fi
  # shellcheck disable=SC2154
  if [[ -n "${ssces}" ]]; then
    kill -9 "${ssces}"
  fi
}
function start_kafka_zookeeper() {
  quorumpeermain=$( (ps -ef | grep QuorumPeerMain | grep -v "grep" | wc -l))
  if [ "${quorumpeermain}" -eq 0 ]; then
    echo -e "${OK} ${Yellow} 开始启动zookeeper ${Font}"
    zkServer.sh start
    echo -e "${OK} ${Yellow} 开始启动kafka ${Font}"
    /app/kafka/bin/kafka-server-start.sh /app/kafka/config/server.properties 1>/app/kafka/logs/kafka-server.log 2>&1 &
  else
    echo -e "${Error} ${RedBG} 启动失败 ${Font}"
    exit 5
  fi
  quorumpeermainStart=$( (ps -ef | grep QuorumPeerMain | grep -v "grep" | wc -l))
  kafka=$( (ps -ef | grep kafka | grep -v "grep" | wc -l))
  sum=$((sum + quorumpeermainStart + kafka))
}
function is_start_bigdata() {
  if [ "${sum}" -eq 2 ]; then
    su - root -c "/usr/local/bin/bootstrap.sh -d"
  fi
}
function main() {
  echo -e "${OK} ${Yellow} 开始启动 ${Font}"
  stop_pid
  start_kafka_zookeeper
  is_start_bigdata
}

main
