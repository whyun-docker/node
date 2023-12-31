#!/bin/bash
set -ex

NODE_VERSION=18.19.0
OS_NAME=${OS_NAME:-ubuntu}
BUILD_ARGS="--build-arg NODE_VERSION=${NODE_VERSION} \
"
# export VERSION_NAME_PREFIX=""
# if [ "$OS_NAME" = "alpine" ] ; then
#     export VERSION_NAME_PREFIX="alpine-"
# fi

# BUILD_TAG_CORE=$(node ci/get_image_build_tag.js core)
# BUILD_TAG_COMPILER=$(node ci/get_image_build_tag.js compiler)
# BUILD_TAG_RUNTIME=$(node ci/get_image_build_tag.js runtime)

if [ "$NEED_PUSH" = "1" ] ; then
    PLATFORM="--platform=linux/arm64,linux/amd64"
    PARAM_OUTPUT="--push"
else
    PLATFORM=""
    PARAM_OUTPUT="-o type=docker"
fi

docker buildx build -f node.dockerfile core \
$PLATFORM \
$BUILD_ARGS \
--target core  \
-t yunnysunny/node $PARAM_OUTPUT

docker buildx build -f node.dockerfile compiler \
$PLATFORM \
$BUILD_ARGS \
--target compiler \
-t yunnysunny/node-compiler $PARAM_OUTPUT

docker buildx build -f node.dockerfile xtransit \
$PLATFORM \
$BUILD_ARGS \
--target xtransit \
-t yunnysunny/node-xtransit $PARAM_OUTPUT


