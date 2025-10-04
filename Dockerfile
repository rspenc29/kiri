FROM --platform=$BUILDPLATFORM node:24-alpine AS build
ARG VERSION=latest

WORKDIR /app

RUN <<EOF
  if [ "$VERSION" = "latest" ]; then
    VERSION=$(wget -qO- https://api.github.com/repos/GridSpace/grid-apps/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  fi

  wget https://api.github.com/repos/GridSpace/grid-apps/tarball/$VERSION -O - | tar xz --strip 1
  npm install && npm run setup && npm run prod-pack && rm -rf node_modules /root/.npm
  mkdir dist && mv package.json app.js apps src web dist
EOF

FROM node:24-alpine
LABEL org.opencontainers.image.source=https://github.com/rspenc29/kiri

WORKDIR /app
CMD ["npx", "gs-app-server", "--logs=/tmp/logs"]
ENV NODE_ENV=production

COPY --from=build /app/dist /app
RUN npm install --omit=dev --ignore-scripts && rm -rf /root/.npm package-lock.json

