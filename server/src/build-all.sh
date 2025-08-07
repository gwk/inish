#!/usr/bin/env bash
# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

set -euo pipefail

./build-sqlite.sh
./build-python.sh
./build-litestream.sh
