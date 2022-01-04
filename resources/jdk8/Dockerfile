#FROM alpine:3.10.3
FROM java

MAINTAINER w741069229@163.com
USER root
#ADD jdk.tar.gz /usr/java/
#LABEL desc="jdk8"
#ENV JAVA_HOME /usr/java/jdk
#ENV PATH ${PATH}:${JAVA_HOME}/bin
RUN java -version
#RUN mkdir -p /opt
WORKDIR /opt
CMD [ "java","-version" ]
COPY words-project-0.0.1-SNAPSHOT.jar /opt/
#RUN ls   /opt/
##CMD["java","-jar","words-project-0.0.1-SNAPSHOT.jar"]
ENTRYPOINT ["java", "-jar", "/opt/words-project-0.0.1-SNAPSHOT.jar"]







