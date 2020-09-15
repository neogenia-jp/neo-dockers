#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
LOCK_FILE=/var/lib/mysql/.db_initialized

export RAILS_ENV=production

cd /usr/share/redmine

if [ ! -f $LOCK_FILE ]; then
  echo '----- INITIALIZE DB -----'

  # Exec database initialize SQL script.
  echo " exec $SCRIPT_DIR/initdb.sql"
  mysql < $SCRIPT_DIR/initdb.sql
  if [ -f /mnt/mysql_data.sql.gz ]; then
    echo '----- importing old_data -----'
    zcat /mnt/mysql_data.sql.gz | mysql redmine
    if [ $? -ne 0 ]; then
      echo "##### ERROR ##### can't initialize RDB"
      exit 1
    fi
  fi
  touch $LOCK_FILE
fi

# PIDファイルを削除
rm tmp/pids/* 2>/dev/null

LOG_FILE=log/production.log

echo '----- bundle install -----'
bundle install
if [ $? -ne 0 ]; then
  echo "##### ERROR ##### failed bundle install"
  exit 1
fi

echo '----- database migrating -----'
bin/rake generate_secret_token
bin/rake db:migrate
if [ $? -ne 0 ]; then
  echo "##### ERROR ##### failed db:migrate"
  exit 1
fi

chronic bin/rails server -b 0.0.0.0 -d \
  && echo '----- REDMINE STARTED -----'

