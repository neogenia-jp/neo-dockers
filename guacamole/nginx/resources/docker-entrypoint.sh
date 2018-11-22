#!/bin/bash

if [ ! -z "$@" ]; then
  exec "$@"
else
  logs="/var/log/monit.log /var/log/nginx/*error*"

  # td-agent
  if [ -z "$FLUENTD_COLLECTOR_HOST" ]; then
    # disable td-agent
    echo "-- disable fluentd."
    mv /etc/monit/conf.d/td-agent /tmp/
  else
    # enable td-agnet
    echo "-- enable fluentd. forward host=$FLUENTD_COLLECTOR_HOST"
  fi

  # start monit
  echo '--- START MONIT -----'
  if [ -z "$MONIT_ARGS" ]; then
    /etc/init.d/monit start
    tail -f $logs
  else
    monit $MONIT_ARGS -I
  fi
fi

