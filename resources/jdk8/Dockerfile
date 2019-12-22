FROM alpine-all

MAINTAINER w741069229@163.com

ADD jdk.tar /usr/java/
LABEL desc="jdk8"
ENV JAVA_HOME /usr/java/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin
RUN java -version
WORKDIR /opt







