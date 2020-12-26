#!/bin/bash

# Install gcc, python
apt update
apt install -y --no-install-recommends \
            build-essential \
            python3-dev \
            xz-utils
rm -rf /var/lib/apt/lists/*

# Install clang
cd ~
curl -OL https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz && \
llvm="clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-20.04"
tar xf ~/${llvm}.tar.xz && \
cd ~/${llvm} && \
sudo cp -r * /usr/local &&

rm ~/${llvm}.tar.xz
rm -r ~/${llvm}
