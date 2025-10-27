# -----------------------------------------------------------------------------
# Makefile for Docker Compose Traefik
# -----------------------------------------------------------------------------

.DEFAULT_GOAL := help

# --- Development Commands ---
up-dev:
	docker compose -f docker-compose-local.yml up -d

down-dev:
	docker compose -f docker-compose-local.yml down

restart-dev:
	docker compose -f docker-compose-local.yml restart

logs-dev:
	docker compose -f docker-compose-local.yml logs -f

ps-dev:
	docker compose -f docker-compose-local.yml ps

# --- Production Commands ---
up-prod:
	docker compose -f docker-compose-prod.yml up -d

down-prod:
	docker compose -f docker-compose-prod.yml down

restart-prod:
	docker compose -f docker-compose-prod.yml restart

logs-prod:
	docker compose -f docker-compose-prod.yml logs -f

ps-prod:
	docker compose -f docker-compose-prod.yml ps

# --- Setup & Maintenance ---
setup-prod:
	@echo "Setting up production environment..."
	@mkdir -p letsencrypt
	@touch letsencrypt/acme.json
	@chmod 600 letsencrypt/acme.json
	@echo "Production setup complete! letsencrypt/acme.json created with correct permissions."

pull-dev:
	docker compose -f docker-compose-local.yml pull

pull-prod:
	docker compose -f docker-compose-prod.yml pull

pull-all:
	docker compose -f docker-compose-local.yml pull
	docker compose -f docker-compose-prod.yml pull

status:
	@echo "=== Development Stack ==="
	@docker compose -f docker-compose-local.yml ps 2>/dev/null || echo "No dev containers running"
	@echo ""
	@echo "=== Production Stack ==="
	@docker compose -f docker-compose-prod.yml ps 2>/dev/null || echo "No prod containers running"

clean-dev:
	docker compose -f docker-compose-local.yml down -v

clean-prod:
	docker compose -f docker-compose-prod.yml down -v

# --- Help ---
help:
	@echo ""
	@echo "Traefik Docker Compose Management"
	@echo "=================================="
	@echo ""
	@echo "Development:"
	@echo "  make up-dev          Start development stack"
	@echo "  make down-dev        Stop development stack"
	@echo "  make restart-dev     Restart development stack"
	@echo "  make logs-dev        Show logs for dev (follow mode)"
	@echo "  make ps-dev          Show dev container status"
	@echo "  make clean-dev       Stop dev and remove volumes"
	@echo ""
	@echo "Production:"
	@echo "  make up-prod         Start production stack"
	@echo "  make down-prod       Stop production stack"
	@echo "  make restart-prod    Restart production stack"
	@echo "  make logs-prod       Show logs for prod (follow mode)"
	@echo "  make ps-prod         Show prod container status"
	@echo "  make clean-prod      Stop prod and remove volumes"
	@echo "  make setup-prod      Initialize letsencrypt directory"
	@echo ""
	@echo "Maintenance:"
	@echo "  make pull-dev        Pull latest dev images"
	@echo "  make pull-prod       Pull latest prod images"
	@echo "  make pull-all        Pull all images"
	@echo "  make status          Show all container statuses"
	@echo ""
