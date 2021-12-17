#!/bin/bash
set -eu

cargo install sccache --version 0.2.15 --no-default-features --target "$1"
cargo install diesel_cli --version 1.4.1 --no-default-features --features postgres --target "$1"
cargo install diesel_cli_ext --version 0.3.6 --target "$1"
cargo install cargo-audit --version 0.15.0 --features vendored-openssl --target "$1"
cargo install cargo-watch --version 8.1.1 --target "$1"
