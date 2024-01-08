FROM ubuntu:22.04 as core

LABEL maintainer="yunnysunny@gmail.com"

# 安装依赖
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
  && sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
  && apt-get update \
  && apt-get install  --no-install-recommends  curl  ca-certificates -y \
  && rm -rf /var/lib/apt/lists/*

ARG NPM_REGISTRY=https://registry.npmmirror.com
ARG NPM_MIRROR=https://npmmirror.com

ENV HOME /root

ARG NODE_VERSION
ENV NODE_VERSION=${NODE_VERSION}
# ENV ARCH=x64
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "arm64" ] ; then \
      export ARCH=arm64 ; \
    elif [ "$TARGETARCH" = "arm" ] ; then \
      export ARCH=armv7l ; \
    else \
      export ARCH=x64 ; \
    fi ; \
    if [ "$TARGETARCH" = "arm64" ] || [ "$TARGETARCH" = "arm" ] ; then \
      apt-get update \
      && apt-get install libatomic1 --no-install-recommends -y \
      && rm -rf /var/lib/apt/lists/* ; \
    fi \
  && curl -fsSLO --compressed "${NPM_MIRROR}/mirrors/node/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.gz" \
  && curl -fsSLO --compressed "${NPM_MIRROR}/mirrors/node/v$NODE_VERSION/SHASUMS256.txt" \
  && grep " node-v$NODE_VERSION-linux-$ARCH.tar.gz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -zxvf "node-v$NODE_VERSION-linux-$ARCH.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-$ARCH.tar.gz" SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && npm config set registry ${NPM_REGISTRY} \
  && npm install -g yarn \
  && npm cache clean --force \
  && yarn config set registry ${NPM_REGISTRY}

RUN echo "disable-self-update-check true" >> ~/.yarnrc
ARG BIN_MIRRORS=${NPM_MIRROR}/mirrors

RUN echo "disturl = \"${BIN_MIRRORS}/node\" \n\
chromedriver-cdnurl = \"${BIN_MIRRORS}/chromedriver\" \n\
couchbase-binary-host-mirror = \"${BIN_MIRRORS}/couchbase/v{version}\" \n\
debug-binary-host-mirror = \"${BIN_MIRRORS}/node-inspector\" \n\
electron-mirror = \"${BIN_MIRRORS}/electron/\" \n\
flow-bin-binary-host-mirror = \"${BIN_MIRRORS}/flow/v\" \n\
fse-binary-host-mirror = \"${BIN_MIRRORS}/fsevents\" \n\
fuse-bindings-binary-host-mirror = \"${BIN_MIRRORS}/fuse-bindings/v{version}\" \n\
git4win-mirror = \"${BIN_MIRRORS}/git-for-windows\" \n\
gl-binary-host-mirror = \"${BIN_MIRRORS}/gl/v{version}\" \n\
grpc-node-binary-host-mirror = \"${BIN_MIRRORS}\" \n\
hackrf-binary-host-mirror = \"${BIN_MIRRORS}/hackrf/v{version}\" \n\
leveldown-binary-host-mirror = \"${BIN_MIRRORS}/leveldown/v{version}\" \n\
leveldown-hyper-binary-host-mirror = \"${BIN_MIRRORS}/leveldown-hyper/v{version}\" \n\
mknod-binary-host-mirror = \"${BIN_MIRRORS}/mknod/v{version}\" \n\
node-sqlite3-binary-host-mirror = \"${BIN_MIRRORS}\" \n\
node-tk5-binary-host-mirror = \"${BIN_MIRRORS}/node-tk5/v{version}\" \n\
nodegit-binary-host-mirror = \"${BIN_MIRRORS}/nodegit/v{version}/\" \n\
operadriver-cdnurl = \"${BIN_MIRRORS}/operadriver\" \n\
phantomjs-cdnurl = \"${BIN_MIRRORS}/phantomjs\" \n\
profiler-binary-host-mirror = \"${BIN_MIRRORS}/node-inspector/\" \n\
puppeteer-download-host = \"${BIN_MIRRORS}\" \n\
python-mirror = \"${BIN_MIRRORS}/python\" \n\
rabin-binary-host-mirror = \"${BIN_MIRRORS}/rabin/v{version}\" \n\
sass-binary-site = \"${BIN_MIRRORS}/node-sass\" \n\
sodium-prebuilt-binary-host-mirror = \"${BIN_MIRRORS}/sodium-prebuilt/v{version}\" \n\
sqlite3-binary-site = \"${BIN_MIRRORS}/sqlite3\" \n\
utf-8-validate-binary-host-mirror = \"${BIN_MIRRORS}/utf-8-validate/v{version}\" \n\
utp-native-binary-host-mirror = \"${BIN_MIRRORS}/utp-native/v{version}\" \n\
zmq-prebuilt-binary-host-mirror = \"${BIN_MIRRORS}/zmq-prebuilt/v{version}\" \n\
canvas-binary-host-mirror = \"${BIN_MIRRORS}/node-canvas-prebuilt/v{version}\" \n\
canvas-prebuilt-binary-host-mirror = \"${BIN_MIRRORS}/node-canvas-prebuilt/v{version}\" \n\
swc_binary_site = \"${BIN_MIRRORS}/node-swc\" \n\
xprofiler_binary_host_mirror= \"${BIN_MIRRORS}/xprofiler\" \n" >> ~/.npmrc

FROM core as compiler
RUN apt-get update \
  && apt-get  --no-install-recommends install \
  git gcc g++ make python3 openssh-client libjemalloc2 -y \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp 

FROM core as xtransit
RUN npm install xtransit -g && npm cache clean --force
COPY . /root/
ENTRYPOINT [ "/root/entrypoint.sh" ]

FROM compiler as ezm-compiler
COPY package.json .
COPY yarn.lock .
RUN yarn install --production

FROM core as ezm-runtime
# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY --from=ezm-compiler /tmp/node_modules ./node_modules
COPY . .
ENV NODE_ENV=production \
  EGG_SERVER_ENV=prod

ARG CONSOLE_PORT
ENV CONSOLE_PORT=${CONSOLE_PORT}
ARG MANAGER_PORT
ENV MANAGER_PORT=${MANAGER_PORT}
ARG WSS_PORT
ENV WSS_PORT=${WSS_PORT}
EXPOSE ${CONSOLE_PORT} ${MANAGER_PORT} ${WSS_PORT}
CMD ["npm", "run", "start:foreground"]