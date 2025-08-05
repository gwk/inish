#!/usr/bin/env bash

set -euo pipefail
set -x

src_dir=$(dirname $0)
cd "$src_dir"

litestream_commit="af076fc9f08ee5c81f9fc8d03c2df76dd2336eb4"
litestream_dir=litestream-$litestream_commit
litestream_zip=$litestream_dir.zip
if ! test -f $litestream_zip; then
  curl -L -o $litestream_zip "https://github.com/benbjohnson/litestream/archive/$litestream_commit.zip"
fi

rm -rf $litestream_dir
unzip -q $litestream_zip
cd $litestream_dir

go build ./cmd/litestream
sudo install litestream /usr/local/bin
