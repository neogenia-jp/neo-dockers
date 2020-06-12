#!/bin/bash

cd /usr/share/redmine

for i in tmp/pids/*; do
  echo "-- Killing process $i"
  kill `cat $i`
done

# PIDファイルを削除
rm tmp/pids/* 2>/dev/null

echo '----- REDMINE STOPPED -----'
