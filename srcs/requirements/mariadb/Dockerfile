FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/entrypoint.sh /tools/entrypoint.sh
RUN chmod +x /tools/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/tools/entrypoint.sh"]
