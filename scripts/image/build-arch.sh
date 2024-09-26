#!/bin/bash
set -eu

export PKG_CONFIG_SYSROOT_DIR="/usr/${2}-linux-gnu"
export RUSTFLAGS="-C linker=${2}-linux-gnu-gcc"
export HOST_CC=gcc

# We have to point directly to the right cross compilation tools, becuase cargo
# isnt smart enough to choose them automatically
export CC_x86_64_unknown_linux_gnu=/usr/bin/x86_64-linux-gnu-gcc
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=/usr/bin/x86_64-linux-gnu-gcc
export CC_aarch64_unknown_linux_gnu=/usr/bin/aarch64-linux-gnu-gcc
export CARGO_TARGET_AARCH_64_UNKNOWN_LINUX_GNU_LINKER=/usr/bin/aarch64-linux-gnu-gcc

echo "building '$1'"

cargo install sccache --version 0.8.0 --no-default-features --target "$1"
printf "\n"
cargo install diesel_cli --version 2.2.4 --no-default-features --features postgres --target "$1"
printf "\n"
cargo install diesel_cli_ext --version 0.3.14 --target "$1"
printf "\n"
cargo install cargo-audit --version 0.20.0 --target "$1"
printf "\n"
cargo install cargo-watch --version 8.5.2 --target "$1"
printf "\n"
cargo install cargo-dylint --version 3.1.0 --target "$1"
printf "\n"
cargo install dylint-link --version 3.1.0 --target "$1"
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
cp $CARGO_HOME/bin/cargo-dylint /export/$1/
cp $CARGO_HOME/bin/dylint-link /export/$1/
cp $CARGO_HOME/bin/penguin /export/$1/
