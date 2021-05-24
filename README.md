# TDM-GCC #
![GitHub All Releases](https://img.shields.io/github/downloads/jmeubank/tdm-gcc/total?color=%2309ABF6&label=installer%20downloads)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/jmeubank/tdm-gcc)

TDM-GCC 10.3.0

## COPYING ##

To the extent possible under law, the author(s) have dedicated all copyright and
related and neighboring rights to this software to the public domain worldwide.
This software is distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication along with
this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.


## PACKAGE CONTENTS ##

This is the set of scripts and miscellaneous files used to drive the build
systems of all components that create the TDM-GCC toolchain. It includes a
Makefile with targets for the TDM and TDM64 editions of GCC and all support
libraries, and .sh script files that invoke the Makefile with appropriate
arguments for each TDM-GCC edition.

Patches for the underlying binutils, GCC, GDB, and winpthreads components used
to be included as part of a combined TDM source and build scripts release
tarball, but are now kept in individual Github.com source repositories per
component:
 * https://github.com/jmeubank/tdm-gcc-src
 * https://github.com/jmeubank/tdm-binutils-gdb (for both binutils and gdb)
 * https://github.com/jmeubank/tdm-winpthreads


## ADDITIONAL REQUIREMENTS ##

In order to duplicate the build process used for TDM's binaries, you will need
the following packages:
 * For the TDM32 edition, the MinGW project's "binutils", "mingwrt" and "w32api"
     bin and dev packages
 * For the TDM64 edition, the GNU binutils sources
     (https://github.com/jmeubank/tdm-binutils-gdb/tree/tdm-patches-binutils.public)
     and the MinGW-w64 project's runtime sources
     (https://github.com/jmeubank/mingw-w64/tree/tdm-patches)
 * The GCC source package
     (https://github.com/jmeubank/tdm-gcc-src/tree/tdm-patches.public)
 * The GMP, MPFR, and MPC sources
 * The windows-default-manifest resource file
     (https://sourceware.org/git/?p=cygwin-apps/windows-default-manifest.git;a=tree)
 * For support for character sets other than UTF-8, the libiconv sources
 * For support for the Graphite loop optimizations, the ISL sources
 * For OpenMP and pthreads support, the TDM winpthreads sources, patched from
     the original MinGW-w64 version
     (https://github.com/jmeubank/tdm-winpthreads/tree/tdm-patches.public)
 * To build GDB, the GDB
     (https://github.com/jmeubank/tdm-binutils-gdb/tree/tdm-patches-gdb.public)
     and expat sources and a Python 32-bit or 64-bit binary distribution


## BUILD NOTES ##

The 9.2.0 TDM32 and TDM64 GCC binaries were built as native bootstraps in
Windows 10 (64-bit), using previously built toolchains with the same set of
patches, under the [MSYS2](https://www.msys2.org/) environment. The build
scripts in this package will probably not work in Cygwin, WSL, or GNU/Linux
without modification.

Generally, building GCC consists of first building its support libraries (gmp,
mpfr, mpc, isl, libiconv, winpthreads, and windows-default-manifest), combining
these with binutils and the runtime API into the "staging prefix", and then
building GCC itself. GCC is built to expect it will be installed to the staging
prefix but for the installation step is actually staged into a different
directory.

Building the TDM32 edition typically looks like this:
 * Extract all sources to `/crossdev/src`
 * Copy or build a previous MinGW installation to a "build toolchain"
 * Bootstrap the MinGW.org mingw-get installer into `/crossdev/gccmaster/mgbase`
 * Ensure the prefix, typically `/mingw32tdm`, is empty
 * `./tdm32.sh`

Building the TDM64 edition typically looks like this:
 * Extract all sources to `/crossdev/src`
 * Copy or build a previous multilib MinGW-w64/GCC installation to a "build
     toolchain"
 * Ensure the prefix, typically `/mingw64tdm`, is empty
 * `./tdm64.sh`
