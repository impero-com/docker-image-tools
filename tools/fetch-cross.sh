#!/bin/sh

set -eu

NAME="cross"
REPO="rust-embedded"
VERSION="v0.1.16"
TARGET="x86_64-unknown-linux-musl"
FORMAT=".tar.gz"

URL=https://github.com/$REPO/$NAME/releases/download/$VERSION/$NAME-$VERSION-$TARGET$FORMAT

curl --location $URL | tar xz
chmod +x $NAME
mv $NAME tools/bin/x86_64/
