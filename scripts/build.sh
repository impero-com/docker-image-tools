#!/bin/bash
set -eu

mkdir -p "$1/x86_64" "$1/aarch64"
echo "Building Docker image..."
docker build --tag cc .

echo "Building x86_64 tools..."
docker run -it --name build-x86_64 cc scripts/build.sh x86_64-unknown-linux-gnu /tools
docker container cp build-x86_64:/tools/. "$1/x86_64"
docker container rm build-x86_64

echo "Building aarch64 tools..."
docker run -it --name build-aarch64 cc scripts/build.sh aarch64-unknown-linux-gnu /tools
docker container cp build-aarch64:/tools/. "$1/aarch64"
docker container rm build-aarch64

docker image rm cc
