#!/bin/bash
set -eu

scripts/build.sh aarch64-unknown-linux-gnu
scripts/export.sh /tools/aarch64
