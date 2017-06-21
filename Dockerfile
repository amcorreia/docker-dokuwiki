# Ripped from: https://bitbucket.org/mprasil/docker_dokuwiki/src/96330e626964?at=master
#
# DESCRIPTION:    Image with DokuWiki & lighttpd
# TO_BUILD:       docker build -t amcorreia/docker-dokuwiki .
# TO_RUN:         docker run -d -p 80:80 --name wiki amcorreia/docker-dokuwiki

# Base docker image
FROM alpine:3.6
MAINTAINER  Alessandro Madruga Correia <mutley.sandro@gmail.com>

# Set the version you want of Wiki
ENV DOKUWIKI_VERSION=stable DOKUWIKI_CSUM=ea11e4046319710a2bc6fdf58b5cda86

# Update & install packages & cleanup afterwards
RUN set -x && apk add --update --no-cache wget lighttpd php5-cgi php5-gd php5-xml tar tzdata && \
    wget --no-check-certificate -q -O /dokuwiki.tgz "https://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" && \
    if [ "$DOKUWIKI_CSUM" != "$(md5sum /dokuwiki.tgz | awk '{print($1)}')" ];then echo "Wrong md5sum of downloaded file!"; exit 1; fi && \
    mkdir /dokuwiki && \
    tar -zxf dokuwiki.tgz -C /dokuwiki --strip-components 1 && \
    rm dokuwiki.tgz && \
    chown -R lighttpd:lighttpd /dokuwiki && \
    mkdir /var/run/lighttpd && \
    chown lighttpd:lighttpd /var/run/lighttpd && \
    echo 'include "dokuwiki.conf"' >> /etc/lighttpd/lighttpd.conf && \
    apk del tar wget

# Configure lighttpd
ADD dokuwiki.conf /etc/lighttpd/dokuwiki.conf

EXPOSE 80

VOLUME ["/dokuwiki/data/", "/dokuwiki/lib/plugins/", "/dokuwiki/conf/", "/dokuwiki/lib/tpl/"]

ENTRYPOINT ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
