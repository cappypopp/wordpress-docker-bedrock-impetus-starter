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
fi

mkcert -install
mkcert -key-file docker/certs/localhost-key.pem -cert-file docker/certs/localhost.pem 'localhost' '*.localhost'

# Bedrock expects these files to be named localhost.crt and localhost.key
mv docker/certs/localhost.pem docker/certs/localhost.crt
mv docker/certs/localhost-key.pem docker/certs/localhost.key
