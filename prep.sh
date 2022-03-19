#!/usr/bin/env bash

exit 0

# https://github.com/mLupine/docker-lambda

IMAGE_NAME=mlupin/docker-lambda:nodejs14.x-build-arm64

# Install dependencies
docker run --rm -v "$PWD/root":/root -v "$PWD":/var/task mlupin/docker-lambda:nodejs14.x-build-arm64 npm --no-optional --no-audit --progress=false install

# Build the layer
docker run --rm -v "$PWD/root":/root -v "$PWD":/var/task mlupin/docker-lambda:nodejs14.x-build-arm64 node ./node_modules/webpack/bin/webpack.js

# Perform a smoke-test
docker run --rm -w /var/task/dist/nodejs -v "$PWD/root":/root -v "$PWD":/var/task:ro,delegated mlupin/docker-lambda:nodejs14.x-build-arm64 node -e "console.log(require('sharp'))"


# This will always execute the code in an x86_64 environment (native on x86 computers, emulated on arm64)
#docker run --rm -v "$PWD":/var/task:ro,delegated mlupin/docker-lambda:nodejs12.x-x86_64 index.handler

# This will always execute the code in an arm64 environment (native on arm64 computers, emulated on x86)
#docker run --rm -v "$PWD":/var/task:ro,delegated mlupin/docker-lambda:nodejs12.x-arm64 index.handler

# This will always execute the code in an environment matching the host computer architecture
#docker run --rm -v "$PWD":/var/task:ro,delegated mlupin/docker-lambda:nodejs12.x index.handler

