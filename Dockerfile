FROM mitcdh/caddy-php
MAINTAINER Mitchell Hewes <me@mitcdh.com>

RUN apk --update add \
    php5-gd \
    php5-pdo \
    php5-pdo_mysql && \
    rm -rf /var/cache/apk/*

ADD files/yourls.sh /www/yourls.sh
ADD files/Caddyfile /scripts/Caddyfile
RUN chmod +x /www/yourls.sh

VOLUME /www/public/user

EXPOSE 2015