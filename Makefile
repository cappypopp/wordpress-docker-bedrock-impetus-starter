# Include .env file
include .env
export

# Database export
db-export:
	./scripts/db-export.sh

# Database import
db-import:
	./scripts/db-import.sh

install:
	composer install
	cd web/app/themes/${WP_THEME_NAME} && composer install
	cd web/app/themes/${WP_THEME_NAME} && npm install

# Full rebuild (optional bonus)
rebuild:
	docker-compose down
	docker-compose up -d --build

full-rebuild:
	docker-compose down
	docker-compose build --no-cache
	docker-compose up -d

up:
	docker-compose up -d

down:
	docker-compose down

deploy:
	./scripts/deploy.zsh

docker-info:
	@echo "\033[1;32m\n----STATUS------------------------------------\n\033[0m"
	@docker ps --format "table {{.Names}}\t{{.Status}}"
	@echo "\033[1;32m\n----PORTS------------------------------------\n\033[0m"
	@docker ps --format "table {{.Names}}\t{{.Ports}}"
	@echo "\033[1;32m\n----NETWORKS------------------------------------\n\033[0m"
	@docker ps --format "table {{.Names}}\t{{.Networks}}"

# Helper function to get container name
get-container = $(shell docker ps --filter "name=$(1)" --format "{{.Names}}" | head -n 1)

# Parameterized container commands
docker-attach-%:
	docker exec -it $(call get-container,$*) bash

docker-restart-%:
	docker restart $(call get-container,$*)

docker-logs-%:
	docker logs -f $(call get-container,$*)

# Aliases for backward compatibility
docker-attach: docker-attach-php
docker-restart-php: docker-restart-php
nginx-logs: docker-logs-nginx

# use them like this:
# make docker-attach-php
# make docker-attach-db
# make docker-attach-nginx

# make docker-restart-php
# make docker-restart-db
# make docker-restart-nginx

# make docker-logs-php
# make docker-logs-db
# make docker-logs-nginx

docker-clean:
	docker system prune -af --volumes

dev:
	npm --prefix web/app/themes/${WP_THEME_NAME} run dev

setup:
	./scripts/setup.zsh

initial-wp-setup:
	./scripts/initial-wp-setup.zsh

clear-caches:
	./scripts/clear-caches.zsh

wp-admin-pw-reset:
	./scripts/wp-admin-pw-reset.zsh

# SSL cert generation (optional bonus)
ssl-cert:
	cd docker/certs && mkcert localhost && mv localhost.pem localhost.crt && mv localhost-key.pem localhost.key

# Example of a target that calls other targets
fresh-start:
	$(MAKE) down
	$(MAKE) docker-clean
	$(MAKE) full-rebuild
	sleep 8  # Wait for WordPress to initialize
	$(MAKE) install
	$(MAKE) initial-wp-setup
	$(MAKE) dev

# Start Xdebug workflow
debug:
	@echo "\033[1;36m🔧 Starting Docker stack...\033[0m"
	$(MAKE) up

	@echo "\033[1;36m🧠 Make sure VSCode/Cursor is in 'Listen for Xdebug' mode (port ${XDEBUG_PORT})\033[0m"
	@echo "\033[1;36m🌐 Opening browser to trigger Xdebug session...\033[0m"
	sleep 2
	open "https://localhost:${WP_HTTPS_PORT}?XDEBUG_SESSION_START=${XDEBUG_IDEKEY}"

# Dump WordPress DB into backup/
db-backup:

	@echo "\033[1;34m🐳 Starting DB container...\033[0m"
	docker compose up -d db

	@echo "\033[1;33m⏳ Waiting for DB to initialize...\033[0m"
	sleep 10

	@echo "\033[1;32m💾 Dumping database...\033[0m"
	./scripts/backup-db.zsh

	@echo "\033[1;32m✅ Backup complete. File saved in ./backup/\033[0m"
