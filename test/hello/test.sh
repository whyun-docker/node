#!/bin/bash
set -ex

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
--build-arg IMAGE_VERSION=${IMAGE_VERSION}
# test script
container_id=$(docker run -e APP_PORT="${APP_PORT}" -p ${APP_PORT}:${APP_PORT}  -d ${MY_NAME})
docker exec "${container_id}" bash -c 'node -e "console.log(new Date().toString())" ; \
sleep 3 ; \
curl http://localhost:${APP_PORT} ; \
ps -ef | grep node ; \
pldd 1; '


docker stop "${container_id}"
docker rm "${container_id}"

