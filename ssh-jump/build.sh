#!/bin/bash
#
# Usage:
#   ./build.sh [tag]
# Example:
#   ./build.sh latest
#
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

TAG=${1:-`date "+%Y%m%d"`}

IMAGE_NAME=neogenia/ssh-jump
NAME_TAG=$IMAGE_NAME:$TAG
echo building image "$NAME_TAG" ...

(cd $SCRIPT_DIR; time docker-compose build ssh-jump) \
&& docker tag $IMAGE_NAME $NAME_TAG \
&& cat <<GUIDE
# build finished successfuly.
# If you push image to DockerHub, use below command:

docker login

docker push $IMAGE_NAME

GUIDE
