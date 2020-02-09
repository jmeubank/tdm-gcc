
## User-specified vars
ifeq ($(SZA),)
$(error Must specify SZA)
endif

ifeq ($(EDITION),)
$(error Must specify EDITION)
endif

ifeq ($(STAGING_PREFIX),)
$(error Must specify STAGING_PREFIX)
endif

ifeq ($(BUILD_TYPE),)
$(error Must specify BUILD_TYPE)
endif

ifeq ($(BUILD),)
$(error Must specify BUILD platform)
endif

ifeq ($(BUILD_TYPE),cross)
ifeq ($(HOST),)
$(error Must specify HOST platform)
endif
ifeq ($(TARGET),)
$(error Must specify TARGET platform)
endif
ifeq ($(BUILD_TOOLCHAIN),)
$(error Must specify BUILD_TOOLCHAIN)
endif
endif

ifeq ($(LANGS),)
$(error Must specify LANGS)
endif
ifeq ($(EXCEPTIONS),)
$(error Must specify EXCEPTIONS)
endif
ifeq ($(THREAD_TYPE),)
$(error Must specify THREAD_TYPE)
endif

ifeq ($(HOST_TOOLCHAIN),)
$(error Must specify HOST_TOOLCHAIN)
endif

ifeq ($(GMP_SRC),)
$(error Must specify GMP_SRC)
endif
ifeq ($(MPFR_SRC),)
$(error Must specify MPFR_SRC)
endif
ifeq ($(MPC_SRC),)
$(error Must specify MPC_SRC)
endif

ifneq ($(GDB_SRC),)
ifeq ($(PYTHON_DIR),)
$(error Must specify PYTHON_DIR)
endif
ifeq ($(PYTHON_DLL),)
$(error Must specify PYTHON_DLL)
endif
endif

ifeq ($(BUILD_TYPE),native)
ifeq ($(DISTRIB_BASE),)
$(error Must specify DISTRIB_BASE)
endif
endif


## Composited vars
BUILD_BASE := $(shell pwd)
BUILD_BASE_WIN := $(shell /bin/sh -c "pwd -W")
THIS_MAKEFILE_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

SCRATCH := $(BUILD_BASE)/build-$(EDITION)
SCRATCH_WIN := $(BUILD_BASE_WIN)/build-$(EDITION)
BUILDFROM := $(BUILD_BASE)/host-toolchain-$(EDITION)
DISTRIB := $(BUILD_BASE)/distrib/$(EDITION)-$(EXCEPTIONS)

ifeq ($(BUILD_TYPE),native)
HOST := $(BUILD)
TARGET := $(BUILD)
endif

ifneq ($(PKGVERSION),)
PKGVERSION_OPT := --with-pkgversion="$(PKGVERSION)"
endif

PKG_BINUTILS := $(BUILD_BASE)/binutils-pkg-$(EDITION)
PKG_RUNTIME := $(BUILD_BASE)/runtime-pkg-$(EDITION)
PKG_GCC := $(BUILD_BASE)/gcc-pkg-$(EDITION)-$(EXCEPTIONS)
PKG_GDB := $(BUILD_BASE)/gdb-pkg-$(EDITION)

ifeq ($(BIARCH),1)
BINUTILS_TARGETS_OPT := --enable-targets=x86_64-w64-mingw32,i686-w64-mingw32
GDB_TARGETS_OPT := --enable-targets=x86_64-w64-mingw32,i686-w64-mingw32
GCC_TARGETS_OPT := --enable-targets=all
ENABLE_LIB32_OPT := --enable-lib32
else
BINUTILS_TARGETS_OPT := --disable-multilib
GCC_TARGETS_OPT := --disable-multilib
endif

MAYBEGCCVERSUFFIX=
ifeq ($(EXCEPTIONS),sjlj)
EXCEPTIONS_OPT := --enable-sjlj-exceptions
EXCEPTIONS_CAPS=SJLJ
endif
ifeq ($(EXCEPTIONS),dw2)
EXCEPTIONS_OPT := --disable-sjlj-exceptions --program-suffix=-dw2
MAYBEGCCVERSUFFIX=-dw2
EXCEPTIONS_CAPS=DW2
endif

ifeq ($(SUPPORT_SHARED),1)
SUPPORT_SHARED_OPT := --disable-static --enable-shared
else
SUPPORT_SHARED_OPT := --enable-static --disable-shared
endif
ifeq ($(RUNTIME_SHARED),1)
RUNTIME_SHARED_OPT := --disable-static --enable-shared
else
RUNTIME_SHARED_OPT := --enable-static --disable-shared
endif

ifeq ($(LTO_BUILD),1)
LTO_OPT := -flto
endif

ifeq ($(findstring w64,$(TARGET)),)
DEFAULT_MANIFEST_ARCH := x86
else
ifeq ($(BIARCH),1)
DEFAULT_MANIFEST_ARCH := x86_64_multi
else
DEFAULT_MANIFEST_ARCH := x86_64
endif
endif

ifneq ($(NETMANIFEST),)
NEW_NET_MFT := $(NETMANIFEST).new.txt
endif


## Stamp target vars
STAMP_HOST_TOOLCHAIN_COPY := $(BUILDFROM)/master-stamp-host-toolchain-copy-$(EDITION)

STAMP_NEW_NET_MANIFEST := $(BUILD_BASE)/distrib/master-stamp-new-net-manifest

STAMP_GMP_BUILD := $(SCRATCH)/gmp/master-stamp-gmp-build-$(EDITION)
STAMP_GMP_HOST_INSTALL := $(BUILDFROM)/master-stamp-gmp-host-install-$(EDITION)
STAMP_GMP_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-gmp-stage-install-$(EDITION)

STAMP_MPFR_BUILD := $(SCRATCH)/mpfr/master-stamp-mpfr-build-$(EDITION)
STAMP_MPFR_HOST_INSTALL := $(BUILDFROM)/master-stamp-mpfr-host-install-$(EDITION)
STAMP_MPFR_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-mpfr-stage-install-$(EDITION)

STAMP_MPC_BUILD := $(SCRATCH)/mpc/master-stamp-mpc-build-$(EDITION)
STAMP_MPC_HOST_INSTALL := $(BUILDFROM)/master-stamp-mpc-host-install-$(EDITION)
STAMP_MPC_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-mpc-stage-install-$(EDITION)

STAMP_ISL_BUILD := $(SCRATCH)/isl/master-stamp-isl-build-$(EDITION)
STAMP_ISL_HOST_INSTALL := $(BUILDFROM)/master-stamp-isl-host-install-$(EDITION)
STAMP_ISL_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-isl-stage-install-$(EDITION)

STAMP_CLOOG_BUILD := $(SCRATCH)/cloog/master-stamp-cloog-build-$(EDITION)
STAMP_CLOOG_HOST_INSTALL := $(BUILDFROM)/master-stamp-cloog-host-install-$(EDITION)
STAMP_CLOOG_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-cloog-stage-install-$(EDITION)

STAMP_LIBICONV_BUILD := $(SCRATCH)/libiconv/master-stamp-libiconv-build-$(EDITION)
STAMP_LIBICONV_HOST_INSTALL := $(BUILDFROM)/master-stamp-libiconv-host-install-$(EDITION)
STAMP_LIBICONV_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-libiconv-stage-install-$(EDITION)

STAMP_ZSTD_BUILD := $(SCRATCH)/zstd/master-stamp-zstd-build-$(EDITION)
STAMP_ZSTD_HOST_INSTALL := $(BUILDFROM)/master-stamp-zstd-host-install-$(EDITION)
STAMP_ZSTD_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-zstd-stage-install-$(EDITION)

STAMP_MINGW_GET_BASE := $(STAGING_PREFIX)/master-stamp-mingw-get-base

STAMP_WINPTHREADS_BUILD := $(SCRATCH)/winpthreads/master-stamp-winpthreads-build-$(EDITION)
STAMP_WINPTHREADS_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-winpthreads-stage-install-$(EDITION)

STAMP_BINUTILS_BUILD := $(SCRATCH)/binutils/master-stamp-binutils-build-$(EDITION)
STAMP_BINUTILS_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-binutils-stage-install-$(EDITION)
STAMP_BINUTILS_PKG_INSTALL := $(PKG_BINUTILS)/master-stamp-binutils-pkg-install-$(EDITION)
STAMP_BINUTILS_DISTRIB := $(DISTRIB)/master-stamp-binutils-distrib-$(EDITION)
STAMP_BINUTILS_MANIFEST := $(DISTRIB)/master-stamp-binutils-manifest-$(EDITION)

STAMP_RUNTIME_HEADERS_BUILD := $(SCRATCH)/runtime-headers/master-stamp-runtime-headers-build-$(EDITION)
STAMP_RUNTIME_HEADERS_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-runtime-headers-stage-install-$(EDITION)

STAMP_GCC_CORE_BUILD := $(SCRATCH)/gcc-$(EXCEPTIONS)/master-stamp-gcc-core-build-$(EDITION)-$(EXCEPTIONS)
STAMP_GCC_CORE_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-gcc-core-stage-install-$(EDITION)-$(EXCEPTIONS)

STAMP_RUNTIME_BUILD := $(SCRATCH)/runtime/master-stamp-runtime-build-$(EDITION)
STAMP_RUNTIME_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-runtime-stage-install-$(EDITION)
STAMP_RUNTIME_PKG_INSTALL := $(PKG_RUNTIME)/master-stamp-runtime-pkg-install-$(EDITION)
STAMP_RUNTIME_DISTRIB := $(DISTRIB)/master-stamp-runtime-distrib-$(EDITION)
STAMP_RUNTIME_MANIFEST := $(DISTRIB)/master-stamp-runtime-manifest-$(EDITION)

STAMP_DEFAULT_MANIFEST_BUILD := $(SCRATCH)/default-manifest/master-stamp-default-manifest-build
STAMP_DEFAULT_MANIFEST_HOST_INSTALL := $(BUILDFROM)/master-stamp-default-manifest-host-install-$(EDITION)
STAMP_DEFAULT_MANIFEST_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-default-manifest-stage-install
STAMP_DEFAULT_MANIFEST_PKG_INSTALL := $(DISTRIB)/master-stamp-default-manifest-pkg-install
STAMP_DEFAULT_MANIFEST_DISTRIB := $(DISTRIB)/master-stamp-default-manifest-distrib-$(EDITION)
STAMP_DEFAULT_MANIFEST_MFTUPDATE := $(DISTRIB)/master-stamp-default-manifest-mftupdate-$(EDITION)

STAMP_STAGE_COPY32 := $(STAGING_PREFIX)/master-stamp-stage-copy32-$(EDITION)

STAMP_GCC_BUILD := $(SCRATCH)/gcc-$(EXCEPTIONS)/master-stamp-gcc-build-$(EDITION)-$(EXCEPTIONS)
STAMP_GCC_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-gcc-stage-install-$(EDITION)-$(EXCEPTIONS)
STAMP_GCC_PKG_INSTALL := $(PKG_GCC)/master-stamp-gcc-pkg-install-$(EDITION)-$(EXCEPTIONS)
STAMP_GCC_DISTRIB := $(DISTRIB)/master-stamp-gcc-distrib-$(EDITION)-$(EXCEPTIONS)
STAMP_GCC_MANIFEST := $(DISTRIB)/master-stamp-gcc-manifest-$(EDITION)-$(EXCEPTIONS)

STAMP_DISTRIB_LIBGCC_32_DW2_DLL := $(BUILD_BASE)/distrib/tdm32-dw2/master-stamp-libgcc-dll-distrib

STAMP_EXPAT_BUILD := $(SCRATCH)/expat/master-stamp-expat-build-$(EDITION)
STAMP_EXPAT_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-expat-stage-install-$(EDITION)

STAMP_PYTHON_COPY := $(SCRATCH)/python_src/master-stamp-python-copy-src

STAMP_GDB_BUILD := $(SCRATCH)/gdb/master-stamp-gdb-build-$(EDITION)
STAMP_GDB_STAGE_INSTALL := $(STAGING_PREFIX)/master-stamp-gdb-stage-install-$(EDITION)
STAMP_GDB_PKG_INSTALL := $(PKG_GDB)/master-stamp-gdb-pkg-install-$(EDITION)
STAMP_GDB_DISTRIB := $(DISTRIB)/master-stamp-gdb-distrib-$(EDITION)
STAMP_GDB_MANIFEST := $(DISTRIB)/master-stamp-gdb-manifest-$(EDITION)

STAMP_DISTRIB_MG_ROOT := $(BUILD_BASE)/distrib/mingw-get-root/master-stamp-copy-mingw-get-root
STAMP_DISTRIB_MG_STAGE := $(BUILD_BASE)/distrib/mingw-get-root/master-stamp-mingw-get-stage
STAMP_NETMANIFEST_UPSTREAM_DEPS := $(BUILD_BASE)/distrib/master-stamp-manifest-upstream-deps


###########
# default
###########
.PHONY: default

ifneq ($(filter binutils,$(MAKE_PACKAGES)),)
ifeq ($(BINUTILS_SRC),)
$(error Must specify BINUTILS_SRC)
endif
ifeq ($(BINUTILS_VER),)
$(error Must specify BINUTILS_VER)
endif
default: $(STAMP_BINUTILS_MANIFEST)
$(STAMP_MANIFEST): $(STAMP_BINUTILS_DISTRIB)
endif

ifneq ($(filter runtime,$(MAKE_PACKAGES)),)
ifeq ($(RUNTIME_SRC),)
$(error Must specify RUNTIME_SRC)
endif
ifeq ($(RUNTIME_BRANCH),)
$(error Must specify RUNTIME_BRANCH)
endif
ifeq ($(RUNTIME_VER),)
$(error Must specify RUNTIME_VER)
endif
ifeq ($(GCC_SERIES),)
$(error Must specify GCC_SERIES)
endif
default: $(STAMP_RUNTIME_MANIFEST)
endif

ifneq ($(GCC_SRC),)
default: $(STAMP_GCC_STAGE_INSTALL)
endif

ifneq ($(filter gcc,$(MAKE_PACKAGES)),)
ifeq ($(GCC_VER),)
$(error Must specify GCC_VER)
endif
ifeq ($(GCC_SERIES),)
$(error Must specify GCC_SERIES)
endif
default: $(STAMP_GCC_MANIFEST)
endif

ifneq ($(filter gdb,$(MAKE_PACKAGES)),)
ifeq ($(GDB_SRC),)
$(error Must specify GDB_SRC)
endif
ifeq ($(GDB_VER),)
$(error Must specify GDB_VER)
endif
default: $(STAMP_GDB_MANIFEST)
endif

ifneq ($(filter default-manifest,$(MAKE_PACKAGES)),)
ifeq ($(DEFAULT_MANIFEST_SRC),)
$(error Must specify DEFAULT_MANIFEST_SRC)
endif
ifeq ($(DEFAULT_MANIFEST_VER),)
$(error Must specify DEFAULT_MANIFEST_VER)
endif
default: $(STAMP_DEFAULT_MANIFEST_MFTUPDATE)
endif

ifeq ($(MINGW_BASE_MINGWRT_VER),)
MINGW_BASE_MINGWRT_SPEC := mingwrt
else
MINGW_BASE_MINGWRT_SPEC := "mingwrt=$(MINGW_BASE_MINGWRT_VER)"
endif
ifeq ($(MINGW_BASE_W32API_VER),)
MINGW_BASE_W32API_SPEC := w32api
else
MINGW_BASE_W32API_SPEC := "w32api=$(MINGW_BASE_W32API_VER)"
endif
ifeq ($(MINGW_BASE_BINUTILS_VER),)
MINGW_BASE_BINUTILS_SPEC := binutils
else
MINGW_BASE_BINUTILS_SPEC := "binutils=$(MINGW_BASE_BINUTILS_VER)"
endif
ifeq ($(MINGW_BASE_M32MAKE_VER),)
MINGW_BASE_M32MAKE_SPEC := mingw32-make
else
MINGW_BASE_M32MAKE_SPEC := "mingw32-make=$(MINGW_BASE_M32MAKE_VER)"
endif
ifeq ($(MINGW_BASE_GDB_VER),)
MINGW_BASE_GDB_SPEC := gdb
else
MINGW_BASE_GDB_SPEC := "gdb=$(MINGW_BASE_GDB_VER)"
endif
ifeq ($(MINGW_BASE_PTHREADS_VER),)
MINGW_BASE_PTHREADS_SPEC := pthreads-w32
else
MINGW_BASE_PTHREADS_SPEC := "pthreads-w32=$(MINGW_BASE_PTHREADS_VER)"
endif
ifeq ($(MINGW_BASE_GCC_VER),)
MINGW_BASE_GCC_SPEC_ADDL :=
else
MINGW_BASE_GCC_SPEC_ADDL := "=$(MINGW_BASE_GCC_VER)"
endif

ifneq ($(filter manifest-upstream-deps,$(MAKE_PACKAGES)),)
default: $(STAMP_NETMANIFEST_UPSTREAM_DEPS)
endif


###########
# host-toolchain-copy
###########
.PHONY: host-toolchain-copy
host-toolchain-copy: $(STAMP_HOST_TOOLCHAIN_COPY)

$(STAMP_HOST_TOOLCHAIN_COPY):
	@echo "=== gccmaster: Copy host toolchain to scratch area ==="
	rm -fR $(BUILDFROM)
	mkdir -p $(BUILDFROM)
	cp -Rp $(HOST_TOOLCHAIN)/* $(BUILDFROM)/
ifeq ($(BUILD_TYPE),cross)
	-cp -p $(BUILDFROM)/bin/$(HOST)-gnatmake.exe $(BUILDFROM)/bin/gnatmake.exe
	-cp -p $(BUILDFROM)/bin/$(HOST)-gnatbind.exe $(BUILDFROM)/bin/gnatbind.exe
	-cp -p $(BUILDFROM)/bin/$(HOST)-gnatlink.exe $(BUILDFROM)/bin/gnatlink.exe
	-cp -p $(BUILDFROM)/bin/$(HOST)-gnatls.exe $(BUILDFROM)/bin/gnatls.exe
endif
#ifeq ($(BUILD_TYPE),native)
#	cp -Rp $(HOST_TOOLCHAIN)/* $(STAGING_PREFIX)/
#endif
	touch $@


###########
# new-net-mft
###########
.PHONY: new-net-mft
new-net-mft: $(STAMP_NEW_NET_MANIFEST)

$(STAMP_NEW_NET_MANIFEST): $(NETMANIFEST)
	@echo "=== gccmaster: Copy net manifest to new file ==="
	mkdir -p $(DISTRIB)
	rm -f $(NEW_NET_MFT)
	cp -p $(NETMANIFEST) $(NEW_NET_MFT)
	touch $@


###########
# gmp
###########
.PHONY: gmp gmp-host-install gmp-stage-install
gmp: $(STAMP_GMP_BUILD)
gmp-host-install: $(STAMP_GMP_HOST_INSTALL)
gmp-stage-install: $(STAMP_GMP_STAGE_INSTALL)

ifneq ($(findstring x86_64,$(HOST)),)
ABIARG := "ABI=64"
endif
$(STAMP_GMP_BUILD): $(STAMP_HOST_TOOLCHAIN_COPY)
	@echo "=== gccmaster: Build gmp ==="
	rm -fR $(SCRATCH)/gmp
	mkdir -p $(SCRATCH)/gmp
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/gmp \
	 && \
	 $(GMP_SRC)/configure --prefix=$(BUILDFROM)/$(HOST) --build=$(BUILD) \
	  --host=$(HOST) $(SUPPORT_SHARED_OPT) $(ABIARG) \
	  CFLAGS="-O2 -g $(LTO_OPT)" LDFLAGS="$(LTO_OPT)" \
	 && \
	 $(MAKE)
endif
ifeq ($(BUILD_TYPE),native)
ifeq ($(findstring x86_64,$(HOST)),)
	mkdir -p $(SCRATCH)/gmp/build
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/gmp/build \
	 && \
	 $(GMP_SRC)/configure --prefix=$(SCRATCH)/gmp/stage --build=$(HOST) \
	  --enable-fat $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 $(LTO_OPT)" \
	  CXXFLAGS="-O2 $(LTO_OPT)" \
	  LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE) && $(MAKE) install
else
ifeq ($(BIARCH),1)
	mkdir -p $(SCRATCH)/gmp/build32
	mkdir -p $(SCRATCH)/gmp/build64
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/gmp/build32 \
	 && \
	 $(GMP_SRC)/configure --prefix=$(SCRATCH)/gmp/stage/32 --build=$(HOST) \
	  $(SUPPORT_SHARED_OPT) \
	  LD="ld.exe -m i386pe" CFLAGS="-O2 -m32 $(LTO_OPT)" \
	  CXXFLAGS="-O2 -m32 $(LTO_OPT)" LDFLAGS="-m32 -s $(LTO_OPT)" ABI=32 \
	 && \
	 $(MAKE) && $(MAKE) install
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/gmp/build64 \
	 && \
	 $(GMP_SRC)/configure --prefix=$(SCRATCH)/gmp/stage/64 \
	  --build=$(HOST) --enable-cxx $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 $(LTO_OPT)" CXXFLAGS="-O2 $(LTO_OPT)" \
	  LDFLAGS="-s $(LTO_OPT)" ABI=64 \
	 && \
	 $(MAKE) && $(MAKE) install
endif
endif
endif
	touch $@

$(STAMP_GMP_HOST_INSTALL): $(STAMP_GMP_BUILD)
	@echo "=== gccmaster: Install gmp in scratch toolchain ==="
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/gmp \
	 && \
	 $(MAKE) install
endif
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/gmp/stage DEST=$(BUILDFROM)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@

$(STAMP_GMP_STAGE_INSTALL): $(STAMP_GMP_BUILD)
	@echo "=== gccmaster: Install gmp in staging prefix ==="
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/gmp \
	 && \
	 $(MAKE) install prefix=$(STAGING_PREFIX)
endif
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/gmp/stage DEST=$(STAGING_PREFIX)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@


###########
# mpfr
###########
.PHONY: mpfr mpfr-host-install mpfr-stage-install
mpfr: $(STAMP_MPFR_BUILD)
mpfr-host-install: $(STAMP_MPFR_HOST_INSTALL)
mpfr-stage-install: $(STAMP_MPFR_STAGE_INSTALL)

$(STAMP_MPFR_BUILD): $(STAMP_HOST_TOOLCHAIN_COPY) $(STAMP_GMP_HOST_INSTALL)
	@echo "=== gccmaster: Build mpfr ==="
	rm -fR $(SCRATCH)/mpfr
	mkdir -p $(SCRATCH)/mpfr
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpfr \
	 && \
	 $(MPFR_SRC)/configure --prefix=$(BUILDFROM)/$(HOST) --build=$(BUILD) \
	  --host=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 -g $(LTO_OPT)" LDFLAGS="$(LTO_OPT)" \
	 && \
	 $(MAKE)
endif
ifeq ($(BUILD_TYPE),native)
ifeq ($(findstring x86_64,$(HOST)),)
	mkdir -p $(SCRATCH)/mpfr/build
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpfr/build \
	 && \
	 $(MPFR_SRC)/configure --prefix=$(SCRATCH)/mpfr/stage \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 $(LTO_OPT)" LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE) && $(MAKE) install
else
ifeq ($(BIARCH),1)
	mkdir -p $(SCRATCH)/mpfr/build32
	mkdir -p $(SCRATCH)/mpfr/build64
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin32:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpfr/build32 \
	 && \
	 $(MPFR_SRC)/configure --prefix=$(SCRATCH)/mpfr/stage/32 \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 -m32 $(LTO_OPT)" LDFLAGS="-m32 -s $(LTO_OPT)" \
	 && \
	 $(MAKE) && $(MAKE) install
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpfr/build64 \
	 && \
	 $(MPFR_SRC)/configure --prefix=$(SCRATCH)/mpfr/stage/64 \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-I$(SCRATCH)/gmp/stage/64/include -O2 $(LTO_OPT)" LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE) && $(MAKE) install
endif
endif
endif
	touch $@

$(STAMP_MPFR_HOST_INSTALL): $(STAMP_MPFR_BUILD)
	@echo "=== gccmaster: Install mpfr in scratch toolchain ==="
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpfr \
	 && \
	 $(MAKE) install
endif
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/mpfr/stage DEST=$(BUILDFROM)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@

$(STAMP_MPFR_STAGE_INSTALL): $(STAMP_MPFR_BUILD)
	@echo "=== gccmaster: Install mpfr in staging prefix ==="
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpfr \
	 && \
	 $(MAKE) install prefix=$(STAGING_PREFIX)
endif
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/mpfr/stage DEST=$(STAGING_PREFIX)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@


###########
# mpc
###########
.PHONY: mpc mpc-host-install mpc-stage-install
mpc: $(STAMP_MPC_BUILD)
mpc-host-install: $(STAMP_MPC_HOST_INSTALL)
mpc: $(STAMP_MPC_STAGE_INSTALL)

$(STAMP_MPC_BUILD): $(STAMP_HOST_TOOLCHAIN_COPY) $(STAMP_GMP_HOST_INSTALL)
$(STAMP_MPC_BUILD): $(STAMP_MPFR_HOST_INSTALL)
	@echo "=== gccmaster: Build mpc ==="
	rm -fR $(SCRATCH)/mpc
	mkdir -p $(SCRATCH)/mpc
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpc \
	 && \
	 $(MPC_SRC)/configure --prefix=$(BUILDFROM)/$(HOST) --build=$(BUILD) \
	  --host=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 -g $(LTO_OPT)" LDFLAGS="$(LTO_OPT)" \
	 && \
	 $(MAKE)
endif
ifeq ($(BUILD_TYPE),native)
ifeq ($(findstring x86_64,$(HOST)),)
	mkdir -p $(SCRATCH)/mpc/build
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpc/build \
	 && \
	 $(MPC_SRC)/configure --prefix=$(SCRATCH)/mpc/stage \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 $(LTO_OPT)" LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE) LDFLAGS="-s -no-undefined" \
	 && \
	 $(MAKE) install
else
ifeq ($(BIARCH),1)
	mkdir -p $(SCRATCH)/mpc/build32
	mkdir -p $(SCRATCH)/mpc/build64
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin32:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpc/build32 \
	 && \
	 $(MPC_SRC)/configure --prefix=$(SCRATCH)/mpc/stage/32 \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 -m32 $(LTO_OPT)" LDFLAGS="-m32 -s $(LTO_OPT)" \
	 && \
	 $(MAKE) LDFLAGS="-s -no-undefined" \
	 && \
	 $(MAKE) install
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpc/build64 \
	 && \
	 $(MPC_SRC)/configure --prefix=$(SCRATCH)/mpc/stage/64 \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 $(LTO_OPT)" LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE) LDFLAGS="-s -no-undefined" \
	 && \
	 $(MAKE) install
endif
endif
endif
	touch $@

$(STAMP_MPC_HOST_INSTALL): $(STAMP_MPC_BUILD)
	@echo "=== gccmaster: Install mpc in scratch toolchain ==="
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpc \
	 && \
	 $(MAKE) install
endif
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/mpc/stage DEST=$(BUILDFROM)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@

$(STAMP_MPC_STAGE_INSTALL): $(STAMP_MPC_BUILD)
	@echo "=== gccmaster: Install mpc in staging prefix ==="
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/mpc \
	 && \
	 $(MAKE) install prefix=$(STAGING_PREFIX)
endif
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/mpc/stage DEST=$(STAGING_PREFIX)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@


###########
# isl
###########
.PHONY: isl isl-host-install isl-stage-install
isl: $(STAMP_ISL_BUILD)
isl-host-install: $(STAMP_ISL_HOST_INSTALL)
isl-stage-install: $(STAMP_ISL_STAGE_INSTALL)

#libisl_la_LDFLAGS="-version-info $(ISL_VERSION_INFO) -no-undefined"
$(STAMP_ISL_BUILD): $(STAMP_HOST_TOOLCHAIN_COPY) $(STAMP_GMP_HOST_INSTALL)
	@echo "=== gccmaster: Build isl ==="
	rm -fR $(SCRATCH)/isl
	mkdir -p $(SCRATCH)/isl
ifeq ($(BUILD_TYPE),native)
ifeq ($(findstring x86_64,$(HOST)),)
	mkdir -p $(SCRATCH)/isl/build
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/isl/build \
	 && \
	 $(ISL_SRC)/configure --prefix=$(SCRATCH)/isl/stage \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 $(LTO_OPT)" CXXFLAGS="-O2 $(LTO_OPT)" \
	  LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE) LDFLAGS="-s -no-undefined" \
	 && \
	 $(MAKE) install
else
ifeq ($(BIARCH),1)
	mkdir -p $(SCRATCH)/isl/build32
	mkdir -p $(SCRATCH)/isl/build64
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin32:$(PATH)" \
	 && \
	 cd $(SCRATCH)/isl/build32 \
	 && \
	 $(ISL_SRC)/configure --prefix=$(SCRATCH)/isl/stage/32 \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 -m32 $(LTO_OPT)" CXXFLAGS="-O2 -m32 $(LTO_OPT)" \
	  LDFLAGS="-s -m32 $(LTO_OPT)" \
	 && \
	 $(MAKE) LDFLAGS="-s -no-undefined" \
	 && \
	 $(MAKE) install
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/isl/build64 \
	 && \
	 $(ISL_SRC)/configure --prefix=$(SCRATCH)/isl/stage/64 \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 $(LTO_OPT)" CXXFLAGS="-O2 $(LTO_OPT)" \
	  LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE) LDFLAGS="-s -no-undefined" \
	 && \
	 $(MAKE) install
endif
endif
endif
	touch $@

$(STAMP_ISL_HOST_INSTALL): $(STAMP_ISL_BUILD)
	@echo "=== gccmaster: Install isl in scratch toolchain ==="
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/isl/stage DEST=$(BUILDFROM)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@

$(STAMP_ISL_STAGE_INSTALL): $(STAMP_ISL_BUILD)
	@echo "=== gccmaster: Install isl in staging prefix ==="
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/isl/stage DEST=$(STAGING_PREFIX)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@


###########
# cloog
###########
.PHONY: cloog cloog-host-install cloog-stage-install
cloog: $(STAMP_CLOOG_BUILD)
cloog-host-install: $(STAMP_CLOOG_HOST_INSTALL)
cloog-stage-install: $(STAMP_CLOOG_STAGE_INSTALL)

$(STAMP_CLOOG_BUILD): $(STAMP_HOST_TOOLCHAIN_COPY) $(STAMP_GMP_HOST_INSTALL)
$(STAMP_CLOOG_BUILD): $(STAMP_ISL_HOST_INSTALL)
	@echo "=== gccmaster: Build cloog ==="
	rm -fR $(SCRATCH)/cloog
	mkdir -p $(SCRATCH)/cloog
ifeq ($(BUILD_TYPE),native)
ifeq ($(findstring x86_64,$(HOST)),)
	mkdir -p $(SCRATCH)/cloog/build
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/cloog/build \
	 && \
	 $(CLOOG_SRC)/configure --prefix=$(SCRATCH)/cloog/stage \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) --with-isl=system --with-bits=gmp \
	  CFLAGS="-O2 $(LTO_OPT)" CXXFLAGS="-O2 $(LTO_OPT)" \
	  LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE) libcloog_isl_la_LDFLAGS="-version-info 3:0:0 -no-undefined" \
	 && \
	 $(MAKE) install
else
ifeq ($(BIARCH),1)
	mkdir -p $(SCRATCH)/cloog/build32
	mkdir -p $(SCRATCH)/cloog/build64
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin32:$(PATH)" \
	 && \
	 cd $(SCRATCH)/cloog/build32 \
	 && \
	 $(CLOOG_SRC)/configure --prefix=$(SCRATCH)/cloog/stage/32 \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) --with-isl=system --with-bits=gmp \
	  CFLAGS="-O2 -m32 $(LTO_OPT)" CXXFLAGS="-O2 -m32 $(LTO_OPT)" \
	  LDFLAGS="-s -m32 $(LTO_OPT)" \
	 && \
	 $(MAKE) libcloog_isl_la_LDFLAGS="-version-info 3:0:0 -no-undefined" \
	 && \
	 $(MAKE) install
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(HOST)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/cloog/build64 \
	 && \
	 $(CLOOG_SRC)/configure --prefix=$(SCRATCH)/cloog/stage/64 \
	  --build=$(HOST) $(SUPPORT_SHARED_OPT) --with-isl=system --with-bits=gmp \
	  CFLAGS="-O2 $(LTO_OPT)" CXXFLAGS="-O2 $(LTO_OPT)" \
	  LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE) libcloog_isl_la_LDFLAGS="-version-info 3:0:0 -no-undefined" \
	 && \
	 $(MAKE) install
endif
endif
endif
	touch $@

$(STAMP_CLOOG_HOST_INSTALL): $(STAMP_CLOOG_BUILD)
	@echo "=== gccmaster: Install cloog in scratch toolchain ==="
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/cloog/stage DEST=$(BUILDFROM)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@

$(STAMP_CLOOG_STAGE_INSTALL): $(STAMP_CLOOG_BUILD)
	@echo "=== gccmaster: Install cloog in staging prefix ==="
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/cloog/stage DEST=$(STAGING_PREFIX)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@


###########
# libiconv
###########
.PHONY: libiconv libiconv-host-install libiconv-stage-install
libiconv: $(STAMP_LIBICONV_BUILD)
libiconv-host-install: $(STAMP_LIBICONV_HOST_INSTALL)
libiconv-stage-install: $(STAMP_LIBICONV_STAGE_INSTALL)

$(STAMP_LIBICONV_BUILD): $(STAMP_HOST_TOOLCHAIN_COPY)
	@echo "=== gccmaster: Build libiconv ==="
	rm -fR $(SCRATCH)/libiconv
	mkdir -p $(SCRATCH)/libiconv
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/libiconv \
	 && \
	 $(LIBICONV_SRC)/configure --prefix=$(BUILDFROM)/$(HOST) --build=$(BUILD) \
	  --host=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 -g $(LTO_OPT)" LDFLAGS="$(LTO_OPT)" \
	 && \
	 $(MAKE)
endif
ifeq ($(BUILD_TYPE),native)
ifeq ($(findstring x86_64,$(HOST)),)
	mkdir -p $(SCRATCH)/libiconv/build
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/libiconv/build \
	 && \
	 $(LIBICONV_SRC)/configure --prefix=$(SCRATCH)/libiconv/stage \
	  --build=$(HOST) --host=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 $(LTO_OPT)" LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE) && $(MAKE) install
else
ifeq ($(BIARCH),1)
	mkdir -p $(SCRATCH)/libiconv/build32
	mkdir -p $(SCRATCH)/libiconv/build64
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/libiconv/build32 \
	 && \
	 $(LIBICONV_SRC)/configure --prefix=$(SCRATCH)/libiconv/stage/32 \
	  --build=$(HOST) --host=$(HOST) $(SUPPORT_SHARED_OPT) \
	  CFLAGS="-O2 -m32 $(LTO_OPT)" LDFLAGS="-s -m32 $(LTO_OPT)" \
	  RC="windres -F pe-i386" WINDRES="windres -F pe-i386" \
	 && \
	 $(MAKE) && $(MAKE) install
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/libiconv/build64 \
	 && \
	 $(LIBICONV_SRC)/configure --prefix=$(SCRATCH)/libiconv/stage/64 \
	  --build=$(HOST) --host=$(HOST) --enable-shared=no \
	  CFLAGS="-O2 $(LTO_OPT)" LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE) && $(MAKE) install
endif
endif
endif
	touch $@

$(STAMP_LIBICONV_HOST_INSTALL): $(STAMP_LIBICONV_BUILD)
	@echo "=== gccmaster: Install libiconv in scratch toolchain ==="
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/libiconv \
	 && \
	 $(MAKE) install
endif
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/libiconv/stage DEST=$(BUILDFROM)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@

$(STAMP_LIBICONV_STAGE_INSTALL): $(STAMP_LIBICONV_BUILD)
	@echo "=== gccmaster: Install libiconv in staging prefix ==="
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/libiconv \
	 && \
	 $(MAKE) install prefix=$(STAGING_PREFIX)
endif
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/libiconv/stage DEST=$(STAGING_PREFIX)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@


###########
# zstd
###########
.PHONY: zstd zstd-host-install zstd-stage-install
zstd: $(STAMP_ZSTD_BUILD)
zstd-host-install: $(STAMP_ZSTD_HOST_INSTALL)
zstd-stage-install: $(STAMP_ZSTD_STAGE_INSTALL)

$(STAMP_ZSTD_BUILD): $(STAMP_HOST_TOOLCHAIN_COPY)
	@echo "=== gccmaster: Build zstd ==="
	rm -fR $(SCRATCH)/zstd
	mkdir -p $(SCRATCH)/zstd
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cp -Rp $(ZSTD_SRC)/lib/* $(SCRATCH)/zstd/ \
	 && \
	 cd $(SCRATCH)/zstd \
	 && \
	 $(MAKE) CC=gcc CFLAGS="-O2 -g $(LTO_OPT)" LDFLAGS="$(LTO_OPT)"
endif
ifeq ($(BUILD_TYPE),native)
ifeq ($(findstring x86_64,$(HOST)),)
	mkdir -p $(SCRATCH)/zstd/build
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cp -Rp $(ZSTD_SRC)/lib/* $(SCRATCH)/zstd/build/ \
	 && \
	 cd $(SCRATCH)/zstd/build \
	 && \
	 $(MAKE) CC=gcc CFLAGS="-O3 $(LTO_OPT)" LDFLAGS="-s $(LTO_OPT)"
else
ifeq ($(BIARCH),1)
	mkdir -p $(SCRATCH)/zstd/build32
	mkdir -p $(SCRATCH)/zstd/build64
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cp -Rp $(ZSTD_SRC)/lib/* $(SCRATCH)/zstd/build32/ \
	 && \
	 cd $(SCRATCH)/zstd/build32 \
	 && \
	 $(MAKE) CC=gcc CFLAGS="-O3 -m32 $(LTO_OPT)" LDFLAGS="-s -m32 $(LTO_OPT)" \
	  RC="windres -F pe-i386" WINDRES="windres -F pe-i386"
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cp -Rp $(ZSTD_SRC)/lib/* $(SCRATCH)/zstd/build64/ \
	 && \
	 cd $(SCRATCH)/zstd/build64 \
	 && \
	 $(MAKE) CC=gcc CFLAGS="-O3 $(LTO_OPT)" LDFLAGS="-s $(LTO_OPT)"
endif
endif
endif
	touch $@

$(STAMP_ZSTD_HOST_INSTALL): $(STAMP_ZSTD_BUILD)
	@echo "=== gccmaster: Install zstd in scratch toolchain ==="
ifeq ($(BUILD_TYPE),cross)
	cd $(SCRATCH)/zstd \
	 && \
	 install -d -m 755 $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 zstd.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 common/zstd_errors.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 deprecated/zbuff.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 dictBuilder/zdict.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -d -m 755 $(BUILDFROM)/$(HOST)/lib/ && \
	 install -m 644 libzstd.a $(BUILDFROM)/$(HOST)/lib/ && \
	 install -m 644 dll/libzstd.lib $(BUILDFROM)/$(HOST)/lib/libzstd.dll.a && \
	 install -d -m 755 $(BUILDFROM)/$(HOST)/bin/ && \
	 install dll/libzstd.dll $(BUILDFROM)/$(HOST)/bin/
endif
ifeq ($(BUILD_TYPE),native)
ifeq ($(BIARCH),1)
	cd $(SCRATCH)/zstd/build64 \
	 && \
	 install -d -m 755 $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 zstd.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 common/zstd_errors.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 deprecated/zbuff.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 dictBuilder/zdict.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -d -m 755 $(BUILDFROM)/$(HOST)/lib/ && \
	 install -m 644 libzstd.a $(BUILDFROM)/$(HOST)/lib/ && \
	 install -m 644 dll/libzstd.lib $(BUILDFROM)/$(HOST)/lib/libzstd.dll.a && \
	 install -d -m 755 $(BUILDFROM)/$(HOST)/bin/ && \
	 install dll/libzstd.dll $(BUILDFROM)/$(HOST)/bin/
	cd $(SCRATCH)/zstd/build32 \
	 && \
	 install -d -m 755 $(BUILDFROM)/$(HOST)/lib32/ && \
	 install -m 644 libzstd.a $(BUILDFROM)/$(HOST)/lib32/ && \
	 install -m 644 dll/libzstd.lib $(BUILDFROM)/$(HOST)/lib32/libzstd.dll.a && \
	 install -d -m 755 $(BUILDFROM)/$(HOST)/bin32/ && \
	 install dll/libzstd.dll $(BUILDFROM)/$(HOST)/bin32/
else
	cd $(SCRATCH)/zstd/build \
	 && \
	 install -d -m 755 $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 zstd.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 common/zstd_errors.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 deprecated/zbuff.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -m 644 dictBuilder/zdict.h $(BUILDFROM)/$(HOST)/include/ && \
	 install -d -m 755 $(BUILDFROM)/$(HOST)/lib/ && \
	 install -m 644 libzstd.a $(BUILDFROM)/$(HOST)/lib/ && \
	 install -m 644 dll/libzstd.lib $(BUILDFROM)/$(HOST)/lib/libzstd.dll.a && \
	 install -d -m 755 $(BUILDFROM)/$(HOST)/bin/ && \
	 install dll/libzstd.dll $(BUILDFROM)/$(HOST)/bin/
endif
endif
	touch $@

$(STAMP_ZSTD_STAGE_INSTALL): $(STAMP_ZSTD_BUILD)
	@echo "=== gccmaster: Install zstd in staging prefix ==="
ifeq ($(BUILD_TYPE),cross)
	cd $(SCRATCH)/zstd \
	 && \
	 install -d -m 755 $(STAGING_PREFIX)/include/ && \
	 install -m 644 zstd.h $(STAGING_PREFIX)/include/ && \
	 install -m 644 common/zstd_errors.h $(STAGING_PREFIX)/include/ && \
	 install -m 644 deprecated/zbuff.h $(STAGING_PREFIX)/include/ && \
	 install -m 644 dictBuilder/zdict.h $(STAGING_PREFIX)/include/ && \
	 install -d -m 755 $(STAGING_PREFIX)/lib/ && \
	 install -m 644 libzstd.a $(STAGING_PREFIX)/lib/ && \
	 install -m 644 dll/libzstd.lib $(STAGING_PREFIX)/lib/libzstd.dll.a && \
	 install -d -m 755 $(STAGING_PREFIX)/bin/ && \
	 install dll/libzstd.dll $(STAGING_PREFIX)/bin/
endif
ifeq ($(BUILD_TYPE),native)
ifeq ($(BIARCH),1)
	cd $(SCRATCH)/zstd/build64 \
	 && \
	 install -d -m 755 $(STAGING_PREFIX)/$(HOST)/include/ && \
	 install -m 644 zstd.h $(STAGING_PREFIX)/$(HOST)/include/ && \
	 install -m 644 common/zstd_errors.h $(STAGING_PREFIX)/$(HOST)/include/ && \
	 install -m 644 deprecated/zbuff.h $(STAGING_PREFIX)/$(HOST)/include/ && \
	 install -m 644 dictBuilder/zdict.h $(STAGING_PREFIX)/$(HOST)/include/ && \
	 install -d -m 755 $(STAGING_PREFIX)/$(HOST)/lib/ && \
	 install -m 644 libzstd.a $(STAGING_PREFIX)/$(HOST)/lib/ && \
	 install -m 644 dll/libzstd.lib $(STAGING_PREFIX)/$(HOST)/lib/libzstd.dll.a && \
	 install -d -m 755 $(STAGING_PREFIX)/$(HOST)/bin/ && \
	 install dll/libzstd.dll $(STAGING_PREFIX)/$(HOST)/bin/
	cd $(SCRATCH)/zstd/build32 \
	 && \
	 install -d -m 755 $(STAGING_PREFIX)/$(HOST)/lib32/ && \
	 install -m 644 libzstd.a $(STAGING_PREFIX)/$(HOST)/lib32/ && \
	 install -m 644 dll/libzstd.lib $(STAGING_PREFIX)/$(HOST)/lib32/libzstd.dll.a && \
	 install -d -m 755 $(STAGING_PREFIX)/$(HOST)/bin32/ && \
	 install dll/libzstd.dll $(STAGING_PREFIX)/$(HOST)/bin32/
else
	cd $(SCRATCH)/zstd \
	 && \
	 install -d -m 755 $(STAGING_PREFIX)/$(HOST)/include/ && \
	 install -m 644 zstd.h $(STAGING_PREFIX)/$(HOST)/include/ && \
	 install -m 644 common/zstd_errors.h $(STAGING_PREFIX)/$(HOST)/include/ && \
	 install -m 644 deprecated/zbuff.h $(STAGING_PREFIX)/$(HOST)/include/ && \
	 install -m 644 dictBuilder/zdict.h $(STAGING_PREFIX)/$(HOST)/include/ && \
	 install -d -m 755 $(STAGING_PREFIX)/$(HOST)/lib/ && \
	 install -m 644 libzstd.a $(STAGING_PREFIX)/$(HOST)/lib/ && \
	 install -m 644 dll/libzstd.lib $(STAGING_PREFIX)/$(HOST)/lib/libzstd.dll.a && \
	 install -d -m 755 $(STAGING_PREFIX)/$(HOST)/bin/ && \
	 install dll/libzstd.dll $(STAGING_PREFIX)/$(HOST)/bin/
endif
endif
	touch $@


###########
# mingw-get-base
###########
.PHONY: mingw-get-base
mingw-get-base: $(STAMP_MINGW_GET_BASE)

$(STAMP_MINGW_GET_BASE):
ifeq ($(findstring w64,$(HOST)),)
	@echo "=== gccmaster: Set up MinGW.org base in staging prefix with mingw-get ==="
	mkdir -p $(STAGING_PREFIX)
	cp -Rp $(MINGW_GET_ROOT)/* $(STAGING_PREFIX)/
	( \
		cd $(STAGING_PREFIX)/bin && \
		./mingw-get.exe install $(MINGW_BASE_MINGWRT_SPEC) $(MINGW_BASE_W32API_SPEC) $(MINGW_BASE_BINUTILS_SPEC) \
	)
	rm -f $(STAGING_PREFIX)/TOUCH-ME-NOT.txt
endif
	touch $@

###########
# winpthreads
###########
.PHONY: winpthreads winpthreads-stage-install
winpthreads: $(STAMP_WINPTHREADS_BUILD)
winpthreads-stage-install: $(STAMP_WINPTHREADS_STAGE_INSTALL)

ifeq ($(BIARCH),1)
WINPTHREADS_DEFAULT_STAGE := $(SCRATCH)/winpthreads/stage/64
WINPTHREADS_TAG_OPT := "WINPTHREADS_TAG_64=1"
else
WINPTHREADS_DEFAULT_STAGE := $(SCRATCH)/winpthreads/stage
WINPTHREADS_TAG_OPT :=
endif
ifeq ($(BUILD_TYPE),cross)
ifneq ($(findstring x86_64,$(HOST)),)
$(STAMP_WINPTHREADS_BUILD): $(STAMP_GCC_CORE_STAGE_INSTALL)
endif
endif
ifeq ($(BUILD_TYPE),native)
$(STAMP_WINPTHREADS_BUILD): $(STAMP_HOST_TOOLCHAIN_COPY)
endif
$(STAMP_WINPTHREADS_BUILD): $(STAMP_DEFAULT_MANIFEST_HOST_INSTALL)
	@echo "=== gccmaster: Build winpthreads ==="
	rm -fR $(SCRATCH)/winpthreads
	mkdir -p $(SCRATCH)/winpthreads
	mkdir -p $(SCRATCH)/winpthreads/build
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 echo $PATH \
	 && \
	 cd $(SCRATCH)/winpthreads/build \
	 && \
	 $(WINPTHREADS_SRC)/configure --prefix=$(WINPTHREADS_DEFAULT_STAGE) \
	  --build=$(HOST) --host=$(TARGET) $(RUNTIME_SHARED_OPT) CFLAGS="-O0 -g" \
	 && \
	 $(MAKE) && $(MAKE) install
ifeq ($(BIARCH),1)
	mkdir -p $(SCRATCH)/winpthreads/build-alt
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/winpthreads/build-alt \
	 && \
	 $(WINPTHREADS_SRC)/configure --prefix=$(SCRATCH)/winpthreads/stage/32 \
	  --build=$(HOST) --host=$(TARGET) $(RUNTIME_SHARED_OPT) \
	  RC="windres -F pe-i386" CFLAGS="-O0 -g -m32" \
	  LDFLAGS="-m32" \
	 && \
	 $(MAKE) && $(MAKE) install
endif
endif
ifeq ($(BUILD_TYPE),native)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/winpthreads/build \
	 && \
	 $(WINPTHREADS_SRC)/configure --prefix=$(WINPTHREADS_DEFAULT_STAGE) \
	  --build=$(HOST) --host=$(TARGET) --enable-static --enable-shared \
	  CFLAGS="-O2" LDFLAGS="-s" \
	 && \
	 $(MAKE) $(WINPTHREADS_TAG_OPT) \
	 && \
	 $(MAKE) install
	mv -f $(WINPTHREADS_DEFAULT_STAGE)/lib/libpthread.dll.a $(WINPTHREADS_DEFAULT_STAGE)/lib/libpthread_s.dll.a
ifeq ($(BIARCH),1)
	mkdir -p $(SCRATCH)/winpthreads/build-alt
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/winpthreads/build-alt \
	 && \
	 $(WINPTHREADS_SRC)/configure --prefix=$(SCRATCH)/winpthreads/stage/32 \
	  --build=$(HOST) --host=$(TARGET) --enable-static --enable-shared \
	  RC="windres -F pe-i386" CFLAGS="-O2 -m32" \
	  LDFLAGS="-s -m32" \
	 && \
	 $(MAKE) && $(MAKE) install
	mv -f $(SCRATCH)/winpthreads/stage/32/lib/libpthread.dll.a $(SCRATCH)/winpthreads/stage/32/lib/libpthread_s.dll.a
endif
endif
	touch $@

ifneq ($(findstring x86_64,$(HOST)),)
$(STAMP_WINPTHREADS_STAGE_INSTALL): $(STAMP_RUNTIME_STAGE_INSTALL)
endif
$(STAMP_WINPTHREADS_STAGE_INSTALL): $(STAMP_WINPTHREADS_BUILD)
	@echo "=== gccmaster: Install winpthreads in staging prefix ==="
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/winpthreads/stage DEST=$(STAGING_PREFIX)/$(TARGET) \
	 BIARCH=$(BIARCH)
	touch $@


###########
# binutils
###########
.PHONY: binutils binutils-stage-install binutils-pkg-install binutils-distrib
binutils: $(STAMP_BINUTILS_BUILD)
binutils-stage-install: $(STAMP_BINUTILS_STAGE_INSTALL)
binutils-pkg-install: $(STAMP_BINUTILS_PKG_INSTALL)
binutils-distrib: $(STAMP_BINUTILS_DISTRIB)
binutils-manifest: $(STAMP_BINUTILS_MANIFEST)

$(STAMP_BINUTILS_BUILD): $(STAMP_HOST_TOOLCHAIN_COPY) $(STAMP_DEFAULT_MANIFEST_HOST_INSTALL)
	@echo "=== gccmaster: Build binutils ==="
	rm -fR $(SCRATCH)/binutils
	mkdir -p $(SCRATCH)/binutils
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/binutils \
	 && \
	 $(BINUTILS_SRC)/configure --build=$(BUILD) --host=$(HOST) \
	  --target=$(TARGET) $(BINUTILS_TARGETS_OPT) --prefix=$(STAGING_PREFIX) \
	  --disable-nls --disable-gdb \
	  CFLAGS="-O2 -g $(LTO_OPT)" LDFLAGS="$(LTO_OPT)" \
	 && \
	 $(MAKE)
endif
ifeq ($(BUILD_TYPE),native)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/binutils \
	 && \
	 echo "int _dowildcard = -1;" >glob_enable.c \
	 && \
	 gcc -m32 -c -o glob_enable.o glob_enable.c \
	 && \
	 $(BINUTILS_SRC)/configure --prefix=$(STAGING_PREFIX) \
	  --build=$(TARGET) $(BINUTILS_TARGETS_OPT) \
	  --disable-gdb --enable-plugins --disable-shared \
	  --enable-lto --enable-64-bit-bfd --disable-werror --disable-nls \
	  CFLAGS="-O2 -m32 $(LTO_OPT)" \
	  LDFLAGS="-s -m32 $(LTO_OPT) -Wl,$(SCRATCH_WIN)/binutils/glob_enable.o -Wl,--large-address-aware" \
	 && \
	 $(MAKE)
endif
	touch $@

$(STAMP_BINUTILS_STAGE_INSTALL): $(STAMP_BINUTILS_BUILD)
	@echo "=== gccmaster: Install binutils in staging prefix ==="
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/binutils \
	 && \
	 $(MAKE) install
	touch $@

ifeq ($(BUILD_TYPE),native)

$(STAMP_BINUTILS_PKG_INSTALL): $(STAMP_BINUTILS_BUILD)
	@echo "=== gccmaster: Install binutils in package directory ==="
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/binutils \
	 && \
	 $(MAKE) install prefix=$(PKG_BINUTILS)
	touch $@

$(STAMP_BINUTILS_DISTRIB): $(STAMP_BINUTILS_PKG_INSTALL)
	@echo "=== gccmaster: Create binutils distribution ==="
	rm -fR -- $(DISTRIB)/binutils
	mkdir -p -- $(DISTRIB)/binutils
	cp -Rp -- $(PKG_BINUTILS)/* $(DISTRIB)/binutils/
	rm -f -- $(DISTRIB)/binutils/lib/*.la
	rm -f -- $(DISTRIB)/binutils/share/info/dir
	rm -f -- $(DISTRIB)/binutils/master-stamp-*
	$(BUILDFROM)/bin/strip.exe $(DISTRIB)/binutils/bin/*.exe
	cp -Rp -- $(DISTRIB_BASE)/$(EDITION)/binutils/* $(DISTRIB)/binutils/
	cd $(DISTRIB)/binutils \
	 && \
	 rm -f ../binutils-$(BINUTILS_VER)-$(PKGVERSION).zip && \
	 $(SZA) a -tzip -mx9 ../binutils-$(BINUTILS_VER)-$(PKGVERSION).zip * \
	 && \
	 rm -f ../binutils-$(BINUTILS_VER)-$(PKGVERSION).tar.xz && \
	 tar -ahcf ../binutils-$(BINUTILS_VER)-$(PKGVERSION).tar.xz *
	touch $@

ifeq ($(MFTUPDATE_BINUTILS_UNSIZE_ADD),)
MFTUPDATE_BINUTILS_UNSIZE_ADD=0
endif

ifeq ($(EDITION),tdm64)

define MFTUPDATE_BINUTILS
$(NEW_NET_MFT)
System:id|tdm64
Component:id|binutils
Version:id|binutils-.+-tdm64.*
]]>]]>
<Version default="true" id="binutils-::VER::" name="Binutils: ::VER::" unsize="::UNSIZE::">
    <Description>Current Release - binutils-::VER::</Description>
    <Archive path="http://downloads.sourceforge.net/project/tdm-gcc/GNU%20binutils/binutils-::VER::.tar.xz" arcsize="::ARCSIZE::" />
</Version>
]]>]]>
System:id|tdm64
InstallType:id|tdmrec$$
Select:id|binutils-.+-tdm64.*
]]>]]>
<Select id="binutils-::VER::" />
]]>]]>
System:id|tdm64
InstallType:id|tdmrecall
Select:id|binutils-.+-tdm64.*
]]>]]>
<Select id="binutils-::VER::" />
endef

endif
export MFTUPDATE_BINUTILS

$(STAMP_BINUTILS_MANIFEST): $(STAMP_NEW_NET_MANIFEST) $(STAMP_BINUTILS_DISTRIB)
	@echo "=== gccmaster: Update manifest for binutils ==="
	echo "$$MFTUPDATE_BINUTILS" >MFTUPDATE_BINUTILS.txt
	sed -i -e 's/\:\:VER\:\:/$(BINUTILS_VER)-$(PKGVERSION)/g' MFTUPDATE_BINUTILS.txt
	test -d $(DISTRIB)/binutils \
	 && UNSIZE1=`du -bs $(DISTRIB)/binutils | cut -f1` \
	 && UNSIZE2=`expr $$UNSIZE1 + $(MFTUPDATE_BINUTILS_UNSIZE_ADD)` \
	 && sed -i -e "s/\:\:UNSIZE\:\:/$$UNSIZE2/g" MFTUPDATE_BINUTILS.txt
	test -f $(DISTRIB)/binutils-$(BINUTILS_VER)-$(PKGVERSION).tar.xz \
	 && ARCSIZE1=`du -bs $(DISTRIB)/binutils-$(BINUTILS_VER)-$(PKGVERSION).tar.xz | cut -f1` \
	 && sed -i -e "s/\:\:ARCSIZE\:\:/$$ARCSIZE1/g" MFTUPDATE_BINUTILS.txt
	$(BUILD_BASE)/mftu.exe <MFTUPDATE_BINUTILS.txt 1>$(NEW_NET_MFT).new
	rm MFTUPDATE_BINUTILS.txt
	mv $(NEW_NET_MFT).new $(NEW_NET_MFT)
	touch $@

endif
# BUILD_TYPE==native

###########
# runtime
###########
.PHONY: runtime runtime-stage-install runtime-pkg-install
runtime: $(STAMP_RUNTIME_BUILD)
runtime-stage-install: $(STAMP_RUNTIME_STAGE_INSTALL)
runtime-pkg-install: $(STAMP_RUNTIME_PKG_INSTALL)
runtime-distrib: $(STAMP_RUNTIME_DISTRIB)
runtime-manifest: $(STAMP_RUNTIME_MANIFEST)

ifeq ($(BUILD_TYPE),cross)
$(STAMP_RUNTIME_HEADERS_BUILD): $(STAMP_BINUTILS_STAGE_INSTALL)
	@echo "=== Build mingw-w64 runtime headers ==="
	rm -fR $(SCRATCH)/runtime-headers
	mkdir -p $(SCRATCH)/runtime-headers
	export PATH="$(STAGING_PREFIX)/bin:$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/runtime-headers \
	 && \
	 $(RUNTIME_SRC)/mingw-w64-headers/configure --build=$(HOST) \
	  --host=$(TARGET) --prefix=$(STAGING_PREFIX)/$(TARGET) \
	  --enable-secure-api
	touch $@
$(STAMP_RUNTIME_HEADERS_STAGE_INSTALL): $(STAMP_RUNTIME_HEADERS_BUILD)
	@echo "=== gccmaster: Install mingw-w64 runtime headers in staging prefix ==="
	export PATH="$(STAGING_PREFIX)/bin:$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/runtime-headers \
	 && \
	 $(MAKE) install
	touch $@
endif

ifeq ($(BUILD_TYPE),cross)
$(STAMP_RUNTIME_BUILD): $(STAMP_GCC_CORE_STAGE_INSTALL)
endif
$(STAMP_RUNTIME_BUILD): $(STAMP_DEFAULT_MANIFEST_HOST_INSTALL)
	@echo "=== gccmaster: Build mingw-w64 runtime ==="
	rm -fR $(SCRATCH)/runtime
	mkdir -p $(SCRATCH)/runtime
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(STAGING_PREFIX)/bin:$(STAGING_PREFIX)/$(TARGET)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/runtime \
	 && \
	 $(RUNTIME_SRC)/configure --build=$(HOST) --host=$(TARGET) \
	  --prefix=$(STAGING_PREFIX)/$(TARGET) $(ENABLE_LIB32_OPT) \
	  --enable-secure-api \
	 && \
	 $(MAKE)
endif
ifeq ($(BUILD_TYPE),native)
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(TARGET)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/runtime \
	 && \
	 $(RUNTIME_SRC)/configure --build=$(TARGET) $(ENABLE_LIB32_OPT) \
	  --enable-sdk=all --with-libraries=libmangle --with-tools=all --enable-secure-api \
	  --prefix=$(STAGING_PREFIX)/$(TARGET) \
	 && \
	 cd $(SCRATCH)/runtime/mingw-w64-headers \
	 && \
	 $(MAKE) install \
	 && \
	 cd $(SCRATCH)/runtime \
	 && \
	 $(MAKE)
endif
	touch $@

$(STAMP_RUNTIME_STAGE_INSTALL): $(STAMP_RUNTIME_BUILD)
	@echo "=== gccmaster: Install mingw-w64 runtime in staging prefix ==="
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(STAGING_PREFIX)/bin:$(STAGING_PREFIX)/$(TARGET)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/runtime \
	 && \
	 $(MAKE) install
endif
ifeq ($(BUILD_TYPE),native)
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(TARGET)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/runtime \
	 && \
	 $(MAKE) install
endif
	touch $@

ifeq ($(BUILD_TYPE),native)

$(STAMP_RUNTIME_PKG_INSTALL): $(STAMP_RUNTIME_BUILD)
	@echo "=== gccmaster: Install mingw-w64 runtime in package directory ==="
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/runtime \
	 && \
	 $(MAKE) install prefix=$(PKG_RUNTIME)/$(TARGET)
	-rm -f $(PKG_RUNTIME)/$(TARGET)/include/pthread*.h
	touch $@

$(STAMP_RUNTIME_DISTRIB): $(STAMP_RUNTIME_PKG_INSTALL)
	@echo "=== gccmaster: Create runtime distribution ==="
	rm -fR -- $(DISTRIB)/crt
	mkdir -p -- $(DISTRIB)/crt
	cp -Rp -- $(PKG_RUNTIME)/* $(DISTRIB)/crt/
	rm -f -- $(DISTRIB)/crt/master-stamp-*
	cp -Rp -- $(DISTRIB_BASE)/$(EDITION)/crt/* $(DISTRIB)/crt/
	cd $(DISTRIB)/crt \
	 && \
	 rm -f ../mingw64runtime-$(RUNTIME_VER)-$(PKGVERSION).zip && \
	 $(SZA) a -tzip -mx9 ../mingw64runtime-$(RUNTIME_VER)-$(PKGVERSION).zip * \
	 && \
	 rm -f ../mingw64runtime-$(RUNTIME_VER)-$(PKGVERSION).tar.xz && \
	 tar -ahcf ../mingw64runtime-$(RUNTIME_VER)-$(PKGVERSION).tar.xz *
	touch $@

ifeq ($(MFTUPDATE_RUNTIME_UNSIZE_ADD),)
MFTUPDATE_RUNTIME_UNSIZE_ADD=0
endif

ifeq ($(EDITION),tdm64)

define MFTUPDATE_RUNTIME
$(NEW_NET_MFT)
System:id|tdm64
Component:id|mingw64-runtime
Version:id|mingw64-runtime-.+-tdm64.*
]]>]]>
<Version default="true" id="mingw64-runtime-::VER::" name="MinGW-w64 Runtime Snapshot: ::VER::" unsize="::UNSIZE::">
    <Description>MinGW-w64 git-::BRANCH:: for GCC ::GCCSERIES:: multilib</Description>
    <Archive path="http://downloads.sourceforge.net/project/tdm-gcc/MinGW-w64%20runtime/GCC%20::GCCSERIES::%20series/mingw64runtime-::VER::.tar.xz" arcsize="::ARCSIZE::" />
</Version>
]]>]]>
System:id|tdm64
InstallType:id|tdmrec$$
Select:id|mingw64-runtime-.+-tdm64.*
]]>]]>
<Select id="mingw64-runtime-::VER::" />
]]>]]>
System:id|tdm64
InstallType:id|tdmrecall
Select:id|mingw64-runtime-.+-tdm64.*
]]>]]>
<Select id="mingw64-runtime-::VER::" />
endef

endif
export MFTUPDATE_RUNTIME

$(STAMP_RUNTIME_MANIFEST): $(STAMP_NEW_NET_MANIFEST) $(STAMP_RUNTIME_DISTRIB)
	@echo "=== gccmaster: Update manifest for runtime ==="
	echo "$$MFTUPDATE_RUNTIME" >MFTUPDATE_RUNTIME.txt
	sed -i -e 's/\:\:VER\:\:/$(RUNTIME_VER)-$(PKGVERSION)/g' MFTUPDATE_RUNTIME.txt
	sed -i -e 's/\:\:BRANCH\:\:/$(RUNTIME_BRANCH)/g' MFTUPDATE_RUNTIME.txt
	sed -i -e 's/\:\:GCCSERIES\:\:/$(GCC_SERIES)/g' MFTUPDATE_RUNTIME.txt
	test -d $(DISTRIB)/crt \
	 && UNSIZE1=`du -bs $(DISTRIB)/crt | cut -f1` \
	 && UNSIZE2=`expr $$UNSIZE1 + $(MFTUPDATE_RUNTIME_UNSIZE_ADD)` \
	 && sed -i -e "s/\:\:UNSIZE\:\:/$$UNSIZE2/g" MFTUPDATE_RUNTIME.txt
	test -f $(DISTRIB)/mingw64runtime-$(RUNTIME_VER)-$(PKGVERSION).tar.xz \
	 && ARCSIZE1=`du -bs $(DISTRIB)/mingw64runtime-$(RUNTIME_VER)-$(PKGVERSION).tar.xz | cut -f1` \
	 && sed -i -e "s/\:\:ARCSIZE\:\:/$$ARCSIZE1/g" MFTUPDATE_RUNTIME.txt
	$(BUILD_BASE)/mftu.exe <MFTUPDATE_RUNTIME.txt 1>$(NEW_NET_MFT).new
	rm MFTUPDATE_RUNTIME.txt
	mv $(NEW_NET_MFT).new $(NEW_NET_MFT)
	touch $@

endif
#BUILD_TYPE==native


###########
# default-manifest
###########
.PHONY: default-manifest
default-manifest: $(STAMP_DEFAULT_MANIFEST_PKG_INSTALL)

$(STAMP_DEFAULT_MANIFEST_BUILD): $(STAMP_HOST_TOOLCHAIN_COPY)
	@echo "=== gccmaster: Build default-manifest ==="
	rm -fR $(SCRATCH)/default-manifest
	mkdir -p $(SCRATCH)/default-manifest/build
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
		&& cd $(SCRATCH)/default-manifest/build \
		&& $(DEFAULT_MANIFEST_SRC)/configure --prefix=$(BUILDFROM)/$(HOST) --build=$(HOST) \
		&& $(MAKE)
else
ifneq ($(BIARCH),1)
	export PATH=$(HOST_TOOLCHAIN)/bin:$(HOST_TOOLCHAIN)/$(TARGET)/bin:$(PATH) \
		&& cd $(SCRATCH)/default-manifest/build \
		&& $(DEFAULT_MANIFEST_SRC)/configure --prefix=$(SCRATCH)/default-manifest/stage --build=$(HOST) \
		&& $(MAKE) && $(MAKE) install
else
	mkdir -p $(SCRATCH)/default-manifest/build32
	export PATH=$(HOST_TOOLCHAIN)/bin:$(HOST_TOOLCHAIN)/$(TARGET)/bin:$(PATH) \
		&& cd $(SCRATCH)/default-manifest/build32 \
		&& $(DEFAULT_MANIFEST_SRC)/configure --prefix=$(SCRATCH)/default-manifest/stage/32 --build=$(HOST) \
		&& $(MAKE) RC_FLAGS="-F pe-i386" && $(MAKE) install
	export PATH=$(HOST_TOOLCHAIN)/bin:$(HOST_TOOLCHAIN)/$(TARGET)/bin:$(PATH) \
		&& cd $(SCRATCH)/default-manifest/build \
		&& $(DEFAULT_MANIFEST_SRC)/configure --prefix=$(SCRATCH)/default-manifest/stage/64 --build=$(HOST) \
		&& $(MAKE) && $(MAKE) install
endif
endif
	touch $@

$(STAMP_DEFAULT_MANIFEST_HOST_INSTALL): $(STAMP_DEFAULT_MANIFEST_BUILD)
	@echo "=== gccmaster: Install default-manifest in scratch toolchain ==="
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && cd $(SCRATCH)/default-manifest/build \
	 && $(MAKE) install
endif
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/default-manifest/stage DEST=$(BUILDFROM)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@

$(STAMP_DEFAULT_MANIFEST_STAGE_INSTALL): $(STAMP_DEFAULT_MANIFEST_BUILD)
	@echo "=== gccmaster: Install default-manifest in staging prefix ==="
ifeq ($(BUILD_TYPE),cross)
	export PATH="$(BUILDFROM)/bin:$(PATH)" \
	 && $(SCRATCH)/default-manifest/build \
	 && $(MAKE) install prefix=$(STAGING_PREFIX)
endif
ifeq ($(BUILD_TYPE),native)
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/default-manifest/stage DEST=$(STAGING_PREFIX)/$(HOST) BIARCH=$(BIARCH)
endif
	touch $@


ifeq ($(EDITION),tdm32)

define MFTUPDATE_DEFAULT_MANIFEST
$(NEW_NET_MFT)
System:id|tdm32
Component:id|default-manifest
Version:id|windows-default-manifest-.+-x86
]]>]]>
<Version default="true" id="windows-default-manifest-::VER::-x86" name="TDM Current: ::VER::" unsize="::UNSIZE::">
	<Description>Current release - ::VER::</Description>
	<Archive path="http://downloads.sourceforge.net/project/tdm-gcc/Windows%20default%20manifest/windows-default-manifest-::VER::-x86.tar.xz" arcsize="::ARCSIZE::" />
</Version>
]]>]]>
System:id|tdm32
InstallType:id|tdmrec$$
Select:id|windows-default-manifest-.+-x86
]]>]]>
<Select id="windows-default-manifest-::VER::-x86" />
]]>]]>
System:id|tdm32
InstallType:id|tdmrecall$$
Select:id|windows-default-manifest-.+-x86
]]>]]>
<Select id="windows-default-manifest-::VER::-x86" />
endef

else

define MFTUPDATE_DEFAULT_MANIFEST
$(NEW_NET_MFT)
System:id|tdm64
Component:id|default-manifest
Version:id|windows-default-manifest-.+-x86_64_multi
]]>]]>
<Version default="true" id="windows-default-manifest-::VER::-x86_64_multi" name="TDM64 Current: ::VER::" unsize="::UNSIZE::">
	<Description>Current release - ::VER::</Description>
	<Archive path="http://downloads.sourceforge.net/project/tdm-gcc/Windows%20default%20manifest/windows-default-manifest-::VER::-x86_64_multi.tar.xz" arcsize="::ARCSIZE::" />
</Version>
]]>]]>
System:id|tdm64
InstallType:id|tdmrec$$
Select:id|windows-default-manifest-.+-x86_64_multi
]]>]]>
<Select id="windows-default-manifest-::VER::-x86_64_multi" />
]]>]]>
System:id|tdm64
InstallType:id|tdmrecall$$
Select:id|windows-default-manifest-.+-x86_64_multi
]]>]]>
<Select id="windows-default-manifest-::VER::-x86_64_multi" />
endef

endif
export MFTUPDATE_DEFAULT_MANIFEST

ifeq ($(BUILD_TYPE),native)
$(STAMP_DEFAULT_MANIFEST_PKG_INSTALL): $(STAMP_DEFAULT_MANIFEST_BUILD)
	@echo "=== gccmaster: Install default-manifest in distrib directory ==="
	mkdir -p -- $(DISTRIB)/default-manifest
	cp -Rp -- $(DISTRIB_BASE)/$(EDITION)/default-manifest/* $(DISTRIB)/default-manifest/
	$(MAKE) -f $(THIS_MAKEFILE_DIR)/install_from_stage.makefile \
	 SRC=$(SCRATCH)/default-manifest/stage DEST=$(DISTRIB)/default-manifest/$(TARGET) BIARCH=$(BIARCH)
	touch $@
$(STAMP_DEFAULT_MANIFEST_DISTRIB): $(STAMP_DEFAULT_MANIFEST_PKG_INSTALL)
	@echo "=== gccmaster: Create default-manifest distribution ==="
	cd $(DISTRIB)/default-manifest \
	 && \
	 rm -f ../windows-default-manifest-$(DEFAULT_MANIFEST_VER)-$(DEFAULT_MANIFEST_ARCH).zip && \
	 $(SZA) a -tzip -mx9 ../windows-default-manifest-$(DEFAULT_MANIFEST_VER)-$(DEFAULT_MANIFEST_ARCH).zip * \
	 && \
	 rm -f ../windows-default-manifest-$(DEFAULT_MANIFEST_VER)-$(DEFAULT_MANIFEST_ARCH).tar.xz && \
	 tar -ahcf ../windows-default-manifest-$(DEFAULT_MANIFEST_VER)-$(DEFAULT_MANIFEST_ARCH).tar.xz *
	touch $@
$(STAMP_DEFAULT_MANIFEST_MFTUPDATE): $(STAMP_NEW_NET_MANIFEST) $(STAMP_DEFAULT_MANIFEST_DISTRIB)
	@echo "=== gccmaster: Update manifest for default-manifest package ==="
	echo "$$MFTUPDATE_DEFAULT_MANIFEST" >MFTUPDATE_DEFAULT_MANIFEST.txt
	sed -i -e 's/\:\:VER\:\:/$(DEFAULT_MANIFEST_VER)/g' MFTUPDATE_DEFAULT_MANIFEST.txt
	test -d $(DISTRIB)/default-manifest \
	 && UNSIZE1=`du -bs $(DISTRIB)/default-manifest | cut -f1` \
	 && UNSIZE2=`expr $$UNSIZE1 + $(MFTUPDATE_GCC_DEFAULT_MANIFEST_UNSIZE_ADD)` \
	 && sed -i -e "s/\:\:UNSIZE\:\:/$$UNSIZE2/g" MFTUPDATE_DEFAULT_MANIFEST.txt
	test -f $(DISTRIB)/windows-default-manifest-$(DEFAULT_MANIFEST_VER)-$(DEFAULT_MANIFEST_ARCH).tar.xz \
	 && ARCSIZE1=`du -bs $(DISTRIB)/windows-default-manifest-$(DEFAULT_MANIFEST_VER)-$(DEFAULT_MANIFEST_ARCH).tar.xz | cut -f1` \
	 && sed -i -e "s/\:\:ARCSIZE\:\:/$$ARCSIZE1/g" MFTUPDATE_DEFAULT_MANIFEST.txt
	$(BUILD_BASE)/mftu.exe <MFTUPDATE_DEFAULT_MANIFEST.txt 1>$(NEW_NET_MFT).new
	rm MFTUPDATE_DEFAULT_MANIFEST.txt
	mv $(NEW_NET_MFT).new $(NEW_NET_MFT)
	touch $@
endif

###########
# stage-copy32
###########
.PHONY: stage-copy32
stage-copy32: $(STAMP_STAGE_COPY32)

ifeq ($(BUILD_TYPE),cross)
ifeq ($(findstring w64,$(TARGET)),)
$(STAMP_STAGE_COPY32): $(STAMP_MINGW_GET_BASE)
$(STAMP_STAGE_COPY32): $(STAMP_GMP_HOST_INSTALL) $(STAMP_MPFR_HOST_INSTALL)
$(STAMP_STAGE_COPY32): $(STAMP_MPC_HOST_INSTALL) $(STAMP_DEFAULT_MANIFEST_STAGE_INSTALL)
else
$(STAMP_STAGE_COPY32): $(STAMP_RUNTIME_STAGE_INSTALL)
$(STAMP_STAGE_COPY32): $(STAMP_DEFAULT_MANIFEST_STAGE_INSTALL)
endif
ifeq ($(THREAD_TYPE),posix)
$(STAMP_STAGE_COPY32): $(STAMP_WINPTHREADS_STAGE_INSTALL)
endif
endif

ifeq ($(BUILD_TYPE),native)
$(STAMP_STAGE_COPY32): $(STAMP_GMP_STAGE_INSTALL) $(STAMP_MPFR_STAGE_INSTALL)
$(STAMP_STAGE_COPY32): $(STAMP_MPC_STAGE_INSTALL) $(STAMP_ISL_STAGE_INSTALL)
#$(STAMP_STAGE_COPY32): $(STAMP_CLOOG_STAGE_INSTALL)
$(STAMP_STAGE_COPY32): $(STAMP_LIBICONV_STAGE_INSTALL)
$(STAMP_STAGE_COPY32): $(STAMP_WINPTHREADS_STAGE_INSTALL)
$(STAMP_STAGE_COPY32): $(STAMP_DEFAULT_MANIFEST_STAGE_INSTALL)
ifeq ($(findstring w64,$(TARGET)),)
$(STAMP_STAGE_COPY32): $(STAMP_MINGW_GET_BASE)
else
$(STAMP_STAGE_COPY32): $(STAMP_BINUTILS_STAGE_INSTALL)
$(STAMP_STAGE_COPY32): $(STAMP_RUNTIME_STAGE_INSTALL)
endif
endif

$(STAMP_STAGE_COPY32):
ifeq ($(BIARCH),1)
	@echo "=== gccmaster: Copy staging prefix TARGET/lib32 to TARGET/lib/32 ==="
	mkdir -p $(STAGING_PREFIX)/$(TARGET)/lib/32
	cp -Rp $(STAGING_PREFIX)/$(TARGET)/lib32/* $(STAGING_PREFIX)/$(TARGET)/lib/32/
endif
	touch $@


###########
# gcc
###########
.PHONY: gcc gcc-stage-install gcc-pkg-install gcc-distrib gcc-manifest
gcc: $(STAMP_GCC_BUILD)
gcc-stage-install: $(STAMP_GCC_STAGE_INSTALL)
gcc-pkg-install: $(STAMP_GCC_PKG_INSTALL)
gcc-distrib: $(STAMP_GCC_DISTRIB)
gcc-manifest: $(STAMP_GCC_MANIFEST)

ifeq ($(BUILD_TYPE),cross)
$(STAMP_GCC_CORE_BUILD): $(STAMP_HOST_TOOLCHAIN_COPY) $(STAMP_GMP_HOST_INSTALL)
$(STAMP_GCC_CORE_BUILD): $(STAMP_MPFR_HOST_INSTALL) $(STAMP_MPC_HOST_INSTALL)
$(STAMP_GCC_CORE_BUILD): $(STAMP_LIBICONV_STAGE_INSTALL) $(STAMP_DEFAULT_MANIFEST_HOST_INSTALL)
ifneq ($(findstring w64,$(TARGET)),)
$(STAMP_GCC_CORE_BUILD): $(STAMP_BINUTILS_STAGE_INSTALL)
$(STAMP_GCC_CORE_BUILD): $(STAMP_RUNTIME_HEADERS_STAGE_INSTALL)
endif
$(STAMP_GCC_CORE_BUILD):
	@echo "=== gccmaster: Build gcc core ==="
	rm -fR $(SCRATCH)/gcc-$(EXCEPTIONS)
	mkdir -p $(SCRATCH)/gcc-$(EXCEPTIONS)
	export PATH="$(BUILDFROM)/bin:$(BUILD_TOOLCHAIN)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(GCC_SRC)/configure --build=$(BUILD) --host=$(HOST) $(GCC_TARGETS_OPT) \
	  --target=$(TARGET) --prefix=$(STAGING_PREFIX) $(RUNTIME_SHARED_OPT) \
	  --enable-languages=$(LANGS) --disable-werror --with-gnu-ld \
	  --disable-nls --disable-win32-registry --disable-bootstrap \
	  $(EXCEPTIONS_OPT) --enable-threads=$(THREAD_TYPE) \
	 && \
	 $(MAKE) all-gcc ADA_CFLAGS=-fpermissive CFLAGS="-O0 -g $(LTO_OPT)" \
	  LDFLAGS="$(LTO_OPT)"
	touch $@
$(STAMP_GCC_CORE_STAGE_INSTALL): $(STAMP_GCC_CORE_BUILD)
	@echo "=== gccmaster: Install gcc core in staging prefix ==="
	export PATH="$(BUILDFROM)/bin:$(BUILD_TOOLCHAIN)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(MAKE) install-gcc
	touch $@
endif

$(STAMP_GCC_BUILD): $(STAMP_STAGE_COPY32)
ifeq ($(BUILD_TYPE),native)
$(STAMP_GCC_BUILD): $(STAMP_GMP_HOST_INSTALL) $(STAMP_MPFR_HOST_INSTALL)
$(STAMP_GCC_BUILD): $(STAMP_MPC_HOST_INSTALL) $(STAMP_ISL_HOST_INSTALL)
#$(STAMP_GCC_BUILD): $(STAMP_CLOOG_HOST_INSTALL)
$(STAMP_GCC_BUILD): $(STAMP_LIBICONV_HOST_INSTALL) $(STAMP_WINPTHREADS_STAGE_INSTALL)
$(STAMP_GCC_BUILD): $(STAMP_DEFAULT_MANIFEST_HOST_INSTALL)
endif

$(STAMP_GCC_BUILD):
	@echo "=== gccmaster: Build gcc ==="
ifeq ($(BUILD_TYPE),cross)
ifeq ($(findstring w64,$(TARGET)),)
	rm -fR $(SCRATCH)/gcc-$(EXCEPTIONS)
	mkdir -p $(SCRATCH)/gcc-$(EXCEPTIONS)
	export PATH="$(BUILDFROM)/bin:$(BUILD_TOOLCHAIN)/bin:$(PATH)" && \
	 export LPATH="$(STAGING_PREFIX)/lib;$(STAGING_PREFIX)/$(TARGET)/lib;$(BUILDFROM)/lib" && \
	 export CPATH="$(STAGING_PREFIX)/include;$(STAGING_PREFIX)/$(TARGET)/include;$(BUILDFROM)/include;$(BUILDFROM)/$(TARGET)/include" \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(GCC_SRC)/configure --build=$(BUILD) --host=$(HOST) $(GCC_TARGETS_OPT) \
	  --target=$(TARGET) --prefix=$(STAGING_PREFIX) $(RUNTIME_SHARED_OPT) \
	  --enable-languages=$(LANGS) --disable-werror --with-gnu-ld \
	  --enable-nls --disable-win32-registry --disable-bootstrap \
	  --enable-graphite --enable-libstdcxx-filesystem-ts=yes \
	  --enable-libstdcxx-time=yes --enable-checking=release \
	  $(EXCEPTIONS_OPT) --enable-threads=$(THREAD_TYPE) \
	 && \
	 $(MAKE) ADA_CFLAGS=-fpermissive CFLAGS="-O0 -g $(LTO_OPT)" \
	  LDFLAGS="$(LTO_OPT)"
else
	export PATH="$(BUILDFROM)/bin:$(BUILD_TOOLCHAIN)/bin:$(PATH)" && \
	 export LPATH="$(STAGING_PREFIX)/lib;$(STAGING_PREFIX)/$(TARGET)/lib;$(BUILDFROM)/lib" && \
	 export CPATH="$(STAGING_PREFIX)/include;$(STAGING_PREFIX)/$(TARGET)/include;$(BUILDFROM)/include;$(BUILDFROM)/$(TARGET)/include" \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(MAKE) ADA_CFLAGS=-fpermissive CFLAGS="-O0 -g $(LTO_OPT)" \
	  LDFLAGS="$(LTO_OPT)"
endif
endif
ifeq ($(BUILD_TYPE),native)
	rm -fR $(SCRATCH)/gcc-$(EXCEPTIONS)
	mkdir -p $(SCRATCH)/gcc-$(EXCEPTIONS)
ifeq ($(findstring w64,$(TARGET)),)
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(TARGET)/bin:$(PATH)" && \
	 export LPATH="$(STAGING_PREFIX)/lib;$(STAGING_PREFIX)/$(TARGET)/lib;$(BUILDFROM)/lib" && \
	 export CPATH="$(STAGING_PREFIX)/include;$(STAGING_PREFIX)/$(TARGET)/include" \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(GCC_SRC)/configure --build=$(BUILD) --enable-languages=$(LANGS) \
	  --enable-libgomp --enable-lto --enable-graphite --enable-libstdcxx-debug \
	  --enable-threads=$(THREAD_TYPE) --enable-version-specific-runtime-libs \
	  --enable-fully-dynamic-string --enable-libstdcxx-threads --disable-build-format-warnings \
	  --enable-libstdcxx-time --with-gnu-ld --disable-werror --enable-nls \
	  --disable-win32-registry --disable-symvers --enable-large-address-aware \
	  --enable-cxx-flags='-fno-function-sections -fno-data-sections -DWINPTHREAD_STATIC' \
	  --enable-libstdcxx-filesystem-ts=yes --enable-libstdcxx-time=yes \
	  --enable-checking=release \
	  --prefix=$(STAGING_PREFIX) --with-local-prefix=$(STAGING_PREFIX) \
	  $(PKGVERSION_OPT) $(EXCEPTIONS_OPT) \
	  --with-bugurl="http://tdm-gcc.tdragon.net/bugs" \
	 && \
	 $(MAKE) bootstrap \
	  CFLAGS="-O2 $(LTO_OPT) -D__USE_MINGW_ACCESS -DWINPTHREAD_STATIC" \
	  BOOT_CFLAGS="-O2 $(LTO_OPT) -D__USE_MINGW_ACCESS -DWINPTHREAD_STATIC" \
	  CFLAGS_FOR_TARGET="-O2 $(LTO_OPT) -D__USE_MINGW_ACCESS -DWINPTHREAD_STATIC" \
	  CXXFLAGS="-mthreads -O2 $(LTO_OPT) -D__USE_MINGW_ACCESS -DWINPTHREAD_STATIC" \
	  BOOT_CXXFLAGS="-mthreads -O2 $(LTO_OPT) -D__USE_MINGW_ACCESS -DWINPTHREAD_STATIC" \
	  CXXFLAGS_FOR_TARGET="-mthreads -O2 $(LTO_OPT) -D__USE_MINGW_ACCESS -DWINPTHREAD_STATIC" \
	  BOOT_LDFLAGS="-s $(LTO_OPT) -Wl,--large-address-aware -Wl,--exclude-libs,libpthread.a" \
	  LDFLAGS_FOR_TARGET="-s $(LTO_OPT) -Wl,--large-address-aware -Wl,--exclude-libs,libpthread.a" \
	  ADA_CFLAGS="-fpermissive"
else
ifeq ($(BIARCH),1)
# First expected fail - libcpp.a non-32-bit causing genmatch.exe link fail
	-export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(TARGET)/bin32:$(BUILDFROM)/$(TARGET)/bin:$(PATH)" && \
	 export LPATH="$(STAGING_PREFIX)/lib;$(STAGING_PREFIX)/$(TARGET)/lib;$(BUILDFROM)/lib" && \
	 export CPATH="$(STAGING_PREFIX)/include;$(STAGING_PREFIX)/$(TARGET)/include" \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(GCC_SRC)/configure --build=$(BUILD) $(GCC_TARGETS_OPT) \
	  --enable-languages=$(LANGS) --enable-libgomp --enable-lto \
	  --enable-graphite --enable-cxx-flags=-DWINPTHREAD_STATIC \
	  --disable-build-with-cxx --disable-build-poststage1-with-cxx \
	  --enable-libstdcxx-debug --enable-threads=$(THREAD_TYPE) \
	  --enable-version-specific-runtime-libs --enable-fully-dynamic-string \
	  --enable-libstdcxx-threads --enable-libstdcxx-time --with-gnu-ld \
	  --disable-werror --disable-nls --disable-win32-registry \
	  --enable-large-address-aware --disable-rpath --disable-symvers \
	  --prefix=$(STAGING_PREFIX) --with-local-prefix=$(STAGING_PREFIX) \
	  $(PKGVERSION_OPT) $(EXCEPTIONS_OPT) \
	  --with-bugurl="http://tdm-gcc.tdragon.net/bugs" \
	 && \
	 $(MAKE) bootstrap \
	  STAGE1_CFLAGS=-m32 STAGE1_CXXFLAGS=-m32 STAGE1_LDFLAGS=-m32 \
	  CFLAGS_FOR_BUILD=-m32 CXXFLAGS_FOR_BUILD=-m32 LDFLAGS_FOR_BUILD=-m32 \
	  CFLAGS_FOR_TARGET="-O2 -DWINPTHREAD_STATIC" \
	  CXXFLAGS_FOR_TARGET="-O2 -DWINPTHREAD_STATIC" \
	  LDFLAGS_FOR_TARGET=-Wl,--exclude-libs,libpthread.a
	test -f $(SCRATCH)/gcc-$(EXCEPTIONS)/gcc/build/genmatch.o
	test -n $(SCRATCH)/gcc-$(EXCEPTIONS)/gcc/build/genmatch.exe
	rm -f $(SCRATCH)/gcc-$(EXCEPTIONS)/build-$(TARGET)/libcpp/*.o
# Second expected fail - stage 3 fixincludes exe non-32-bit link fail
	-export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(TARGET)/bin32:$(BUILDFROM)/$(TARGET)/bin:$(PATH)" && \
	 export LPATH="$(STAGING_PREFIX)/lib;$(STAGING_PREFIX)/$(TARGET)/lib;$(BUILDFROM)/lib" && \
	 export LIBRARY_PATH="$(SCRATCH)/gcc-$(EXCEPTIONS)/prev-$(TARGET)/32/libgcc;$(SCRATCH)/gcc-$(EXCEPTIONS)/prev-$(TARGET)/libgcc;$(SCRATCH)/gcc-$(EXCEPTIONS)/prev-$(TARGET)/32/libstdc++-v3/src/.libs;$(SCRATCH)/gcc-$(EXCEPTIONS)/prev-$(TARGET)/libstdc++-v3/libsupc++/.libs" && \
	 export CPATH="$(STAGING_PREFIX)/include;$(STAGING_PREFIX)/$(TARGET)/include" \
	 && \
	 $(MAKE) -C $(SCRATCH)/gcc-$(EXCEPTIONS)/build-$(TARGET)/libcpp CXXFLAGS=-m32 \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(MAKE) bootstrap \
	  STAGE1_CFLAGS=-m32 STAGE1_CXXFLAGS=-m32 STAGE1_LDFLAGS=-m32 \
	  CFLAGS_FOR_BUILD=-m32 CXXFLAGS_FOR_BUILD=-m32 LDFLAGS_FOR_BUILD=-m32 \
	  BOOT_CFLAGS="-O2 -m32 -DWINPTHREAD_STATIC \
	   -isystem ../prev-$(TARGET)/32/libstdc++-v3/include/$(TARGET) \
	   -isystem ../prev-$(TARGET)/32/libstdc++-v3/include \
	   -isystem ../prev-$(TARGET)/libstdc++-v3/include/$(TARGET) \
	   -isystem ../prev-$(TARGET)/libstdc++-v3/include \
	   -isystem $(STAGING_PREFIX)/$(TARGET)/include" \
	  BOOT_CXXFLAGS="-O2 -m32 -DWINPTHREAD_STATIC" \
	  BOOT_LDFLAGS="-s -m32 $(LTO_OPT) -Wl,--exclude-libs,libpthread.a" \
	  CFLAGS_FOR_TARGET="-O2 -DWINPTHREAD_STATIC" \
	  CXXFLAGS_FOR_TARGET="-O2 -DWINPTHREAD_STATIC" \
	  LDFLAGS_FOR_TARGET="$(LTO_OPT) -Wl,--exclude-libs,libpthread.a" \
	  ADA_CFLAGS=-fpermissive
	test -f $(SCRATCH)/gcc-$(EXCEPTIONS)/fixincludes/fixincl.o
	test -n $(SCRATCH)/gcc-$(EXCEPTIONS)/fixincludes/fixincl.exe
	rm -f $(SCRATCH)/gcc-$(EXCEPTIONS)/fixincludes/*.o
# Final attempt - should succeed
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(TARGET)/bin32:$(BUILDFROM)/$(TARGET)/bin:$(PATH)" && \
	 export LPATH="$(STAGING_PREFIX)/lib;$(STAGING_PREFIX)/$(TARGET)/lib" && \
	 export LIBRARY_PATH="$(SCRATCH)/gcc-$(EXCEPTIONS)/prev-$(TARGET)/32/libgcc;$(SCRATCH)/gcc-$(EXCEPTIONS)/prev-$(TARGET)/libgcc;$(SCRATCH)/gcc-$(EXCEPTIONS)/prev-$(TARGET)/32/libstdc++-v3/src/.libs" && \
	 export CPATH="$(STAGING_PREFIX)/include;$(STAGING_PREFIX)/$(TARGET)/include" \
	 && \
	 $(MAKE) -C $(SCRATCH)/gcc-$(EXCEPTIONS)/fixincludes CFLAGS=-m32 LDFLAGS=-m32 \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(MAKE) bootstrap \
	  STAGE1_CFLAGS=-m32 STAGE1_CXXFLAGS=-m32 STAGE1_LDFLAGS=-m32 \
	  CFLAGS_FOR_BUILD=-m32 CXXFLAGS_FOR_BUILD=-m32 LDFLAGS_FOR_BUILD=-m32 \
	  BOOT_CFLAGS="-O2 -m32 -DWINPTHREAD_STATIC" \
	  BOOT_CXXFLAGS="-O2 -m32 -DWINPTHREAD_STATIC" \
	  BOOT_LDFLAGS="-s -m32 $(LTO_OPT) -Wl,--exclude-libs,libpthread.a" \
	  CFLAGS_FOR_TARGET="-O2 -DWINPTHREAD_STATIC" \
	  CXXFLAGS_FOR_TARGET="-O2 -DWINPTHREAD_STATIC" \
	  LDFLAGS_FOR_TARGET="$(LTO_OPT) -Wl,--exclude-libs,libpthread.a" \
	  ADA_CFLAGS=-fpermissive GNATTOOLS_NATIVE_CFLAGS="-O2 -m32" \
	  GNATTOOLS_NATIVE_LDFLAGS="-s -m32" GNATTOOLS_NATIVE_MULTISUBDIR=/32 \
	  GNATTOOLS_NATIVE_GCC_LINK_FLAGS="-s -m32" \
	  GNATTOOLS_NATIVE_RTS_SUFFIX=_32
endif
endif
endif
	touch $@

$(STAMP_GCC_STAGE_INSTALL): $(STAMP_GCC_BUILD)
	@echo "=== gccmaster: Install gcc in staging prefix ==="
ifeq ($(findstring w64,$(TARGET)),)
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(TARGET)/bin:$(PATH)" && \
	 export LPATH="$(STAGING_PREFIX)/lib;$(STAGING_PREFIX)/$(TARGET)/lib;$(BUILDFROM)/lib" && \
	 export CPATH="$(STAGING_PREFIX)/include;$(STAGING_PREFIX)/$(TARGET)/include" \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(MAKE) install
else
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(TARGET)/bin32:$(BUILDFROM)/$(TARGET)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(MAKE) install
endif
	touch $@

ifeq ($(BUILD_TYPE),native)

$(STAMP_GCC_PKG_INSTALL): $(STAMP_GCC_BUILD)
	@echo "=== gccmaster: Install gcc in package directory ==="
	rm -fR $(PKG_GCC)
ifeq ($(findstring w64,$(TARGET)),)
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(TARGET)/bin:$(PATH)" && \
	 export LPATH="$(STAGING_PREFIX)/lib;$(STAGING_PREFIX)/$(TARGET)/lib;$(BUILDFROM)/lib" && \
	 export CPATH="$(STAGING_PREFIX)/include;$(STAGING_PREFIX)/$(TARGET)/include" \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(MAKE) install prefix=$(PKG_GCC)
else
	export PATH="$(BUILDFROM)/bin:$(BUILDFROM)/$(TARGET)/bin32:$(BUILDFROM)/$(TARGET)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/gcc-$(EXCEPTIONS) \
	 && \
	 $(MAKE) install prefix=$(PKG_GCC)
endif
	touch $@

ifeq ($(findstring w64,$(TARGET)),)
ifeq ($(EXCEPTIONS),dw2)
$(STAMP_GCC_DISTRIB): $(STAMP_DISTRIB_LIBGCC_32_DW2_DLL)
$(STAMP_DISTRIB_LIBGCC_32_DW2_DLL):
	@echo "=== gccmaster: Build libgcc DW2 DLL package ==="
	rm -fR -- $(DISTRIB)/libgcc_dll/*
	mkdir -p -- $(DISTRIB)/libgcc_dll/bin
	cp -p -- $(PKG_GCC)/bin/libgcc_s_dw2-*.dll $(DISTRIB)/libgcc_dll/bin/
	cp -Rp -- $(DISTRIB_BASE)/$(EDITION)/libgcc_dll/* $(DISTRIB)/libgcc_dll/
	cd $(DISTRIB)/libgcc_dll \
		&& \
		rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-libgcc.tar.xz && \
		tar -ahcf ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-libgcc.tar.xz *
	touch $@
endif
endif

$(STAMP_GCC_DISTRIB): $(STAMP_GCC_PKG_INSTALL)
	@echo "=== gccmaster: Create GCC distribution ==="
	rm -fR -- $(DISTRIB)/ada
	rm -fR -- $(DISTRIB)/c++
	rm -fR -- $(DISTRIB)/core
	rm -fR -- $(DISTRIB)/fortran
	rm -fR -- $(DISTRIB)/objc
	rm -fR -- $(DISTRIB)/openmp
	rm -fR -- $(DISTRIB)/default-manifest
	mkdir -p -- $(DISTRIB)/core
	cp -Rp -- $(PKG_GCC)/* $(DISTRIB)/core/
	rmdir -- $(DISTRIB)/core/include
	rm -fR -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/debug
	rm -fR -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/debug
ifneq ($(findstring w64,$(TARGET)),)
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/lib/libgcc_s.a $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	rmdir -- $(DISTRIB)/core/lib/gcc/$(TARGET)/lib
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/lib32/libgcc_s.a $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/
	rmdir -- $(DISTRIB)/core/lib/gcc/$(TARGET)/lib32
# if these DLLs are failing to materialize, did you forget to apply libs64.patch in gcc and/or winpthreads?
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/*.dll $(DISTRIB)/core/bin/
	rm -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/*.la
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/*.dll $(DISTRIB)/core/bin/
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/adalib/*.dll $(DISTRIB)/core/bin/
endif
	rm -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/*.la
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/adalib/*.dll $(DISTRIB)/core/bin/
	rm -f -- $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/*.la
	rm -f -- $(DISTRIB)/core/share/info/dir
ifeq ($(findstring w64,$(TARGET)),)
	cp -p -- $(SCRATCH)/gmp/stage/bin/libgmp-*.dll $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	cp -p -- $(SCRATCH)/isl/stage/bin/libisl-*.dll $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	cp -p -- $(SCRATCH)/libiconv/stage/bin/libiconv-*.dll $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	cp -p -- $(SCRATCH)/libiconv/stage/bin/libiconv-*.dll $(DISTRIB)/core/bin/
	cp -p -- $(SCRATCH)/mpc/stage/bin/libmpc-*.dll $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	cp -p -- $(SCRATCH)/mpfr/stage/bin/libmpfr-*.dll $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	mkdir -p -- $(DISTRIB)/core/lib
	cp -p -- $(SCRATCH)/winpthreads/stage/bin/*.dll $(DISTRIB)/core/bin/
	cp -p -- $(SCRATCH)/winpthreads/stage/lib/*.a $(DISTRIB)/core/lib/
	cp -Rp -- $(SCRATCH)/winpthreads/stage/include $(DISTRIB)/core/
else
	mkdir -p -- $(DISTRIB)/core/lib/bfd-plugins/
	cp -p -- $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/liblto_plugin-*.dll $(DISTRIB)/core/lib/bfd-plugins/
	cp -p -- $(SCRATCH)/gmp/stage/32/bin/libgmp-*.dll $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	cp -p -- $(SCRATCH)/isl/stage/32/bin/libisl-*.dll $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	cp -p -- $(SCRATCH)/libiconv/stage/32/bin/libiconv-*.dll $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	cp -p -- $(SCRATCH)/libiconv/stage/32/bin/libiconv-*.dll $(DISTRIB)/core/bin/
	cp -p -- $(SCRATCH)/mpc/stage/32/bin/libmpc-*.dll $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	cp -p -- $(SCRATCH)/mpfr/stage/32/bin/libmpfr-*.dll $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	mkdir -p -- $(DISTRIB)/core/$(TARGET)/lib32
	cp -p -- $(SCRATCH)/winpthreads/stage/32/lib/*.a $(DISTRIB)/core/$(TARGET)/lib32/
	cp -p -- $(SCRATCH)/winpthreads/stage/32/lib/*.dll $(DISTRIB)/core/bin/
	cp -Rp -- $(SCRATCH)/winpthreads/stage/64/include $(DISTRIB)/core/$(TARGET)/
	mkdir -p -- $(DISTRIB)/core/$(TARGET)/lib
	cp -p -- $(SCRATCH)/winpthreads/stage/64/lib/*.a $(DISTRIB)/core/$(TARGET)/lib/
	cp -p -- $(SCRATCH)/winpthreads/stage/64/lib/*.dll $(DISTRIB)/core/bin/
	$(BUILDFROM)/bin/strip.exe $(DISTRIB)/core/lib/bfd-plugins/*.dll
endif
	$(BUILDFROM)/bin/strip.exe $(DISTRIB)/core/bin/*.exe
	$(BUILDFROM)/bin/strip.exe $(DISTRIB)/core/bin/*.dll
	$(BUILDFROM)/bin/strip.exe $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/*.exe
	$(BUILDFROM)/bin/strip.exe $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/*.dll
	mkdir -p -- $(DISTRIB)/ada
	cp -Rp -- $(DISTRIB_BASE)/$(EDITION)/ada/* $(DISTRIB)/ada/
	mkdir -p -- $(DISTRIB)/c++
	cp -Rp -- $(DISTRIB_BASE)/$(EDITION)/c++/* $(DISTRIB)/c++/
	mkdir -p -- $(DISTRIB)/core
	cp -Rp -- $(DISTRIB_BASE)/$(EDITION)/core/* $(DISTRIB)/core/
	mkdir -p -- $(DISTRIB)/fortran
	cp -Rp -- $(DISTRIB_BASE)/$(EDITION)/fortran/* $(DISTRIB)/fortran/
	mkdir -p -- $(DISTRIB)/objc
	cp -Rp -- $(DISTRIB_BASE)/$(EDITION)/objc/* $(DISTRIB)/objc/
	mkdir -p -- $(DISTRIB)/openmp
	cp -Rp -- $(DISTRIB_BASE)/$(EDITION)/openmp/* $(DISTRIB)/openmp/
	mkdir -p -- $(DISTRIB)/ada/bin
	mv -f -- $(DISTRIB)/core/bin/*gnat* $(DISTRIB)/ada/bin/
	mv -f -- $(DISTRIB)/core/bin/*gnarl* $(DISTRIB)/ada/bin/
	mkdir -p -- $(DISTRIB)/c++/bin
	mv -f -- $(DISTRIB)/core/bin/*++* $(DISTRIB)/c++/bin/
	mkdir -p -- $(DISTRIB)/fortran/bin
	mv -f -- $(DISTRIB)/core/bin/*fortran* $(DISTRIB)/fortran/bin/
	mkdir -p -- $(DISTRIB)/objc/bin
	mv -f -- $(DISTRIB)/core/bin/*objc* $(DISTRIB)/objc/bin/
	mkdir -p -- $(DISTRIB)/openmp/bin
	mv -f -- $(DISTRIB)/core/bin/*gomp* $(DISTRIB)/openmp/bin/
	mkdir -p -- $(DISTRIB)/ada/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/*ada* $(DISTRIB)/ada/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	mkdir -p -- $(DISTRIB)/fortran/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/*fortran* $(DISTRIB)/fortran/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	mkdir -p -- $(DISTRIB)/openmp/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/*gomp* $(DISTRIB)/openmp/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	mkdir -p -- $(DISTRIB)/objc/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/*objc* $(DISTRIB)/objc/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	mkdir -p -- $(DISTRIB)/c++/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/*++* $(DISTRIB)/c++/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
ifneq ($(findstring w64,$(TARGET)),)
	mkdir -p -- $(DISTRIB)/ada/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/*ada* $(DISTRIB)/ada/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/
	mkdir -p -- $(DISTRIB)/fortran/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/*fortran* $(DISTRIB)/fortran/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/
	mkdir -p -- $(DISTRIB)/openmp/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/*gomp* $(DISTRIB)/openmp/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/
	mkdir -p -- $(DISTRIB)/objc/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/*objc* $(DISTRIB)/objc/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/
	mkdir -p -- $(DISTRIB)/c++/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/*++* $(DISTRIB)/c++/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/32/
endif
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/finclude $(DISTRIB)/fortran/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	mkdir -p -- $(DISTRIB)/c++/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/include
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/include/c++ $(DISTRIB)/c++/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/include/
	mkdir -p -- $(DISTRIB)/objc/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/include
	mv -f -- $(DISTRIB)/core/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/include/objc $(DISTRIB)/objc/lib/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/include/
	mkdir -p -- $(DISTRIB)/objc/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)
	mv -f -- $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/*obj* $(DISTRIB)/objc/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	mkdir -p -- $(DISTRIB)/c++/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)
	mv -f -- $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/cc1plus.exe $(DISTRIB)/c++/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	mkdir -p -- $(DISTRIB)/fortran/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)
	mv -f -- $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/f951.exe $(DISTRIB)/fortran/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	mkdir -p -- $(DISTRIB)/ada/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)
	mv -f -- $(DISTRIB)/core/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/gnat1.exe $(DISTRIB)/ada/libexec/gcc/$(TARGET)/$(GCC_VER)$(MAYBEGCCVERSUFFIX)/
	mkdir -p -- $(DISTRIB)/c++/share
	mv -f -- $(DISTRIB)/core/share/gcc-$(GCC_VER)$(MAYBEGCCVERSUFFIX) $(DISTRIB)/c++/share/
	mkdir -p -- $(DISTRIB)/fortran/share/info
	mv -f -- $(DISTRIB)/core/share/info/*fortran* $(DISTRIB)/fortran/share/info/
	mkdir -p -- $(DISTRIB)/ada/share/info
	mv -f -- $(DISTRIB)/core/share/info/*gnat* $(DISTRIB)/ada/share/info/
	mkdir -p -- $(DISTRIB)/openmp/share/info
	mv -f -- $(DISTRIB)/core/share/info/*gomp* $(DISTRIB)/openmp/share/info/
	mkdir -p -- $(DISTRIB)/c++/share/man/man1
	mv -f -- $(DISTRIB)/core/share/man/man1/*++* $(DISTRIB)/c++/share/man/man1/
	mkdir -p -- $(DISTRIB)/fortran/share/man/man1
	mv -f -- $(DISTRIB)/core/share/man/man1/*fortran* $(DISTRIB)/fortran/share/man/man1/
	rm -f $(DISTRIB)/core/master-stamp-*
	cd $(DISTRIB)/ada \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-ada.zip && \
	 $(SZA) a -tzip -mx9 ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-ada.zip * \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-ada.tar.xz && \
	 tar -ahcf ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-ada.tar.xz *
	cd $(DISTRIB)/c++ \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-c++.zip && \
	 $(SZA) a -tzip -mx9 ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-c++.zip * \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-c++.tar.xz && \
	 tar -ahcf ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-c++.tar.xz *
	cd $(DISTRIB)/core \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-core.zip && \
	 $(SZA) a -tzip -mx9 ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-core.zip * \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-core.tar.xz && \
	 tar -ahcf ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-core.tar.xz *
	cd $(DISTRIB)/fortran \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-fortran.zip && \
	 $(SZA) a -tzip -mx9 ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-fortran.zip * \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-fortran.tar.xz && \
	 tar -ahcf ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-fortran.tar.xz *
	cd $(DISTRIB)/objc \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-objc.zip && \
	 $(SZA) a -tzip -mx9 ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-objc.zip * \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-objc.tar.xz && \
	 tar -ahcf ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-objc.tar.xz *
	cd $(DISTRIB)/openmp \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-openmp.zip && \
	 $(SZA) a -tzip -mx9 ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-openmp.zip * \
	 && \
	 rm -f ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-openmp.tar.xz && \
	 tar -ahcf ../gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-openmp.tar.xz *
	touch $@

ifeq ($(findstring w64,$(TARGET)),)
ifeq ($(EXCEPTIONS),dw2)
$(STAMP_DISTRIB_LIBGCC_32_DW2_DLL): $(STAMP_GCC_PKG_INSTALL)
endif
endif

ifeq ($(MFTUPDATE_GCC_CORE_UNSIZE_ADD),)
MFTUPDATE_GCC_CORE_UNSIZE_ADD=0
endif
ifeq ($(MFTUPDATE_GCC_CXX_UNSIZE_ADD),)
MFTUPDATE_GCC_CXX_UNSIZE_ADD=0
endif
ifeq ($(MFTUPDATE_GCC_FORTRAN_UNSIZE_ADD),)
MFTUPDATE_GCC_FORTRAN_UNSIZE_ADD=0
endif
ifeq ($(MFTUPDATE_GCC_ADA_UNSIZE_ADD),)
MFTUPDATE_GCC_ADA_UNSIZE_ADD=0
endif
ifeq ($(MFTUPDATE_GCC_OBJC_UNSIZE_ADD),)
MFTUPDATE_GCC_OBJC_UNSIZE_ADD=0
endif
ifeq ($(MFTUPDATE_GCC_OPENMP_UNSIZE_ADD),)
MFTUPDATE_GCC_OPENMP_UNSIZE_ADD=0
endif
ifeq ($(MFTUPDATE_GCC_DEFAULT_MANIFEST_UNSIZE_ADD),)
MFTUPDATE_GCC_DEFAULT_MANIFEST_UNSIZE_ADD=0
endif

ifeq ($(EDITION),tdm32)

define MFTUPDATE_GCC
$(NEW_NET_MFT)
System:id|tdm32
Category:id|gcc
Version:id|gcc-.+-tdm-[0-9+]$(MAYBEGCCVERSUFFIX)$$
]]>]]>
<Version id="gcc-::VER::" name="TDM-GCC Current: ::VER::">
	<Description>GCC ::VER::: The most recent TDM release of the
	             GCC ::SERIES:: series, for MinGW, with $(EXCEPTIONS_CAPS) unwinding</Description>
	<Component base="gcc-core" name="core" id="gcc-core-::VER::" unsize="::UNSIZE_CORE::">
		<Description>Required base files and C support</Description>
		<Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-core.tar.xz" arcsize="::ARCSIZE_CORE::" />
	</Component>
	<Component base="gcc-g++" name="g++" id="gcc-c++-::VER::" unsize="::UNSIZE_CXX::">
		<Description>C++ support</Description>
		<Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-c++.tar.xz" arcsize="::ARCSIZE_CXX::" />
	</Component>
	<Component base="gcc-fortran" name="fortran" id="gcc-fortran-::VER::" unsize="::UNSIZE_FORTRAN::">
		<Description>Fortran support</Description>
		<Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-fortran.tar.xz" arcsize="::ARCSIZE_FORTRAN::" />
	</Component>
	<Component base="gcc-ada" name="ada" id="gcc-ada-::VER::" unsize="::UNSIZE_ADA::">
		<Description>Ada support</Description>
		<Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-ada.tar.xz" arcsize="::ARCSIZE_ADA::" />
	</Component>
	<Component base="gcc-objc" name="objc" id="gcc-objc-::VER::" unsize="::UNSIZE_OBJC::">
		<Description>Objective-C/C++ support</Description>
		<Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-objc.tar.xz" arcsize="::ARCSIZE_OBJC::" />
	</Component>
	<Component base="gcc-openmp" name="openmp" id="gcc-openmp-::VER::" unsize="::UNSIZE_OPENMP::">
		<Description>OpenMP support</Description>
		<Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-openmp.tar.xz" arcsize="::ARCSIZE_OPENMP::" />
	</Component>
</Version>
]]>]]>
System:id|tdm32
InstallType:id|tdmrec$$
Select:id|gcc-core-.+-tdm-[0-9+]$$
]]>]]>
<Select id="gcc-core-::VER_NO_SUFFIX::" />
]]>]]>
System:id|tdm32
InstallType:id|tdmrec$$
Select:id|gcc-c..-.+-tdm-[0-9+]$$
]]>]]>
<Select id="gcc-c++-::VER_NO_SUFFIX::" />
]]>]]>
System:id|tdm32
InstallType:id|tdmrecall
SelectTree:id|gcc-.+-tdm-[0-9+]$$
]]>]]>
<SelectTree id="gcc-::VER_NO_SUFFIX::" />
endef

else

define MFTUPDATE_GCC
$(NEW_NET_MFT)
System:id|tdm64
Category:id|gcc
Version:id|gcc-.+-tdm64.*
]]>]]>
<Version default="true" id="gcc-::VER::" name="TDM64 Current: ::VER::">
    <Description>Current Release - gcc-::VER::: The most
                 recent TDM64/MinGW-w64 release of GCC for MinGW</Description>
    <Component base="gcc-core" name="core" id="gcc-core-::VER::" unsize="::UNSIZE_CORE::">
        <Description>Required base files and C support</Description>
        <Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-core.tar.xz" arcsize="::ARCSIZE_CORE::" />
    </Component>
    <Component base="gcc-c++" name="c++" id="gcc-c++-::VER::" unsize="::UNSIZE_CXX::">
        <Description>C++ support</Description>
        <Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-c++.tar.xz" arcsize="::ARCSIZE_CXX::" />
    </Component>
    <Component base="gcc-fortran" name="fortran" id="gcc-fortran-::VER::" unsize="::UNSIZE_FORTRAN::">
        <Description>Fortran support</Description>
        <Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-fortran.tar.xz" arcsize="::ARCSIZE_FORTRAN::" />
    </Component>
    <Component base="gcc-ada" name="ada" id="gcc-ada-::VER::" unsize="::UNSIZE_ADA::">
        <Description>Ada support</Description>
        <Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-ada.tar.xz" arcsize="::ARCSIZE_ADA::" />
    </Component>
    <Component base="gcc-objc" name="objc" id="gcc-objc-::VER::" unsize="::UNSIZE_OBJC::">
        <Description>Objective-C/C++ support</Description>
        <Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-objc.tar.xz" arcsize="::ARCSIZE_OBJC::" />
    </Component>
    <Component base="gcc-openmp" name="openmp" id="gcc-openmp-::VER::" unsize="::UNSIZE_OPENMP::">
        <Description>OpenMP support (libgomp)</Description>
        <Archive path="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%20::SERIES::%20series/::VER_DIR::/gcc-::VER::-openmp.tar.xz" arcsize="::ARCSIZE_OPENMP::" />
    </Component>
</Version>
]]>]]>
System:id|tdm64
InstallType:id|tdmrec$$
Select:id|gcc-core-.+-tdm64.*
]]>]]>
<Select id="gcc-core-::VER_NO_SUFFIX::" />
]]>]]>
System:id|tdm64
InstallType:id|tdmrec$$
Select:id|gcc-c..-.+-tdm64.*
]]>]]>
<Select id="gcc-c++-::VER_NO_SUFFIX::" />
]]>]]>
System:id|tdm64
InstallType:id|tdmrecall
SelectTree:id|gcc-.+-tdm64.*
]]>]]>
<SelectTree id="gcc-::VER_NO_SUFFIX::" />
endef

endif
export MFTUPDATE_GCC

$(STAMP_GCC_MANIFEST): $(STAMP_NEW_NET_MANIFEST) $(STAMP_GCC_DISTRIB)
	@echo "=== gccmaster: Update manifest for GCC ==="
	echo "$$MFTUPDATE_GCC" >MFTUPDATE_GCC.txt
	sed -i -e 's/\:\:VER\:\:/$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)/g' MFTUPDATE_GCC.txt
	sed -i -e 's/\:\:VER_NO_SUFFIX\:\:/$(GCC_VER)-$(PKGVERSION)/g' MFTUPDATE_GCC.txt
	sed -i -e 's/\:\:VER_DIR\:\:/$(GCC_VER)-$(PKGVERSION)%20$(EXCEPTIONS_CAPS)/g' MFTUPDATE_GCC.txt
	sed -i -e 's/\:\:SERIES\:\:/$(GCC_SERIES)/g' MFTUPDATE_GCC.txt
	test -d $(DISTRIB)/core \
	 && UNSIZE1=`du -bs $(DISTRIB)/core | cut -f1` \
	 && UNSIZE2=`expr $$UNSIZE1 + $(MFTUPDATE_GCC_CORE_UNSIZE_ADD)` \
	 && sed -i -e "s/\:\:UNSIZE_CORE\:\:/$$UNSIZE2/g" MFTUPDATE_GCC.txt
	test -f $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-core.tar.xz \
	 && ARCSIZE1=`du -bs $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-core.tar.xz | cut -f1` \
	 && sed -i -e "s/\:\:ARCSIZE_CORE\:\:/$$ARCSIZE1/g" MFTUPDATE_GCC.txt
	test -d $(DISTRIB)/c++ \
	 && UNSIZE1=`du -bs $(DISTRIB)/c++ | cut -f1` \
	 && UNSIZE2=`expr $$UNSIZE1 + $(MFTUPDATE_GCC_CXX_UNSIZE_ADD)` \
	 && sed -i -e "s/\:\:UNSIZE_CXX\:\:/$$UNSIZE2/g" MFTUPDATE_GCC.txt
	test -f $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-c++.tar.xz \
	 && ARCSIZE1=`du -bs $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-c++.tar.xz | cut -f1` \
	 && sed -i -e "s/\:\:ARCSIZE_CXX\:\:/$$ARCSIZE1/g" MFTUPDATE_GCC.txt
	test -d $(DISTRIB)/fortran \
	 && UNSIZE1=`du -bs $(DISTRIB)/fortran | cut -f1` \
	 && UNSIZE2=`expr $$UNSIZE1 + $(MFTUPDATE_GCC_FORTRAN_UNSIZE_ADD)` \
	 && sed -i -e "s/\:\:UNSIZE_FORTRAN\:\:/$$UNSIZE2/g" MFTUPDATE_GCC.txt
	test -f $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-fortran.tar.xz \
	 && ARCSIZE1=`du -bs $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-fortran.tar.xz | cut -f1` \
	 && sed -i -e "s/\:\:ARCSIZE_FORTRAN\:\:/$$ARCSIZE1/g" MFTUPDATE_GCC.txt
	test -d $(DISTRIB)/ada \
	 && UNSIZE1=`du -bs $(DISTRIB)/ada | cut -f1` \
	 && UNSIZE2=`expr $$UNSIZE1 + $(MFTUPDATE_GCC_ADA_UNSIZE_ADD)` \
	 && sed -i -e "s/\:\:UNSIZE_ADA\:\:/$$UNSIZE2/g" MFTUPDATE_GCC.txt
	test -f $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-ada.tar.xz \
	 && ARCSIZE1=`du -bs $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-ada.tar.xz | cut -f1` \
	 && sed -i -e "s/\:\:ARCSIZE_ADA\:\:/$$ARCSIZE1/g" MFTUPDATE_GCC.txt
	test -d $(DISTRIB)/objc \
	 && UNSIZE1=`du -bs $(DISTRIB)/objc | cut -f1` \
	 && UNSIZE2=`expr $$UNSIZE1 + $(MFTUPDATE_GCC_OBJC_UNSIZE_ADD)` \
	 && sed -i -e "s/\:\:UNSIZE_OBJC\:\:/$$UNSIZE2/g" MFTUPDATE_GCC.txt
	test -f $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-objc.tar.xz \
	 && ARCSIZE1=`du -bs $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-objc.tar.xz | cut -f1` \
	 && sed -i -e "s/\:\:ARCSIZE_OBJC\:\:/$$ARCSIZE1/g" MFTUPDATE_GCC.txt
	test -d $(DISTRIB)/openmp \
	 && UNSIZE1=`du -bs $(DISTRIB)/openmp | cut -f1` \
	 && UNSIZE2=`expr $$UNSIZE1 + $(MFTUPDATE_GCC_OPENMP_UNSIZE_ADD)` \
	 && sed -i -e "s/\:\:UNSIZE_OPENMP\:\:/$$UNSIZE2/g" MFTUPDATE_GCC.txt
	test -f $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-openmp.tar.xz \
	 && ARCSIZE1=`du -bs $(DISTRIB)/gcc-$(GCC_VER)-$(PKGVERSION)$(MAYBEGCCVERSUFFIX)-openmp.tar.xz | cut -f1` \
	 && sed -i -e "s/\:\:ARCSIZE_OPENMP\:\:/$$ARCSIZE1/g" MFTUPDATE_GCC.txt
	$(BUILD_BASE)/mftu.exe <MFTUPDATE_GCC.txt 1>$(NEW_NET_MFT).new
	rm MFTUPDATE_GCC.txt
	mv $(NEW_NET_MFT).new $(NEW_NET_MFT)
	touch $@

endif
#BUILD_TYPE==native


###########
# expat
###########
.PHONY: expat expat-stage-install
expat: $(STAMP_EXPAT_BUILD)
expat-stage-install: $(STAMP_EXPAT_STAGE_INSTALL)

ifeq ($(BUILD_TYPE),native)
$(STAMP_EXPAT_BUILD): $(STAMP_GCC_STAGE_INSTALL)
	@echo "=== gccmaster: Build expat ==="
	rm -fR $(SCRATCH)/expat
	mkdir -p $(SCRATCH)/expat
ifeq ($(findstring w64,$(TARGET)),)
	export PATH="$(STAGING_PREFIX)/bin:$(STAGING_PREFIX)/$(HOST)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/expat \
	 && \
	 $(EXPAT_SRC)/configure --build=$(HOST) --prefix=$(STAGING_PREFIX) \
	  --enable-static --disable-shared \
	  CFLAGS="-O2 $(LTO_OPT)" LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE)
else
	export PATH="$(STAGING_PREFIX)/bin:$(STAGING_PREFIX)/$(HOST)/bin32:$(PATH)" \
	 && \
	 cd $(SCRATCH)/expat \
	 && \
	 $(EXPAT_SRC)/configure --build=$(HOST) --prefix=$(STAGING_PREFIX)/$(HOST) \
	  --enable-static --disable-shared \
	  CFLAGS="-O2 $(LTO_OPT)" LDFLAGS="-s $(LTO_OPT)" \
	 && \
	 $(MAKE)
endif
	touch $@

$(STAMP_EXPAT_STAGE_INSTALL): $(STAMP_EXPAT_BUILD)
	@echo "=== gccmaster: Install expat in scratch toolchain ==="
	export PATH="$(STAGING_PREFIX)/bin:$(STAGING_PREFIX)/$(HOST)/bin32:$(PATH)" \
	 && \
	 cd $(SCRATCH)/expat \
	 && \
	 $(MAKE) install
	touch $@
endif


###########
# python-src-copy
###########
.PHONY: python-src-copy
python-src-copy: $(STAMP_PYTHON_COPY)

PYTHON_SCRATCH := $(SCRATCH)/python_src

$(STAMP_PYTHON_COPY):
	rm -fR $(PYTHON_SCRATCH)
	mkdir -p $(PYTHON_SCRATCH)
	cp -Rp $(PYTHON_DIR)/* $(PYTHON_SCRATCH)/
	touch $@

###########
# gdb
###########
.PHONY: gdb gdb-stage-install gdb-pkg-install gdb-distrib
gdb: $(STAMP_GDB_BUILD)
gdb-stage-install: $(STAMP_GDB_STAGE_INSTALL)
gdb-pkg-install: $(STAMP_GDB_PKG_INSTALL)
gdb-distrib: $(STAMP_GDB_DISTRIB)
gdb-manifest: $(STAMP_GDB_MANIFEST)

ifeq ($(BUILD_TYPE),native)

$(STAMP_GDB_BUILD): $(STAMP_GCC_STAGE_INSTALL) $(STAMP_EXPAT_STAGE_INSTALL) $(STAMP_PYTHON_COPY)
$(STAMP_GDB_BUILD): $(STAMP_DEFAULT_MANIFEST_STAGE_INSTALL)
	@echo "=== gccmaster: Build gdb ==="
	rm -fR $(SCRATCH)/gdb
	mkdir -p $(SCRATCH)/gdb
ifeq ($(findstring w64,$(TARGET)),)
	export PATH="$(STAGING_PREFIX)/bin:$(STAGING_PREFIX)/$(HOST)/bin:$(PYTHON_SCRATCH):$(PATH)" \
	 && \
	 cd $(SCRATCH)/gdb \
	 && \
	 $(GDB_SRC)/configure --build=$(HOST) --prefix=$(STAGING_PREFIX)/gdb32 \
	  --enable-nls $(GDB_TARGETS_OPT) --with-python --with-expat=yes \
	  --program-suffix="$(GDB_SUFFIX)" --disable-binutils \
	  --with-system-gdbinit=$(STAGING_PREFIX)/gdb32/bin/gdbinit \
	  CFLAGS="-O2 $(LTO_OPT) -I$(PYTHON_SCRATCH)/include" \
	  CXXFLAGS="-O2 $(LTO_OPT) -I$(PYTHON_SCRATCH)/include" \
	  LDFLAGS="-s $(LTO_OPT) -L$(PYTHON_SCRATCH)/libs" \
	 && \
	 V=1 $(MAKE)
else
	export PATH="$(STAGING_PREFIX)/bin:$(STAGING_PREFIX)/$(HOST)/bin32:$(PYTHON_SCRATCH):$(PATH)" \
	 && \
	 cd $(SCRATCH)/gdb \
	 && \
	 $(GDB_SRC)/configure --build=$(HOST) --prefix=$(STAGING_PREFIX)/gdb64 \
	  --disable-nls $(GDB_TARGETS_OPT) --with-python --with-expat=yes \
	  --disable-binutils \
	  --enable-64-bit-bfd --with-system-gdbinit=$(STAGING_PREFIX)/gdb64/bin/gdbinit \
	  CFLAGS="-O2 $(LTO_OPT) -DMS_WIN64 -I$(PYTHON_SCRATCH)/include" \
	  CXXFLAGS="-O2 $(LTO_OPT) -DMS_WIN64 -I$(PYTHON_SCRATCH)/include" \
	  LDFLAGS="-s $(LTO_OPT) -L$(PYTHON_SCRATCH)/libs -lssp" \
	 && \
	 V=1 $(MAKE)
endif
	touch $@

$(STAMP_GDB_STAGE_INSTALL): $(STAMP_GDB_BUILD)
	@echo "=== gccmaster: Install gdb in staging prefix ==="
	export PATH="$(STAGING_PREFIX)/bin:$(STAGING_PREFIX)/$(HOST)/bin32:$(PYTHON_SCRATCH):$(PATH)" \
	 && \
	 cd $(SCRATCH)/gdb \
	 && \
	 $(MAKE) install prefix=$(STAGING_PREFIX)
	touch $@

$(STAMP_GDB_PKG_INSTALL): $(STAMP_GDB_BUILD)
	@echo "=== gccmaster: Install gdb in package directory ==="
	rm -fR $(PKG_GDB)
	export PATH="$(STAGING_PREFIX)/bin:$(PATH)" \
	 && \
	 cd $(SCRATCH)/gdb \
	 && \
	 $(MAKE) install prefix=$(PKG_GDB)
	touch $@

$(STAMP_GDB_DISTRIB): $(STAMP_GDB_PKG_INSTALL)
	@echo "=== gccmaster: Create GDB distribution ==="
	rm -fR -- $(DISTRIB)/gdb
	mkdir -p -- $(DISTRIB)/gdb
	cp -Rp -- $(PKG_GDB)/* $(DISTRIB)/gdb/
	rm -f -- $(DISTRIB)/gdb/share/info/dir
ifeq ($(findstring w64,$(TARGET)),)
	mkdir -p -- $(DISTRIB)/gdb/gdb32
	mv $(DISTRIB)/gdb/bin $(DISTRIB)/gdb/gdb32/
	mkdir -p -- $(DISTRIB)/gdb/gdb32/share
	mv $(DISTRIB)/gdb/share/gdb $(DISTRIB)/gdb/gdb32/share/
	cp -p -- $(SCRATCH)/libiconv/stage/bin/libiconv-*.dll $(DISTRIB)/gdb/gdb32/bin/
	cp -p -- $(SCRATCH)/gmp/stage/bin/libgmp-*.dll $(DISTRIB)/gdb/gdb32/bin/
	cp -p -- $(SCRATCH)/mpfr/stage/bin/libmpfr-*.dll $(DISTRIB)/gdb/gdb32/bin/
	$(BUILDFROM)/bin/strip.exe $(DISTRIB)/gdb/gdb32/bin/*.dll
	$(BUILDFROM)/bin/strip.exe $(DISTRIB)/gdb/gdb32/bin/*.exe
	mkdir -p -- $(DISTRIB)/gdb/bin
	export PATH="$(STAGING_PREFIX)/bin:$(STAGING_PREFIX)/$(HOST)/bin:$(PATH)" \
	 && \
	 gcc -s -O2 -o $(DISTRIB)/gdb/bin/gdb32.exe \
	  $(THIS_MAKEFILE_DIR)/gdbwrapper.c -DREAL_GDB_PATH=L\"../gdb32/bin/gdb$(GDB_SUFFIX).exe\" \
	 && \
	 gcc -s -O2 -o $(DISTRIB)/gdb/bin/gdbserver32.exe \
	  $(THIS_MAKEFILE_DIR)/gdbwrapper.c -DREAL_GDB_PATH=L\"../gdb32/bin/gdbserver$(GDB_SUFFIX).exe\"
	cp -Rp -- $(PYTHON_DIR)/DLLs $(PYTHON_DIR)/Lib $(PYTHON_DIR)/$(PYTHON_DLL) $(DISTRIB)/gdb/gdb32/bin/
	mv $(DISTRIB)/gdb/gdb32/bin/gdb-add-index32 $(DISTRIB)/gdb/bin/
	sed -i 's/GDB:=gdb/GDB:=gdb32/' $(DISTRIB)/gdb/bin/gdb-add-index32
else
	mkdir -p -- $(DISTRIB)/gdb/gdb64
	mv $(DISTRIB)/gdb/bin $(DISTRIB)/gdb/gdb64/
	mkdir -p -- $(DISTRIB)/gdb/gdb64/share
	mv $(DISTRIB)/gdb/share/gdb $(DISTRIB)/gdb/gdb64/share/
	cp -p -- $(STAGING_PREFIX)/lib/gcc/x86_64-w64-mingw32/9.2.0/libssp_64-*.dll $(DISTRIB)/gdb/gdb64/bin/
	cp -p -- $(SCRATCH)/gmp/stage/64/bin/libgmp-*.dll $(DISTRIB)/gdb/gdb64/bin/
	cp -p -- $(SCRATCH)/mpfr/stage/64/bin/libmpfr-*.dll $(DISTRIB)/gdb/gdb64/bin/
	$(BUILDFROM)/bin/strip.exe $(DISTRIB)/gdb/gdb64/bin/*.exe
	mkdir -p -- $(DISTRIB)/gdb/bin
	export PATH="$(STAGING_PREFIX)/bin:$(STAGING_PREFIX)/$(HOST)/bin32:$(PATH)" \
	 && \
	 gcc -s -O2 -o $(DISTRIB)/gdb/bin/gdb.exe \
	  $(THIS_MAKEFILE_DIR)/gdbwrapper.c -DREAL_GDB_PATH=L\"../gdb64/bin/gdb.exe\" \
	 && \
	 gcc -s -O2 -o $(DISTRIB)/gdb/bin/gdb64.exe \
	  $(THIS_MAKEFILE_DIR)/gdbwrapper.c -DREAL_GDB_PATH=L\"../gdb64/bin/gdb.exe\" \
	 && \
	 gcc -s -O2 -o $(DISTRIB)/gdb/bin/gdbserver.exe \
	  $(THIS_MAKEFILE_DIR)/gdbwrapper.c -DREAL_GDB_PATH=L\"../gdb64/bin/gdbserver.exe\" \
	 && \
	 gcc -s -O2 -o $(DISTRIB)/gdb/bin/gdbserver64.exe \
	  $(THIS_MAKEFILE_DIR)/gdbwrapper.c -DREAL_GDB_PATH=L\"../gdb64/bin/gdbserver.exe\"
	cp -Rp -- $(PYTHON_DIR)/DLLs $(PYTHON_DIR)/Lib $(PYTHON_DIR)/$(PYTHON_DLL) $(DISTRIB)/gdb/gdb64/bin/
	mv $(DISTRIB)/gdb/gdb64/bin/gdb-add-index $(DISTRIB)/gdb/bin/
endif
	$(BUILDFROM)/bin/strip.exe $(DISTRIB)/gdb/bin/*.exe
	rm -fR -- $(DISTRIB)/gdb/include
	rm -fR -- $(DISTRIB)/gdb/lib
	rm -f -- $(DISTRIB)/gdb/master-stamp-*
	cp -Rp -- $(DISTRIB_BASE)/$(EDITION)/gdb/* $(DISTRIB)/gdb/
	cd $(DISTRIB)/gdb \
	 && \
	 rm -f ../gdb$(GDB_SUFFIX)-$(GDB_VER)-$(PKGVERSION).zip && \
	 $(SZA) a -tzip -mx9 ../gdb$(GDB_SUFFIX)-$(GDB_VER)-$(PKGVERSION).zip * \
	 && \
	 rm -f ../gdb$(GDB_SUFFIX)-$(GDB_VER)-$(PKGVERSION).tar.xz && \
	 tar -ahcf ../gdb$(GDB_SUFFIX)-$(GDB_VER)-$(PKGVERSION).tar.xz *
	touch $@

ifeq ($(MFTUPDATE_GDB_UNSIZE_ADD),)
MFTUPDATE_GDB_UNSIZE_ADD=0
endif

ifeq ($(EDITION),tdm32)

define MFTUPDATE_GDB
$(NEW_NET_MFT)
System:id|tdm32
Component:id|gdb
Version:id|gdb32-[^-]+-tdm.*
]]>]]>
<Version default="true" id="gdb32-::VER::" name="Stable Release: ::VER::" unsize="::UNSIZE::">
    <Description>Current Release - gdb32-::VER:: (Python enabled)</Description>
    <Archive path="http://downloads.sourceforge.net/project/tdm-gcc/GDB/gdb32-::VER::.tar.xz" arcsize="::ARCSIZE::" />
</Version>
]]>]]>
System:id|tdm32
InstallType:id|tdmrec$$
Select:id|gdb32-[^-]+-tdm.*
]]>]]>
<Select id="gdb32-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|tdmrecall
Select:id|gdb32-[^-]+-tdm.*
]]>]]>
<Select id="gdb32-::VER::" />
]]>]]>
System:id|tdm64
Component:id|gdb32
Version:id|gdb32-[^-]+-tdm.*
]]>]]>
<Version id="gdb32-::VER::" name="Stable Release: ::VER::" unsize="::UNSIZE::">
    <Description>Current Release - gdb32-::VER:: (Python enabled)</Description>
    <Archive path="http://downloads.sourceforge.net/project/tdm-gcc/GDB/gdb32-::VER::.tar.xz" arcsize="::ARCSIZE::" />
</Version>
]]>]]>
System:id|tdm64
InstallType:id|tdmrecall
Select:id|gdb32-[^-]+-tdm.*
]]>]]>
<Select id="gdb32-::VER::" />
endef

else

define MFTUPDATE_GDB
$(NEW_NET_MFT)
System:id|tdm64
Component:id|mingw64-gdb
Version:id|gdb-[^-]+-tdm64.*
]]>]]>
<Version default="true" id="gdb-::VER::" name="Stable Release: ::VER::" unsize="::UNSIZE::">
    <Description>Current Release - gdb-::VER::</Description>
    <Archive path="http://downloads.sourceforge.net/project/tdm-gcc/GDB/gdb-::VER::.tar.xz" arcsize="::ARCSIZE::" />
</Version>
]]>]]>
System:id|tdm64
InstallType:id|tdmrec$$
Select:id|gdb-[^-]+-tdm64.*
]]>]]>
<Select id="gdb-::VER::" />
]]>]]>
System:id|tdm64
InstallType:id|tdmrecall
Select:id|gdb-[^-]+-tdm64.*
]]>]]>
<Select id="gdb-::VER::" />
endef

endif
export MFTUPDATE_GDB

$(STAMP_GDB_MANIFEST): $(STAMP_NEW_NET_MANIFEST) $(STAMP_GDB_DISTRIB)
	@echo "=== gccmaster: Update manifest for GDB ==="
	echo "$$MFTUPDATE_GDB" >MFTUPDATE_GDB.txt
	sed -i -e 's/\:\:VER\:\:/$(GDB_VER)-$(PKGVERSION)/g' MFTUPDATE_GDB.txt
	test -d $(DISTRIB)/gdb \
	 && UNSIZE1=`du -bs $(DISTRIB)/gdb | cut -f1` \
	 && UNSIZE2=`expr $$UNSIZE1 + $(MFTUPDATE_GDB_UNSIZE_ADD)` \
	 && sed -i -e "s/\:\:UNSIZE\:\:/$$UNSIZE2/g" MFTUPDATE_GDB.txt
	test -f $(DISTRIB)/gdb$(GDB_SUFFIX)-$(GDB_VER)-$(PKGVERSION).tar.xz \
	 && ARCSIZE1=`du -bs $(DISTRIB)/gdb$(GDB_SUFFIX)-$(GDB_VER)-$(PKGVERSION).tar.xz | cut -f1` \
	 && sed -i -e "s/\:\:ARCSIZE\:\:/$$ARCSIZE1/g" MFTUPDATE_GDB.txt
	$(BUILD_BASE)/mftu.exe <MFTUPDATE_GDB.txt 1>$(NEW_NET_MFT).new
	rm MFTUPDATE_GDB.txt
	mv $(NEW_NET_MFT).new $(NEW_NET_MFT)
	touch $@

endif
#BUILD_TYPE==native


###########
# manifest-upstream-deps
###########
.PHONY: manifest-upstream-deps
manifest-upstream-deps: $(STAMP_NETMANIFEST_UPSTREAM_DEPS)

$(STAMP_NETMANIFEST_UPSTREAM_DEPS): $(STAMP_NEW_NET_MANIFEST)

ifeq ($(findstring w64,$(HOST)),)
$(STAMP_NETMANIFEST_UPSTREAM_DEPS): $(STAMP_DISTRIB_MG_ROOT)

$(STAMP_DISTRIB_MG_ROOT):
	@echo "=== gccmaster: Copy mingw-get root to distrib for manifest update ops ==="
	rm -fR $(BUILD_BASE)/distrib/mingw-get-root/*
	mkdir -p $(BUILD_BASE)/distrib/mingw-get-root
	cp -Rp $(MINGW_GET_ROOT)/* $(BUILD_BASE)/distrib/mingw-get-root/
	rm -f $(BUILD_BASE)/distrib/mingw-get-root/TOUCH-ME-NOT.txt
	touch $@

define MFTUPDATE_MINGW_BASE_BINUTILS
$(NEW_NET_MFT)
System:id|tdm32
Component:id|binutils
Version:id|binutils-.*
]]>]]>
<Version default="true" id="binutils-::VER::" name="MinGW recommended: ::VER::" unsize="::UNSIZE::">
    <Description>MinGW recommended - binutils-::VER::</Description>
::ARCSLIST::
</Version>
]]>]]>
System:id|tdm32
InstallType:id|tdmrec$$
Select:id|binutils-.*
]]>]]>
<Select id="binutils-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|tdmrecall
Select:id|binutils-.*
]]>]]>
<Select id="binutils-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|mingwstable$$
Select:id|binutils-.*
]]>]]>
<Select id="binutils-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|mingwstableall
Select:id|binutils-.*
]]>]]>
<Select id="binutils-::VER::" />
endef
export MFTUPDATE_MINGW_BASE_BINUTILS

define MFTUPDATE_MINGW_BASE_MINGWRT
$(NEW_NET_MFT)
System:id|tdm32
Component:id|mingw-runtime
Version:id|mingw-runtime-.*
]]>]]>
            <Version default="true" id="mingw-runtime-::VER::" name="MinGW recommended: ::VER::" unsize="::UNSIZE::">
                <Description>MinGW recommended - mingwrt-::VER::</Description>
::ARCSLIST::
            </Version>
]]>]]>
System:id|tdm32
InstallType:id|tdmrec$$
Select:id|mingw-runtime-.*
]]>]]>
<Select id="mingw-runtime-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|tdmrecall
Select:id|mingw-runtime-.*
]]>]]>
<Select id="mingw-runtime-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|mingwstable$$
Select:id|mingw-runtime-.*
]]>]]>
<Select id="mingw-runtime-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|mingwstableall
Select:id|mingw-runtime-.*
]]>]]>
<Select id="mingw-runtime-::VER::" />
endef
export MFTUPDATE_MINGW_BASE_MINGWRT

define MFTUPDATE_MINGW_BASE_W32API
$(NEW_NET_MFT)
System:id|tdm32
Component:id|w32api
Version:id|w32api-.*
]]>]]>
            <Version default="true" id="w32api-::VER::" name="MinGW recommended: ::VER::" unsize="::UNSIZE::">
                <Description>MinGW recommended - w32api-::VER::</Description>
::ARCSLIST::
            </Version>
]]>]]>
System:id|tdm32
InstallType:id|tdmrec$$
Select:id|w32api-.*
]]>]]>
<Select id="w32api-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|tdmrecall
Select:id|w32api-.*
]]>]]>
<Select id="w32api-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|mingwstable$$
Select:id|w32api-.*
]]>]]>
<Select id="w32api-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|mingwstableall
Select:id|w32api-.*
]]>]]>
<Select id="w32api-::VER::" />
endef
export MFTUPDATE_MINGW_BASE_W32API

define MFTUPDATE_MINGW_BASE_MAKE
$(NEW_NET_MFT)
System:id|tdm32
Component:id|mingw32-make
Version:id|mingw32-make-.*
]]>]]>
            <Version default="true" id="mingw32-make-::VER::" name="MinGW recommended: ::VER::" unsize="::UNSIZE::">
                <Description>MinGW recommended - mingw32-make-::VER::</Description>
::ARCSLIST::
            </Version>
]]>]]>
System:id|tdm64
Component:id|mingw32-make
Version:id|mingw32-make-.*
]]>]]>
            <Version default="true" id="mingw32-make-::VER::" name="MinGW Stable: ::VER::" unsize="::UNSIZE::">
                <Description>Current Release - mingw32-make-::VER::</Description>
::ARCSLIST::
            </Version>
]]>]]>
System:id|tdm32
InstallType:id|tdmrec$$
Select:id|mingw32-make-.*
]]>]]>
<Select id="mingw32-make-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|tdmrecall
Select:id|mingw32-make-.*
]]>]]>
<Select id="mingw32-make-::VER::" />
]]>]]>
System:id|tdm64
InstallType:id|tdmrec$$
Select:id|mingw32-make-.*
]]>]]>
<Select id="mingw32-make-::VER::" />
]]>]]>
System:id|tdm64
InstallType:id|tdmrecall
Select:id|mingw32-make-.*
]]>]]>
<Select id="mingw32-make-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|mingwstable$$
Select:id|mingw32-make-.*
]]>]]>
<Select id="mingw32-make-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|mingwstableall
Select:id|mingw32-make-.*
]]>]]>
<Select id="mingw32-make-::VER::" />
endef
export MFTUPDATE_MINGW_BASE_MAKE

define MFTUPDATE_MINGW_BASE_GDB
$(NEW_NET_MFT)
System:id|tdm32
Component:id|gdb
Version:id|gdb-.*
]]>]]>
            <Version id="gdb-::VER::" name="MinGW recommended: ::VER::" unsize="::UNSIZE::">
                <Description>Current Release - gdb-::VER::</Description>
::ARCSLIST::
            </Version>
]]>]]>
System:id|tdm32
InstallType:id|mingwstable$$
Select:id|gdb-.*
]]>]]>
<Select id="gdb-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|mingwstableall
Select:id|gdb-.*
]]>]]>
<Select id="gdb-::VER::" />
endef
export MFTUPDATE_MINGW_BASE_GDB

define MFTUPDATE_MINGW_BASE_GCC_CORE
$(NEW_NET_MFT)
System:id|tdm32
Category:id|gcc
Version:id|gcc-[^t]+$$
]]>]]>
            <Version default="true" id="gcc-::VER::" name="MinGW.org recommended: ::VER::">
                <Description>Current Release - gcc-::VER::: The most recent
				 stable release of GCC for MinGW</Description>
                <Component base="gcc-core" name="core" id="gcc-core--" />
                <Component base="gcc-g++" name="g++" id="gcc-c++--" />
                <Component base="gcc-fortran" name="fortran" id="gcc-fortran--" />
                <Component base="gcc-ada" name="ada" id="gcc-ada--" />
                <Component base="gcc-objc" name="objc" id="gcc-objc--" />
                <Component base="gcc-openmp" name="openmp" id="gcc-openmp--" />
                <Component base="gcc-nls" name="nls" id="gcc-nls--" />
			</Version>
]]>]]>
System:id|tdm32
Category:id|gcc
Version:id|gcc-[^t]+$$
Component:id|gcc-core-[^t]+$$
]]>]]>
                <Component base="gcc-core" name="core" id="gcc-core-::VER::" unsize="::UNSIZE::">
                    <Description>Required base files and C support</Description>
::ARCSLIST::
            	</Component>
]]>]]>
System:id|tdm32
InstallType:id|mingwstable$$
Select:id|gcc-core-.*
]]>]]>
<Select id="gcc-core-::VER::" />
]]>]]>
System:id|tdm32
InstallType:id|mingwstableall
SelectTree:id|gcc-.*
]]>]]>
<SelectTree id="gcc-::VER::" />
endef
export MFTUPDATE_MINGW_BASE_GCC_CORE

define MFTUPDATE_MINGW_BASE_GCC_CXX
$(NEW_NET_MFT)
System:id|tdm32
Category:id|gcc
Version:id|gcc-[^t]+$$
Component:id|gcc-c\+\+-[^t]+$$
]]>]]>
                <Component base="gcc-g++" name="g++" id="gcc-c++-::VER::" unsize="::UNSIZE::">
                    <Description>C++ support</Description>
::ARCSLIST::
                </Component>
]]>]]>
System:id|tdm32
InstallType:id|mingwstable$$
Select:id|gcc-c\+\+-.*
]]>]]>
<Select id="gcc-c++-::VER::" />
endef
export MFTUPDATE_MINGW_BASE_GCC_CXX

define MFTUPDATE_MINGW_BASE_GCC_FORTRAN
$(NEW_NET_MFT)
System:id|tdm32
Category:id|gcc
Version:id|gcc-[^t]+$$
Component:id|gcc-fortran-[^t]+$$
]]>]]>
                <Component base="gcc-fortran" name="fortran" id="gcc-fortran-::VER::" unsize="::UNSIZE::">
                    <Description>Fortran support</Description>
::ARCSLIST::
                </Component>
endef
export MFTUPDATE_MINGW_BASE_GCC_FORTRAN

define MFTUPDATE_MINGW_BASE_GCC_ADA
$(NEW_NET_MFT)
System:id|tdm32
Category:id|gcc
Version:id|gcc-[^t]+$$
Component:id|gcc-ada-[^t]+$$
]]>]]>
                <Component base="gcc-ada" name="ada" id="gcc-ada-::VER::" unsize="::UNSIZE::">
                    <Description>Ada support</Description>
::ARCSLIST::
                </Component>
endef
export MFTUPDATE_MINGW_BASE_GCC_ADA

define MFTUPDATE_MINGW_BASE_GCC_OBJC
$(NEW_NET_MFT)
System:id|tdm32
Category:id|gcc
Version:id|gcc-[^t]+$$
Component:id|gcc-objc-[^t]+$$
]]>]]>
                <Component base="gcc-objc" name="objc" id="gcc-objc-::VER::" unsize="::UNSIZE::">
                    <Description>Objective-C/C++ support</Description>
::ARCSLIST::
                </Component>
endef
export MFTUPDATE_MINGW_BASE_GCC_OBJC

define MFTUPDATE_MINGW_BASE_GCC_OPENMP
$(NEW_NET_MFT)
System:id|tdm32
Category:id|gcc
Version:id|gcc-[^t]+$$
Component:id|gcc-openmp-[^t]+$$
]]>]]>
                <Component base="gcc-openmp" name="openmp" id="gcc-openmp-::VER::" unsize="::UNSIZE::">
                    <Description>OpenMP support (pthreads-w32)</Description>
::ARCSLIST::
                </Component>
endef
export MFTUPDATE_MINGW_BASE_GCC_OPENMP

define MFTUPDATE_MINGW_BASE_GCC_NLS
$(NEW_NET_MFT)
System:id|tdm32
Category:id|gcc
Version:id|gcc-[^t]+$$
Component:id|gcc-nls-[^t]+$$
]]>]]>
                <Component base="gcc-nls" name="nls" id="gcc-nls-::VER::" unsize="::UNSIZE::">
                    <Description>Native language support (localizations)</Description>
::ARCSLIST::
                </Component>
endef
export MFTUPDATE_MINGW_BASE_GCC_NLS

PKG_SRC_DIR=$(BUILD_BASE)/distrib/mingw-get-root/var/cache/mingw-get/packages
MFTUPDATE_EXE=$(BUILD_BASE)/mftu.exe

endif #HOST == mingw32


$(STAMP_NETMANIFEST_UPSTREAM_DEPS):
	@echo "=== gccmaster: Create upstream dependencies in manifest ==="
ifeq ($(findstring w64,$(HOST)),)
# Download the files with mingw-get
	cd $(BUILD_BASE)/distrib/mingw-get-root/bin \
		&& ./mingw-get --download-only install \
			$(MINGW_BASE_BINUTILS_SPEC) \
			$(MINGW_BASE_MINGWRT_SPEC) \
			$(MINGW_BASE_W32API_SPEC) \
			$(MINGW_BASE_M32MAKE_SPEC) \
			$(MINGW_BASE_GDB_SPEC) \
			$(MINGW_BASE_PTHREADS_SPEC) \
			"gcc-core$(MINGW_BASE_GCC_SPEC_ADDL)" \
			"gcc-c++$(MINGW_BASE_GCC_SPEC_ADDL)" \
			"gcc-fortran$(MINGW_BASE_GCC_SPEC_ADDL)" \
			"gcc-ada$(MINGW_BASE_GCC_SPEC_ADDL)" \
			"gcc-objc$(MINGW_BASE_GCC_SPEC_ADDL)"
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install $(MINGW_BASE_BINUTILS_SPEC) | grep -v libiconv | grep -v libgcc` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/binutils \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_BINUTILS" \
		VER_RGX="binutils-(.*)-mingw32-bin" \
		ADDIN_URLS="http://downloads.sourceforge.net/project/tdm-gcc/Installer%20Supplement/libgcc/gcc-$(GCC_VER)-$(PKGVERSION)-dw2-libgcc.tar.xz" \
		ADDIN_STAGE_DIR="$(BUILD_BASE)/distrib/tdm32-dw2" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install $(MINGW_BASE_MINGWRT_SPEC) | tr -d '\r'` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/mingwrt \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_MINGWRT" \
		VER_RGX="mingwrt-(.*)-mingw32-dev" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install $(MINGW_BASE_W32API_SPEC) | tr -d '\r'` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/w32api \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_W32API" \
		VER_RGX="w32api-(.*)-mingw32-dev" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install $(MINGW_BASE_M32MAKE_SPEC) | grep -v libgcc` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/mingw32-make \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_MAKE" \
		VER_RGX="make-(.*)-bin" \
		ADDIN_URLS="http://downloads.sourceforge.net/project/tdm-gcc/Installer%20Supplement/libgcc/gcc-$(GCC_VER)-$(PKGVERSION)-dw2-libgcc.tar.xz" \
		ADDIN_STAGE_DIR="$(BUILD_BASE)/distrib/tdm32-dw2" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install $(MINGW_BASE_GDB_SPEC) | tr -d '\r'` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/upstream-gdb \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_GDB" \
		VER_RGX="gdb-(.*)-mingw32-bin" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install "gcc-core$(MINGW_BASE_GCC_SPEC_ADDL)" | grep -v wsl-features | grep -v mingwrt | grep -v w32api | grep -v binutils | grep -v lang` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/upstream-gcc-core \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_GCC_CORE" \
		VER_RGX="gcc-core-(.*)-mingw32-bin" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install "gcc-c++$(MINGW_BASE_GCC_SPEC_ADDL)" | grep -v wsl-features | grep -v mingwrt | grep -v w32api | grep -v binutils | grep -v libiconv | grep -v libatomic | grep -v libgcc | grep -v libintl | grep -v libgmp | grep -v libmpfr | grep -v libquadmath | grep -v libgomp | grep -v libssp | grep -v libmpc | grep -v libisl | grep -v gcc-core` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/upstream-gcc-cxx \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_GCC_CXX" \
		VER_RGX="gcc-c\+\+-(.*)-mingw32-bin" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install "gcc-fortran$(MINGW_BASE_GCC_SPEC_ADDL)" | grep -v wsl-features | grep -v mingwrt | grep -v w32api | grep -v binutils | grep -v libiconv | grep -v libatomic | grep -v libgcc | grep -v libintl | grep -v libgmp | grep -v libmpfr | grep -v libquadmath | grep -v libgomp | grep -v libssp | grep -v libmpc | grep -v libisl | grep -v gcc-core | grep -v libstdc\+\+` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/upstream-gcc-fortran \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_GCC_FORTRAN" \
		VER_RGX="gcc-fortran-(.*)-mingw32-bin" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install "gcc-ada$(MINGW_BASE_GCC_SPEC_ADDL)" | grep -v wsl-features | grep -v mingwrt | grep -v w32api | grep -v binutils | grep -v libiconv | grep -v libatomic | grep -v libgcc | grep -v libintl | grep -v libgmp | grep -v libmpfr | grep -v libquadmath | grep -v libgomp | grep -v libssp | grep -v libmpc | grep -v libisl | grep -v gcc-core | grep -v libstdc\+\+` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/upstream-gcc-ada \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_GCC_ADA" \
		VER_RGX="gcc-ada-(.*)-mingw32-bin" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install "gcc-objc$(MINGW_BASE_GCC_SPEC_ADDL)" | grep -v wsl-features | grep -v mingwrt | grep -v w32api | grep -v binutils | grep -v libiconv | grep -v libatomic | grep -v libgcc | grep -v libintl | grep -v libgmp | grep -v libmpfr | grep -v libquadmath | grep -v libgomp | grep -v libssp | grep -v libmpc | grep -v libisl | grep -v gcc-core | grep -v libstdc\+\+` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/upstream-gcc-objc \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_GCC_OBJC" \
		VER_RGX="gcc-objc-(.*)-mingw32-bin" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install $(MINGW_BASE_PTHREADS_SPEC) | tr -d '\r'` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/upstream-gcc-openmp \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_GCC_OPENMP" \
		VER_RGX="pthreads-GC-w32-(.*)-dev" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
	PKGLIST=`$(BUILD_BASE)/distrib/mingw-get-root/bin/mingw-get --print-uris install "gcc-core$(MINGW_BASE_GCC_SPEC_ADDL)" | grep lang` \
		MFTUPDATE_DIR=$(BUILD_BASE)/distrib/mftupdate/upstream-gcc-nls \
		MFTUPDATE_TEMPLATE="$$MFTUPDATE_MINGW_BASE_GCC_NLS" \
		VER_RGX="gcc-(.*)-mingw32-lang" \
		PKG_SRC_DIR=$(PKG_SRC_DIR) MFTUPDATE_EXE=$(MFTUPDATE_EXE) NEW_NET_MFT=$(NEW_NET_MFT) STAGE_DIR=$(DISTRIB) \
		$(MAKE) -f stage-from-arclist.mk
endif #HOST == mingw32
	touch $@
