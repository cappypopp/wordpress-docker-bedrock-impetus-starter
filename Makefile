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

npm-clean:
	cd web/app/themes/${WP_THEME_NAME} && npm run clean
	cd web/app/themes/${WP_THEME_NAME} && npm install

# Full rebuild (optional bonus)
rebuild:
	$(MAKE) down
	docker-compose up -d --build

full-rebuild:
	$(MAKE) down
	docker-compose build --no-cache
	$(MAKE) up

up:
	docker-compose up -d

down:
	docker-compose down

deploy:
	./scripts/deploy.sh

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
	./scripts/setup.sh

initial-wp-setup:
	./scripts/initial-wp-setup.sh

clear-caches:
	./scripts/clear-caches.sh

wp-admin-pw-reset:
	./scripts/wp-admin-pw-reset.sh

# SSL cert generation (optional bonus)
ssl-cert:
	./scripts/setup-mkcert.sh
# Example of a target that calls other targets
fresh-start:
	@echo "\033[1;36m🔧 If this is the first time running this, you may need to generate your hashes and salts here: https://roots.io/salts.html\033[0m"
	@echo "\033[1;36m🔧 If you've already generated your hashes and salts, make sure they're in your .env file."
	@echo "\033[1;36m🔧 Then you can run this target to start the Docker stack.\033[0m"
	./scripts/teardown.sh
	docker-compose build --no-cache
	$(MAKE) up
	sleep 8  # Wait for WordPress to initialize
	$(MAKE) install
	$(MAKE) clear-caches
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
	./scripts/backup-db.sh

	@echo "\033[1;32m✅ Backup complete. File saved in ./backup/\033[0m"
