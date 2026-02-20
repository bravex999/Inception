#!/bin/sh
set -eu

# Initialize only if datadir is empty (idempotent)
if [ ! -d '/var/lib/mysql/mysql' ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null

    # Start mysqld temporarily for initialization
    mysqld --user=mysql --datadir=/var/lib/mysql &
    pid=$!

    # Wait for server to be ready (bounded wait, max 30s)
    i=0
    until mariadb -uroot -e 'SELECT 1' >/dev/null 2>&1; do
        i=$((i+1))
        if [ "$i" -ge 30 ]; then
            echo 'MariaDB init timeout' >&2
            exit 1
        fi
        sleep 1
    done

    # Run initialization SQL via client
    mariadb -uroot <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    # Clean shutdown of temporary server
    mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait $pid
fi

# exec hands PID 1 to the actual server
exec mysqld --user=mysql --datadir=/var/lib/mysql
