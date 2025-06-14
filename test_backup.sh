#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
HOSTNAME=$(hostname)
FILENAME="test_backup_${HOSTNAME}_${DATE}.tar.gz"
BACKUP_DIR="$HOME/backups"
RETENTION_DAYS=7
LOG_TAG="vm-backup"

# Temporary test-only directories
TEST_BACKUP_SOURCE="$HOME/test_backup_source"
mkdir -p "$TEST_BACKUP_SOURCE/Documents"
mkdir -p "$TEST_BACKUP_SOURCE/projects"

echo "Test doc content" > "$TEST_BACKUP_SOURCE/Documents/test.txt"
echo "Project backup check" > "$TEST_BACKUP_SOURCE/projects/code.txt"

SPECIFIC_DIRS=(
  "$TEST_BACKUP_SOURCE"
)

SOURCE_DIRS=("${SPECIFIC_DIRS[@]}")

# Create backup directory if it doesn’t exist
mkdir -p "$BACKUP_DIR"

# Create the archive
tar -czf "$BACKUP_DIR/$FILENAME" "${SOURCE_DIRS[@]}"

# Log result
logger -t "$LOG_TAG" "Test Backup created: $BACKUP_DIR/$FILENAME"

# Delete old backups
find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +$RETENTION_DAYS -exec rm {} \;
logger -t "$LOG_TAG" "Old backups older than $RETENTION_DAYS days deleted"

echo "Test Backup complete: $FILENAME"
