#!/bin/bash

if [ ! -z "$@" ]; then
  exec "$@"
else

  # initialize log files
  redmine_log=/var/log/redmine/default/production.log
  echo > $redmine_log  # cleaning it
  startup_log=/var/log/redmine/startup.log
  touch $startup_log   # create it if not exists

  # start monit
  echo '--- START MONIT -----'
  if [ -z "$MONIT_ARGS" ]; then
    /etc/init.d/monit start
    tail -f $redmine_log $startup_log
  else
    monit $MONIT_ARGS -I
  fi
fi
