FROM openjdk:8u191-jdk-alpine   as builder
MAINTAINER : shizeying <w741069229@gmail.com>
ENV PATH $PATH:/opt/flume/bin
#设置工作目录
RUN  mkdir /opt/flume \
         && wget -qO- http://archive.apache.org/dist/flume/1.8.0/apache-flume-1.8.0-bin.tar.gz \
               | tar zxvf - -C /opt/flume --strip 1
ADD start-flume.sh /opt/flume/bin/start-flume
RUN chmod 777 /opt/flume/bin/start-flume
#ENV PATH $PATH:/opt/flume/bin
ENTRYPOINT [ "start-flume" ]
FROM openjdk:8u191-jdk-alpine
WORKDIR /opt/flume
COPY --from=0 /opt/flume /opt/flume