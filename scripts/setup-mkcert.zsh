#! /opt/homebrew/bin/zsh

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "This script is designed to run on macOS only."
    exit 1
fi

# Check if mkcert is installed
if ! command -v mkcert &>/dev/null; then
    echo "mkcert is not installed. Installing..."
    brew install mkcert
    echo "if you intend to use Firefox, you need to install the nss brew package as well!"
fi

# Create certs directory if it doesn't exist
mkdir -p docker/certs

# Install mkcert if not already installed
mkcert -install

# Generate localhost certificate
mkcert -key-file docker/certs/localhost.key -cert-file docker/certs/localhost.crt 'localhost' '*.localhost'

# Print success message
echo "✅ mkcert setup complete!"
echo "🔒 Your certificates are in docker/certs/"
echo "🔒 You can now start your Docker containers with 'make up'"
echo "🔒 Visit https://localhost:${WP_HTTPS_PORT} to access your site"
