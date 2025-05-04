# Variables
COMPOSE=docker-compose
DOCKER_RUN=$(COMPOSE) run --rm
DOCKER_EXEC=$(COMPOSE) exec

# Default target
.DEFAULT_GOAL := help

# Help command
help:
	@echo "Available commands:"
	@echo "  make up             - Start the services in the foreground"
	@echo "  make up-detached    - Start the services in the background"
	@echo "  make down           - Stop the services"
	@echo "  make rebuild        - Rebuild all services"
	@echo "  make web            - Access the web service"
	@echo "  make db             - Access the db service"
	@echo "  make rabbitmq       - Access the rabbitmq service"
	@echo "  make logs           - View logs for all services"
	@echo "  make logs-web       - View logs for the web service"
	@echo "  make logs-db        - View logs for the db service"
	@echo "  make logs-rabbitmq  - View logs for the rabbitmq service"
	@echo "  make nuke           - Stop all services and remove containers, networks, and volumes"

# Commands
up: ## Start the services in the foreground
	$(COMPOSE) up

up-detached: ## Start the services in the background
	$(COMPOSE) up -d

down: ## Stop the services
	$(COMPOSE) down

rebuild: ## Rebuild all services
	$(COMPOSE) up --build

web: ## Access the web service
	$(DOCKER_EXEC) web bash

db: ## Access the db service
	$(DOCKER_EXEC) db bash

rabbitmq: ## Access the rabbitmq service
	$(DOCKER_EXEC) rabbitmq bash

logs: ## View logs for all services
	$(COMPOSE) logs

logs-web: ## View logs for the web service
	$(COMPOSE) logs web

logs-db: ## View logs for the db service
	$(COMPOSE) logs db

logs-rabbitmq: ## View logs for the rabbitmq service
	$(COMPOSE) logs rabbitmq

nuke: ## Stop all services and remove containers, networks, and volumes
	$(COMPOSE) down -v --remove-orphans
