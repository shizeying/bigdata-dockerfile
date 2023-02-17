##修改你需要的版本即可
FROM docker.elastic.co/elasticsearch/elasticsearch:7.16.0  as builder
MAINTAINER w741069229@163.com

LABEL author="史泽颖"
LABEL version=${version}

ENV version=7.16.0

ENV knn_version=${version}.0

USER elasticsearch
LABEL desc="elasticsearch是基于alpine:3.10的镜像构建出来的,优点是比centos构建出来的更小巧,缩小了大概200M,其中改变了中文乱码的情况,使用jdk8,有了ik,拼音,繁体,hanLp这四个插件,其中该版本更改了拼音插件,支持中文拼音混合查询"
RUN     echo y | bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v${version}/elasticsearch-analysis-ik-${version}.zip  && \
 echo y | bin/elasticsearch-plugin   install https://github.com/medcl/elasticsearch-analysis-pinyin/releases/download/v${version}/elasticsearch-analysis-pinyin-${version}.zip   && \
 echo y | bin/elasticsearch-plugin   install https://github.com/alexklibisz/elastiknn/releases/download/${knn_version}/elastiknn-${knn_version}.zip   && \
 echo y | bin/elasticsearch-plugin install analysis-phonetic   && \
 echo y | bin/elasticsearch-plugin install ingest-attachment   && \
 echo y | bin/elasticsearch-plugin install repository-s3   && \
  bin/elasticsearch-plugin install analysis-icu
# echo y | bin/elasticsearch-plugin install https://github.com/shizeying/elasticsearch-dynamic-synonym/releases/download/v${version}/elasticsearch-dynamic-synonym-${version}.zip    && \
USER root
RUN  rm -rf /opt/*.zip
USER elasticsearch




EXPOSE 9300 9200
FROM docker.elastic.co/elasticsearch/elasticsearch:7.16.0
COPY --from=0 /usr/share/elasticsearch/ /usr/share/elasticsearch/