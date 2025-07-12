#!/bin/bash

DB_HOST="127.0.0.1"
DB_PORT="5432"
DB_USER="admin"
DB_PASSWORD="password"
DB_NAME="db_name"
BACKUP_FILE="/home/user/backups/backup_file.sql"

PGPASSWORD="$DB_PASSWORD" \
pg_restore -h "$DB_HOST" \
           -p "$DB_PORT" \
           -U "$DB_USER" \
           -d "$DB_NAME" \
           -c \
           "$BACKUP_FILE"
