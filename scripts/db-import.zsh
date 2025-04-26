#!/opt/homebrew/bin/zsh

# Import database backup into Docker MySQL container
echo "Importing database from scripts/db_backup.sql..."

cat scripts/db_backup.sql | docker-compose exec -T db /usr/bin/mysql -uwordpress -psecret wordpress

echo "✅ Database import completed!"
