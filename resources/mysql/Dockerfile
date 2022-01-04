FROM myapline
ARG BUILD_DATE
ARG VCS_REF
RUN apk add --no-cache  mariadb mariadb-client mariadb-server-utils pwgen && \
    rm -f /var/cache/apk/*
ADD file/start.sh /usr/local/bin/start.sh
RUN mkdir -p /docker-entrypoint-initdb.d && \
    mkdir -p /scripts/pre-exec.d && \
    mkdir -p /scripts/pre-init.d
EXPOSE 3306
RUN chmod 777  /usr/local/bin/start.sh
ENTRYPOINT ["/usr/local/bin/start.sh"]
#CMD ["bash"]