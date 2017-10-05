#!/bin/bash

if [ ! -z "$@" ]; then
  exec "$@"
else
  logs="/var/log/monit.log /var/log/nginx/access.log"

  # start monit
  echo '--- START MONIT -----'
  if [ -z "$MONIT_ARGS" ]; then
    /etc/init.d/monit start
    tail -f $logs
  else
    monit $MONIT_ARGS -I
  fi
fi
