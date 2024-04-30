#!/bin/bash
set -eu

export PKG_CONFIG_SYSROOT_DIR=/usr/aarch64-linux-gnu

cargo install sccache --version 0.8.0 --no-default-features --target "$1"
printf "\n"
cargo install diesel_cli --version 1.4.1 --no-default-features --features postgres --target "$1"
printf "\n"
cargo install diesel_cli_ext --version 0.3.6 --target "$1"
printf "\n"
cargo install cargo-audit --version 0.20.0 --target "$1"
printf "\n"
cargo install cargo-watch --version 8.5.2 --target "$1"
printf "\n"
# For doing live reload of documentation
cargo install penguin-app --version 0.2.6 --target "$1"
printf "\n"

echo "Copying files to /export/$1"
mkdir -p /export/$1
cp $CARGO_HOME/bin/sccache /export/$1/
cp $CARGO_HOME/bin/diesel /export/$1/
cp $CARGO_HOME/bin/diesel_ext /export/$1/
cp $CARGO_HOME/bin/cargo-audit /export/$1/
cp $CARGO_HOME/bin/cargo-watch /export/$1/
cp $CARGO_HOME/bin/penguin /export/$1/
