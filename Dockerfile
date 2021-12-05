FROM ubuntu:21.04

ARG TOOLCHAIN=nightly

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    curl \
    git \
    make \
    bison \
    flex \
    libssl-dev \
    libpq-dev

# Set up Rust
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN curl https://sh.rustup.rs -sSf | sh -s -- \
    --profile minimal --default-toolchain "$TOOLCHAIN" -y && \
    rustup --version && \
    cargo --version && \
    rustc --version && \
    rustup target add x86_64-unknown-linux-gnu && \
    rustup target add aarch64-unknown-linux-gnu

# Set up cross compilation environment
COPY cargo/. /cargo
RUN cp /cargo/$(uname -m)/* $CARGO_HOME/ && ls -lh $CARGO_HOME && rm -r /cargo

COPY scripts/docker/ scripts/
RUN scripts/install.sh x86_64-unknown-linux-gnu
RUN scripts/install.sh aarch64-unknown-linux-gnu