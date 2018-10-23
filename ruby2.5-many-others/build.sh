#!/bin/bash
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

TAG=neogenia/ruby2.5-many-others

if [ -z $1 ]; then
  TAG=${TAG}:$1
fi

(cd $SCRIPT_DIR; docker build -t $TAG .)

