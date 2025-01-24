#! /bin/bash
# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

set -euo pipefail
set -x

fail() { echo "Error: $@" 1>&2; exit 1; }

src_dir=$(dirname $0)
cd "$src_dir"

sqlite_latest_product_csv=$(curl -sS https://www.sqlite.org/download.html \
 | grep --max-count=1 --regexp='^PRODUCT,.*/sqlite-autoconf-.*\.tar\.gz')

echo "$sqlite_latest_product_csv"

sqlite_version=$(echo "$sqlite_latest_product_csv" | cut -d, -f2)
sqlite_gz_remote_path=$(echo "$sqlite_latest_product_csv" | cut -d, -f3)
sqlite_size=$(echo "$sqlite_latest_product_csv" | cut -d, -f4)
sqlite_sha3=$(echo "$sqlite_latest_product_csv" | cut -d, -f5)

sqlite_src_gz=$(basename "$sqlite_gz_remote_path")
sqlite_src_url="https://www.sqlite.org/$sqlite_gz_remote_path"
sqlite_src_dir="${sqlite_src_gz%.tar.gz}"

[[ -f "$sqlite_src_gz" ]] || curl -o "$sqlite_src_gz" "$sqlite_src_url"

rm -rf "$sqlite_src_dir"
tar -xzf "$sqlite_src_gz"

[[ -d "$sqlite_src_dir" ]] || fail "Missing SQLite source directory: '$sqlite_src_dir'."

cd "$sqlite_src_dir"
mkdir _build
cd _build

cflags=(
  -DSQLITE_DEFAULT_MEMSTATUS=0 # Disable memory tracking interfaces to speed up sqlite3_malloc().
  -DSQLITE_DEFAULT_WAL_SYNCHRONOUS=1 # WAL mode defaults to PRAGMA synchronous=NORMAL instead of FULL. Faster and still safe.
  #-DSQLITE_DQS=0 # Disables double-quoted string literals, which breaks sloppy 3rd party tools.
  -DSQLITE_ENABLE_DBSTAT_VTAB
  -DSQLITE_ENABLE_EXPLAIN_COMMENTS
  -DSQLITE_ENABLE_FTS5
  -DSQLITE_ENABLE_GEOPOLY
  -DSQLITE_ENABLE_NULL_TRIM
  -DSQLITE_ENABLE_PREUPDATE_HOOK
  -DSQLITE_ENABLE_RBU
  -DSQLITE_ENABLE_RTREE
  -DSQLITE_ENABLE_SESSION
  -DSQLITE_LIKE_DOESNT_MATCH_BLOBS # LIKE and GLOB operators always return FALSE if either operand is a BLOB. Speeds up LIKE.
  -DSQLITE_OMIT_AUTOINIT # Helps many API calls run a little faster.
  -DSQLITE_OMIT_DEPRECATED
  #-DSQLITE_OMIT_SHARED_CACHE # Shared cache is a deprecated feature, but the Python sqlite3 links to it.
  -DSQLITE_STRICT_SUBTYPE=1
  -DSQLITE_THREADSAFE=1 # Default "serialized" mode. Safe for use in multithreaded environment.
  -I/opt/homebrew/opt/readline/include
  -Os
)

export CFLAGS="${cflags[@]}"

../configure
make
sudo make install


# PRODUCT,3.47.1,2024/sqlite-autoconf-3470100.tar.gz,3328564,c6c1756fbeb1e34e0ee31f8609bfc1fd4630b3faadde71a28ad3a55df259d854
