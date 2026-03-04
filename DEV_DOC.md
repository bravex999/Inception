# Developer Notes — Inception

## Prerequisites

- Debian/Ubuntu VM with desktop environment and browser
- Docker Engine and Docker Compose v2 (`docker compose version` returns v2.x.x)
- User added to `docker` group (`docker ps` works without sudo)
- `/etc/hosts` entry: `127.0.0.1 chnaranj.42.fr`
- Directories created: `/home/chnaranj/data/mariadb` and `/home/chnaranj/data/wordpress`

## Setup from Scratch

```bash
git clone <repo-url> inception
cd inception
cp .env from out to srcs/.env
nano srcs/.env                  # fill all 'change_me' values
mkdir -p /home/chnaranj/data/mariadb /home/chnaranj/data/wordpress
make
```

## Project Structure

```
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
└── srcs/
    ├── .env
    ├── .env.example
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/    (Dockerfile, conf/, tools/)
        ├── wordpress/  (Dockerfile, tools/)
        └── nginx/      (Dockerfile, conf/, tools/)
```

## Container Management

```bash
docker compose -f srcs/docker-compose.yml -p inception ps
docker compose -f srcs/docker-compose.yml -p inception logs -f <service>
docker exec -it inception-<service>-1 sh
```

## Data Storage

Named volumes use `driver_opts` with `device` pointing to host directories:

- `inception_mariadb_data` → `/home/chnaranj/data/mariadb`
- `inception_wordpress_data` → `/home/chnaranj/data/wordpress`

```bash
docker volume ls | grep inception
docker volume inspect inception_mariadb_data    # check Options.device
docker volume inspect inception_wordpress_data  # check Options.device
ls /home/chnaranj/data/mariadb/                 # MariaDB files on host
ls /home/chnaranj/data/wordpress/               # WordPress files on host
```

- `make down` preserves volumes (data survives).
- `make clean` removes containers and images but preserves volumes.
- Volumes must be removed manually with `docker volume rm` if needed.

## Debug

```bash
# MariaDB connectivity
docker exec -it inception-mariadb-1 mariadb -u wpuser -p;'

# php-fpm listening
docker exec inception-wordpress-1 ss -lntp | grep 9000

# TLS verification
openssl s_client -connect chnaranj.42.fr:443 -tls1_2
openssl s_client -connect chnaranj.42.fr:443 -tls1_3

# HTTP must be refused
curl http://chnaranj.42.fr
```
