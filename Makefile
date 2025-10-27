# -----------------------------------------------------------------------------
# Makefile for Docker Compose Traefik
# -----------------------------------------------------------------------------

.DEFAULT_GOAL := help

# Load .env file if it exists
-include .env
export

# Set default environment if not specified
ENV ?= local

# Determine which compose file to use based on ENV
ifeq ($(ENV),prod)
    COMPOSE_FILE = docker-compose-prod.yml
else
    COMPOSE_FILE = docker-compose-local.yml
endif

# --- Main Commands ---
up:
	@echo "Starting $(ENV) environment..."
	docker compose -f $(COMPOSE_FILE) up -d

down:
	@echo "Stopping $(ENV) environment..."
	docker compose -f $(COMPOSE_FILE) down

restart:
	@echo "Restarting $(ENV) environment..."
	docker compose -f $(COMPOSE_FILE) restart

logs:
	@echo "Showing logs for $(ENV) environment..."
	docker compose -f $(COMPOSE_FILE) logs -f

ps:
	@echo "Status for $(ENV) environment:"
	docker compose -f $(COMPOSE_FILE) ps

clean:
	@echo "Cleaning $(ENV) environment (removing volumes)..."
	docker compose -f $(COMPOSE_FILE) down -v

pull:
	@echo "Pulling images for $(ENV) environment..."
	docker compose -f $(COMPOSE_FILE) pull

# --- Setup & Maintenance ---
setup:
	@echo "Setting up $(ENV) environment..."
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "Created .env from .env.example"; \
	else \
		echo ".env already exists"; \
	fi
	@if [ "$(ENV)" = "prod" ]; then \
		mkdir -p letsencrypt; \
		touch letsencrypt/acme.json; \
		chmod 600 letsencrypt/acme.json; \
		echo "Production setup complete! letsencrypt/acme.json created."; \
	else \
		echo "Local setup complete!"; \
	fi

status:
	@echo "=== Local Stack ==="
	@docker compose -f docker-compose-local.yml ps 2>/dev/null || echo "No local containers running"
	@echo ""
	@echo "=== Production Stack ==="
	@docker compose -f docker-compose-prod.yml ps 2>/dev/null || echo "No prod containers running"

# --- Help ---
help:
	@echo ""
	@echo "Traefik Docker Compose Management"
	@echo "=================================="
	@echo ""
	@echo "Current ENV: $(ENV) → using $(COMPOSE_FILE)"
	@echo ""
	@echo "Commands:"
	@echo "  make setup           Initialize environment (creates .env, sets up prod if needed)"
	@echo "  make up              Start environment"
	@echo "  make down            Stop environment"
	@echo "  make restart         Restart environment"
	@echo "  make logs            Show logs (follow mode)"
	@echo "  make ps              Show container status"
	@echo "  make clean           Stop and remove volumes"
	@echo "  make pull            Pull latest images"
	@echo "  make status          Show all stacks status"
	@echo ""
	@echo "Quick Start:"
	@echo "  1. Run 'make setup' to create .env file"
	@echo "  2. Edit .env and set ENV=local or ENV=prod"
	@echo "  3. Run 'make setup' again if switching to prod"
	@echo "  4. Run 'make up' to start"
	@echo ""
