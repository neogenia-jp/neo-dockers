#!/bin/bash
#
# Usage:
#   ./build.sh <ruby_version> [tag]
# Example:
#   ./build.sh 2.5.3 latest
#
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

RUBY_VERSION=${1:-2.5.3}
TAG=${2:-$RUBY_VERSION}

IMAGE_NAME=neogenia/$(basename $SCRIPT_DIR)
NAME_TAG=$IMAGE_NAME:$TAG
echo building image "$NAME_TAG" ...

(cd $SCRIPT_DIR; docker build -t $NAME_TAG --build-arg RUBY_VERSION=$RUBY_VERSION .) \
&& cat <<GUIDE
# build finished successfuly.
# If you push image to DockerHub, use below command:

docker login

docker push $NAME_TAG

GUIDE
