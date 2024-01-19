#!/bin/bash
set -ex
if [ "$USE_PODMAN" = "1" ] ; then
    docker() { 
        podman "$@"
    }
    docker -v
fi
APP_PORT=4231
IMAGE_VERSION=${IMAGE_VERSION:-latest}
MY_NAME=myhello
OS_NAME=${OS_NAME:-ubuntu}
VERSION_NAME_PREFIX=""
if [ "$OS_NAME" = "alpine" ] ; then
    VERSION_NAME_PREFIX="alpine-"
fi

docker build . -t ${MY_NAME} \
--build-arg VERSION_NAME_PREFIX=${VERSION_NAME_PREFIX} \
--build-arg IMAGE_VERSION=${IMAGE_VERSION} \
--build-arg EZM_APP_ID=${EZM_APP_ID} \
--build-arg EZM_APP_SECRET=${EZM_APP_SECRET} \
--build-arg XTRANSIT_SERVER=${XTRANSIT_SERVER} 
# test script
container_id=$(docker run -e APP_PORT="${APP_PORT}"  --privileged -d ${MY_NAME})
docker exec "${container_id}" bash -c 'node -e "console.log(new Date().toString())" ; \
pldd 1; \
sleep 1; \
curl http://localhost:${APP_PORT} ; \
' || true


docker stop "${container_id}"
docker rm "${container_id}"

