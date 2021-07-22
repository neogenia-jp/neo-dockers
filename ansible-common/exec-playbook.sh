#!/bin/bash
#
# Usage:
#   ./exec-playbook.sh <playbook_root_dir> [args for ansible-playbook]..
# Example:
#   ./exec-playbook.sh /home/neo/playbook1 -i inventory.ini site.xml
#

function usage() {
  if [ -n "$1" ]; then
    echo ERROR: $1
  fi
  echo "Usage: $0 <playbook_root_dir> [args for ansible-playbook]..."
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

args=()
for arg; do
  if [[ $arg =~ ^--private-key=(.+) ]]; then
    # override the `private-key` option!
    export KEY_FILE=${BASH_REMATCH[1]}
    if [ ! -e "$KEY_FILE" ]; then
      usage "not found private-key file '$key_file'."
    fi
    additional_file="-f docker-compose.with_key.yml"
    arg="--private-key=/root/priv_key"
  fi
  args+=( $arg )
done

exec docker-compose -f docker-compose.yml $additional_file run --rm -e PLAYBOOK_ROOT -e KEY_FILE ansible ansible-playbook "${args[@]}"
