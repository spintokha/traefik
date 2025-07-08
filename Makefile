# -----------------------------------------------------------------------------
# Makefile for Docker Compose Traefik
# -----------------------------------------------------------------------------

# --- Dev
up-dev:
	docker-compose -f docker-compose-local.yml up -d

down-dev:
	docker-compose -f docker-compose-local.yml down

logs-dev:
	docker-compose -f docker-compose-local.yml logs -f

# --- Production
up-prod:
	docker-compose -f docker-compose-prod.yml up -d

down-prod:
	docker-compose -f docker-compose-prod.yml down

logs-prod:
	docker-compose -f docker-compose-prod.yml logs -f

help:
	@echo ""
	@echo "Available commands:"
	@echo "  make up-dev        Start development stack"
	@echo "  make down-dev      Stop development stack"
	@echo "  make logs-dev      Show logs for dev"
	@echo "  make up-prod       Start production stack"
	@echo "  make down-prod     Stop production stack"
	@echo "  make logs-prod     Show logs for prod"

