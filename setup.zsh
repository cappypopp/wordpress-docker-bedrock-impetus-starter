#!/opt/homebrew/bin/zsh

# Exit immediately on error
set -e

# Copy and configure environment
cp -n .env.example .env || echo ".env already exists"
sed -i '' 's/database_name/wordpress/' .env
sed -i '' 's/database_user/wordpress/' .env
sed -i '' 's/database_password/secret/' .env

# Install Bedrock dependencies
composer install

# Setup Sage theme dependencies
cd web/app/themes/impetus

composer install
npm install
