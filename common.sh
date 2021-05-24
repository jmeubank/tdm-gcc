#!/bin/sh

# Sources & versions
export GMP_SRC=/crossdev/src/gmp-6.2.1
export MPFR_SRC=/crossdev/src/mpfr-4.1.0
export MPC_SRC=/crossdev/src/mpc-1.2.1
export ISL_SRC=/crossdev/src/isl-0.23
export CLOOG_SRC=/crossdev/src/cloog-0.18.1
export LIBICONV_SRC=/crossdev/src/libiconv-1.16
export ZSTD_SRC=/crossdev/src/zstd-1.4.9
export BINUTILS_SRC=/crossdev/src/binutils-git-2_36_1
export BINUTILS_VER=2.36.1
export GCC_SRC=../../../src/gcc-git-10.3.0
export GCC_VER=10.3.0
export GCC_SERIES=10
export RUNTIME_SRC=/crossdev/src/mingw-w64-v8-git
export RUNTIME_BRANCH=v8.x
export RUNTIME_VER=v8-git2021050601-gcc${GCC_SERIES}
export DEFAULT_MANIFEST_SRC=/crossdev/src/windows-default-manifest
export DEFAULT_MANIFEST_VER=6.4
export EXPAT_SRC=/crossdev/src/expat-2.2.10
export TERMCAP_SRC=/crossdev/src/termcap-git-1.3.1
export READLINE_SRC=/crossdev/src/readline-git-8.0
export NCURSES_SRC=/crossdev/src/ncurses-6.2
export GDB_SRC=/crossdev/src/gdb-git-10.2
export GDB_VER=10.2
# export MINGW_BASE_MINGWRT_VER=5.2.3
# export MINGW_BASE_W32API_VER=5.2.3
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
export CMAKE=/crossdev/cmake-3.20.2-windows-i386/cmake.exe
