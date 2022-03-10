#!/bin/bash
set -eu

apt-get install -qq \
    crossbuild-essential-arm64 \
    libc6-arm64-cross \
    libc6-dev-arm64-cross \
    pkg-config-aarch64-linux-gnu

export PKG_CONFIG_aarch64_unknown_linux_gnu=/usr/bin/aarch64-linux-gnu-pkg-config
export PKG_CONFIG_PATH_aarch64_unknown_linux_gnu=/usr/bin/aarch64-linux-gnu-pkg-config
export PKG_CONFIG_SYSROOT_DIR=/usr/aarch64-linux-gnu

# Build libssl
git clone https://github.com/openssl/openssl.git --depth 1 --branch OpenSSL_1_1_1m
cd openssl && \
    ./Configure linux-arm64 --cross-compile-prefix=aarch64-linux-gnu- --prefix=/usr/aarch64-linux-gnu && \
    make
cd .. && rm -rf openssl

# Build libpq
git clone https://github.com/postgres/postgres.git --depth 1 --branch REL_14_2
cd postgres && \
    CC=aarch64-linux-gnu-gcc CXX=aarch64-linux-gnu-g++ AR=aarch64-linux-gnu-ar RANLIB=aarch64-linux-gnu-ranlib; \
    ./configure --host=aarch64-linux-gnu --prefix=/usr/aarch64-linux-gnu --without-zlib --without-readline && \
    cd src/interfaces/libpq && make install && \
    cd ../../bin/pg_config && make && make install

cd .. && rm -rf postgres

rm -rf /tmp/*
