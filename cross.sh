#!/bin/sh

. ./common.sh

make $* \
  SZA=$SZA \
  EDITION=cross2 \
  STAGING_PREFIX=/crossdev/prefix-cross2-x86_64-w64-mingw32 \
  BUILD_TYPE=cross \
  BUILD=x86_64-w64-mingw32 \
  HOST=x86_64-w64-mingw32 \
  TARGET=x86_64-w64-mingw32 \
  BIARCH=1 \
  LANGS=ada,c,c++ \
  EXCEPTIONS=sjlj \
  THREAD_TYPE=posix \
  SUPPORT_SHARED=0 \
  RUNTIME_SHARED=0 \
  BUILD_TOOLCHAIN=/crossdev/buildfrom-cross2 \
  HOST_TOOLCHAIN=/crossdev/buildfrom-cross2 \
  GMP_SRC=$GMP_SRC \
  MPFR_SRC=$MPFR_SRC \
  MPC_SRC=$MPC_SRC \
  LIBICONV_SRC=$LIBICONV_SRC \
  ZSTD_SRC=$ZSTD_SRC \
  WINPTHREADS_SRC=$WINPTHREADS_SRC \
  BINUTILS_SRC=$BINUTILS_SRC \
  RUNTIME_SRC=$RUNTIME_SRC \
  GCC_SRC=$GCC_SRC \
  GCC_VER=$GCC_VER
