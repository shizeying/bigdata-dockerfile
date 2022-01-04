FROM  myapline
MAINTAINER w741069229@163.com
LABEL desc="scala+java8"
ADD scala.tar /usr/java/
ADD jdk.tar.gz /usr/java/
ENV JAVA_HOME /usr/java/jdk
ENV SCALA_HOME /usr/java/scala
ENV PATH ${PATH}:${SCALA_HOME}/bin:${JAVA_HOME}/bin
WORKDIR /app