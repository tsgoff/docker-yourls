#!/bin/sh

YOURLS_SRC=/www/yourls-src
YOURLS_PATH=/www/public

echo "updating yourls"
cp -Ru "${YOURLS_SRC}/." "${YOURLS_PATH}/"