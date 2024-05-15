#!/bin/bash

set -ex

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
INSTALL_DIR="$ROOT_DIR/tools/pkgconf"

tempdir=$(mktemp -d)
trap "rm -rf $tempdir" EXIT

cd "$tempdir"
git clone --depth 1 --branch pkgconf-2.2.0 https://github.com/pkgconf/pkgconf .
meson setup build --prefix=$(pwd) -Ddefault_library=static
ninja -C build install
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/bin"
install -m 755 bin/pkgconf "$INSTALL_DIR/bin/pkgconf"
