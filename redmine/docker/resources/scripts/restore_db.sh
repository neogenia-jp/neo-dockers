#!/bin/bash

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
  echo "Usage: $0 <backup_file>"
  exit 1
fi

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

echo " exec $SCRIPT_DIR/initdb.sql"
mysql < $SCRIPT_DIR/initdb.sql

zcat "$BACKUP_FILE" | mysql redmine
