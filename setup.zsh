#!/opt/homebrew/bin/zsh

# Install Bedrock
composer create-project roots/bedrock .

# Copy and configure environment
cp .env.example .env
sed -i '' 's/database_name/wordpress/' .env
sed -i '' 's/database_user/wordpress/' .env
sed -i '' 's/database_password/secret/' .env

# Setup Sage theme
cd web/app/themes
composer create-project roots/sage impetus

cd impetus
composer install
npm install
