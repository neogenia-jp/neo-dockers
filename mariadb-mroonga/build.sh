#!/bin/bash
#
# Usage:
#   ./build.sh <mariadb_version> [tag]
#   tagは省略した場合はMariaDBバージョンになります。
# Example:
#   ./build.sh 10.8.2
#   ./build.sh 10.8.2 latest
#
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

# buildxを使えるか判定する
ENABLE_BUILD_X=""
if docker buildx version >/dev/null 2>&1; then
  ENABLE_BUILD_X=true
fi

MARIA_DB_VERSION=${1:-10.8.2}
TAG=${2:-$MARIA_DB_VERSION}

IMAGE_NAME=neogenia/$(basename $SCRIPT_DIR)
NAME_TAG=$IMAGE_NAME:$TAG
echo building image "$NAME_TAG" ...

if [[ -n "$ENABLE_BUILD_X" ]]; then
  echo "Using buildx (multi-arch build)"
  DOCKER_BUILD_COMMAND_BASE="docker buildx build --platform linux/amd64,linux/arm64"
else
  echo "Warning: buildx not found. Unable to multi-arch build"
  DOCKER_BUILD_COMMAND_BASE="docker build"
fi

(cd $SCRIPT_DIR; time $DOCKER_BUILD_COMMAND_BASE -t $NAME_TAG --build-arg MARIA_DB_VERSION=$MARIA_DB_VERSION .) \
&& cat <<GUIDE
# build finished successfuly.
# If you push image to DockerHub, use below command:

docker login

docker push $NAME_TAG

GUIDE
