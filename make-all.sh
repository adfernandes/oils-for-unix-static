#!/bin/bash

set -eEux -o pipefail

ROOT="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

cd -- "${ROOT}"

PATH="/opt/musl-cross-make/bin:${PATH}"

# -----------------------------------------------------------------------------

for TARGET in \
    aarch64-linux-musl aarch64_be-linux-musl \
    arm-linux-musleabi arm-linux-musleabihf armeb-linux-musleabi armeb-linux-musleabihf \
    mips-linux-musl mips-linux-muslsf mipsel-linux-musl mipsel-linux-muslsf \
    x86_64-linux-musl \
; do

PREFIX="${ROOT}"/prefix/"${TARGET}"

cp -r "src" "work"

# -----------------------------------------------------------------------------

cd "${ROOT}/work/ncurses-6.5"

# Note: Does not build without the CFLAGS and CXXFLAGS settings:
#       https://gitlab.archlinux.org/archlinux/packaging/packages/ncurses/-/issues/3

CFLAGS=-std=gnu17 \
CXXFLAGS=-std=gnu++17 \
    ./configure \
        --host="${TARGET}" \
        --with-build-cc=cc \
        --prefix="${PREFIX}" \
        --disable-shared \
        --enable-static \
        --without-progs \
        --with-fallbacks="linux,xterm,xterm-256color,screen,screen-256color,gnome,gnome-256color,konsole,konsole-256color,putty,putty-256color,ansi" \
    ;

make -j "$(nproc)" install

# -----------------------------------------------------------------------------

cd "${ROOT}/work/readline-8.3"

./configure \
    --host="${TARGET}" \
    --prefix="${PREFIX}" \
    --disable-shared \
    --enable-static \
    --with-curses="${PREFIX}" \
    --disable-install-examples \
    --enable-multibyte \
    --enable-year2038 \
;

make -j "$(nproc)" install

# -----------------------------------------------------------------------------

cd "${ROOT}/work/oils-for-unix-0.37.0"

CC="${TARGET}-gcc" \
CXX="${TARGET}-g++" \
    ./configure \
        --cxx-for-configure "g++" \
        --prefix="${PREFIX}" \
        --with-readline --readline="${PREFIX}" \
    ;

sed -i.orig -r \
    -e "s@^HAVE_READLINE=\$@HAVE_READLINE=1@" \
    -e "s@^READLINE_DIR=\$@READLINE_DIR=${PREFIX}@" \
    "_build/detected-config.sh"

for file in "_build/oils.sh" "build/ninja-rules-cpp.sh" ; do
    sed -i.orig -r \
        -e "s@ strip @ ${TARGET}-strip @" \
        -e "s@ objcopy @ ${TARGET}-objcopy @" \
        "${file}"
done

CXXFLAGS=--static \
LDFLAGS="-lncursesw --static" \
OILS_CXX_VERBOSE=1 \
    _build/oils.sh --cxx "${TARGET}"-g++

./install "_bin/${TARGET}-g++-opt-sh/oils-for-unix.stripped"

# -----------------------------------------------------------------------------

cd "${ROOT}" && rm -rf -- "work"

done
