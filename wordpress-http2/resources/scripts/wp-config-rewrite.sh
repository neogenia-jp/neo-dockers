#!/bin/bash

FILE=/var/www/wordpress/wp-config.php
cp /var/www/wordpress/wp-config-sample.php $FILE

sed -i -e "s!define('DB_NAME', 'database_name_here');!define('DB_NAME', 'wordpress');!g" \
       -e "s!define('DB_USER', 'username_here');!define('DB_USER', 'wordpress');!g" \
       -e "s!define('DB_PASSWORD', 'password_here');!define('DB_PASSWORD', 'Passw0rd');!g" \
       -e "s!define('DB_HOST', '');!define('DB_HOST', 'wordpress');!g" \
       -e "s!$table_prefix  = 'wp_';!$table_prefix  = 'wp2_';!g" \
  $FILE
