#!/bin/sh
set -eu

if [ ! -f '/var/lib/mysql/.initialized' ]; then
    echo "First run: initializing database..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    mysqld --user=mysql --datadir=/var/lib/mysql &
    pid=$!

    i=0
    until mariadb -uroot -e 'SELECT 1' >/dev/null 2>&1; do
        i=$((i+1))
        if [ "$i" -ge 30 ]; then
            echo "MariaDB init timeout" >&2
            exit 1
        fi
        sleep 1
    done
    echo "MariaDB is ready, running init SQL..."

    mariadb -uroot -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mariadb -uroot -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mariadb -uroot -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mariadb -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mariadb -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

    echo "Init SQL complete. Shutting down temporary server..."
    mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait $pid

    touch /var/lib/mysql/.initialized
    echo "Initialization done."
fi

exec mysqld --user=mysql --datadir=/var/lib/mysql
