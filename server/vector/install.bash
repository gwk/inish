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
    vector_arch="arm64" ;;
  *)
    fail "Unsupported architecture: ${machine_arch}" ;;
esac

set -x

vector_v_version=$(curl -s https://api.github.com/repos/vectordotdev/vector/releases/latest | jq -r '.tag_name')
vector_version=${vector_v_version#v} # Remove "v" prefix.

vector_dl_name="vector-${vector_version}-${vector_arch}-unknown-linux-gnu.tar.gz"
vector_dl_url="https://github.com/vectordotdev/vector/releases/download/${vector_v_version}/${vector_dl_name}"
# https://github.com/vectordotdev/vector/releases/download/v0.49.0/vector-0.49.0-x86_64-unknown-linux-gnu.tar.gz

vector_dl_dir="vector-${vector_arch}-unknown-linux-gnu"
#^ Note that the decompressed directory name does not contain the version number.

mkdir -p download
rm -rf "download/${vector_dl_dir}"

if ! test -f "download/${vector_dl_name}"; then
  curl -L -o "download/${vector_dl_name}" "${vector_dl_url}"
fi

tar -xzf "download/${vector_dl_name}" -C download

sudo install "download/${vector_dl_dir}/bin/vector" /usr/local/bin
