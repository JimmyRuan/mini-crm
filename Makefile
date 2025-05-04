# Variables
COMPOSE=docker compose
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
	@echo ""
	@echo "Development Commands:"
	@echo "  make test           - Run all tests"
	@echo "  make test-coverage  - Run tests with coverage report"
	@echo "  make test-focus     - Run focused tests (specify with TEST=path/to/test)"
	@echo "  make lint           - Run Rubocop linting"
	@echo "  make lint-fix       - Run Rubocop linting with auto-fix"
	@echo "  make db-migrate     - Run database migrations"
	@echo "  make db-rollback    - Rollback last database migration"
	@echo "  make db-reset       - Reset database (drop, create, migrate, seed)"
	@echo "  make db-seed        - Run database seeds"
	@echo "  make console        - Start Rails console"
	@echo "  make routes         - List all routes"
	@echo "  make clean          - Clean temporary files and logs"

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

# Development Commands
test: ## Run all tests
	$(DOCKER_EXEC) web bundle exec rspec

test-coverage: ## Run tests with coverage report
	$(DOCKER_EXEC) web COVERAGE=true bundle exec rspec

test-focus: ## Run focused tests (specify with TEST=path/to/test)
	$(DOCKER_EXEC) web bundle exec rspec $(TEST)

lint: ## Run Rubocop linting
	$(DOCKER_EXEC) web bundle exec rubocop

lint-fix: ## Run Rubocop linting with auto-fix
	$(DOCKER_EXEC) web bundle exec rubocop -a

db-migrate: ## Run database migrations
	$(DOCKER_EXEC) web bundle exec rails db:migrate

db-rollback: ## Rollback last database migration
	$(DOCKER_EXEC) web bundle exec rails db:rollback

db-reset: ## Reset database (drop, create, migrate, seed)
	$(DOCKER_EXEC) web bundle exec rails db:drop db:create db:migrate db:seed

db-seed: ## Run database seeds
	$(DOCKER_EXEC) web bundle exec rails db:seed

console: ## Start Rails console
	$(DOCKER_EXEC) web bundle exec rails console

routes: ## List all routes
	$(DOCKER_EXEC) web bundle exec rails routes

clean: ## Clean temporary files and logs
	$(DOCKER_EXEC) web bundle exec rails tmp:clear log:clear
