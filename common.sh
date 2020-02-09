#!/bin/sh

# Sources & versions
export GMP_SRC=/crossdev/src/gmp-6.1.0
export MPFR_SRC=/crossdev/src/mpfr-3.1.4
export MPC_SRC=/crossdev/src/mpc-1.0.3
export ISL_SRC=/crossdev/src/isl-0.18
export CLOOG_SRC=/crossdev/src/cloog-0.18.1
export LIBICONV_SRC=/crossdev/src/libiconv-1.16
export ZSTD_SRC=/crossdev/src/zstd-1.4.2
export BINUTILS_SRC=/crossdev/src/binutils-2.33.1
export BINUTILS_VER=2.33.1
export GCC_SRC=../../../src/gcc-git-9.2.0
export GCC_VER=9.2.0
export GCC_SERIES=9
export RUNTIME_SRC=/crossdev/src/mingw-w64-v7-git20191109
export RUNTIME_BRANCH=v7.x
export RUNTIME_VER=v7-git20191109-gcc${GCC_SERIES}
export DEFAULT_MANIFEST_SRC=/crossdev/src/windows-default-manifest
export DEFAULT_MANIFEST_VER=6.4
export EXPAT_SRC=/crossdev/src/expat-2.2.7
export GDB_SRC=/crossdev/src/gdb-git-8.3.1
export GDB_VER=8.3.1
export MINGW_BASE_MINGWRT_VER=
export MINGW_BASE_W32API_VER=
export MINGW_BASE_BINUTILS_VER=
export MINGW_BASE_M32MAKE_VER=
export MINGW_BASE_GDB_VER=
export MINGW_BASE_PTHREADS_VER=

# Base files
export MINGW_GET_ROOT=/crossdev/gccmaster/mgbase
export DISTRIB_BASE=/crossdev/tdm-distrib
export NETMANIFEST=/crossdev/gccmaster/distrib/net-manifest.txt

# Utilities
export SZA=/crossdev/7z1900-extra/7za.exe
