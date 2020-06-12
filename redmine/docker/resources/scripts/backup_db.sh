#!/bin/bash

BACKUP_DIR=/mnt/bkup_`date "+%a"`/

if [ ! -f "$BACKUP_DIR" ]; then
  mkdir "$BACKUP_DIR"
fi

mysqldump --default-character-set=utf8 --hex-blob -R redmine | gzip -c > "$BACKUP_DIR/redmine.sql.tgz"
