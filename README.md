This project has been created as part of the 42 curriculum by chnaranj.
Description
Inception is a system administration project that deploys a small web infrastructure using Docker. Three services — NGINX, WordPress with php-fpm, and MariaDB — run in isolated containers, orchestrated by Docker Compose. The stack is accessible only via HTTPS (port 443) with TLSv1.2/1.3, and data persists through named volumes stored under /home/chnaranj/data.
Instructions

Clone the repository and enter the directory
Copy srcs/.env.example to srcs/.env and fill in real credentials
Run make
Open https://chnaranj.42.fr in the browser (accept the self-signed certificate warning)
Stop: make down — Full clean: make clean

Project Description
Virtual Machines vs Docker
A VM emulates full hardware and runs a complete OS, providing strong isolation at the cost of high resource usage and slow boot times. Docker containers share the host kernel, start in milliseconds, and consume far less memory. This project uses both: the VM provides a reproducible host environment, while Docker isolates each service.
Secrets vs Environment Variables
Environment variables (.env) are plain text and can be exposed through docker inspect. Docker secrets mount sensitive data as files in a tmpfs filesystem, visible only inside the container. The subject requires .env for configuration and recommends secrets for passwords.
Docker Network vs Host Network
Host network removes all network isolation — containers share the host's network stack, which can cause port conflicts. A custom bridge network (used in this project) isolates containers from the host and from each other while allowing inter-container communication by service name.
Docker Volumes vs Bind Mounts
Bind mounts link a specific host directory into a container, creating tight coupling with the host filesystem layout. Named volumes are managed by Docker, portable across environments, and survive container rebuilds. The subject requires named volumes; bind mounts are forbidden.
Resources

Docker docs — https://docs.docker.com — Container lifecycle, Compose syntax, networking, and volume management
Dockerfile best practices — https://docs.docker.com/develop/develop-images/dockerfile_best-practices/ — Image layering, PID 1, and entrypoint patterns
MariaDB Knowledge Base — https://mariadb.com/kb/en/ — Server configuration, user management, and mariadb-install-db usage
NGINX docs — https://nginx.org/en/docs/ — HTTPS configuration, ssl_protocols, and FastCGI proxy setup
WP-CLI — https://wp-cli.org/ — Automated WordPress installation and user creation via command line
PHP-FPM manual — https://www.php.net/manual/en/install.fpm.php — Pool configuration, process management, and clear_env directive
OpenSSL — https://www.openssl.org/docs/ — Self-signed certificate generation with req command

AI Usage
The AI  was used as a learning and productivity tool throughout this project. Specifically:

Concept explanations: PID 1 in Docker, idempotent initialization, TLS handshake, bridge networks, named volumes, FastCGI protocol, DNS resolution, bootstrap mode, etc.
Structuring entrypoint scripts for MariaDB, WordPress, and NGINX
Debugging initialization failures.


All generated content was reviewed, tested manually, and adapted to pass evaluation. No code was used without understanding its purpose.
