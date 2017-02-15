#!/bin/bash

set -eo pipefail

build() {
	declare dest="$1"; shift;
	git reset --hard
	git clean -xdf
	scons -j$(nproc) "$@"
	install -D bin/* "$dest"
}

build-templates() {
	declare dest="$1"
	declare platform bits target platform_alias

	for tuple in {windows,x11:linux_x11}-{32,64}-{release,debug}; do
		IFS=- read platform bits target <<< $tuple
		IFS=: read platform platform_alias <<< $platform
		outfile="$dest/${platform_alias:-$platform}_${bits}_${target}"
		if [[ "$platform" == "windows" ]]; then
			outfile="$outfile.exe"
		fi
		build "$outfile" platform=$platform bits=$bits target=$target tools=no
		if [[ "$target" == "release" ]]; then
			upx "$outfile"
		fi
	done
}

main() {
	declare src="$1" dest="$(readlink -f $2)"

	pushd "$src"
	build "$dest/godot" platform=x11 bits=64 target=debug
	build-templates "$dest/templates"
	popd
}

main "$@"
