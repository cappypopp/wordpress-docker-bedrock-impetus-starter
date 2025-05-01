#!/usr/bin/env bash

# Export database from Docker container
echo "Exporting database to scripts/db_backup.sql..."

if docker compose exec -T db mysqldump \
    --user="${DB_USER}" \
    --password="${DB_PASSWORD}" \
    --databases "${DB_NAME}" \
    --single-transaction \
    --quick \
    --lock-tables=false >scripts/db_backup.sql; then
    echo "✅ Database export completed!"
else
    echo "❌ Export failed!"
    exit 1
fi
