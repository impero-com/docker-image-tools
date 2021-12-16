#!/bin/bash
set -eu

mkdir -p $2
cp $CARGO_HOME/bin/sccache $2/
cp $CARGO_HOME/bin/diesel $2/
cp $CARGO_HOME/bin/diesel_ext $2/
cp $CARGO_HOME/bin/cargo-audit $2/
cp $CARGO_HOME/bin/cargo-watch $2/
