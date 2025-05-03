#!/usr/bin/env bash

BLUE="\033[1;34m"
NC="\033[0m" # No Color

echo ""
echo "${BLUE}🧪 Upgrading composer dependencies...${NC}"
echo ""

composer update -vvv
# compose update
exec "$@"
