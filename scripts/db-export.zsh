#!/opt/homebrew/bin/zsh

# Export database from Docker MySQL container
echo "Exporting database to scripts/db_backup.sql..."

docker-compose exec db /usr/bin/mysqldump -uwordpress -psecret wordpress >scripts/db_backup.sql

echo "✅ Database export completed!"
