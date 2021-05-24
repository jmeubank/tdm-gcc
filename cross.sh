#!/bin/sh

. ./common.sh

make $* \
  SZA=$SZA \
  EDITION=cross1 \
  STAGING_PREFIX=/crossdev/prefix-cross1-mingw32 \
  BUILD_TYPE=cross \
  BUILD=mingw32 \
  HOST=mingw32 \
  TARGET=mingw32 \
  BIARCH=0 \
  LANGS=ada,c,c++ \
  EXCEPTIONS=dw2 \
  THREAD_TYPE=posix \
  SUPPORT_SHARED=0 \
  RUNTIME_SHARED=0 \
  BUILD_TOOLCHAIN=/crossdev/buildfrom-cross1 \
  HOST_TOOLCHAIN=/crossdev/buildfrom-cross1 \
  GMP_SRC=$GMP_SRC \
  MPFR_SRC=$MPFR_SRC \
  MPC_SRC=$MPC_SRC \
  LIBICONV_SRC=$LIBICONV_SRC \
  ZSTD_SRC=$ZSTD_SRC \
  WINPTHREADS_SRC=/crossdev/src/mingw-w64-v8-git/mingw-w64-libraries/winpthreads \
  BINUTILS_SRC=$BINUTILS_SRC \
  RUNTIME_SRC=$RUNTIME_SRC \
  GCC_SRC=$GCC_SRC \
  GCC_VER=$GCC_VER \
  DEFAULT_MANIFEST_SRC=$DEFAULT_MANIFEST_SRC \
  DEFAULT_MANIFEST_VER=$DEFAULT_MANIFEST_VER \
  MINGW_GET_ROOT=$MINGW_GET_ROOT
