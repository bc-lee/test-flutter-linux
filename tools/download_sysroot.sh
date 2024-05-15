#!/bin/bash

set -xe

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
SYSROOTS_JSON="$ROOT_DIR/tools/sysroots.json"

error() {
  echo "$1" >&2
  exit 1
}

arch="$1"

if [[ -z "$arch" ]]; then
  echo "Usage: $0 <arch>"
  exit 1
fi

if [[ "$arch" != "amd64" ]] && [[ "$arch" != "arm64" ]]; then
  error "Invalid architecture: $arch. Supported architectures: amd64, arm64"
fi

jq --version > /dev/null || error "jq is required to parse JSON files. Please install it."

sysroot_name="debian_bullseye_${arch}-sysroot"

bucket_name=$(jq -r ".sysroots[] | select(.name == \"$sysroot_name\").bucket" "$SYSROOTS_JSON")
object_name=$(jq -r ".sysroots[] | select(.name == \"$sysroot_name\").object_name" "$SYSROOTS_JSON")
sha256=$(jq -r ".sysroots[] | select(.name == \"$sysroot_name\").sha256" "$SYSROOTS_JSON")
size_in_bytes=$(jq -r ".sysroots[] | select(.name == \"$sysroot_name\").size_bytes" "$SYSROOTS_JSON")

# Download the sysroot tarball.

sysroot_dir="$ROOT_DIR/sysroots/$sysroot_name"
sysroot_tarball="$sysroot_dir/sysroot.tar.xz"

mkdir -p "$sysroot_dir"
curl -o "$sysroot_tarball" -L "https://storage.googleapis.com/$bucket_name/$object_name"
trap "rm -f $sysroot_tarball" EXIT

echo "$sha256 $sysroot_tarball" | sha256sum --check || error "SHA-256 hash mismatch"
actual_size_in_bytes=$(stat --format=%s "$sysroot_tarball")
if [[ "$actual_size_in_bytes" -ne "$size_in_bytes" ]]; then
  error "Size mismatch: expected $size_in_bytes bytes, got $actual_size_in_bytes bytes"
fi

tar -C "$sysroot_dir" -xf "$sysroot_tarball"

echo "Sysroot extracted to $sysroot_dir"
