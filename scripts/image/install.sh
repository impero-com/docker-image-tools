#!/bin/bash
set -eu

apt-get install -qq \
    crossbuild-essential-arm64 \
    libc6-arm64-cross \
    libc6-dev-arm64-cross

# Build libssl
OPENSSL_TAG=openssl-3.0.2
git clone https://github.com/openssl/openssl.git --depth 1 --tag "$OPENSSL_TAG"
cd "$OPENSSL_TAG" && \
    ./Configure linux-aarch64 --cross-compile-prefix=aarch64-linux-gnu- --prefix=/usr/aarch64-linux-gnu && \
    make && make install
cd .. && rm -rf "$OPENSSL_TAG"

# Build libpq
git clone https://github.com/postgres/postgres.git --depth 1 --branch REL_14_2
cd postgres && \
    CC=aarch64-linux-gnu-gcc CXX=aarch64-linux-gnu-g++ AR=aarch64-linux-gnu-ar RANLIB=aarch64-linux-gnu-ranlib; \
    ./configure --host=aarch64-linux-gnu --prefix=/usr/aarch64-linux-gnu --without-zlib --without-readline && \
    cd src/interfaces/libpq && make install && \
    cd ../../bin/pg_config && make && make install

cd .. && rm -rf postgres

rm -rf /tmp/*
