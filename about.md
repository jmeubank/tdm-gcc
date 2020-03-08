---
layout: page
title:  About
permalink: /about/
order: 1
---

- TDM-GCC is a compiler suite for Windows.

- It combines the most recent stable release of the [GCC](https://gcc.gnu.org/)
  compiler, a few patches for Windows-friendliness, and the free and open-source
  [MinGW.org](http://www.mingw.org/) or [MinGW-w64](http://mingw-w64.org/)
  runtime APIs, to create a more lightweight open-source alternative to
  Microsoft's compiler and platform SDK.

- It can create 32-bit OR 64-bit binaries, for any version of Windows since
  Windows XP.

- It has an easy-to-use single-file installer that creates a working
  installation with just a few clicks, and can update that installation when new
  packages become available.

- It consists of command-line tools only. If you want a visual IDE (text editor,
  compiler interface, visual debugger),
  [Code::Blocks](http://www.codeblocks.org/) integrates well with TDM-GCC.

- TDM-GCC remixes and redistributes components that are created and supported by
  various upstream projects. You generally will find better support from those
  projects' forums, rather than from TDM-GCC.

### TDM-GCC is Quirky! ###

It's not quite like other compilers in a few ways. Most importantly, it changes
the default GCC runtime libraries to be statically linked and use a shared
memory region for handling exceptions.

But you should check out the README file for the TDM32 edition at
Github:[jmeubank/tdm-distrib/blob/master/tdm32/core/README-gcc-tdm.md](https://github.com/jmeubank/tdm-distrib/blob/master/tdm32/core/README-gcc-tdm.md),
or for the TDM64 edition at
Github:[jmeubank/tdm-distrib/blob/master/tdm64/core/README-gcc-tdm64.md](https://github.com/jmeubank/tdm-distrib/blob/master/tdm64/core/README-gcc-tdm64.md),
to learn more.
