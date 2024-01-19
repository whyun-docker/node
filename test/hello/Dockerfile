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
COPY --from=build-stage /tmp/node_modules ./node_modules
ENV LD_PRELOAD=${JEMALLOC_HOME}/libjemalloc.so.2
COPY . .
ARG EZM_APP_ID
ENV EZM_APP_ID=${EZM_APP_ID}
ARG EZM_APP_SECRET
ENV EZM_APP_SECRET=${EZM_APP_SECRET}
ARG XTRANSIT_SERVER
ENV XTRANSIT_SERVER=${XTRANSIT_SERVER}
CMD ["node", "src/app.js"]