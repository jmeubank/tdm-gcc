Open issues this go-around:
  * Fix website README
  * Finish website

Goals:
  * Rethink the prefix structure
    * / = scoop, msys, Windows, whatever -- sysroot? c:/msys64 etc
    * /usr = msys prefix, c:/msys64/usr
    * /usr/bin/gcc = x86_64-pc-msys-gcc
    *
    * /mingw64 = mingw64 prefix, tdm64 sysroot
    * /mingw64/bin/gcc = shim to x86_64-w64-mingw32-gcc
    * /mingw64/local = local_prefix (sysrooted, relocated)
    * /mingw64/local/include = local includes
    * /mingw64/x86_64-w64-mingw32 = target_system_root (/mingw64/tdm64/../x86_64-w64-mingw32)
    * /mingw64/x86_64-w64-mingw32/include = target system includes
    * /mingw64/tdm64 = tdm prefix
    * /mingw64/tdm64/bin/gcc = tdm64-gcc
    *
    * /mingw = mingw.org prefix, tdm32 sysroot
    * /mingw/tdm32 = tdm32 target_system_root
    * /mingw/tdm32/bin/gcc = tdm32-gcc-sjlj
    * /mingw/tdm32/bin/gcc-dw2 = tdm32-gcc-dw2
    * /mingw/tdm32/bin/gcc-sjlj = tdm32-gcc-sjlj
  * [DONE] Are MinGW.org versions up to date with recent GCC 9, mingwrt 5.3, etc?
  * [DONE] Check build arguments upstream for mingw-w64-runtime, binutils, gcc, gdb
  * [DONE] Check mingw-w64-runtime, binutils, gcc, gdb versions used upstream (MinGW.org, MSYS2, ???)
  * Integrate tdm-distrib files into the patched source folders
  * Check if unsizes are correct and UNSIZE_ADDs are all correct
  * Separate out NLS files (share/locale, others?)
  * Check for code size hogs (std::string, map, etc) in tdminstall.dll and rewrite to small versions
  * [DONE] Clean up __pycache__ folders
  * [DONE] Don't let a non-net-manifest installer try to manage an installation from the opposite system
  * Handle incomplete installations gracefully; error out gracefully; what to do about failed components?
  * LTO binutils plugin hanky panky -> seems to work for TDM64, need MinGW.org binutils 2.33 for TDM32
  * [DONE] Get GDB to display colors like GCC in MinTTY (it already does in cmd.exe and the MSYS2 version even does in mintty)
  * [DONE] LARGEADDRESSAWARE flag for gcc & binutils
  * Command-line length limitations?
  * mudflap support
  * Go language support
  * Better changelogs
  * Drop-in support for MSYS (look for python & friends in relative paths, use MSYS2-MinGW32 versions of gmp/mpfr/mpc/isl/zstd/libiconv/termcap/readline/expat/ncurses)
  * Add TDM-GCC to scoop, chocolatey, MSYS2 package managers (conflicts gcc or version selection machinery)
  * Installer silent mode & console output
  * Include cached downloaded archives in disk space usage on install selection page
  * [DONE] Make checkboxes for start menu and path match current installation when managing in installer
  * Have CMake regenerate properly when extlibs dependencies change (e.g. new version of UPX)
  * [DONE] New version message has clickable link (probably don't use MessageBox)
  * default-manifest.o is supposed to be optional, why do we complain when we don't find it?

Backlog:
  * Open README in markdown viewer
  * Migrate off SourceForge
  * Try out MCFgthread - https://gcc-mcf.lhmouse.com/

CHANGELIST:
  * [GCC] The shared memory region for exceptions and winpthreads has been rewritten for better stability and TLS support
  * [GCC,binutils] Both the TDM32 and TDM64 editions of GCC and binutils are built with --enable-nls and include localization .po files
  * [GDB] GDB emits colored output when running under MinTTY
  * [GDB] The 64-bit GDB is built with TUI support 
  * [Installer] Start menu & PATH options stay consistent with previous selection when upgrading
  * [Installer] Yes/No choice to open browser to download page if a forced installer update is required
  * [Installer] The installer will gracefully block a bundle install from trying to rewrite an existing install from a non-supported edition
  * New upstream dependency versions:
    * gcc-10.3.0
    * gdb-10.2
    * binutils-2.36.1 (TDM64 only)
    * mingw64-runtime v8-git2021050601 (TDM64 only)
    * mingwrt-5.4.1 (TDM32 only)
    * w32api-5.4.1 (TDM32 only)
    * gmp-6.2.1
    * mpfr-4.1.0
    * mpc-1.2.1
    * isl-0.23
    * zstd-1.4.9
    * expat-2.2.10 (GDB, both editions)
    * termcap-1.3.1 (TDM64-GDB only)
    * readline-8.0 (TDM64-GDB only)
    * ncurses-6.2 (TDM64-GDB only)
