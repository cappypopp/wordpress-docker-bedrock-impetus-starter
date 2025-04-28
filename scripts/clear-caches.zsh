#!/opt/homebrew/bin/zsh

# Clear all runtime caches (Acorn views, Composer, Nginx if needed)

echo "🧹 Clearing Acorn view caches..."
rm -rf web/app/cache/acorn/framework/views/*

echo "🧹 Clearing Acorn package caches..."
rm -rf web/app/cache/acorn/framework/cache/*

echo "🧹 Clearing Composer cache..."
composer clear-cache

# Optional: clear Vite build cache (if you ever cache builds)
# echo "🧹 Clearing Vite build cache..."
# rm -rf web/app/themes/impetus/public/build/

echo "✅ All caches cleared!"
