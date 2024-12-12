#!/usr/bin/env bash

set -ex

src_dir=$(dirname $0)
cd "$src_dir"

if ! test -f litestream-main.zip; then
  curl -L -o litestream-main.zip https://github.com/benbjohnson/litestream/archive/refs/heads/main.zip
fi

rm -rf litestream-main/
unzip litestream-main.zip
cd litestream-main

go build ./cmd/litestream
sudo install litestream /usr/local/bin
