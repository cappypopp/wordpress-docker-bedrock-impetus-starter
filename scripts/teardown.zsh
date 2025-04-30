#!/opt/homebrew/bin/zsh

# Teardown Script for WordPress Bedrock Dev
# Stops containers, prunes volumes, deletes DBs if needed

set -e

echo "🛑 Stopping Docker containers..."
docker-compose down

echo "🧹 Cleaning up unused Docker volumes (optional)..."
docker volume prune -f

echo "🧹 Cleaning up any dangling images (optional)..."
docker image prune -f

echo "🧹 Cleaning node_modules and vendor (optional)..."
rm -rf web/app/themes/${WP_THEME_NAME}/node_modules
rm -rf web/app/themes/${WP_THEME_NAME}/vendor
rm -rf web/app/themes/${WP_THEME_NAME}/composer.lock
rm -rf vendor
rm -f composer.lock

echo "✅ Teardown complete! Environment cleaned."
