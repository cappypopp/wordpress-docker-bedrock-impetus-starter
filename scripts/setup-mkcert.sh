#!/usr/bin/env bash

# Setup mkcert for local HTTPS development
set -euo pipefail

# Source environment variables if .env exists
if [ -f ".env" ]; then
    # shellcheck disable=SC1091
    source .env
fi

# Validate required environment variables
: "${WP_HTTPS_PORT:=8443}"

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ This script is designed to run on macOS only."
    exit 1
fi

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    echo "❌ Homebrew is not installed. Please install it first:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Check if mkcert is installed
if ! command -v mkcert &>/dev/null; then
    echo "📦 mkcert is not installed. Installing..."
    if ! brew install mkcert; then
        echo "❌ Failed to install mkcert"
        exit 1
    fi
    echo "ℹ️  If you intend to use Firefox, you need to install the nss package:"
    echo "   brew install nss"
fi

# Create certs directory if it doesn't exist
echo "📁 Creating certificates directory..."
if ! mkdir -p docker/certs; then
    echo "❌ Failed to create certificates directory"
    exit 1
fi

# Install mkcert root CA
echo "🔑 Installing mkcert root CA..."
if ! mkcert -install; then
    echo "❌ Failed to install mkcert root CA"
    exit 1
fi

# Generate localhost certificate
echo "🔒 Generating localhost certificates..."
if ! mkcert -key-file docker/certs/localhost.key \
    -cert-file docker/certs/localhost.crt \
    'localhost' '*.localhost'; then
    echo "❌ Failed to generate certificates"
    exit 1
fi

# Check if certificates were created successfully
if [[ ! -f docker/certs/localhost.key ]] || [[ ! -f docker/certs/localhost.crt ]]; then
    echo "❌ Certificate files were not created properly"
    exit 1
fi

# Print success message
echo
echo "✅ mkcert setup complete!"
echo "🔒 Your certificates are in docker/certs/"
echo "🔒 You can now start your Docker containers with 'make up'"
echo "🔒 Visit https://localhost:${WP_HTTPS_PORT} to access your site"
