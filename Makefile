# Database export
db-export:
	./scripts/db-export.sh

# Database import
db-import:
	./scripts/db-import.sh

install:
	composer install
	cd web/app/themes/impetus && composer install
	cd web/app/themes/impetus && npm install

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

docker-attach:
	docker exec -it $$(docker ps --filter "name=php" --format "{{.Names}}" | head -n 1) bash

docker-clean:
	docker system prune -af --volumes

docker-restart-php:
	docker restart $$(docker ps --filter "name=php" --format "{{.Names}}" | head -n 1)

nginx-logs:
	docker logs -f $$(docker ps --filter "name=nginx" --format "{{.Names}}" | head -n 1)

dev:
	npm --prefix web/app/themes/impetus run dev

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
	$(MAKE) install
	$(MAKE) initial-wp-setup
	$(MAKE) dev
