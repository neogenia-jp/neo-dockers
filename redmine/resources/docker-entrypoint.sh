#!/bin/bash

if [ ! -z "$@" ]; then
  exec "$@"
else
  archive=/var/redmine_data/files
  if [ -d "$archive" ]; then
    echo ' -  detect attachment files. migrating...'
    mv $archive /usr/share/redmine/instances/default/
  fi

  archive=/var/redmine_data/var/hg
  if [ -d "$archive" ]; then
    echo ' -  detect hg repos. migrating...'
    mv $archive /var/
  fi

  # clear log
  log=/usr/share/redmine/log/production.log
  echo > $log

  # start monit
  echo '--- START MONIT -----'
  if [ -z "$MONIT_ARGS" ]; then
    /etc/init.d/monit start
    tail -f $log
  else
    monit $MONIT_ARGS -I
  fi
fi
