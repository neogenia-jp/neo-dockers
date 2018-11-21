#!/bin/bash
#
# Usage:
#   ./build.sh [version]
# Example:
#   ./build.sh latest
#
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

VERSION=${1:-latest}
TAG=${VERSION}

IMAGE_NAME=neogenia/$(basename $SCRIPT_DIR)
NAME_TAG=$IMAGE_NAME:$TAG
echo building image "$NAME_TAG" ...

(cd $SCRIPT_DIR; docker build -t $NAME_TAG --build-arg VERSION=$VERSION .) \
&& cat <<GUIDE
# build finished successfuly.
# If you push image to DockerHub, use below command:

docker login

docker push $NAME_TAG

GUIDE
