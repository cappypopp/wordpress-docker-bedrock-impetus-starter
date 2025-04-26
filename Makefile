# Database export
db-export:
	./scripts/db-export.sh

# Database import
db-import:
	./scripts/db-import.sh

# Full rebuild (optional bonus)
rebuild:
	docker-compose down
	docker-compose up -d --build

# SSL cert generation (optional bonus)
ssl-cert:
	cd docker/certs && mkcert localhost && mv localhost.pem localhost.crt && mv localhost-key.pem localhost.key
