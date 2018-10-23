#!/bin/bash
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

RUBY_VERSION=2.5.3

TAG=neogenia/ruby2.5:$RUBY_VERSION

(cd $SCRIPT_DIR; docker build -t $TAG --build-arg RUBY_VERSION=$RUBY_VERSION .)

