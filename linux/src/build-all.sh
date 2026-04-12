#!/usr/bin/env bash
# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

set -euo pipefail

cd "$(dirname $0)../.."

common/build-sqlite.sh
linux/src/build-python.sh
linux/src/build-litestream.sh
