#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
cd /var

if [ ! -f .wp_initialized ]; then
  echo '----- INITIALIZE Wordpress -----'
  echo " exec $SCRIPT_DIR/wp-config-rewrite.sh"
  $SCRIPT_DIR/wp-config-rewrite.sh

  $SCRIPT_DIR/extract-wp-content.sh

  chown -R www-data.www-data /var/www/wordpress
  touch .wp_initialized
fi

if [ ! -f .db_initialized ]; then
  echo '----- INITIALIZE DB -----'
  echo " exec $SCRIPT_DIR/initdb.sql"
  mysql < $SCRIPT_DIR/initdb.sql
  if [ -f $SCRIPT_DIR/data/old_data.sql ]; then
    echo '-- IMPORTING OLD DB...'
    mysql -uwordpress -pPassw0rd wordpress < $SCRIPT_DIR/data/old_data.sql
  fi
  touch .db_initialized
fi

echo '----- START PHP-FPM -----'
/etc/init.d/php5.6-fpm start

#tail -f /var/log/php7.0-fpm.log

