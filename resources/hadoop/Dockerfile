FROM jdk-scala

MAINTAINER shizeying:w741069229@163.com

USER root
RUN mkdir -p /app
WORKDIR /app
##头部
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
	cat  /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_key
RUN mkdir -p hadoop hbase zookeeper

ADD ssh_config /root/.ssh/config
##hadoop
#RUN wget -O hadoop.tar.gz https://archive.cloudera.com/cdh5/cdh/5/hadoop-2.6.0-cdh5.14.2.tar.gz
#RUN tar zxvf hadoop-2.6.0-cdh5.14.2.tar.gz  -strip-components=1  -C  /app/hadoop
#ADD hadoop.tar.gz /app/

COPY hadoop.tar.gz   /app/
RUN mkdir -p /app/hadoop
RUN tar zxf /app/hadoop.tar.gz  --strip-components=1  -C  /app/hadoop && \
	rm -rf /app/hadoop.tar.gz
ENV HADOOP_HOME /app/hadoop
ENV HADOOP_PREFIX /app/hadoop
ENV HADOOP_COMMON_HOME /app/hadoop
ENV HADOOP_HDFS_HOME /app/hadoop
ENV HADOOP_MAPRED_HOME /app/hadoop
ENV HADOOP_YARN_HOME /app/hadoop
ENV HADOOP_CONF_DIR /app/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_HOME/etc/hadoop

RUN mkdir -p /app/hadoop/data/tmp
ADD etc/hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD etc/hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD etc/hadoop/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD etc/hadoop/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD etc/hadoop/slaves $HADOOP_HOME/etc/hadoop/slaves
ADD etc/hadoop/hadoop-env.sh    $HADOOP_HOME/etc/hadoop/hadoop-env.sh
ADD etc/hadoop/yarn-env.sh    $HADOOP_HOME/etc/hadoop/yarn-env.sh
ADD etc/hadoop/mapred-env.sh    $HADOOP_HOME/etc/hadoop/mapred-env.sh
RUN chmod +x $HADOOP_HOME/etc/hadoop/*-env.sh
#zookeeper
ADD zookeeper.tar.gz /app/
ADD etc/zookeeper/zoo.cfg /app/zookeeper/conf/zoo.cfg
RUN mkdir -p /app/zookeeper/data  && \
	mkdir -p /app/zookeeper/logs  && \
	touch  /app/zookeeper/data/myid  && \
	echo "0" > /app/zookeeper/data/myid
ENV ZOOKEEPER_HOME /app/zookeeper

##hbase
#RUN wget https://archive.cloudera.com/cdh5/cdh/5/hbase-1.2.0-cdh5.14.2.tar.gz
#RUN  tar xvf hbase-1.2.0-cdh5.14.2.tar.gz  -strip-components 1  -C  /app/hbase
ADD hbase.tar.gz /app/
ADD etc/hbase/hbase-site.xml /app/hbase/conf/hbase-site.xml
ADD etc/hbase/hbase-env.sh  /app/hbase/conf/hbase-env.sh
ENV HBASE_HOME  /app/hbase

#flink
ADD flink.tar.gz /app
ADD  /etc/flink/flink-conf.yaml /app/flink/conf/flink-conf.yaml
ADD  /etc/flink/masters /app/flink/conf/masters
ADD  /etc/flink/slaves /app/flink/conf/slaves
ADD  /etc/flink/zoo.cfg /app/flink/conf/zoo.cfg
ENV FLINK_HOME /app/flink
#kafka
ADD kafka.tar.gz /app
ADD etc/kafka/server.properties /app/kafka/config/server.properties
ENV KAFKA_HOME /app/kafka
ENV KAFKA_VERSION=2.11-1.0.2-cdh5.14.2
RUN chmod +x ${KAFKA_HOME}/bin/*.sh
RUN mkdir -p /app/kafka/logs
RUN touch /app/kafka/logs/kafka-server.log

#path配置
ENV PATH ${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${ZOOKEEPER_HOME}/bin:${HBASE_HOME}/bin:${FLINK_HOME}/bin:${KAFKA_HOME}/bin
## format hdfs, add libraries to hdfs, set up hive metastore
ADD bootstrap.sh /usr/local/bin/bootstrap.sh
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 777  /usr/local/bin/*.sh
RUN chown root.root -R /app
RUN hdfs namenode -format
HEALTHCHECK --interval=60s --timeout=5s CMD /usr/local/bin/bootstrap.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#CMD ["/usr/local/bin/start-kafkak.sh" ]
#CMD ["bash"]
# hadoop
EXPOSE 8088 50070 9000 19888 8020 8033 8031 8032  8042  50090   50010  50020
## zoo
EXPOSE 2181
##hbase
EXPOSE 60010 16301  16201
##flink
EXPOSE 9999  6123 8081
WORKDIR /app/
