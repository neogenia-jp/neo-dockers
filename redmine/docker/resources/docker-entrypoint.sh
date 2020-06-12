#!/bin/bash

if [ ! -z "$@" ]; then
  exec "$@"
else

  # clear log
  log=/var/log/redmine/default/production.log
  echo > $log
  #log2=/var/log/redmine/startup
  #echo > $log2

  # start monit
  echo '--- START MONIT -----'
  if [ -z "$MONIT_ARGS" ]; then
    /etc/init.d/monit start
    tail -f $log
  else
    monit $MONIT_ARGS -I
  fi
fi
