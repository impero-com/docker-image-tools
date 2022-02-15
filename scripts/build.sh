#!/bin/bash
set -eu

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

echo "Copying files to /export/$1"
mkdir -p /export/$1
cp $CARGO_HOME/bin/sccache /export/$1/
cp $CARGO_HOME/bin/diesel /export/$1/
cp $CARGO_HOME/bin/diesel_ext /export/$1/
cp $CARGO_HOME/bin/cargo-audit /export/$1/
cp $CARGO_HOME/bin/cargo-watch /export/$1/
