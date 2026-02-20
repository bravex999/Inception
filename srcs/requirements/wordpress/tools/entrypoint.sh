#!/bin/sh
set -eu

# Wait for MariaDB (bounded, max 30s)
i=0
until mariadb -hmariadb -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" \
    -e 'SELECT 1;' >/dev/null 2>&1; do
    i=$((i+1))
    if [ "$i" -ge 30 ]; then
        echo 'MariaDB not responding after 30s; aborting.' >&2
        exit 1
    fi
    sleep 1
done
echo "MariaDB is ready."

# Idempotent install (only if wp-config.php is missing)
if [ ! -f wp-config.php ]; then
    echo "First run: installing WordPress..."

    wp core download --allow-root

    wp config create \
        --dbname="${MYSQL_DATABASE}" --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" --dbhost="mariadb:3306" \
        --allow-root

    wp core install \
        --url="https://${DOMAIN_NAME}" --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email --allow-root

    wp user create "${WP_USER}" "${WP_EMAIL}" \
        --user_pass="${WP_PASSWORD}" --role=author --allow-root

    echo "WordPress installed."
fi

# exec hands PID 1 to php-fpm in foreground
PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
exec php-fpm${PHP_VER} -F
