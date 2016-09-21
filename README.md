# Docker Yourls

* Docker image to start a yourls container with Alpine, Hiawatha, fpm, and an external mysql host.

### Environment Variables
* `YOURLS_SITE`='http://domain.tld'
* `YOURL_USER`='admin'
* `YOURL_PASSWORD`='mysecretpassword'
* `DB_PREFIX`='yourls_'
* `DB_HOST`='mysql01.yourls.tld'
* `DB_USER`='yourls'
* `DB_PASSWORD`='mysecretpassword'
* `DB_NAME`='yourls'
* `REDIRECT_SITE`='http://mysite.tld'

### Usage
````
docker run -d \
-e DB_HOST='mysql01.yourls.tld' \
-e DB_USER='yourls' \
-e DB_PASSWORD='mysecretpassword' \
-e DB_NAME='yourls' \
-e YOURL_USER='admin' \
-e YOURL_PASSWORD='mysecretpassword' \
-e YOURLS_SITE='http://sh.tld' \
mitcdh/yourls
````

### Structure
* `/www`: Web root
* `/yourls-data`: yourls user directory

### Exposed Ports
* `80`: http web server

### Credits
* [bios/docker-yourls](https://hub.docker.com/r/bios/docker-yourls/)
