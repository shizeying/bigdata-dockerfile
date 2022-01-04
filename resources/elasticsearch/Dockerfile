##修改你需要的版本即可
FROM docker.elastic.co/elasticsearch/elasticsearch:7.13.0  as builder
MAINTAINER w741069229@163.com

LABEL author="史泽颖"
LABEL version=${version}
ENV version=7.13.0
USER elasticsearch
#COPY elasticsearch.yml  /usr/share/elasticsearch/config/elasticsearch.yml
#ADD plugin/elasticsearch-analysis-ik-${version}.zip /opt
ADD plugin/elasticsearch-dynamic-synonym-7.13.0.zip /opt
ADD plugin/elasticsearch-analysis-dynamic-synonym-7.13.0.zip /opt
#ADD plugin/elasticsearch-position-similarity-7.9.3.zip /opt
ADD java.policy /usr/share/elasticsearch/jdk/conf/security/java.policy
LABEL desc="elasticsearch是基于alpine:3.10的镜像构建出来的,优点是比centos构建出来的更小巧,缩小了大概200M,其中改变了中文乱码的情况,使用jdk8,有了ik,拼音,繁体,hanLp这四个插件,其中该版本更改了拼音插件,支持中文拼音混合查询"
#./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v6.3.0/elasticsearch-analysis-ik-6.3.0.zip
#RUN     echo y | bin/elasticsearch-plugin install file:///opt/elasticsearch-analysis-ik-${version}.zip  && \
RUN     echo y | bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v${version}/elasticsearch-analysis-ik-${version}.zip  && \
#	echo y | bin/elasticsearch-plugin   install https://github.com/KennFalcon/elasticsearch-analysis-hanlp/releases/download/v${version}/elasticsearch-analysis-hanlp-${version}.zip && \
#  echo y | bin/elasticsearch-plugin install https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-smartcn/analysis-smartcn-${version}.zip    && \
# echo y | bin/elasticsearch-plugin   install https://github.com/NLPchina/elasticsearch-analysis-ansj/releases/download/v7.9.3/elasticsearch-analysis-ansj-7.9.3.0-release.zip  && \
 echo y | bin/elasticsearch-plugin   install https://github.com/medcl/elasticsearch-analysis-pinyin/releases/download/v${version}/elasticsearch-analysis-pinyin-${version}.zip   && \
# echo y | bin/elasticsearch-plugin   install http://es-learn-to-rank.labs.o19s.com/ltr-plugin-v1.5.3-es7.9.3.zip   && \
# echo y | bin/elasticsearch-plugin   install https://github.com/alexklibisz/elastiknn/releases/download/0.1.0-PRE51/elastiknn-0.1.0-PRE51_es7.9.3.zip   && \
 echo y | bin/elasticsearch-plugin install analysis-phonetic   && \
 echo y | bin/elasticsearch-plugin install ingest-attachment   && \
  bin/elasticsearch-plugin install analysis-icu    && \
 echo y | bin/elasticsearch-plugin install file:///opt/elasticsearch-dynamic-synonym-7.13.0.zip    && \
 echo y | bin/elasticsearch-plugin install file:///opt/elasticsearch-analysis-dynamic-synonym-7.13.0.zip    && \
# echo y | bin/elasticsearch-plugin install file:///opt/elasticsearch-position-similarity-7.9.3.zip    && \
  mkdir  config/synonym && \
  touch config/synonym/synonym.dic
USER root
RUN  rm -rf /opt/*.zip
USER elasticsearch




EXPOSE 9300 9200
FROM docker.elastic.co/elasticsearch/elasticsearch:7.13.0
COPY --from=0 /usr/share/elasticsearch/ /usr/share/elasticsearch/