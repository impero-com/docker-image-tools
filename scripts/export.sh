#!/bin/bash
set -eu

mkdir -p $1
cp $CARGO_HOME/bin/sccache $1/
cp $CARGO_HOME/bin/diesel $1/
cp $CARGO_HOME/bin/diesel_ext $1/
cp $CARGO_HOME/bin/cargo-audit $1/
cp $CARGO_HOME/bin/cargo-watch $1/
