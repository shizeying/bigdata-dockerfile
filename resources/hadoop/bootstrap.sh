#!/bin/bash

#fonts color
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"
#notification information
export HADOOP_HOME=/app/hadoop
export HBASE_HOME=/app/hbase
export KAFKA_HOME=/app/kafka
export FLINK_HOME=/app/flink
export PATH=${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${HBASE_HOME}/bin:${FLINK_HOME}/bin:${KAFKA_HOME}/bin

#hadoop
# shellcheck disable=SC2034
namenode=$(ps -ef | grep namenode | grep -v "grep" | wc -l)

#spark
count=0
# shellcheck disable=SC2120
is_root() {
  # shellcheck disable=SC2046
  if [ $(id -u) == 0 ]; then
    echo -e "${OK} ${Red} 当前用户是root用户，进入启动流程 ${Font}"
  else
    echo -e "${Error} ${RedBG} 当前用户不是root用户，请重新配置dockerfile ${Font}"
    exit 1
  fi
}
is_hadoop() {
  if [ "${count}" -eq 0 ]; then
    echo -e "${OK} ${GreenBG} 开始启动namenode ${Font}"
    hadoop-daemon.sh start namenode
  else
    echo -e "${Error} ${RedBG} 启动namenode失败 ${Font}"
    exit 1
  fi
  namenodestart=$(ps -ef | grep namenode | grep -v "grep" | wc -l)
  count=$((count + namenodestart))
  if [ "${count}" -eq 1 ]; then
    echo -e "${OK} ${GreenBG} 开始启动datanode ${Font}"
    hadoop-daemon.sh start datanode
  else
    echo -e "${Error} ${RedBG} 启动datanode失败 ${Font}"
    exit 2
  fi
  datanode=$(ps -ef | grep datanode | grep -v "grep" | wc -l)
  count=$((count + datanode))
  if [ "${count}" -eq 2 ]; then
    echo -e "${OK} ${GreenBG} 开始启动resourcemanager ${Font}"
    yarn-daemon.sh start resourcemanager
  else
    echo -e "${Error} ${RedBG} 启动resourcemanager失败 ${Font}"
    exit 2
  fi
  # shellcheck disable=SC2126
  resourcemanager=$(ps -ef | grep resourcemanager | grep -v "grep" | wc -l)
  count=$((count + resourcemanager))
  # shellcheck disable=SC2086
  if [ "${count}" -eq 3 ]; then
    echo -e "${OK} ${GreenBG} 开始启动nodemanager ${Font}"
    yarn-daemon.sh start nodemanager
  else
    echo -e "${Error} ${RedBG} 启动nodemanager失败 ${Font}"
    exit 4
  fi
  nodemanager=$(ps -ef | grep nodemanager | grep -v "grep" | wc -l)
  count=$((count + nodemanager))
  if [ "${count}" -eq 4 ]; then
    echo -e "${OK} ${GreenBG} 开始启动historyserver ${Font}"
    mr-jobhistory-daemon.sh start historyserver
  else
    echo -e "${Error} ${RedBG} 启动nodemanager失败 ${Font}"
    exit 4
  fi

}

is_hbase() {
  historyserver=$(ps -ef | grep historyserver | grep -v "grep" | wc -l)
  count=$((count + historyserver))
  sleep 3
  quorumpeermain=$( (ps -ef | grep QuorumPeerMain | grep -v "grep" | wc -l))
  count=$((count + quorumpeermain))
  if [ "${count}" -eq 6 ]; then
    echo -e "${OK} ${RedBG} 开始启动hbase ${Font}"
    start-hbase.sh
    hbase-daemon.sh start rest
    hbase-daemon.sh start thrift
  else
    echo -e "${Error} ${RedBG} 启动quorumpeermain未启动 ${Font}"
    exit 6
  fi
  restserver=$(ps -ef | grep RESTServer | grep -v "grep" | wc -l)
  ts=$(ps -ef | grep ThriftServer | grep -v "grep" | wc -l)
  hregionserver=$( (ps -ef | grep HRegionServer | grep -v "grep" | wc -l))
  hmaster=$( (ps -ef | grep HMaster | grep -v "grep" | wc -l))
  count=$((count + restserver + ts + hregionserver + hmaster))
  if [ "${count}" -ne 10 ]; then
    exit 10
  fi
}

main() {
  is_root
  is_hadoop
  is_hbase
}
list() {
  case $1 in
  "-d")
    main
    ;;
  esac
}
list $1
