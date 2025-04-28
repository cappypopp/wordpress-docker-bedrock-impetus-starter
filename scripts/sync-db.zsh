#!/opt/homebrew/bin/zsh

# Sync Production Database to Local
# Usage: ./bin/sync-db <remote-user> <remote-host> <remote-db-name> <remote-db-user> <remote-db-password>

set -e

if [[ $# -ne 5 ]]; then
    echo "❌ Usage: ./scripts/sync-db.zsh <remote-user> <remote-host> <remote-db-name> <remote-db-user> <remote-db-password>"
    exit 1
fi

REMOTE_USER=$1
REMOTE_HOST=$2
REMOTE_DB=$3
REMOTE_DB_USER=$4
REMOTE_DB_PASS=$5

LOCAL_CONTAINER=$(docker ps --filter "name=db" --format "{{.Names}}" | head -n 1)

if [[ -z "$LOCAL_CONTAINER" ]]; then
    echo "❌ Error: MySQL container not found. Is Docker running?"
    exit 1
fi

TMP_SQL="tmp-dump.sql"

echo "🚀 Dumping remote database..."
ssh "$REMOTE_USER@$REMOTE_HOST" "mysqldump -u$REMOTE_DB_USER -p$REMOTE_DB_PASS $REMOTE_DB" >$TMP_SQL

echo "🛠 Importing into local Docker DB..."
docker cp $TMP_SQL $LOCAL_CONTAINER:/tmp/$TMP_SQL
docker exec -i $LOCAL_CONTAINER sh -c "mysql -uwordpress -psecret wordpress < /tmp/$TMP_SQL"
docker exec $LOCAL_CONTAINER rm /tmp/$TMP_SQL
rm $TMP_SQL

echo "🔄 Replacing production domain with local domain..."
PHP_CONTAINER=$(docker ps --filter "name=php" --format "{{.Names}}" | head -n 1)

docker exec -it $PHP_CONTAINER wp search-replace "https://yourproductiondomain.com" "https://localhost:8443" --allow-root --path=/var/www/html/web/wp

echo "✅ Database sync complete!"
