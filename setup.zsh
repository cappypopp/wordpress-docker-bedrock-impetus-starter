#!/opt/homebrew/bin/zsh

# Exit immediately on error
set -e

# Install Bedrock
# Since I already did this, I'm commenting it out
# composer create-project roots/bedrock .

# Copy and configure environment
cp -n .env.example .env || echo ".env already exists"

# Move into themes and install Sage
# cd web/app/themes
# composer create-project roots/sage your-sage-theme
# cd ../../..

echo "🔒 YOU MUST Generate your keys here: https://roots.io/salts.html and put them in the .env file!"

# do the setup
.scripts/setup.zsh
