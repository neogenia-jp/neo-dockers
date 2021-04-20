#!/bin/bash
#
# Usage:
#   ./exec-galaxy.sh <playbook_root_dir>
# Example:
#   ./exec-galaxy.sh /home/neo/playbook1
#

function usage() {
  if [ -n "$1" ]; then
    echo ERROR: $1
  fi
  echo "Usage: $0 <playbook_root_dir>"
  exit 1
}

export PLAYBOOK_ROOT=$1; shift

if [ -z "$PLAYBOOK_ROOT" ]; then
  usage "some arguments required."
fi

if [ ! -e $PLAYBOOK_ROOT ]; then
  usage "not found '$PLAYBOOK_ROOT'."
fi
if [ ! -d $PLAYBOOK_ROOT ]; then
  usage "'$PLAYBOOK_ROOT' is not a directory."
fi

exec docker-compose run --rm -e PLAYBOOK_ROOT ansible ansible-galaxy install -p roles -r requirements.yml
