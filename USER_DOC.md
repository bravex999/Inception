# USER_DOC

## What services are provided
This stack provides:
- **NGINX**: HTTPS entrypoint (TLS) and reverse-proxy/FastCGI gateway
- **WordPress (php-fpm)**: the website and the admin panel
- **MariaDB**: the database used by WordPress

Only HTTPS (port 443) is exposed to the host.

## Start / stop
From the repository root:
```sh
cp .env(host) to srcs/.env
# edit srcs/.env with real credentials
make
```

Stop containers:
```sh
make down
```

Full clean:
```sh
make clean
```

## Access the website and admin panel
Website:
```text
https://chnaranj.42.fr
```

Administration panel:
```text
https://chnaranj.42.fr/wp-admin
```
Log in with the WordPress administrator credentials configured in your `.env` (or secrets, if you use them).

## Where credentials are located (and how to manage them)
- Main configuration is stored in: `srcs/.env` (must not be committed).


To rotate credentials:
1) update `.env`
2) restart the stack (`make down` then `make`).

## Check that everything is running
Basic status:
```sh
docker compose -f srcs/docker-compose.yml ps
```

Check HTTPS responds (self-signed cert expected):
```sh
curl -kI https://chnaranj.42.fr
```

If something fails, inspect logs:
```sh
docker compose -f srcs/docker-compose.yml logs -f --tail=200
```
