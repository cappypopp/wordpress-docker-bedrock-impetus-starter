#!/usr/bin/env bash

# Initial WordPress setup script using WP-CLI
set -euo pipefail

# Get the directory this script is located in
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source environment variables if .env exists
if [ -f "${SCRIPT_DIR}/../.env" ]; then
    # shellcheck disable=SC1091
    source "${SCRIPT_DIR}/../.env"
fi

# Validate required environment variables
: "${WP_ADMIN_USERNAME:?WP_ADMIN_USERNAME is required}"
: "${WP_ADMIN_PASSWORD:?WP_ADMIN_PASSWORD is required}"
: "${WP_ADMIN_EMAIL:?WP_ADMIN_EMAIL is required}"
: "${WP_SITE_TITLE:?WP_SITE_TITLE is required}"
: "${WP_HOME:?WP_HOME is required}"
: "${WP_THEME_NAME:?WP_THEME_NAME is required}"

echo "🚀 Starting WordPress setup via WP-CLI..."

# Set parameters (allow override via command line args)
ADMIN_USER="${1:-$WP_ADMIN_USERNAME}"
ADMIN_PASSWORD="${2:-$WP_ADMIN_PASSWORD}"
ADMIN_EMAIL="${3:-$WP_ADMIN_EMAIL}"
SITE_TITLE="${4:-$WP_SITE_TITLE}"
SITE_URL="${5:-$WP_HOME}"
THEME_NAME="${6:-$WP_THEME_NAME}"

# Find PHP container
PHP_CONTAINER=$(docker ps --filter "name=php" --format "{{.Names}}" | head -n 1)
if [ -z "$PHP_CONTAINER" ]; then
    echo "❌ PHP container not found. Is Docker running?"
    exit 1
fi

echo "🔄 Installing WordPress core..."
# Run WP CLI commands inside container
if ! docker exec "$PHP_CONTAINER" wp core install \
    --url="$SITE_URL" \
    --title="$SITE_TITLE" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="$ADMIN_EMAIL" \
    --path="/var/www/html/web/wp" \
    --skip-email \
    --allow-root; then
    echo "❌ WordPress core installation failed"
    exit 1
fi

# Example of plugin installation (commented out)
# echo "🔌 Installing and activating plugins..."
# if ! docker exec "$PHP_CONTAINER" wp plugin install acf --activate \
#     --path="/var/www/html/web/wp" \
#     --allow-root; then
#     echo "❌ Plugin installation failed"
#     exit 1
# fi

echo "🎨 Activating theme..."
if ! docker exec "$PHP_CONTAINER" wp theme activate "$THEME_NAME" \
    --path="/var/www/html/web/wp" \
    --allow-root; then
    echo "❌ Theme activation failed"
    exit 1
fi

echo "✅ WordPress setup complete!"
echo "🌐 Your site is available at: $SITE_URL"
echo "👤 Admin login: $ADMIN_USER"
echo "🔑 Admin password: $ADMIN_PASSWORD"
