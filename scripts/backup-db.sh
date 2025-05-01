#!/usr/bin/env bash

# Configuration
BACKUP_DIR="backup"
typeset -i MAX_BACKUPS=7
DB_CONTAINER=""
TIMESTAMP=""
BACKUP_FILE=""

DB_CONTAINER=$(docker ps --filter "name=db" --format "{{.Names}}" | head -n 1)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql.gz"

readonly DB_CONTAINER
readonly TIMESTAMP
readonly BACKUP_FILE

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Create backup
echo "Creating database backup..."
if docker exec "$DB_CONTAINER" mysqldump \
    --user="${DB_USER}" \
    --password="${DB_PASSWORD}" \
    --databases "${DB_NAME}" \
    --single-transaction \
    --quick \
    --lock-tables=false |
    gzip >"$BACKUP_FILE"; then
    echo "Backup created successfully: $BACKUP_FILE"

    # Remove old backups if we have more than MAX_BACKUPS
    cd "$BACKUP_DIR" || exit 1
    find . -maxdepth 1 -name "backup_*.sql.gz" -printf '%T@ %p\n' | sort -nr | tail -n +$((MAX_BACKUPS + 1)) | cut -d' ' -f2- | xargs -r rm
    echo "Old backups cleaned up"
else
    echo "Backup failed!"
    exit 1
fi
