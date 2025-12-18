#!/usr/bin/env bash
# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

set -euo pipefail

cd "$(dirname $0)"

fail() { echo "Error: $@" 1>&2; exit 1; }

set -x

py_version="3.14"
py_point_version="3.14.2"
python_xz="Python-$py_point_version.tar.xz"
python_src_url="https://www.python.org/ftp/python/$py_point_version/$python_xz"
python_src_dir="Python-$py_point_version"


[[ -f "$python_xz" ]] || curl -O "$python_src_url"

sudo rm -rf "$python_src_dir"
tar --xz -xf $python_xz

[[ -d "$python_src_dir" ]] || fail "Missing Python source directory: $python_src_dir."

cd "$python_src_dir"
mkdir _build
cd _build

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export CFLAGS='-I/usr/local/include'
export LDFLAGS='-L/usr/local/lib -Wl,-rpath,/usr/local/lib'
export CC=clang
export CXX=clang++
export LD=clang

time ../configure \
  --with-pkg-config=yes \
  --enable-loadable-sqlite-extensions \
  --enable-optimizations \
  --with-lto \
  --with-computed-gotos \
  --with-sqlite3

# Note: we explicitly specify computed gotos so that if the compiler does not support them, the build will fail.
# Doing so also makes it more obvious from sysconfig results that computed gotos are enabled.
# We explicitly specify sqlite3 so that the build will fail if it is not found.

parallel=-j$(nproc)
time make $parallel
sudo time make $parallel install

(cd /usr/local/bin && sudo ln -sf python${py_version} python)
(cd /usr/local/bin && sudo ln -sf pip${py_version} pip)
hash -r # Make sure the new python is available.

# Set site packages to group-writable so that operator can run pip without sudo which causes warnings.
sudo chmod -R g+w /usr/local/lib/python${py_version}/site-packages
sudo chmod g+w /usr/local/bin
pip install -U pip
