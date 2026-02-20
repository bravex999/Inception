# DEV_DOC

## Architecture
Three containers orchestrated by Docker Compose on a custom bridge network:
- nginx: terminates TLS and forwards PHP requests to WordPress via FastCGI
- wordpress: php-fpm + WordPress bootstrap (often via WP-CLI)
- mariadb: database init and provisioning

Only nginx exposes port 443 to the host. WordPress/MariaDB are reachable only on the internal network by service name.

## Data persistence
Named volumes (bind mounts are forbidden by the subject). Persistent data lives under:
`/home/chnaranj/data`

## Entrypoints (idempotent bootstrap)
- MariaDB: initialize datadir if empty, start server for bootstrap, create DB/user/privileges, then run normally.
- WordPress: wait for DB readiness, generate config, install WordPress, create users, then run php-fpm.
- NGINX: generate/load TLS cert/key, validate config, run in foreground (PID 1).

Goal: scripts must be safe to re-run (no duplicate creation / no destructive resets).

## Security notes
- HTTPS only (TLSv1.2/1.3).
- `.env` is required for config but may be exposed (e.g., docker inspect). Docker secrets are safer but optional/recommended.

## Useful dev commands
```sh
make
make down
make clean
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs -f --tail=200
```

## Debug checklist
- Verify nginx ssl_protocols includes only TLSv1.2/1.3.
- Confirm fastcgi_pass targets the wordpress service + correct port.
- Confirm MariaDB users/privileges match `.env`.
- Ensure processes run in foreground (containers should not exit immediately).
