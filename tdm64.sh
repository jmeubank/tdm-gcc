#!/bin/sh

# ada, c, c++, d, fortran, go, jit, lto, objc, obj-c++
# binutils runtime gcc gdb default-manifest manifest-upstream-deps
( source ./common.sh && make $* \
  WINPTHREADS_SRC=/crossdev/src/mingw-w64-v8-git/mingw-w64-libraries/winpthreads \
  EDITION=tdm64 \
  PKGVERSION=tdm64-1 \
  STAGING_PREFIX=/mingw64tdm \
  BUILD_TYPE=native \
  BUILD=x86_64-w64-mingw32 \
  BIARCH=1 \
  LANGS=ada,c,c++,fortran,jit,lto,objc,obj-c++ \
  EXCEPTIONS=seh \
  THREAD_TYPE=posix \
  SUPPORT_SHARED=1 \
  RUNTIME_SHARED=1 \
  MAKE_PACKAGES="gcc gdb binutils runtime default-manifest manifest-upstream-deps" \
  BUILD_TOOLCHAIN=/crossdev/buildfrom-tdm64 \
  HOST_TOOLCHAIN=/crossdev/buildfrom-tdm64 \
  PYTHON_DIR=/crossdev/src/Python394-64 \
  PYTHON_DLL=python39.dll \
)
