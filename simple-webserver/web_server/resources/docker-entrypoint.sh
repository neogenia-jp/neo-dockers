#!/bin/bash
set -e -o pipefail

if [ ! -z "$@" ]; then
  exec "$@"
else
  if [ ! -e /etc/letsencrypt/live/$APP_DOMAIN ]; then
    echo '--- START INITIALIZE SSL CERT FILES USING LETS ENCRYPT -----'
    nginx -t
    /etc/init.d/nginx start
    sleep 5
    /var/scripts/setup_letsencrypt.sh 
    if [ "$?" != '0' ]; then
      tail -100 /var/log/letsencrypt/letsencrypt.log
      exit 1
    fi
  fi

  # HTTPSを有効化
  echo '--- ENABLE HTTPS -----'
  ln -s /etc/nginx/sites-available/default_https /etc/nginx/sites-enabled/default_https || true
  nginx -t
  /etc/init.d/nginx restart

  logs="/var/log/monit.log /var/log/nginx/*error*"

  # start monit
  echo '--- START MONIT -----'
  if [ -z "$MONIT_ARGS" ]; then
    /etc/init.d/monit start
    tail -f $logs
  else
    monit $MONIT_ARGS -I
  fi
fi

