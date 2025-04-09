set -euo pipefail

./build-sqlite.sh
./build-python.sh
./build-litestream.sh
