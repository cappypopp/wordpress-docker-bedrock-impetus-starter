#!/usr/bin/env bash

# Reset WordPress Admin Password Script
# Usage: ./scripts/wp-admin-pw-reset.sh <username> <newpassword>

set -euo pipefail

# Get the directory this script is located in
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find PHP container
PHP_CONTAINER=$(docker ps --filter "name=php" --format "{{.Names}}" | head -n 1)
if [ -z "$PHP_CONTAINER" ]; then
    echo "❌ Error: PHP container not found. Is Docker running?"
    exit 1
fi

# Pull in the .env file to get WP user and password
if [ -f "${SCRIPT_DIR}/../.env" ]; then
    # shellcheck disable=SC1091
    # shellcheck source=../.env
    set -a
    source "${SCRIPT_DIR}/../.env"
    set +a
fi

# Validate required environment variables
: "${WP_USERNAME:=}"
: "${WP_PASSWORD:=}"

# Get values from CLI args, then fall back to env vars
WPUSER="${1:-$WP_USERNAME}"
NEW_PASSWORD="${2:-$WP_PASSWORD}"

# Validate input
if [ -z "$WPUSER" ] || [ -z "$NEW_PASSWORD" ]; then
    echo "❌ Usage: ./scripts/wp-admin-pw-reset.sh <username> <newpassword>"
    echo "   Or set WP_USERNAME and WP_PASSWORD in .env file"
    exit 1
fi

echo "🔒 Resetting WordPress password for user: $WPUSER..."

# Update the user password
if ! docker exec "$PHP_CONTAINER" \
    wp user update "$WPUSER" \
    --user_pass="$NEW_PASSWORD" \
    --allow-root \
    --path=/var/www/html/web/wp; then
    echo "❌ Failed to reset password"
    exit 1
fi

echo "✅ Password successfully reset for user: $WPUSER"
