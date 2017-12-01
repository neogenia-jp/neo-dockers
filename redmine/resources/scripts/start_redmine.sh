#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
cd /usr/share/redmine

if [ ! -f .db_initialized ]; then
  echo '----- INITIALIZE DB -----'

  # Exec database initialize SQL script.
  echo " exec $SCRIPT_DIR/initdb.sql"
  mysql < $SCRIPT_DIR/initdb.sql
  if [ -f $SCRIPT_DIR/old_data.dmp ]; then
    echo '----- importing old_data -----'
    mysql redmine < $SCRIPT_DIR/old_data.dmp
  fi
  touch .db_initialized
fi

# PIDファイルを削除
rm tmp/pids/* 2>/dev/null

LOG_FILE=log/production.log

echo '----- bundle install -----'
bundle install

echo '----- database migrating -----'
bin/rake db:migrate

chronic bin/rails server -b 0.0.0.0 -d \
  && echo '----- REDMINE STARTED -----'

