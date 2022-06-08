#!/bin/bash
#
# Usage:
#   ./build.sh <mariadb_version> [tag]
# Example:
#   ./build.sh 10.8.2 latest
#
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

MARIA_DB_VERSION=${1:-10.8.2}
TAG=${2:-$MARIA_DB_VERSION}

IMAGE_NAME=neogenia/$(basename $SCRIPT_DIR)
NAME_TAG=$IMAGE_NAME:$TAG
echo building image "$NAME_TAG" ...

(cd $SCRIPT_DIR; time docker build -t $NAME_TAG --build-arg MARIA_DB_VERSION=$MARIA_DB_VERSION .) \
&& cat <<GUIDE
# build finished successfuly.
# If you push image to DockerHub, use below command:

docker login

docker push $NAME_TAG

GUIDE
