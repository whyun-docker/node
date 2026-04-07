FROM debian:stable-slim as core

LABEL maintainer="yunnysunny@gmail.com"

# 安装依赖
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources \
  && apt-get update \
  && apt-get install  --no-install-recommends  curl tzdata  ca-certificates -y \
  && rm -rf /var/lib/apt/lists/*

# 使用东八区时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
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
  && npm install -g pnpm \
  && npm cache clean --force

ARG BIN_MIRRORS=${NPM_MIRROR}/mirrors

ENV CHROMEDRIVER_CDNURL=${NPM_MIRROR}/metadata
ENV CHROMEDRIVER_CDNBINARIESURL=${BIN_MIRRORS}
ENV NODEJS_ORG_MIRROR=${BIN_MIRRORS}/node/
ENV npm_config_disturl=${BIN_MIRRORS}/node
ENV PUPPETEER_CHROME_DOWNLOAD_BASE_URL=${BIN_MIRRORS}/chrome-for-testing
ENV ELECTRON_MIRROR=${BIN_MIRRORS}/electron/
ENV PLAYWRIGHT_DOWNLOAD_HOST=${BIN_MIRRORS}/playwright
ENV npm_config_xprofiler_binary_host=${BIN_MIRRORS}/xprofiler

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
COPY pnpm-lock.yaml .
RUN pnpm install --prod

FROM core as ezm-runtime
# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY --from=ezm-compiler /tmp/node_modules ./node_modules
COPY . .
ENV NODE_ENV=production \
  EGG_SERVER_ENV=prod

ARG CONSOLE_PORT=8443
ENV CONSOLE_PORT=${CONSOLE_PORT}
ARG MANAGER_PORT=8543
ENV MANAGER_PORT=${MANAGER_PORT}
ARG WSS_PORT=9190
ENV WSS_PORT=${WSS_PORT}
EXPOSE ${CONSOLE_PORT} ${MANAGER_PORT} ${WSS_PORT}
CMD ["npm", "run", "start:foreground"]