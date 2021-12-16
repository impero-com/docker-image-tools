#!/bin/bash
set -eu

scripts/docker/build.sh "$1-unknown-linux-gnu"
scripts/docker/export.sh "/tools/$1"
