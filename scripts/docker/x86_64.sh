#!/bin/bash
set -eu

scripts/build.sh x86_64-unknown-linux-gnu
scripts/export.sh /tools/x86_64
