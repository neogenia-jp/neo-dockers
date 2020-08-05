#!/bin/bash
#
# Usage:
#   ./build.sh <ruby_version> [build_options]
# Example:
#   ./build.sh 2.7.1 --with-jemalloc
#
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

RUBY_VERSION=${1:-2.6.3}
TAG=$RUBY_VERSION

IMAGE_NAME=neogenia/ruby
NAME_TAG=$IMAGE_NAME:$TAG
echo building image "$NAME_TAG" ...

(cd $SCRIPT_DIR; time docker build -t $NAME_TAG --build-arg RUBY_VERSION=$RUBY_VERSION --build-arg BUILD_OPTS=$2 .) \
&& cat <<GUIDE
# build finished successfuly.
# If you push image to DockerHub, use below command:

docker login

docker push $NAME_TAG

GUIDE
