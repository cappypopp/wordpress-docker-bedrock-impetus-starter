#!/opt/homebrew/bin/zsh

# Reset WordPress Admin Password Script
# Usage: ./bin/reset-password <username> <newpassword>

PHP_CONTAINER=$(docker ps --filter "name=php" --format "{{.Names}}" | head -n 1)

if [[ -z "$PHP_CONTAINER" ]]; then
    echo "❌ Error: PHP container not found. Is Docker running?"
    exit 1
fi

# Get the directory this script is located in
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# pull in the .env file to get WP user and password
set -a
source "$SCRIPT_DIR/../.env"
set +a

#echo "WP_USERNAME: $WP_USERNAME"
#echo "WP_PASSWORD: $WP_PASSWORD"

# fallback from CLI args, then env
WPUSER=${1:-$WP_USERNAME}
NEW_PASSWORD=${2:-$WP_PASSWORD}

#echo "WPUSER: $WPUSER"
#echo "NEW_PASSWORD: $NEW_PASSWORD"

if [[ -z "$WPUSER" ]] || [[ -z "$NEW_PASSWORD" ]]; then
    echo "❌ Usage: ./bin/reset-password <username> <newpassword>"
    exit 1
fi

echo "🔒 Resetting WordPress password for user: $WPUSER..."

docker exec -it "$PHP_CONTAINER" wp user update "$WPUSER" --user_pass="$NEW_PASSWORD" --allow-root --path=/var/www/html/web/wp

echo "✅ Password reset for user: $WPUSER"
