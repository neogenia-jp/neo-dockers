#!/bin/bash
#
# Usage:
#   ./build.sh <ruby_version> [--push] [tag]
#   tagは省略した場合はruby_versionと同じになります。
# Example:
#   ./build.sh 2.7.0
#   ./build.sh 2.7.0 latest
#
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

RUBY_VERSION=${1:-2.7.0}
TAG=${2:-$RUBY_VERSION}

# buildxを使えるか判定する
ENABLE_BUILD_X=""
if docker buildx version >/dev/null 2>&1; then
  ENABLE_BUILD_X=true
fi

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

(cd $SCRIPT_DIR; time $DOCKER_BUILD_COMMAND_BASE -t $NAME_TAG --build-arg RUBY_VERSION=$RUBY_VERSION  .) \
&& cat <<GUIDE
# build finished successfuly.
# If you push image to DockerHub, use below command:

docker login

docker push $NAME_TAG

GUIDE
