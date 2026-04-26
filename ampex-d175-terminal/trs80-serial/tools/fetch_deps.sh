#!/usr/bin/env bash
# Fetch build dependencies for trs80-serial.
#
#   vendor/sdltrs/                          -- jengun/sdltrs source tree
#   third_party/SDL2-2.30.11/               -- SDL2 mingw devel (Windows cross-build)
#
# System packages still required separately (apt install on Debian/Ubuntu):
#   build-essential pkg-config libsdl2-dev          # native build
#   gcc-mingw-w64-x86-64                            # 'make win' cross-build
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SDLTRS_REF="${SDLTRS_REF:-master}"
SDLTRS_TARBALL="https://gitlab.com/jengun/sdltrs/-/archive/${SDLTRS_REF}/sdltrs-${SDLTRS_REF}.tar.gz"

SDL2_VERSION="2.30.11"
SDL2_TARBALL="https://github.com/libsdl-org/SDL/releases/download/release-${SDL2_VERSION}/SDL2-devel-${SDL2_VERSION}-mingw.tar.gz"

fetch() {
    local url="$1" out="$2"
    echo ">> downloading $url"
    curl -fL --retry 3 --retry-delay 2 -o "$out" "$url"
}

# ---- sdltrs (Linux + Windows builds both need this) ----------------------
if [ ! -f vendor/sdltrs/src/z80.c ]; then
    mkdir -p vendor
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    fetch "$SDLTRS_TARBALL" "$tmp/sdltrs.tar.gz"
    rm -rf vendor/sdltrs
    mkdir -p vendor/sdltrs
    tar -xzf "$tmp/sdltrs.tar.gz" -C vendor/sdltrs --strip-components=1
    rm -rf "$tmp"
    trap - EXIT
    echo ">> sdltrs ready at vendor/sdltrs/"
else
    echo ">> sdltrs already present, skipping"
fi

# ---- SDL2 mingw devel (Windows cross-build only) -------------------------
SDL2_DST="third_party/SDL2-${SDL2_VERSION}"
if [ ! -f "$SDL2_DST/x86_64-w64-mingw32/bin/SDL2.dll" ]; then
    mkdir -p third_party
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    fetch "$SDL2_TARBALL" "$tmp/sdl2-mingw.tar.gz"
    tar -xzf "$tmp/sdl2-mingw.tar.gz" -C third_party
    rm -rf "$tmp"
    trap - EXIT
    echo ">> SDL2 mingw devel ready at $SDL2_DST/"
else
    echo ">> SDL2 mingw devel already present, skipping"
fi

echo "done."
