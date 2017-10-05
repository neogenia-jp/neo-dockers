#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

if [ -f $SCRIPT_DIR/data/wp-content.tgz ]; then
  echo '-- EXTRACT OLD FILES...'
  ( mkdir /tmp/extract_tmp; cd /tmp/extract_tmp; tar xzf $SCRIPT_DIR/data/wp-content.tgz \
    && DIR=$(find /tmp/extract_tmp  -name 'wp-content' -type d) \
    && rsync -av $DIR/* /var/www/wordpress/wp-content/ \
    && rm -rf /tmp/extract_tmp $SCRIPT_DIR/data/wp-content.tgz \
    || (echo '### ERROR ###' && exit 2) )
fi

