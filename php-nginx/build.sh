#!/bin/bash
#
# Usage:
#   ./build.sh <php_version> [composer_version]
# Example:
#   ./build.sh 7.2
#
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

PHP_VERSION=${1:-7.2}
TAG=$PHP_VERSION

IMAGE_NAME=neogenia/php-nginx
NAME_TAG=$IMAGE_NAME:$TAG
echo building image "$NAME_TAG" ...

(cd $SCRIPT_DIR; time docker build -t $NAME_TAG --build-arg PHP_VERSION=${PHP_VERSION//./} --build-arg COMPOSER_VERSION=${2:-1.10.15} .) \
&& cat <<GUIDE
# build finished successfuly.
# If you push image to DockerHub, use below command:

docker login

docker push $NAME_TAG

GUIDE
