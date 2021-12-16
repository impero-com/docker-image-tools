#!/bin/bash
set -eu

case "$1" in
    aarch64-unknown-linux-gnu)
        if [[ "$(uname -m)" == "aarch64" ]]; then
            echo "Native target - skipping install"
            exit 0
        fi

        apt-get install -qq \
            crossbuild-essential-arm64 \
            libc6-arm64-cross \
            libc6-dev-arm64-cross \
            pkg-config-aarch64-linux-gnu

        export PKG_CONFIG_aarch64_unknown_linux_gnu=/usr/bin/aarch64-linux-gnu-pkg-config
        export PKG_CONFIG_PATH_aarch64_unknown_linux_gnu=/usr/bin/aarch64-linux-gnu-pkg-config

        # Build libssl
        git clone https://github.com/openssl/openssl.git --depth 1
        cd openssl && \
            ./Configure linux-arm64 --cross-compile-prefix=arm64-linux-gnu- --prefix=/usr/arm64-linux-gnu && \
            make
        cd .. && rm -rf openssl

        # Build libpq
        git clone https://github.com/postgres/postgres.git --depth 1
        cd postgres && \
            CC=arm64-linux-gnu-gcc CXX=arm64-linux-gnu-g++ AR=arm64-linux-gnu-ar RANLIB=arm64-linux-gnu-ranlib; \
            ./configure --host=arm64-linux-gnu --prefix=/usr/arm64-linux-gnu --without-zlib --without-readline && \
            cd src/interfaces/libpq && make install && \
            cd ../../bin/pg_config && make && make install

        cd .. && rm -rf postgres

        rm -rf /tmp
        ;;
    x86_64-unknown-linux-gnu)
        if [[ "$(uname -m)" == "x86_64" ]]; then
            echo "Native target - skipping install"
            exit 0
        fi
        apt-get install -qq \
            crossbuild-essential-amd64 \
            libc6-amd64-cross \
            libc6-dev-amd64-cross \
            pkg-config-x86-64-linux-gnu

        export PKG_CONFIG_x86_64_unknown_linux_gnu=/usr/bin/x86_64-linux-gnu-pkg-config
        export PKG_CONFIG_PATH_x86_64_unknown_linux_gnu=/usr/bin/x86_64-linux-gnu-pkg-config

        # Build libssl
        git clone https://github.com/openssl/openssl.git --depth 1
        cd openssl && \
            ./Configure linux-x86_64 --cross-compile-prefix=x86_64-linux-gnu- --prefix=/usr/x86_64-linux-gnu && \
            make
        cd .. && rm -rf openssl

        # Build libpq
        git clone https://github.com/postgres/postgres.git --depth 1
        cd postgres && \
            CC=x86_64-linux-gnu-gcc CXX=x86_64-linux-gnu-g++ AR=x86_64-linux-gnu-ar RANLIB=x86_64-linux-gnu-ranlib; \
            ./configure --host=x86_64-linux-gnu --prefix=/usr/x86_64-linux-gnu --without-zlib --without-readline && \
            cd src/interfaces/libpq && make install && \
            cd ../../bin/pg_config && make && make install
        cd .. && rm -rf postgres

        rm -rf /tmp
        ;;
    *)
        echo "Unsupported target: $1"
        exit 1
        ;;
esac
