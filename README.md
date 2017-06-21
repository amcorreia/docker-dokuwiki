#amcorreia/dokuwiki
==================

[![Docker Stars](https://img.shields.io/docker/stars/amcorreia/docker-dokuwiki.svg)](https://hub.docker.com/r/amcorreia/docker-dokuwiki/)
[![Docker Pulls](https://img.shields.io/docker/pulls/amcorreia/docker-dokuwiki.svg)](https://hub.docker.com/r/amcorreia/docker-dokuwiki/)
[![Docker Build](https://img.shields.io/docker/automated/amcorreia/docker-dokuwiki.svg)](https://hub.docker.com/r/amcorreia/docker-dokuwiki/)
[![Layers](https://images.microbadger.com/badges/image/amcorreia/docker-dokuwiki.svg)](https://microbadger.com/images/amcorreia/docker-dokuwiki)
[![Version](https://images.microbadger.com/badges/version/amcorreia/docker-dokuwiki.svg)](https://microbadger.com/images/amcorreia/docker-dokuwiki)


Lightweight Docker container image with [DokuWiki](https://www.dokuwiki.org/dokuwiki) and lighttpd based on Alpine Linux.

### How to run

Assume your docker host is localhost and HTTP public port is 80 (change these values if you need).

### Without data persistency
Just run:

```sh
$ docker run -d -p 80:80 --name wiki amcorreia/dokuwiki
```

### Data persistency

## Volumes we are going to use

| Volume | Usage |
| ------ | ------ |
| data | All data that is written by DokuWiki is stored here (see [savedir](https://www.dokuwiki.org/config:savedir)), the changelog is placed here, too |
| plugins | [Plugins](https://www.dokuwiki.org/plugins) are stored here |
| conf | [Configuration](https://www.dokuwiki.org/devel:configuration) data is stored here  |
| tpl | [Template](https://www.dokuwiki.org/template) |

Create all volumes

```sh
$ docker volume create dokuwiki-data
$ docker volume create dokuwiki-plugins
$ docker volume create dokuwiki-conf
$ docker volume create dokuwiki-tpl
```

Run container with all volumes set up

```
$ docker run --rm -it -p 80:80 --volume dokuwiki-data:/dokuwiki/data --volume dokuwiki-plugins:/dokuwiki/lib/plugins --volume dokuwiki-conf:/dokuwiki/conf --volume dokuwiki-tpl:/dokuwiki/lib/tpl --name wiki  amcorreia/dokuwiki
```

or you can use
```
$ docker run  -it -p 80:80 --volume dokuwiki-data:/dokuwiki/data --volume dokuwiki-plugins:/dokuwiki/lib/plugins --volume dokuwiki-conf:/dokuwiki/conf --volume dokuwiki-tpl:/dokuwiki/lib/tpl --name wiki  amcorreia/dokuwiki
```
and next time just run
```
$ docker start wiki
```

### Backup

I like the idea of using volume because this makes more easy to know which volume belongs to wich container, and
this way I can mount this volume local, and read file normally. To do this.

## Requirements

Install [bindfs](http://bindfs.org/)
```
# apt-get install bindfs
```

Now edit /etc/fstab (this is how i'm using)


```sh
# grep docker /etc/fstab
/var/lib/docker/volumes/dokuwiki-data/_data/    /home/amcorreia/Documentos/WikiPages/data    fuse.bindfs map=100/1000:@101/@1000,auto 0 0
/var/lib/docker/volumes/dokuwiki-plugins/_data/ /home/amcorreia/Documentos/WikiPages/plugins fuse.bindfs map=100/1000:@101/@1000,auto 0 0
/var/lib/docker/volumes/dokuwiki-conf/_data/    /home/amcorreia/Documentos/WikiPages/conf    fuse.bindfs map=100/1000:@101/@1000,auto 0 0
/var/lib/docker/volumes/dokuwiki-tpl/_data/     /home/amcorreia/Documentos/WikiPages/tpl     fuse.bindfs map=100/1000:@101/@1000,auto 0 0
```

This will map systemd-timesync (100) with my user id (1000) and same for group.Now will be able to edit file directly
in folder `~/Documentos/WikiPage/`
