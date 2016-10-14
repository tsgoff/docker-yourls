FROM mitcdh/caddy-php:php7
MAINTAINER Mitchell Hewes <me@mitcdh.com>

RUN apk --update add \
    php7-pdo_mysql && \
    rm -rf /var/cache/apk/*
VOLUME /www/public/user

ADD files/yourls-config.sh /caddy-bootstrap/pre-run/01_yourls-config
ADD files/Caddyfile /caddy-bootstrap/Caddyfile
RUN chmod 500 /caddy-bootstrap/pre-run/01_yourls-config

EXPOSE 2015
