#!/usr/bin/env bash

set -euo pipefail

function fail() { echo "Error: $@" >&2; exit 1; }

src_dir=$(dirname $0)
cd "$src_dir"

machine_arch=$(uname -m)

case "${machine_arch}" in
  "x86_64"|"amd64")
    caddy_arch="amd64" ;;
  "aarch64"|"arm64")
    caddy_arch="arm64" ;;
  *)
    fail "Unsupported architecture: ${machine_arch}" ;;
esac

set -x

caddy_v_version=$(curl -s https://api.github.com/repos/caddyserver/caddy/releases/latest | jq -r '.tag_name')
caddy_version=${caddy_v_version#v} # Remove "v" prefix.

caddy_dl_dir="caddy_${caddy_version}_linux_${caddy_arch}"
caddy_dl_name="${caddy_dl_dir}.tar.gz"
caddy_dl_url="https://github.com/caddyserver/caddy/releases/download/${caddy_v_version}/${caddy_dl_name}"

mkdir -p download
rm -rf download/*

if ! test -f "download/${caddy_dl_name}"; then
  curl -L -o "download/${caddy_dl_name}" "${caddy_dl_url}"
fi

tar -xzf "download/${caddy_dl_name}" -C download

sudo install "download/caddy" /usr/local/bin
