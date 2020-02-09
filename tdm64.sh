#!/bin/sh

# ada, c, c++, d, fortran, go, jit, lto, objc, obj-c++
# binutils runtime gcc gdb default-manifest manifest-upstream-deps
( source ./common.sh && make $* \
  WINPTHREADS_SRC=/crossdev/src/winpthreads-v7-git20191109 \
  EDITION=tdm64 \
  PKGVERSION=tdm64-1 \
  STAGING_PREFIX=/mingw64tdm \
  BUILD_TYPE=native \
  BUILD=x86_64-w64-mingw32 \
  BIARCH=1 \
  LANGS=ada,c,c++,fortran,lto,objc,obj-c++ \
  EXCEPTIONS=seh \
  THREAD_TYPE=posix \
  SUPPORT_SHARED=1 \
  RUNTIME_SHARED=1 \
  MAKE_PACKAGES="binutils runtime gcc gdb default-manifest" \
  BUILD_TOOLCHAIN=/crossdev/buildfrom-tdm64 \
  HOST_TOOLCHAIN=/crossdev/buildfrom-tdm64 \
  PYTHON_DIR=/crossdev/src/Python381-64 \
  PYTHON_DLL=python38.dll \
)
