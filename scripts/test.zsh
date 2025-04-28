#!/opt/homebrew/bin/zsh

# Run Tests and Linters Inside Docker
# Usage: ./scripts/test.zsh/

set -e

# Color Codes
BLUE="\033[1;34m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
MAGENTA="\033[1;35m"
NC="\033[0m" # No Color

echo ""
echo "${BLUE}🧪 Running PHP lint...${NC}"
docker exec -it $(docker ps --filter "name=php" --format "{{.Names}}" | head -n 1) composer run-script lint

echo ""
echo "${CYAN}🔍 Running JavaScript ESLint...${NC}"
docker exec -it $(docker ps --filter "name=php" --format "{{.Names}}" | head -n 1) sh -c "cd /var/www/html/web/app/themes/impetus && npm run lint"

echo ""
echo "${MAGENTA}✅ All tests and linters passed successfully!${NC}"
echo ""
