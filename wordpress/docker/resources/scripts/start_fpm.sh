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
  DUMP_FILE=/var/www/wordpress/old_data.sql.gz
  if [ -f $DUMP_FILE ]; then
    echo '-- IMPORTING OLD DB...'
    zcat $DUMP_FILE | mysql -uwordpress -pPassw0rd wordpress
  fi
  touch .db_initialized
fi

echo '----- START PHP-FPM -----'
/etc/init.d/php7.2-fpm start

#tail -f /var/log/php7.0-fpm.log

