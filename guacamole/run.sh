#!/bin/bash
#
# Usage:
#   ./run.sh <domain_name> <https_cert_email> [version]
# Example:
#   ./run.sh test2.neogenia.co.jp w.maeda@neogenia.co.jp
#
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

export DOMAIN_NAME=$1
export HTTPS_CERT_EMAIL=$2
export VERSION=${3:-0.9.14}

if [ -z "$DOMAIN_NAME" -o -z "$HTTPS_CERT_EMAIL" ]; then
  echo
  echo "  Usage:"
  echo "    $0 <domain_name> <https_cert_email> [version]"
  echo
  exit 1
fi

docker run guacamole/guacamole:$VERSION /opt/guacamole/bin/initdb.sh --mysql > mysql/docker-entrypoint-initdb.d/initdb.sql

(cd $SCRIPT_DIR; docker-compose up --build)

