#!/opt/homebrew/bin/zsh

# Exit immediately on error
set -e

# Copy and configure environment
cp -n .env.example .env || echo ".env already exists"

# Sets default database credentials:
# Database name: wordpress
# Database user: wordpress
# Database password: secret
# Username: admin
# Password: asdf3456POI
sed -i '' 's/database_name/wordpress/' .env
sed -i '' 's/database_user/wordpress/' .env
sed -i '' 's/database_password/secret/' .env
sed -i '' 's/username_here/admin/' .env
sed -i '' 's/password_here/asdf3456POI/' .env

echo "🔒 YOU MUST Generate your keys here: https://roots.io/salts.html and put them in the .env file!"

# do the setup
.scripts/setup.zsh
