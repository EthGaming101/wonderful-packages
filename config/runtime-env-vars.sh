#!/bin/bash
shopt -s extglob

# wf-pacman sees $WF_PATH as $WF_DESTDIR
WF_PATH="/opt/wonderful"
WF_DESTDIR="/"
WF_USE_MUSL=true
WF_LIBRARY_SUFFIX=.so
WF_EXECUTABLE_SUFFIX=
WF_LUA_LDFLAGS=
WF_HOST_OS=linux

case `uname` in MINGW*)
	WF_USE_MUSL=false
	WF_LIBRARY_SUFFIX=.dll
	WF_EXECUTABLE_SUFFIX=.exe
	WF_DESTDIR="/opt/wonderful/"
	WF_LUA_LDFLAGS=-llua
	WF_HOST_OS=windows
esac

remove_dependencies() {
	for rem in "$@"; do
		for i in "${!depends[@]}"; do
			if [[ "${depends[$i]}" == "$rem" ]]; then
				unset depends[$i]
			fi
		done
		for i in "${!makedepends[@]}"; do
			if [[ "${makedepends[$i]}" == "$rem" ]]; then
				unset makedepends[$i]
			fi
		done
	done
}

if [ "$WF_USE_MUSL" == "false" ]; then
	remove_dependencies runtime-gcc-libs runtime-musl-dev runtime-musl
fi

WF_RUNTIME_LDFLAGS="-Wl,-rpath,$WF_PATH/lib -Wl,--dynamic-linker=$WF_PATH/lib/ld-musl-$CARCH.so.1"

WF_RUNTIME_INCLUDES="-isystem $WF_PATH/include"
WF_RUNTIME_LDFLAGS="$WF_RUNTIME_LDFLAGS -L$WF_PATH/lib"
WF_RUNTIME_PKG_CONFIG_PATH="$WF_PATH/lib/pkgconfig"

# This function does the following things:
# 1. If WF_DESTDIR == /, relocate files from ./opt/wonderful to ./.
# 2. If WF_DESTDIR != /, move existing files to opt/wonderful and cd to
#    opt/wonderful.
# In either case, the caller should start in PKGDIR and ends up in the
# toolchain root directory.
wf_relocate_path_to_destdir() {
	if [ "$WF_DESTDIR" == "/" ]; then
		if [ -d opt/wonderful ]; then
			mv opt _opt
			mv _opt/wonderful/* .
			rm -rf _opt
		fi
	else
		if [ ! -d opt/wonderful ]; then
			mkdir -p opt/wonderful
		fi
		mv !(opt) opt/wonderful || true
		cd opt/wonderful
	fi
}

wf_runtime_patchelf() {
	if [ "$WF_USE_MUSL" == "true" ]; then
		patchelf --set-rpath "$WF_PATH/lib" "$1"
		# Setting an interpreter is supported only on executables.
		# For libraries, ignore the failure.
		patchelf --set-interpreter "$WF_PATH/lib/ld-musl-$CARCH.so.1" "$1" || true
	fi
}

wf_use_toolchain() {
	export WF_TOOLCHAIN_PREFIX="$WF_PATH/toolchain/$1/$2"
	export PATH="$WF_PATH/toolchain/$1/bin":$PATH
}

# for thirdparty-blocksds
export BLOCKSDS="$WF_PATH"/thirdparty/blocksds/core
export BLOCKSDSEXT="$WF_PATH"/thirdparty/blocksds/external
