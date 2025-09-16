#!/usr/bin/env bash
# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

set -euo pipefail

function fail() { echo "$1" >&2; exit 1; }

src_dir=$(dirname $0)
cd "$src_dir"

machine_arch=$(uname -m)

case "${machine_arch}" in
  "x86_64"|"amd64")
    vector_arch="x86_64" ;;
  "aarch64"|"arm64")
    vector_arch="aarch64" ;;
  *)
    fail "Unsupported architecture: ${machine_arch}" ;;
esac

set -x

mkdir -p download
cd download
rm -f vector*.tar.gz

# TODO: support platforms other than Linux.

python3 -m inish.github download-release vectordotdev/vector -name 'v\d+\.\d+\.\d+' -assets "$vector_arch-unknown-linux-gnu\.tar\.gz"

vector_dl_name=$(ls vector*.tar.gz)
[[ -n "$vector_dl_name" ]] || fail "No vector archive found."

tar -xzf "${vector_dl_name}"

vector_dl_dir="vector-${vector_arch}-unknown-linux-gnu"
sudo install "${vector_dl_dir}/bin/vector" /usr/local/bin
