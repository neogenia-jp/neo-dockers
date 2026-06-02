#!/bin/bash
#
# Usage:
#   ./build.sh <ruby_version> [--push] [tag]
#   --pushオプションはbuildxを使用している場合にのみ有効で、ビルド後にイメージをDockerHubにプッシュします。
#   tagは省略した場合はruby_versionと同じになります。
# Example:
#   ./build.sh 2.7.0
#   ./build.sh 2.7.0 --push
#   ./build.sh 2.7.0 latest
#   ./build.sh 2.7.0 --push latest
#
SCRIPT_DIR=${SCRIPT_DIR:-$(cd $(dirname $0) && pwd)}

RUBY_VERSION=${1:-2.7.0}

# buildxを使えるか判定する
ENABLE_BUILD_X=""
if docker buildx version >/dev/null 2>&1; then
  ENABLE_BUILD_X=true
fi

# 第1引数（Rubyバージョン）以降のコマンド引数を確認する
# pushオプション以外はタグとして扱う。
shift || true
PUSH_FLAG=""
TAG=""
for arg in "$@"; do
  if [[ "$arg" == "--push" && $ENABLE_BUILD_X ]]; then
    PUSH_FLAG="--push"
  else
    if [[ -z "$TAG" ]]; then
      TAG="$arg"
    fi
  fi
done

# タグが指定されない場合はRubyバージョンをタグにする。
if [[ -z "$TAG" ]]; then
  TAG="$RUBY_VERSION"
fi

IMAGE_NAME=neogenia/$(basename $SCRIPT_DIR)
NAME_TAG=$IMAGE_NAME:$TAG
echo building image "$NAME_TAG" ...

if [[ -n "$ENABLE_BUILD_X" ]]; then
  echo "Using buildx (multi-arch build)"
  DOCKER_BUILD_COMMAND_BASE="docker buildx build --platform linux/amd64,linux/arm64 $PUSH_FLAG"
else
  echo "Warning: buildx not found. Unable to multi-arch build"
  DOCKER_BUILD_COMMAND_BASE="docker build"
fi

(cd $SCRIPT_DIR; time $DOCKER_BUILD_COMMAND_BASE -t $NAME_TAG --build-arg RUBY_VERSION=$RUBY_VERSION  .) \
&& echo "# build finished successfuly."

# 自動pushしない場合はpushコマンドの案内を表示する
if [[ -z "$PUSH_FLAG" ]]; then
  cat <<GUIDE
# If you push image to DockerHub, use below command:

docker login

docker push $NAME_TAG
GUIDE
fi
