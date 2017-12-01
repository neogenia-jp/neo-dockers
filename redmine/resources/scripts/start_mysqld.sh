#!/bin/bash

cd /var/tmp/

if [ ! -f .mysql_initialized ]; then
  echo '----- INITIALIZING MYSQL -----'

  usermod -d /var/lib/mysql mysql

  # Reinitialize MySQL's datadir, because error occuerd in server startup on Ubuntu 16.04
  rm -rf /var/lib/mysql/*
  mysqld --initialize-insecure --datadir /var/lib/mysql --user=mysql

  touch .mysql_initialized
fi

echo '----- STARTING MYSQL -----'
service mysql start

