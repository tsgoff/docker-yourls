FROM mitcdh/caddy-php
MAINTAINER Mitchell Hewes <me@mitcdh.com>

RUN apk --update add \
    php5-gd \
    php5-pdo \
    php5-pdo_mysql && \
    rm -rf /var/cache/apk/*
VOLUME /www/public/user

ADD files/yourls.sh /www/yourls.sh
ADD files/Caddyfile /scripts/Caddyfile
RUN chmod +x /www/yourls.sh && chown -R web-srv:www-data /www/public


EXPOSE 2015