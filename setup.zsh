#!/opt/homebrew/bin/zsh

# Exit immediately on error
set -e

# Install Bedrock
# Since I already did this, I'm commenting it out
# composer create-project roots/bedrock .

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

# Move into themes and install Sage
# cd web/app/themes
# composer create-project roots/sage your-sage-theme
# cd ../../..

echo "🔒 YOU MUST Generate your keys here: https://roots.io/salts.html and put them in the .env file!"

# do the setup
.scripts/setup.zsh
