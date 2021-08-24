{ pkgs ? import <nixpkgs> {} }: with pkgs;
# The compiler Kotlin/Native is just like a piece of shit
# However this nix file just works on Luogu Judge.
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
		outputHash = "0rpb3qd6slfp6wms8aj706zhdyqsr0cz3w64ri26w4ljh4d5fns1";
	};
in stdenv.mkDerivation {
	inherit pname;
	inherit version;

	dontUnpack = true;
	buildInputs = [ makeWrapper unwrapped ];
	propagatedBuildInputs = [ jre ];

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
				--prefix PATH ":" ${jre}/bin \
				--run "$dependenciesLinkHelper" \
			;
		done
	'';
}
