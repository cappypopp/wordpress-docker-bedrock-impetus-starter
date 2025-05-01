#!/usr/bin/env bash

# Teardown Script for WordPress Bedrock Dev
# Complete cleanup: stops containers, removes all unused Docker resources

set -euo pipefail

# Source environment variables if .env exists
if [ -f ".env" ]; then
    # shellcheck disable=SC1091
    # shellcheck source=../.env
    source ".env"
fi

# Validate required environment variables
: "${WP_THEME_NAME:?WP_THEME_NAME is required}"

echo "🛑 Stopping Docker containers..."
if ! docker-compose down; then
    echo "❌ Failed to stop Docker containers"
    exit 1
fi

echo "🧹 Performing complete Docker cleanup..."
if ! docker system prune -af --volumes; then
    echo "❌ Failed to clean Docker system"
    exit 1
fi

echo "🧹 Cleaning node_modules and vendor directories..."
rm -rf \
    "web/app/themes/${WP_THEME_NAME}/node_modules" \
    "web/app/themes/${WP_THEME_NAME}/vendor" \
    "web/app/themes/${WP_THEME_NAME}/composer.lock" \
    vendor \
    composer.lock

echo "✅ Complete teardown finished! Environment fully cleaned."
