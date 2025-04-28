#!/opt/homebrew/bin/zsh

# Deploy Script for WordPress Bedrock + Sage Theme
# Prepares everything for Production

set -e

echo "📦 Installing PHP dependencies optimized for production..."
composer install --no-dev --optimize-autoloader

echo "🎨 Building Sage assets for production..."
cd web/app/themes/impetus
npm install
npm run build

echo "✅ Production build ready."
echo "🚀 Now ready to deploy your project using rsync, GitHub Actions, Deployer, or other tool."
