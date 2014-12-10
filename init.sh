#!/bin/sh

FILE=config.php
YOURLS_PATH=/usr/share/nginx/yourls/user/
SSL_PROTOCOLS_DEFAULT='TLSv1 TLSv1.1 TLSv1.2'
SSL_CIPHERS_DEFAULT='AES256+EECDH:AES256+EDH'

if [ -e /$YOURLS_PATH$FILE ]; then
  echo "restart check: installed"
  else
  echo "starting installation"
    if [ -z "$YOURLS_RELATIV_URL_ROOT" ]; then
            echo "install in Document Root"
    else
            echo "path to yourls: $YOURLS_RELATIV_URL_ROOT"
            /bin/mv /usr/share/nginx/yourls/ /usr/share/yourls/RWlzYW9iYWluZzBpZXNoCg
            /bin/mkdir -p /usr/share/nginx/yourls/$YOURLS_RELATIV_URL_ROOT
            /bin/mv /usr/share/nginx/RWlzYW9iYWluZzBpZXNoCg/* /usr/share/nginx/RWlzYW9iYWluZzBpZXNoCg/.??* /usr/share/nginx/yourls/$YOURLS_RELATIV_URL_ROOT
            /bin/rm -rf /usr/share/nginx/RWlzYW9iYWluZzBpZXNoCg
            YOURLS_PATH=/usr/share/nginx/owncloud/$YOURLS_RELATIV_URL_ROOT/config/
            /bin/chown -R nginx:nginx /usr/share/nginx/yourls/
            #/bin/echo "<?php header(\"Location: $YOURLS_RELATIV_URL_ROOT\"); die(); ?>" > /usr/share/nginx/yourls/index.php

    fi
    
    if [ -z "$YOURLS_SITE" ]; then
            echo "no YOURLS_SITE name detected"
            exit 1
    else
            echo "YOURLS_SITE name: $YOURLS_SITE"
    fi

    if [ -z "$MYSQL_ENV_MYSQL_ROOT_PASSWORD" ]; then
            echo "no linked mysql detected"
    else
            echo "linked mysql detected with container id $HOSTNAME and version $MYSQL_ENV_MYSQL_VERSION"
            DB_TYPE=link_mysql
    fi

    if [ -z "$POSTGRES_ENV_POSTGRES_PASSWORD" ]; then
            echo "no linked postgresql detected"
    else
            echo "linked postgresql detected with container id $HOSTNAME and version $POSTGRES_ENV_PG_VERSION"
            DB_TYPE=link_postgresql
    fi

    if [ -z "$DB_HOST" ]; then
            echo "no external mysql detected"
    else
            echo "external mysql detected"
            DB_TYPE=ext_mysql
    fi

    /bin/mkdir /data
    /bin/chown -R nginx:nginx /data

    function fixperm {
           /bin/chown nginx:nginx $YOURLS_PATH$FILE
    }

    case $DB_TYPE in
        link_mysql)
            echo 'using linked mysql'
            MYSQL_HOST=`echo $MYSQL_NAME | /bin/awk -F "/" '{print $3}'`
            echo "MySQL host is $MYSQL_HOST"
            if [ -z "$MYSQL_USER" ]; then
                echo "set MySQL user default to: root"
                MYSQL_USER=root
            fi
            /bin/cat >$YOURLS_PATH$FILE <<EOL
<?php
define( 'YOURLS_DB_USER', '$MYSQL_USER' );
define( 'YOURLS_DB_PASS', '$MYSQL_ENV_MYSQL_ROOT_PASSWORD' );
define( 'YOURLS_DB_NAME', 'yourls' );
define( 'YOURLS_DB_HOST', '$MYSQL_HOST' );
define( 'YOURLS_DB_PREFIX', '$DB_PREFIX' );
define( 'YOURLS_SITE', '$YOURLS_SITE' );
define( 'YOURLS_HOURS_OFFSET', 0 );
define( 'YOURLS_LANG', '' );
define( 'YOURLS_UNIQUE_URLS', true );
define( 'YOURLS_PRIVATE', true );
$yourls_user_passwords = array(
        'username' => 'password',
        );
define( 'YOURLS_DEBUG', false );
define( 'YOURLS_URL_CONVERT', 36 );
$yourls_reserved_URL = array(
        'reserved',
);
EOL
            fixperm
            ;;
        link_postgresql)
            echo 'using linked postgresql'
            POSTGRESQL_HOST=`echo $POSTGRES_NAME | /bin/awk -F "/" '{print $3}'`
            echo "PostgreSQL host is $POSTGRESQL_HOST"
            if [ -z "$POSTGRESQL_USER" ]; then
                    echo "set PostgreSQL user default to: postgres"
                    POSTGRESQL_USER=postgres
            fi
            if [ -z "$DB_NAME" ]; then
                    echo "set PostgreSQL Database Name to: postgres"
                    DB_NAME=postgres
            fi
            /bin/cat >$YOURLS_PATH$FILE <<EOL
<?php
define( 'YOURLS_DB_USER', '$POSTGRESQL_USER' );
define( 'YOURLS_DB_PASS', '$POSTGRES_ENV_POSTGRES_PASSWORD' );
define( 'YOURLS_DB_NAME', '$DB_NAME' );
define( 'YOURLS_DB_HOST', '$POSTGRESQL_HOST' );
define( 'YOURLS_DB_PREFIX', '$DB_PREFIX' );
define( 'YOURLS_SITE', '$YOURLS_SITE' );
define( 'YOURLS_HOURS_OFFSET', 0 );
define( 'YOURLS_LANG', '' );
define( 'YOURLS_UNIQUE_URLS', true );
define( 'YOURLS_PRIVATE', true );
$yourls_user_passwords = array(
        'username' => 'password',
        );
define( 'YOURLS_DEBUG', false );
define( 'YOURLS_URL_CONVERT', 36 );
$yourls_reserved_URL = array(
        'reserved',
);
EOL
            fixperm
            ;;
        ext_mysql)
            echo 'using external MYSQL DB'
            /bin/cat >$YOURLS_PATH$FILE <<EOL
<?php
define( 'YOURLS_DB_USER', '$DB_USER' );
define( 'YOURLS_DB_PASS', '$DB_PASSWORD' );
define( 'YOURLS_DB_NAME', '$DB_NAME' );
define( 'YOURLS_DB_HOST', '$DB_HOST' );
define( 'YOURLS_DB_PREFIX', '$DB_PREFIX' );
define( 'YOURLS_SITE', '$YOURLS_SITE' );
define( 'YOURLS_HOURS_OFFSET', 0 );
define( 'YOURLS_LANG', '' );
define( 'YOURLS_UNIQUE_URLS', true );
define( 'YOURLS_PRIVATE', true );
$yourls_user_passwords = array(
        'username' => 'password',
        );
define( 'YOURLS_DEBUG', false );
define( 'YOURLS_URL_CONVERT', 36 );
$yourls_reserved_URL = array(
        'reserved',
);
EOL
            fixperm
            ;;
        *)
            echo "no database specified"
            exit 1
    esac


    if [ -z "$FQDN" ]; then
            echo "no fqdn"
            FQDN="local.host"
    else
            echo "found fqdn $FQDN"
            /bin/sed -i "s@server_name  _@server_name  $FQDN@g" /etc/nginx/conf.d/default.conf
    fi


    if [ -z "$SSL_SELFSIGNED" ]; then
            echo "no SSL"
    else
            echo "generating selfsigned cert"
            if [ -z "$SSL_PROTOCOLS" ]; then
                  echo "set default SSL protocol"
                  SSL_PROTOCOLS=$SSL_PROTOCOLS_DEFAULT
            fi
            if [ -z "$SSL_CIPHERS" ]; then
                  echo "set default SSL ciphers"
                  SSL_CIPHERS=$SSL_CIPHERS_DEFAULT
            fi

    /bin/mkdir /etc/nginx/ssl/
    /bin/chown nginx:nginx /etc/nginx/ssl/

    ### <--
        /usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt <<SSL
 YourlsCity
 $FQDN
SSL
    ### -->

    /bin/cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/ssl.conf
    /bin/sed -i "s@listen       80 default_server@listen       443@g" /etc/nginx/conf.d/ssl.conf
    /bin/sed -i '/server_name/a\\n    ssl                  on; \n\
        ssl_certificate      /etc/nginx/ssl/nginx.crt;\n    ssl_certificate_key  /etc/nginx/ssl/nginx.key;\n\
        ssl_session_timeout  5m;\n\n    ssl_protocols  '"$SSL_PROTOCOLS"';\
        ssl_ciphers  '"$SSL_CIPHERS"';\
        ssl_prefer_server_ciphers   on;'  /etc/nginx/conf.d/ssl.conf

    fi

    /bin/env >>  /INSTALLED
    set >> /INSTALLED
fi

/usr/sbin/php-fpm -F &
/usr/sbin/nginx -c /etc/nginx/nginx.conf

if [ -f /data/backup/config.php ]; then
    echo "found backup file -> restore"
    source /data/backup/yourls_env.conf
    /bin/cp /data/backup/config.php $YOURLS_PATH/config.php
    /bin/chown nginx:nginx $YOURLS_PATH/config.php
else
    echo "create backup"
    /bin/mkdir /data/backup && /bin/chown -R nginx:nginx $_
    /bin/echo "YOURLS_PATH=$YOURLS_PATH" > /data/backup/yourls_env.conf && /bin/chown nginx:nginx /data/backup/yourls_env.conf
    while [ ! -f "$YOURLS_PATH/config.php" ]
      do
        /bin/sleep 1
      done
    until /bin/grep installed $YOURLS_PATH/config.php
      do
        /bin/sleep 1
      done
    /bin/cp $YOURLS_PATH/config.php /data/backup/ && /bin/chown nginx:nginx /data/backup/config.php
fi

wait

