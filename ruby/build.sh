#!/bin/bash
#
# Usage:
#   ./build.sh <ruby_version> [build_options...]
# Example:
#   ./build.sh 2.7.1 --with-jemalloc
#
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

RUBY_VERSION=${1:-2.6.3}
TAG=$RUBY_VERSION

# buildxを使えるか判定する
ENABLE_BUILD_X=""
if docker buildx version >/dev/null 2>&1; then
  ENABLE_BUILD_X=true
fi

IMAGE_NAME=neogenia/ruby
NAME_TAG=$IMAGE_NAME:$TAG
echo building image "$NAME_TAG" ...

if [[ -n "$ENABLE_BUILD_X" ]]; then
  echo "Using buildx (multi-arch build)"
  DOCKER_BUILD_COMMAND_BASE="docker buildx build --platform linux/amd64,linux/arm64"
else
  echo "Warning: buildx not found. Unable to multi-arch build"
  DOCKER_BUILD_COMMAND_BASE="docker build"
fi

(cd $SCRIPT_DIR; time $DOCKER_BUILD_COMMAND_BASE -t $NAME_TAG --build-arg RUBY_VERSION=$RUBY_VERSION --build-arg BUILD_OPTS=$2 .) \
&& cat <<GUIDE
# build finished successfuly.
# If you push image to DockerHub, use below command:

docker login

docker push $NAME_TAG

GUIDE
