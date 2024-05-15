#!/bin/bash

set -e

CHROMIUM_REVISION=753e7b2b7bf245f30c0610559497d72c423ed95d
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CLANG_DIR=$ROOT_DIR/third_party/llvm-build/Release+Asserts

tempfile=$(mktemp)
trap "rm -f $tempfile" EXIT

curl -o "$tempfile" -L https://raw.githubusercontent.com/chromium/chromium/$CHROMIUM_REVISION/tools/clang/scripts/update.py

python3 "$tempfile" --output-dir=$CLANG_DIR
echo "Clang downloaded to $CLANG_DIR"
