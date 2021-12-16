#!/bin/bash
set -eu

scripts/docker/build.sh aarch64-unknown-linux-gnu
scripts/docker/export.sh /tools/aarch64
