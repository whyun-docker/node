FROM yunnysunny/ubuntu as core

ARG NPM_REGISTRY=https://registry.npmmirror.com
ARG NPM_MIRROR=https://npmmirror.com

ENV HOME /root
RUN apt-get update \
  && apt-get install  --no-install-recommends  curl  ca-certificates -y \
  && rm -rf /var/lib/apt/lists/*
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

FROM core as compiler
RUN apt-get update \
  && apt-get  --no-install-recommends install git gcc g++ make python3 openssh-client -y \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp 

FROM core as xtransit
RUN npm install xtransit -g && npm cache clean --force
COPY . /root/
ENTRYPOINT [ "/root/entrypoint.sh" ]
