#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
HOSTNAME=$(hostname)
FILENAME="backup_${HOSTNAME}_${DATE}.tar.gz"
BACKUP_DIR="$HOME/backups"
RETENTION_DAYS=7
LOG_TAG="vm-backup"

# Specific files/folders you want to back up
SPECIFIC_DIRS=(
  "$HOME/Documents"
  "$HOME/Desktop"
  "$HOME/.config"
  "$HOME/projects"
  "/etc"
)

# Dynamically include all real user home directories
USER_HOMES=($(awk -F: '$3 >= 1000 && $7 ~ /bash|sh/ { print $6 }' /etc/passwd))

# Combine both
SOURCE_DIRS=("${SPECIFIC_DIRS[@]}" "${USER_HOMES[@]}")

# Create backup directory if it doesn’t exist
mkdir -p "$BACKUP_DIR"

# Create the archive
tar -czf "$BACKUP_DIR/$FILENAME" "${SOURCE_DIRS[@]}"

# Log result
logger -t "$LOG_TAG" "Backup created: $BACKUP_DIR/$FILENAME"

# Delete old backups
find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +$RETENTION_DAYS -exec rm {} \;
logger -t "$LOG_TAG" "Old backups older than $RETENTION_DAYS days deleted"

echo "Backup complete: $FILENAME"
