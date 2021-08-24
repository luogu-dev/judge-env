{ pkgs ? import <nixpkgs> {} }: with pkgs;
# The compiler Kotlin/Native is just like a piece of shit
# FIXME: unusable
# The f**king compiler will download some dependencies on its own, such as LLVM and sysroot.
# Fine, I can let you self download them (check unwrapped.buildPhase).
# BUT the dependencies are not static-linked, and they didn't bring everything they need.
# Which means, they still needs other libraries from system, such as libtinfo.so.5.
# OK, althrough ncurses has upgraded to 6.x, I can still install ncurses5 for you (check propagatedBuildInputs)
# ncurses needs glibc? OK, I give it to you. But why does it throw the error below?
# `./clang++: symbol lookup error: /nix/store/9bh3986bpragfjmr32gay8p95k91q4gy-glibc-2.33-47/lib/libc.so.6: undefined symbol: _dl_catch_error_ptr, version GLIBC_PRIVATE`
# YOU WIN. I GAVE UP. Goodbye and I will drop Kotlin/Native support from Luogu.
let
	pname = "kotlin-native";
	version = "1.5.21";
	sha256 = "fa3dfec9c11711c2b713a1482bcc4511bb8f73f182f12aa7d858943f6f084397";

	unwrapped = stdenv.mkDerivation {
		pname = "${pname}-unwrapped";
		inherit version;

		src = fetchurl {
			url = "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-linux-${version}.tar.gz";
			inherit sha256;
		};
		propagatedBuildInputs = [ jre bash ];

		buildPhase = ''
			export KONAN_DATA_DIR=$PWD/konan-data
			export PATH=$PATH:${jre}/bin:$PWD/bin
			rm bin/kotlinc # kotlinc is deprecated and will be removed in the future
			patchShebangs bin
			kotlinc-native -Xcheck-dependencies
		'';
		installPhase = ''
			mkdir -p $out
			mv * $out
		'';

		dontFixup = true;
		dontStrip = true;
		dontPatchELF = true;
		dontPatchShebangs = true;

		outputHashMode = "recursive";
		outputHashAlgo = "sha256";
		outputHash = "1qqvkcgz2736din1npaji0qy49va4vssskm4msngamgm5m9n78da";
	};
in stdenv.mkDerivation {
	inherit pname;
	inherit version;

	dontUnpack = true;
	buildInputs = [ makeWrapper unwrapped ];
	propagatedBuildInputs = [ jre ncurses5 glibc ];

	dependenciesLinkHelper = ''#!/bin/bash
		konan_dir=''${KONAN_DATA_DIR:-''${HOME:-/tmp}/.konan}
		if [ ! -d "$konan_dir/dependencies" ]; then
			mkdir -p $konan_dir
			ln -s ${unwrapped}/konan-data/dependencies $konan_dir/dependencies
		fi
	'';
	installPhase = ''
		mkdir -p $out/bin
		for p in $(ls ${unwrapped}/bin/); do
			makeWrapper ${unwrapped}/bin/$p $out/bin/$p \
				--prefix LD_LIBRARY_PATH ":" ${ncurses5}/lib:${glibc}/lib \
				--prefix PATH ":" ${jre}/bin \
				--run "$dependenciesLinkHelper" \
			;
		done
	'';
}
