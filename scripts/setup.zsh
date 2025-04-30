#!/opt/homebrew/bin/zsh

# Setup Script for Bedrock WordPress + Docker Dev

set -e

# Color Codes
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
NC="\033[0m" # No Color

echo ""
echo "${BLUE}🐳 Building and 🚀 Restarting Docker images...${NC}"
make full-rebuild

echo ""
echo "${BLUE}🔒 Create SSL certificates and add them to the project${NC}"
make ssl-cert

echo ""
echo "${MAGENTA}🎉 Setup complete! Visit: ${GREEN}https://localhost:${WP_HTTPS_PORT}${NC}"
echo ""
