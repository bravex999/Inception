NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml -p $(NAME)

all: up

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --rmi all

re: clean up

.PHONY: all up down clean re
