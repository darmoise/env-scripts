#!/bin/bash

DB_HOST="127.0.0.1"
DB_PORT="5432"
DB_USER="admin"
DB_PASSWORD="password"
DB_NAME="db_name"
BACKUP_FILE="/home/user/backups/backup_$(date +%Y-%m-%d_%H-%M-%S).sql"

PGPASSWORD="$DB_PASSWORD" pg_dump \
  -h "$DB_HOST" \
  -p "$DB_PORT" \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  -F c \
  -f "$BACKUP_FILE"

