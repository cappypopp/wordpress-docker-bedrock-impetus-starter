#!/usr/bin/env bash

# Deploy Script for WordPress Bedrock + Sage Theme
# Prepares everything for Production

set -euo pipefail

# Source environment variables if .env exists
if [ -f ".env" ]; then
    # shellcheck disable=SC1091
    # shellcheck source=../.env
    source ".env"
fi

# Validate required environment variables
: "${WP_THEME_NAME:?WP_THEME_NAME is required}"

echo "📦 Installing PHP dependencies optimized for production..."
if ! composer install --no-dev --optimize-autoloader; then
    echo "❌ Composer install failed"
    exit 1
fi

echo "🎨 Building Sage assets for production..."
if ! cd "web/app/themes/${WP_THEME_NAME}"; then
    echo "❌ Theme directory not found"
    exit 1
fi

if ! npm install; then
    echo "❌ npm install failed"
    exit 1
fi

if ! npm run build; then
    echo "❌ npm build failed"
    exit 1
fi

echo "✅ Production build ready."
echo "🚀 Now ready to deploy your project using rsync, GitHub Actions, Deployer, or other tool."
