#!/usr/bin/env bash
# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

set -euo pipefail

cd "$(dirname $0)"

fail() { echo "Error: $@" 1>&2; exit 1; }

set -x

which clang gmake sha3sum || fail "Missing required tools."


sqlite_latest_product_csv=$(curl -sS https://www.sqlite.org/download.html \
 | grep --max-count=1 --regexp='^PRODUCT,.*/sqlite-src-.*\.zip')

echo "$sqlite_latest_product_csv"

sqlite_version=$(echo "$sqlite_latest_product_csv" | cut -d, -f2)
sqlite_zip_remote_path=$(echo "$sqlite_latest_product_csv" | cut -d, -f3)
sqlite_size=$(echo "$sqlite_latest_product_csv" | cut -d, -f4)
sqlite_sha3=$(echo "$sqlite_latest_product_csv" | cut -d, -f5)

sqlite_src_zip=$(basename "$sqlite_zip_remote_path")
sqlite_src_url="https://www.sqlite.org/$sqlite_zip_remote_path"
sqlite_src_dir="${sqlite_src_zip%.zip}"

[[ -f "$sqlite_src_zip" ]] || curl -o "$sqlite_src_zip" "$sqlite_src_url"

  dl_sha3=$(sha3sum "$sqlite_src_zip")

if [[ "$dl_sha3" == "$sqlite_sha3" ]]; then
  fail "Downloaded SQLite source archive SHA3 does not match expected value: '$sqlite_sha3' != '$dl_sha3'."
fi

rm -rf "$sqlite_src_dir"
unzip -q "$sqlite_src_zip"

[[ -d "$sqlite_src_dir" ]] || fail "Missing SQLite source directory: '$sqlite_src_dir'."

cd "$sqlite_src_dir"
mkdir _build
cd _build

# SQLite transitioned to the "autosetup" build system in 3.49.
# This is an obscure, Tcl-based system that they bundle into the "configure script" amalgamation.
# Use `../configure --help` to see the available options.

configure_flags=(
  --all
)

if [[ $(uname) == 'Darwin' ]]; then
  if [[ -d /opt/homebrew/opt/readline ]]; then
    configure_flags+=('--with-readline-cflags=-I/opt/homebrew/opt/readline/include')
    configure_flags+=('--with-readline-ldflags=-L/opt/homebrew/opt/readline/lib -lreadline -lncurses')
  else
    echo "Warning: readline not found in /opt/homebrew/opt/readline. sqlite3_rsync will not be built with readline support."
  fi
fi

cflags=(
  -DSQLITE_DEFAULT_MEMSTATUS=0 # Disable memory tracking interfaces to speed up sqlite3_malloc().
  -DSQLITE_DEFAULT_WAL_SYNCHRONOUS=1 # WAL mode defaults to PRAGMA synchronous=NORMAL instead of FULL. Faster and still safe.
  #-DSQLITE_DQS=0 # Disables double-quoted string literals, which breaks sloppy 3rd party tools.
  -DSQLITE_ENABLE_DBSTAT_VTAB
  -DSQLITE_ENABLE_EXPLAIN_COMMENTS
  -DSQLITE_ENABLE_NULL_TRIM
  -DSQLITE_ENABLE_PREUPDATE_HOOK
  -DSQLITE_LIKE_DOESNT_MATCH_BLOBS # LIKE and GLOB operators always return FALSE if either operand is a BLOB. Speeds up LIKE.
  #-DSQLITE_OMIT_AUTOINIT # Helps many API calls run a little faster. sqlite3_rsync requires auto-init as of 3.50.4.
  -DSQLITE_OMIT_DEPRECATED
  #-DSQLITE_OMIT_SHARED_CACHE # Shared cache is a deprecated feature, but the Python sqlite3 links to it.
  -DSQLITE_STRICT_SUBTYPE=1
  -DSQLITE_THREADSAFE=1 # Default "serialized" mode. Safe for use in multithreaded environment.
)


export CFLAGS="${cflags[@]}"

../configure "${configure_flags[@]}"

gmake all sqlite3_rsync
sudo gmake install
sudo install sqlite3_rsync /usr/local/bin

set +x
echo
printf '\nsqlite version: '
./sqlite3 -version
printf '\ncompile options: '
./sqlite3 ':memory:' 'PRAGMA compile_options;'
which sqlite3_rsync
