FROM mitcdh/caddy-php:php7
MAINTAINER Mitchell Hewes <me@mitcdh.com>

RUN apk --update add \
    php7-pdo_mysql && \
    rm -rf /var/cache/apk/*
VOLUME /www/public/user

COPY files/yourls-config.sh /caddy-bootstrap/pre-run/01_yourls-config
COPY files/Caddyfile /caddy-bootstrap/Caddyfile
COPY files/yourls-install.sh /www/yourls-install.sh
RUN chmod 500 /caddy-bootstrap/pre-run/01_yourls-config \
 && chown www-data:www-data /www/public

EXPOSE 2015
