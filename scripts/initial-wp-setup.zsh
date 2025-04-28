#!/opt/homebrew/bin/zsh

# Abort if any command fails
set -e

# Get the directory this script is located in
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# pull in the .env file to get WP user and password
set -a
source "$SCRIPT_DIR/../.env"
set +a

echo "🚀 Starting WordPress setup via WP-CLI..."

# Set basic parameters
ADMIN_USER=${1:-$WP_ADMIN_USERNAME}
ADMIN_PASSWORD=${2:-$WP_ADMIN_PASSWORD}
ADMIN_EMAIL=${3:-$WP_ADMIN_EMAIL}
SITE_TITLE=${4:-$WP_SITE_TITLE}
SITE_URL=${5:-$WP_HOME}
THEME_NAME=${6:-$WP_THEME_NAME}

# Attach to PHP container dynamically
PHP_CONTAINER=$(docker ps --filter "name=php" --format "{{.Names}}" | head -n 1)

# Run WP CLI commands inside container
docker exec -it "$PHP_CONTAINER" wp core install \
    --url="$SITE_URL" \
    --title="$SITE_TITLE" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="$ADMIN_EMAIL" \
    --skip-email

# Setup Plugins like ACF Pro for example
# docker exec -it "$PHP_CONTAINER" wp plugin install acf --activate

# Activate the theme
docker exec -it "$PHP_CONTAINER" wp theme activate "$THEME_NAME"

echo "✅ WordPress setup complete!"
