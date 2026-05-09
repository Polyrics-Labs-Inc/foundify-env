BACK := src/back

.PHONY: init init-dev init-prod \
        up down \
        install run migrate migration rollback test lint format shell

DOCKER_COMPOSE = docker compose

init:
	@scripts/init.sh && scripts/init-back.sh

init-prod:
	@scripts/init.sh prod && scripts/init-back.sh prod

up:
	@[ -f .env ] || $(MAKE) init
	$(DOCKER_COMPOSE) -f compose.yml up -d

down:
	$(DOCKER_COMPOSE) -f compose.yml down

up-prod:
	@[ -f .env ] || $(MAKE) init-prod
	$(DOCKER_COMPOSE) -f compose.yml -f compose.prod.yml up -d
