##修改你需要的版本即可
FROM yili/es

MAINTAINER w741069229@163.com
LABEL author="史泽颖"
LABEL version="6.8.4"

LABEL desc="elasticsearch是基于alpine:3.10的镜像构建出来的,优点是比centos构建出来的更小巧,缩小了大概200M,其中改变了中文乱码的情况,使用jdk8,有了ik,拼音,繁体,hanLp这四个插件,其中该版本更改了拼音插件,支持中文拼音混合查询"
ADD elasticsearch-analysis-ik-6.8.4.zip /opt/
ADD elasticsearch-analysis-pinyin-6.8.4.zip /opt/
ADD elasticsearch-analysis-stconvert-6.8.4.zip /opt/
ADD elasticsearch-analysis-hanlp-6.8.4.zip /opt/
RUN echo y | bin/elasticsearch-plugin   install file:///opt/elasticsearch-analysis-hanlp-6.8.4.zip
RUN echo y | bin/elasticsearch-plugin install file:///opt/elasticsearch-analysis-ik-6.8.4.zip
RUN ./bin/elasticsearch-plugin   install file:///opt/elasticsearch-analysis-pinyin-6.8.4.zip
RUN ./bin/elasticsearch-plugin   install file:///opt/elasticsearch-analysis-stconvert-6.8.4.zip
RUN rm -rf /opt/*.zip
EXPOSE 9300 9200

