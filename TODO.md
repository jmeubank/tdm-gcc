Open issues this go-around:
  * Fix website README
  * Finish website

Goals:
  * Are MinGW.org versions up to date with recent GCC 9, mingwrt 5.3, etc?
  * Check build arguments upstream for mingw-w64-runtime, binutils, gcc, gdb
  * Check mingw-w64-runtime, binutils, gcc, gdb versions used upstream (MinGW.org, MSYS2, ???)
  * Integrate tdm-distrib files into the patched source folders
  * Check if unsizes are correct and UNSIZE_ADDs are all correct
  * Separate out NLS files (share/locale, others?)
  * Check for code size hogs (std::string, map, etc) and rewrite to small versions
  * Clean up __pycache__ folders
  * Don't let a non-net-manifest installer try to manage an installation from the opposite system
  * Handle incomplete installations gracefully; error out gracefully; what to do about failed components?
  * LTO binutils plugin hanky panky -> seems to work for TDM64, need MinGW.org binutils 2.33 for TDM
  * Get GDB to display colors like GCC in MinTTY (it already does in cmd.exe)
  * Migrate off SourceForge
  * LARGEADDRESSAWARE flag for gcc & binutils
  * Command-line length limitations?
  * mudflap support
  * Go language support
  * Better changelogs
  * Drop-in support for MSYS (look for python & friends in relative paths)
  * Add TDM-GCC to scoop, chocolatey, MSYS2 package managers (conflicts gcc or version selection machinery)
  * Installer silent mode & console output
  * Include cached downloaded archives in disk space usage on install selection page
  * Open README in markdown viewer
  * Make checkboxes for start menu and path match current installation when managing in installer
  * Have CMake regenerate properly when extlibs dependencies change (e.g. new version of UPX)
  * New version message has clickable link (probably don't use MessageBox)
  * Try out MCFgthread - https://gcc-mcf.lhmouse.com/

CHANGELIST:
  * License text updates for COPYING.MinGW.txt, LICENSE-python.txt, 
  * Addition of windows-default-manifest package
  * Yanked a bunch more patches from MSYS2 and mingw-builds
