ARG IMAGE_VERSION
FROM yunnysunny/node-compiler:${IMAGE_VERSION} as build-stage

COPY package.json .
COPY yarn.lock .

RUN yarn install

FROM yunnysunny/node-xtransit:${IMAGE_VERSION}
RUN mkdir -p /app
WORKDIR /app
COPY --from=build-stage /tmp/node_modules ./node_modules
COPY . .
CMD ["node", "src/app.js"]