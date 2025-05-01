#!/usr/bin/env bash

# Configuration
echo "Importing database backup..."

if docker compose exec -T db mariadb \
    --user="${DB_USER}" \
    --password="${DB_PASSWORD}" \
    "${DB_NAME}" <scripts/db_backup.sql; then
    echo "✅ Database import completed!"
else
    echo "❌ Import failed!"
    exit 1
fi
