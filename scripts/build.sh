#!/bin/bash
set -eu

export PKG_CONFIG_aarch64_unknown_linux_gnu=/usr/bin/aarch64-linux-gnu-pkg-config
export PKG_CONFIG_PATH_aarch64_unknown_linux_gnu=/usr/bin/aarch64-linux-gnu-pkg-config
export PKG_CONFIG_SYSROOT_DIR=/usr/aarch64-linux-gnu

cargo install sccache --version 0.2.15 --no-default-features --target "$1"
printf "\n"
cargo install diesel_cli --version 1.4.1 --no-default-features --features postgres --target "$1"
printf "\n"
cargo install diesel_cli_ext --version 0.3.6 --target "$1"
printf "\n"
cargo install cargo-audit --version 0.15.0 --features vendored-openssl --target "$1"
printf "\n"
cargo install cargo-watch --version 8.1.1 --target "$1"
printf "\n"
# For doing live reload of documentation
git clone https://github.com/philipahlberg/penguin --depth 1 && \
    cd penguin && \
    cargo install --path app --features vendored-openssl --target "$1" && \
    cd .. && \
    rm -rf ./penguin
printf "\n"

echo "Copying files to /export/$1"
mkdir -p /export/$1
cp $CARGO_HOME/bin/sccache /export/$1/
cp $CARGO_HOME/bin/diesel /export/$1/
cp $CARGO_HOME/bin/diesel_ext /export/$1/
cp $CARGO_HOME/bin/cargo-audit /export/$1/
cp $CARGO_HOME/bin/cargo-watch /export/$1/
cp $CARGO_HOME/bin/penguin /export/$1/
