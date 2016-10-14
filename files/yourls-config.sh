#!/bin/sh

CONFIG=config.php
INDEX=index.php
YOURLS_PATH=/www/public
YOURLS_USER=${YOURLS_PATH}/user

# config check
if [ -e "${YOURLS_USER}/${CONFIG}" ]; then
    echo "config check: existing config"
else
    if [ -z "$DB_USER" ]; then
        echo "no DB_USER found -> EXIT"
        exit 1
    else
        echo "found DB_USER"
    fi
    
    if [ -z "$DB_PASSWORD" ]; then
        echo "no DB_PASSWORD found -> EXIT"
        exit 1
    else
        echo "found DB_PASSWORD"
    fi
    
    if [ -z "$DB_NAME" ]; then
        echo "no database name found -> default is yourls"
        DB_NAME="yourls"
    else
        echo "database name detected"
    fi
    
    if [ -z "$DB_HOST" ]; then
        echo "no external mysql detected"
        DB_HOST="127.0.0.1"
    else
        echo "external mysql detected"
    fi
    
    if [ -z "$DB_PREFIX" ]; then
        echo "no DB_PREFIX found"
        DB_PREFIX="yourls_"
    else
        echo "DB_PREFIX: $DB_PREFIX"
    fi
    
    if [ -z "$YOURL_USER" ]; then
        echo "no YOURL_USER found -> default is admin"
        YOURL_USER="admin"
    else
        echo "YOURL_USER: $YOURL_USER"
    fi
    
    if [ -z "$YOURL_PASSWORD" ]; then
        echo "no YOURL_PASSWORD found -> EXIT"
        exit 1
    else
        echo "found YOURL_PASSWORD"
    fi
    
    if [ -z "$YOURLS_SITE" ]; then
        echo "no YOURLS_SITE name detected -> EXIT"
        exit 1
    else
        echo "YOURLS_SITE name: $YOURLS_SITE"
    fi

    /bin/cat >"${YOURLS_USER}/${CONFIG}" <<EOL
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
\$yourls_user_passwords = array(
        '$YOURL_USER' => '$YOURL_PASSWORD',
        );
define( 'YOURLS_DEBUG', false );
define( 'YOURLS_URL_CONVERT', 36 );
\$yourls_reserved_URL = array(
        'reserved',
);
EOL
    chmod 660 "${YOURLS_USER}/${CONFIG}"
    chown www-data:www-data "${YOURLS_USER}/${CONFIG}"
fi

# index.php redirect check
if [ -z "$REDIRECT_SITE" ]; then
    echo "no REDIRECT_SITE name detected"
else
    echo "REDIRECT_SITE name: $REDIRECT_SITE"
    /bin/cat >"${YOURLS_PATH}/${INDEX}" <<EOL
<?php
header('Location:${REDIRECT_SITE}');
?>
EOL
    chmod 664 "${YOURLS_PATH}/${INDEX}"
fi
