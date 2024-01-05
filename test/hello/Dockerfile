ARG IMAGE_VERSION
FROM yunnysunny/node-compiler:${IMAGE_VERSION} as build-stage

COPY package.json .
COPY yarn.lock .

RUN yarn install

FROM yunnysunny/node-xtransit:${IMAGE_VERSION}
ARG JEMALLOC_HOME=/usr/lib/x86_64-linux-gnu
RUN mkdir -p /app $JEMALLOC_HOME
WORKDIR /app
COPY --from=build-stage ${JEMALLOC_HOME}/libjemalloc.so.2 $JEMALLOC_HOME
COPY --from=build-stage ${JEMALLOC_HOME}/libjemalloc.so $JEMALLOC_HOME
COPY --from=build-stage /tmp/node_modules ./node_modules
ENV LD_PRELOAD=${JEMALLOC_HOME}/libjemalloc.so
COPY . .
CMD ["node", "src/app.js"]