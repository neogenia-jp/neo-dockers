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
  fi
  touch $LOCK_FILE
fi

# PIDファイルを削除
rm tmp/pids/* 2>/dev/null

LOG_FILE=log/production.log

echo '----- bundle install -----'
gem install mysql2 -v '0.5.3' --source 'https://rubygems.org/'  # patch for mysql2 gem install error
gem install puma -v '3.12.6' --source 'https://rubygems.org/'
bundle install

echo '----- database migrating -----'
bin/rake generate_secret_token
bin/rake db:migrate

chronic bin/rails server -b 0.0.0.0 -d \
  && echo '----- REDMINE STARTED -----'

