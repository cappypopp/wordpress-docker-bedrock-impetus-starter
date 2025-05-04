#!/usr/bin/env bash

# Exit immediately on error, unused variables, and pipe failure
set -euo pipefail

# Install Bedrock
# Since I already did this, I'm commenting it out
# composer create-project roots/bedrock .

# Copy environment file if it doesn't exist
if [ ! -f .env ] && cp -n .env.example .env; then
    echo "⚠️  New .env file created from .env.example"
    echo "❌ Please customize your .env file first, then run this script again."
    echo "Be sure that you use a different port for DB_PORT if you have multiple projects running on the same machine."
    echo "🔒 Generate your salts at: https://roots.io/salts.html and put them in the .env file!"
    exit 1
fi

# Continue with setup only if .env exists and has been modified
if [ -f .env ] && ! diff -q .env .env.example >/dev/null 2>&1; then
    echo "✅ .env file exists and has been customized"
    ./scripts/setup.sh
else
    echo "❌ .env file is identical to .env.example"
    echo "Please customize your .env file first, then run this script again."
    echo "🔒 Generate your salts at: https://roots.io/salts.html"
    exit 1
fi

cd "web/app/themes/${WP_THEME_NAME}"
echo ""
echo "🐶 Installing husky..."
npm install --save-dev husky
# The init command simplifies setting up husky in a project.
# It creates a pre-commit script in .husky/ and updates the
# prepare script in package.json. Modifications can be made
# later to suit your workflow.
npx husky init

# Move into themes and install Sage
# cd web/app/themes
# composer create-project roots/sage your-sage-theme
# cd ../../..
