#!/bin/bash

RELEASE=${1:-4.3.1}

docker buildx build --push \
    --build-arg RELEASE=$RELEASE \
    --platform linux/amd64,linux/arm64 \
    -t ghcr.io/rspenc29/kiri:$RELEASE .
