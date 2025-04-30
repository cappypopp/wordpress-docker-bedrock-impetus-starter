#! /opt/homebrew/bin/zsh

# Configuration
typeset -r BACKUP_DIR="../backups"
typeset -i MAX_BACKUPS=7
typeset -r DB_CONTAINER=$(docker ps --filter "name=db" --format "{{.Names}}" | head -n 1)
typeset -r TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
typeset -r BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql.gz"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Create backup
print "Creating database backup..."
if docker exec "$DB_CONTAINER" mysqldump \
    --user="${DB_USER}" \
    --password="${DB_PASSWORD}" \
    --databases "${DB_NAME}" \
    --single-transaction \
    --quick \
    --lock-tables=false |
    gzip >"$BACKUP_FILE"; then
    print "Backup created successfully: $BACKUP_FILE"

    # Remove old backups if we have more than MAX_BACKUPS
    cd "$BACKUP_DIR" || exit 1
    ls -t backup_*.sql.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm
    print "Old backups cleaned up"
else
    print "Backup failed!"
    exit 1
fi
