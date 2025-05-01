#!/usr/bin/env bash

# Sync Production Database to Local
# Usage: ./scripts/sync-db.sh <remote-user> <remote-host> <remote-db-name> <remote-db-user> <remote-db-password> [production-url]

set -euo pipefail

# Source environment variables if .env exists
if [ -f ".env" ]; then
    # shellcheck disable=SC1091
    source .env
fi

# Function to cleanup temporary files
cleanup() {
    local exit_code=$?
    echo "🧹 Cleaning up temporary files..."
    [ -f "$TMP_SQL" ] && rm "$TMP_SQL"
    [ -n "$LOCAL_CONTAINER" ] && docker exec "$LOCAL_CONTAINER" rm -f "/tmp/$TMP_SQL" 2>/dev/null || true
    exit $exit_code
}

# Set trap for cleanup
trap cleanup EXIT

# Validate arguments
if [[ $# -lt 5 ]] || [[ $# -gt 6 ]]; then
    echo "❌ Usage: ./scripts/sync-db.sh <remote-user> <remote-host> <remote-db-name> <remote-db-user> <remote-db-password> [production-url]"
    echo "   Note: If production-url is not provided, WP_PRODUCTION_URL environment variable will be used"
    exit 1
fi

REMOTE_USER=$1
REMOTE_HOST=$2
REMOTE_DB=$3
REMOTE_DB_USER=$4
REMOTE_DB_PASS=$5
# Use 6th argument if provided, otherwise fall back to environment variable or default
if [[ $# -eq 6 ]]; then
    PRODUCTION_URL=$6
else
    PRODUCTION_URL=${WP_PRODUCTION_URL:-https://yourproductiondomain.com}
fi

# Validate required environment variables
: "${DB_USER:?Environment variable DB_USER is not set}"
: "${DB_PASSWORD:?Environment variable DB_PASSWORD is not set}"
: "${DB_NAME:?Environment variable DB_NAME is not set}"
: "${WP_HTTPS_PORT:=8443}"

# Find database container
LOCAL_CONTAINER=$(docker ps --filter "name=db" --format "{{.Names}}" | head -n 1)
if [[ -z "$LOCAL_CONTAINER" ]]; then
    echo "❌ Error: Database container not found. Is Docker running?"
    exit 1
fi

# Create temporary file with random suffix for better security
TMP_SQL=$(mktemp -t "db-dump-XXXXXX.sql")

echo "🚀 Dumping remote database..."
if ! ssh "$REMOTE_USER@$REMOTE_HOST" "mysqldump --no-tablespaces -u$REMOTE_DB_USER -p$REMOTE_DB_PASS $REMOTE_DB" >"$TMP_SQL"; then
    echo "❌ Remote database dump failed!"
    exit 1
fi

echo "🛠 Importing into local Docker DB..."
if ! docker cp "$TMP_SQL" "$LOCAL_CONTAINER:/tmp/$(basename "$TMP_SQL")"; then
    echo "❌ Failed to copy dump to container!"
    exit 1
fi

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
if ! timeout 30 bash -c "until docker exec $LOCAL_CONTAINER mysqladmin ping -h localhost -u$DB_USER -p$DB_PASSWORD --silent; do sleep 2; done"; then
    echo "❌ Database is not responding!"
    exit 1
fi

if ! docker exec -i "$LOCAL_CONTAINER" mariadb \
    --user="${DB_USER}" \
    --password="${DB_PASSWORD}" \
    "${DB_NAME}" <"$TMP_SQL"; then
    echo "❌ Database import failed!"
    exit 1
fi

echo "🔄 Replacing production domain with local domain..."
echo "   From: $PRODUCTION_URL"
echo "   To: https://localhost:${WP_HTTPS_PORT}"

PHP_CONTAINER=$(docker ps --filter "name=php" --format "{{.Names}}" | head -n 1)
if [[ -z "$PHP_CONTAINER" ]]; then
    echo "❌ Error: PHP container not found!"
    exit 1
fi

if ! docker exec -i "$PHP_CONTAINER" wp search-replace \
    "$PRODUCTION_URL" \
    "https://localhost:${WP_HTTPS_PORT}" \
    --allow-root \
    --path=/var/www/html/web/wp; then
    echo "❌ Search-replace failed!"
    exit 1
fi

echo "✅ Database sync complete!"
