#!/usr/bin/env bash

# Clear all runtime caches (Acorn views, Composer, Nginx if needed)

set -euo pipefail

# Source environment variables if .env exists
if [ -f ".env" ]; then
    # shellcheck disable=SC1091
    source .env
fi

echo "🧹 Clearing Acorn view caches..."
if ! rm -rf web/app/cache/acorn/framework/views/* 2>/dev/null; then
    echo "   No view cache files found or unable to remove"
fi

echo "🧹 Clearing Acorn package caches..."
if ! rm -rf web/app/cache/acorn/framework/cache/* 2>/dev/null; then
    echo "   No package cache files found or unable to remove"
fi

echo "🧹 Clearing Composer cache..."
if ! composer clear-cache; then
    echo "❌ Failed to clear Composer cache"
    exit 1
fi

# Optional: clear Vite build cache (uncomment if needed)
# if [ -n "${WP_THEME_NAME:-}" ]; then
#     echo "🧹 Clearing Vite build cache..."
#     if ! rm -rf "web/app/themes/${WP_THEME_NAME}/public/build/" 2>/dev/null; then
#         echo "   No Vite build cache found or unable to remove"
#     fi
# fi

echo "✅ All caches cleared!"
