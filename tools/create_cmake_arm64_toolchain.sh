#!/bin/bash

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

SYSROOT="$ROOT_DIR/sysroots/debian_bullseye_arm64-sysroot"
CLANG_DIR="$ROOT_DIR/third_party/llvm-build/Release+Asserts"
PKGCONF_BIN="$ROOT_DIR/tools/pkgconf/bin/pkgconf"

TOOLCHAIN_FILE="$SYSROOT/cmake-toolchain.cmake"


cat > "$TOOLCHAIN_FILE" <<EOF
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_SYSROOT "$SYSROOT")

set(CMAKE_C_COMPILER "$CLANG_DIR/bin/clang")
set(CMAKE_CXX_COMPILER "$CLANG_DIR/bin/clang++")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

add_compile_options(--target=aarch64-linux-gnu)
add_link_options(--target=aarch64-linux-gnu -fuse-ld=lld)

set(ENV{PKG_CONFIG} "$PKGCONF_BIN")
set(ENV{PKG_CONFIG_SYSROOT_DIR} "$SYSROOT")
set(ENV{PKG_CONFIG_PATH} "$SYSROOT/usr/lib/pkgconfig:$SYSROOT/usr/share/pkgconfig:$SYSROOT/usr/lib/aarch64-linux-gnu/pkgconfig")
EOF
