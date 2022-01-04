FROM centos:7

MAINTAINER shizeying
ENV TZ=Asia/Shanghai
#设置编码
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
#设置环境变量
ENV LC_ALL zh_CN.utf8

ENV JAVA_HOME=/etc/alternatives/jre
WORKDIR /work
COPY chromedriver /usr/bin/chromedriver
RUN yum update glib2 -y  &&\
    yum install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm  java-1.8.0-openjdk   java-1.8.0-openjdk-devel && \
    google-chrome --version  && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&  \
    echo "Asia/Shanghai" > /etc/timezone && \
    date -R
