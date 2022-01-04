FROM openjdk:8u102-jre
#docker.plantdata.cn/app/openjdk:8u102-jre
MAINTAINER shizeying
RUN   echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list \
 && apt update
ENV TZ=Asia/Shanghai
#设置编码
#设置编码
ENV LANG C.UTF-8
WORKDIR /work