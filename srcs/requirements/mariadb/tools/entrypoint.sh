#!/bin/sh
set -eu

# Initialize only if datadir is empty (idempotent)
if [ ! -d '/var/lib/mysql/mysql' ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null

    cat > /tmp/init.sql <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap < /tmp/init.sql
    rm -f /tmp/init.sql
fi

# exec hands PID 1 to the actual server
exec mysqld --user=mysql --datadir=/var/lib/mysql
