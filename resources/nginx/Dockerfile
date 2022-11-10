FROM centos:centos7.9.2009

MAINTAINER w741069229@163.com
LABEL author="shizeying"
LABEL version="1.19.1"

LABEL desc=""
## 设置默认语言环境
ENV LANG=C.UTF-8
#定义时区参数
ENV TZ=Asia/Shanghai
#设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

#安装必要应用
RUN yum -y install kde-l10n-Chinese glibc-common

#设置编码
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

#设置环境变量
ENV LC_ALL zh_CN.utf8


RUN yum -y install pcre* openssl* pcre-devel patch gcc g++ gcc-c++ zlib zlib-devel openssl \
    openssl--devel pcre pcre-devel readline-devel pcre-devel openssl-devel


ADD nginx.tar.gz /usr/local/
ENV LUAJIT_LIB=/usr/local/src/LuaJIT/lib
ENV LUAJIT_INC=/usr/local/src/LuaJIT/include/luajit-2.0
RUN cd /usr/local/src/LuaJIT && make install PREFIX=/usr/local/src/LuaJIT

RUN echo "export LUAJIT_LIB=/usr/local/src/LuaJIT/lib" >> /etc/profile
RUN echo "export LUAJIT_INC=/usr/local/src/LuaJIT/include/luajit-2.0" >> /etc/profile
RUN source /etc/profile

RUN  cd /usr/local/src/nginx && \
 ./configure --prefix=/usr/local/nginx \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --error-log-path=/usr/local/nginx/log/error.log  \
    --http-log-path=/usr/local/nginx/log/access.log  \
    --with-file-aio  \
    --without-http_fastcgi_module ${NGINX_DEBUG:+--debug}  \
    --without-http_uwsgi_module \
    --user=root --group=root    \
    --with-http_stub_status_module \
    --with-http_realip_module  \
    --with-http_gzip_static_module \
    --with-pcre \
    --with-ld-opt="-Wl,-rpath,/usr/local/LuaJIT/lib"  \
    --with-stream=dynamic \
     --with-http_ssl_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --add-module=/usr/local/src/ngx_devel_kit \
    --add-module=/usr/local/src/nginx-upsync-module \
    --add-module=/usr/local/src/nginx_upstream_check_module \
    --add-module=/usr/local/src/nginx-upsync-module \
     && make  && make install
EXPOSE 80
ENV NGINX_HOME=/usr/local/nginx
ENV PATH=$PATH:$NGINX_HOME/sbin
RUN ln -sf /dev/stdout /usr/local/nginx/log/access.log && \
    ln -sf /dev/stderr /usr/local/nginx/log/error.log
STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]

#FROM centos:centos7.9.2009
### 设置默认语言环境
#ENV LANG=C.UTF-8
##定义时区参数
#ENV TZ=Asia/Shanghai
##设置时区
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone
#COPY --from=0 /usr/local/nginx /usr/local/nginx
#COPY --from=0 /usr/lib64/ /usr/lib64/
#EXPOSE 80
#ENV NGINX_HOME=/usr/local/nginx
#ENV PATH=$PATH:$NGINX_HOME/sbin
#RUN ln -sf /dev/stdout /usr/local/nginx/log/access.log && \
#    ln -sf /dev/stderr /usr/local/nginx/log/error.log
#STOPSIGNAL SIGQUIT