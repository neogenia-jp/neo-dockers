#!/bin/bash

BACKUP_DIR=/mnt/bkup`date "+%a"`/

if [ ! -d "$BACKUP_DIR" ]; then
  mkdir "$BACKUP_DIR"
fi

mysqldump --default-character-set=utf8 --hex-blob -R redmine | gzip -c > "$BACKUP_DIR/redmine.sql.gz"
