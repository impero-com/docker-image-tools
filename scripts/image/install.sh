#!/bin/bash
set -eu

CROSS_ARM_SHORT="arm64"
CROSS_ARM_LONG="aarch64"

CROSS_X86_SHORT="amd64"
CROSS_X86_LONG="x86_64"

NATIVE_ARCH="$(uname -m)"

# Depending whether we are building it on host amd64 or arm64, we need to install 
# the cross-compilation tools for the other architecture.
if [ "$NATIVE_ARCH" = "$CROSS_ARM_LONG" ]; then
    CROSS_ARCH_SHORT="$CROSS_X86_SHORT"
    CROSS_ARCH_LONG="$CROSS_X86_LONG"
else
    CROSS_ARCH_SHORT="$CROSS_ARM_SHORT"
    CROSS_ARCH_LONG="$CROSS_ARM_LONG"
fi

echo "Building on $NATIVE_ARCH, also crosscompiling for $CROSS_ARCH_SHORT"

apt-get install -qq \
    "crossbuild-essential-${CROSS_ARCH_SHORT}" \
    "libc6-${CROSS_ARCH_SHORT}-cross" \
    "libc6-dev-${CROSS_ARCH_SHORT}-cross"

# Build libssl
OPENSSL_TAG=openssl-3.0.2
git clone https://github.com/openssl/openssl.git --depth 1 --tag "$OPENSSL_TAG"
cd "$OPENSSL_TAG" && \
    ./Configure "linux-${CROSS_ARCH_LONG}" "--cross-compile-prefix=${CROSS_ARCH_LONG}-linux-gnu-" "--prefix=/usr/${CROSS_ARCH_LONG}-linux-gnu" && \
    make && make install
cd .. && rm -rf "$OPENSSL_TAG"

# Build libpq
git clone https://github.com/postgres/postgres.git --depth 1 --branch REL_14_2
cd postgres && \
    CC="${CROSS_ARCH_LONG}-linux-gnu-gcc" CXX="${CROSS_ARCH_LONG}-linux-gnu-g++" AR="${CROSS_ARCH_LONG}-linux-gnu-ar" RANLIB="${CROSS_ARCH_LONG}-linux-gnu-ranlib"; \
    ./configure "--host=${CROSS_ARCH_LONG}-linux-gnu" "--prefix=/usr/${CROSS_ARCH_LONG}-linux-gnu" --without-zlib --without-readline && \
    cd src/interfaces/libpq && make install && \
    cd ../../bin/pg_config && make && make install

cd .. && rm -rf postgres

rm -rf /tmp/*
