FROM ubuntu:22.04

ARG TOOLCHAIN=stable
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    curl \
    git \
    make \
    bison \
    flex \
    pkg-config \
    libssl-dev \
    libpq-dev

# Set up Rust
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN curl https://sh.rustup.rs -sSf | sh -s -- \
    --profile minimal --default-toolchain "$TOOLCHAIN" -y && \
    rustup target add aarch64-unknown-linux-gnu && \
    rustup target add x86_64-unknown-linux-gnu

RUN rustup --version && \
    cargo --version && \
    rustc --version

# Set up cross compilation environment
COPY .cargo /.cargo
RUN cp /.cargo/* $CARGO_HOME/ && rm -rf /.cargo

COPY scripts/ scripts/
RUN scripts/image/install.sh
