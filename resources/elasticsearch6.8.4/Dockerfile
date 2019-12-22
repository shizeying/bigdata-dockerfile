FROM alpine:3.10.3 AS builder
MAINTAINER w741069229@163.com
LABEL desc="elasticsearch 6.8.4"
RUN mkdir -p elasticsearch
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.8.4.tar.gz /opt/
RUN  tar zxvf /opt/elasticsearch-6.8.4.tar.gz    -strip-components=1  -C   /usr/share/elasticsearch
#ADD elasticsearch.tar.gz /usr/share/
ADD docker-entrypoint.sh   /usr/local/bin/docker-entrypoint.sh
RUN grep ES_DISTRIBUTION_TYPE=tar /usr/share/elasticsearch/bin/elasticsearch-env \
    && sed -ie 's/ES_DISTRIBUTION_TYPE=tar/ES_DISTRIBUTION_TYPE=docker/' /usr/share/elasticsearch/bin/elasticsearch-env

WORKDIR /usr/share/elasticsearch

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh
RUN mkdir -p  data logs

RUN chmod 777 config data logs
ENV PATH /usr/share/elasticsearch/bin:$PATH

RUN adduser -D -h /usr/share/elasticsearch  elasticsearch
RUN chown -R elasticsearch /usr/share/elasticsearch
RUN chgrp -R elasticsearch /usr/share/elasticsearch
RUN chown -R elasticsearch /opt/
RUN mkdir -p /var/log/elasticsearch && \
	chown -R elasticsearch  /var/log/elasticsearch

USER elasticsearch
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["eswrapper"]

#CMD ["bash"]
