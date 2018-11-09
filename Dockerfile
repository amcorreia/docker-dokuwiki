# Ripped from: https://bitbucket.org/mprasil/docker_dokuwiki/src/96330e626964?at=master
#
# DESCRIPTION:    Image with DokuWiki & lighttpd
# TO_BUILD:       docker build -t amcorreia/docker-dokuwiki .
# TO_RUN:         docker run -d -p 80:80 --name wiki amcorreia/docker-dokuwiki

# Base docker image
FROM alpine:3.8
MAINTAINER  Alessandro Madruga Correia <mutley.sandro@gmail.com>

# Set the version you want of Wiki
# current version 2018-04-22a
ENV DOKUWIKI_VERSION=stable DOKUWIKI_CSUM=18765a29508f96f9882349a304bffc03

# Update & install packages & cleanup afterwards
RUN set -x && apk --update --no-cache add wget tar \
              php7 php7-fpm php7-cli php7-session php7-gd php7-xml php7-opcache php7-json php7-mbstring php7-imagick php7-openssl && \
    wget --no-check-certificate -q -O /dokuwiki.tgz "https://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" && \
    if [ "$DOKUWIKI_CSUM" != "$(md5sum /dokuwiki.tgz | awk '{print($1)}')" ];then echo "Wrong md5sum of downloaded file!"; exit 1; fi && \
    mkdir /dokuwiki && \
    tar -zxf dokuwiki.tgz -C /dokuwiki --strip-components 1 && \
    chown -R 0:0 /dokuwiki && \
    apk del tar wget && \
    rm dokuwiki.tgz


EXPOSE 80

VOLUME ["/dokuwiki/data/", "/dokuwiki/lib/plugins/", "/dokuwiki/conf/", "/dokuwiki/lib/tpl/"]

WORKDIR /dokuwiki

CMD ["/usr/bin/php7", "-S", "0.0.0.0:80"]
