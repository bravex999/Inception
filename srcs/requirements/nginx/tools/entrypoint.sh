#!/bin/sh
set -eu

# Generate self-signed certificate if missing
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
        -subj "/C=ES/ST=Madrid/L=42/O=Inception/CN=${DOMAIN_NAME}" \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt
fi

exec nginx -g 'daemon off;'
