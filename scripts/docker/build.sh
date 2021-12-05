#!/bin/bash
set -eu

mkdir -p $2
cargo install sccache --no-default-features --target "$1"
cargo install diesel_cli --version 1.4.1 --no-default-features --features postgres --target "$1"
cargo install diesel_cli_ext --version 0.3.6 --target "$1"
cargo install cargo-audit --version 0.15.0 --features vendored-openssl --target "$1"
mv $CARGO_HOME/bin/sccache $2/
mv $CARGO_HOME/bin/diesel $2/
mv $CARGO_HOME/bin/diesel_ext $2/
mv $CARGO_HOME/bin/cargo-audit $2/
