FROM --platform=$BUILDPLATFORM node:24-alpine AS build

WORKDIR /app
ARG RELEASE

RUN wget https://api.github.com/repos/GridSpace/grid-apps/tarball/$RELEASE -O - | tar xz --strip 1 \
    && npm run setup && npm run prod-pack && rm -rf node_modules /root/.npm \
    && mkdir dist && mv package.json app.js apps src web dist

FROM node:24-alpine
LABEL org.opencontainers.image.source=https://github.com/rspenc29/kiri

WORKDIR /app
CMD ["npx", "gs-app-server", "--logs=/tmp/logs"]
ENV NODE_ENV=production

COPY --from=build /app/dist /app
RUN npm install --omit=dev --ignore-scripts && rm -rf /root/.npm package-lock.json

