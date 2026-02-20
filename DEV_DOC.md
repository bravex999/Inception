# DEV_DOC

## Set up the environment from scratch
### Prerequisites
- Virtual Machine (as required by the subject)
- Docker + Docker Compose
- `make`

### Configuration files / secrets
- Copy `.env`:
  ```sh
  cp srcs/.env.example srcs/.env
  ```
  Fill it with real values.
- If you use secrets: store them locally (gitignored) and mount them as files in containers.
- Ensure persistent storage exists under `/home/chnaranj/data` on the host (named volumes target this location).
- Configure DNS/hosts so `chnaranj.42.fr` resolves to your local VM IP.

## Build and launch
From the repository root:
```sh
make
```

Stop:
```sh
make down
```

Full clean:
```sh
make clean
```

## Architecture
Three containers orchestrated by Docker Compose on a custom bridge network:
- **nginx**: terminates TLS and forwards PHP requests to WordPress via FastCGI
- **wordpress**: php-fpm + WordPress bootstrap (often via WP-CLI)
- **mariadb**: database init and provisioning

Only nginx exposes port 443 to the host. WordPress/MariaDB are reachable only on the internal network by service name.

## Data storage and persistence
- Persistent data is stored in Docker named volumes.
- On the host, volume data is located under `/home/chnaranj/data`.

## Manage containers and volumes
Status / logs:
```sh
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs -f --tail=200
```

Volumes:
```sh
docker volume ls
docker volume inspect <volume_name>
```

## Debug checklist
- NGINX: `ssl_protocols` allows only TLSv1.2/TLSv1.3; container runs in foreground (no infinite loops).
- WordPress: php-fpm only (no nginx inside), waits for DB readiness, bootstrap is idempotent.
- MariaDB: initializes datadir once, provisions DB/users, then runs normally.
- `.env`/secrets: no passwords committed in the repository.
