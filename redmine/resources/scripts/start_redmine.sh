#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
cd /usr/share/redmine

if [ ! -f .db_initialized ]; then
  echo '----- INITIALIZE DB -----'
  echo " exec $SCRIPT_DIR/initdb.sql"
  mysql < $SCRIPT_DIR/initdb.sql
  if [ -f $SCRIPT_DIR/old_data.dmp ]; then
    mysql redmine < $SCRIPT_DIR/old_data.dmp
  fi
  touch .db_initialized
fi

# PIDファイルを削除
rm tmp/pids/* 2>/dev/null

LOG_FILE=log/production.log

bundle install | tee -a $LOG_FILE 2>&1

bin/rake db:migrate | tee -a $LOG_FILE 2>&1

echo '----- START REDMINE -----'
bin/rails server -b 0.0.0.0 -d

