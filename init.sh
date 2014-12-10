#!/bin/sh


/usr/sbin/php-fpm -F &
/usr/sbin/nginx -c /etc/nginx/nginx.conf

wait

