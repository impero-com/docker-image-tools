#!/bin/bash
set -eu

build-image() {
    docker build --rm -f Dockerfile -t imperocom/image-tools .
}

build-arch() {
    local ARCH="$1"
    local SHORT_ARCH="$2"
    local INSTANCE=$(uuidgen)

    if [ $( docker ps -a | grep "builder-$INSTANCE" | wc -l ) -gt 0 ]; then
        echo "builder-$INSTANCE already exists"
        return 1
    fi

    docker run -i --name "builder-$INSTANCE" imperocom/image-tools /scripts/image/build-arch.sh "$ARCH" "$SHORT_ARCH"

    if [ $( docker ps -a | grep "builder-$INSTANCE" | wc -l ) -le 0 ]; then
        echo "builder-$INSTANCE does not exist"
        return 1
    fi

    mkdir "/tmp/builder-$INSTANCE"

    docker cp "builder-$INSTANCE:/export/$ARCH" "/tmp/builder-$INSTANCE/$SHORT_ARCH"

    docker rm -f "builder-$INSTANCE"

    cd "/tmp/builder-$INSTANCE"
    for f in sccache diesel diesel_ext cargo-audit cargo-watch cargo-dylint dylint-link penguin
    do
        echo "Checking $f"
        test -f "$SHORT_ARCH/$f"
        if [ $(uname -m) = "$SHORT_ARCH" ]
        then
            # RUSTUP_TOOLCHAIN for dylint-link
            RUSTUP_TOOLCHAIN="stable" "$SHORT_ARCH/$f" --help
        else
            test -x "$SHORT_ARCH/$f"
        fi
    done
    zip -r "$SHORT_ARCH.zip" "$SHORT_ARCH"
    cd -

    cp "/tmp/builder-$INSTANCE/$SHORT_ARCH.zip" .

    rm -rf "/tmp/builder-$INSTANCE"
}

build-image
build-arch x86_64-unknown-linux-gnu x86_64
build-arch aarch64-unknown-linux-gnu aarch64

