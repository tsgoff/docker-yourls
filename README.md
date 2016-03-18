docker-yourls
========

http://yourls.org/#About  
https://registry.hub.docker.com/u/bios/docker-yourls/

**Docker image to start a yourls container with CentOS, Nginx, fpm**

optional with linked MySQL/Postgres Container or external MySQL.

Quickstart with mysql container
----------

    docker run --name yourlsmysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d mysql
    docker run --name yourls -d \
    -e YOURL_USER='admin' \
    -e YOURL_PASSWORD='mysecretpassword' \
    -e YOURLS_SITE='http://sh.tld' \
    --link yourlsmysql:mysql bios/docker-yourls


Options
-------
 - YOURLS_SITE='http://domain.tld'
 - YOURL_USER='admin'
 - YOURL_PASSWORD='mysecretpassword'

 - YOURLS_RELATIV_URL_ROOT='/short'
 - FQDN='sh.tld'
 - SSL_SELFSIGNED='true'
 - SSL_PROTOCOLS='TLSv1 TLSv1.1 TLSv1.2'
 - SSL_CIPHERS='AES256+EECDH:AES256+EDH'
 - DB_PREFIX='yourls_'
 - DB_HOST='mysql01.yourls.tld'
 - DB_USER='yourls'
 - DB_PASSWORD='mysecretpassword'
 - DB_NAME='yourls'
 - YOURLS_PUB_DUMMY='true'
 - HTTPS='true'
 - REDIRECT_MAIN_PAGE='http://otherdomain.tld'

Linking to PostgreSQL Container
-------------------------------  


    docker run --name yourlspostgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
    docker exec yourlspostgres sed -i '/IPv4 local connections/a host    all             all             172.17.42.1/32          trust' \
    /var/lib/postgresql/data/pg_hba.conf
    docker restart yourlspostgres
        docker run --name yourls -d \
    -e YOURL_USER='admin' \
    -e YOURL_PASSWORD='mysecretpassword' \
    -e YOURLS_SITE='http://sh.tld' \
    --link yourlspostgres:postgres bios/docker-yourls
    
External MySQL Server
---------------------

    docker run --dns 8.8.8.8 \
    -e DB_HOST='mysql01.yourls.tld' \
    -e DB_USER='yourls' \
    -e DB_PASSWORD='mysecretpassword' \
    -e DB_NAME='yourls' \
    -e FQDN='sh.tld' \
    -e YOURL_USER='admin' \
    -e YOURL_PASSWORD='mysecretpassword' \
    -e YOURLS_SITE='http://sh.tld' \
    -e YOURLS_PUB_DUMMY='true' \
    -d bios/docker-yourls

Example
-------
Example with linked MySQL, custom path, custom SSL version / ciphers and custom FQDN

    docker run --name yourls --dns 8.8.4.4 -d \
    -v /opt/yourls:/data \
    -e SSL_SELFSIGNED='true' \
    -e DB_PREFIX='yourls_' \
    -e SSL_PROTOCOLS='TLSv1 TLSv1.1 TLSv1.2' \
    -e SSL_CIPHERS='AES256+EECDH:AES256+EDH' \
    -e YOURLS_RELATIV_URL_ROOT='/short' \
    -e YOURLS_SITE='http://domain.tld' \
    -e YOURL_USER='admin' \
    -e YOURL_PASSWORD='mysecretpassword' \
    -e FQDN='my.hostname.tld' -p 443:443 --link yourlsmysql:mysql bios/docker-yourls
