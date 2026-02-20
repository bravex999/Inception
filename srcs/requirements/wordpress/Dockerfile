FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php-fpm php-mysql curl mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php /var/www/html

RUN curl -sSLo /usr/local/bin/wp \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

RUN PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;') && \
    mkdir -p /etc/php/${PHP_VER}/fpm/pool.d

COPY tools/www.conf /tools/www.conf
COPY tools/install_conf.sh /tools/install_conf.sh
RUN chmod +x /tools/install_conf.sh && /tools/install_conf.sh

COPY tools/entrypoint.sh /tools/entrypoint.sh
RUN chmod +x /tools/entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/tools/entrypoint.sh"]
