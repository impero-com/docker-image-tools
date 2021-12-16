#!/bin/bash
set -eu

scripts/docker/build.sh x86_64-unknown-linux-gnu
scripts/docker/export.sh /tools/x86_64
