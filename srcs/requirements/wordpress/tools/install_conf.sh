#!/bin/sh
PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
POOL_DIR="/etc/php/${PHP_VER}/fpm/pool.d"
mkdir -p "${POOL_DIR}"
cp /tools/www.conf "${POOL_DIR}/www.conf"
mkdir -p /run/php
