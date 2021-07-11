{ pkgs ? import <nixpkgs> {} }: with pkgs;
# The compiler Kotlin/Native is just like a piece of shit
# However this nix file just works on Luogu Judge.
let
	pname = "kotlin-native";
	version = "1.5.20";
	sha256 = "9449219ec9465b14adda1b730ac14ef02da93e9f98219f7303bf70c4c875b7db";

	unwrapped = stdenv.mkDerivation {
		pname = "${pname}-unwrapped";
		inherit version;

		src = fetchurl {
			url = "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-linux-${version}.tar.gz";
			inherit sha256;
		};
		propagatedBuildInputs = [ jre ];

		buildPhase = ''
			export KONAN_DATA_DIR=$PWD/konan-data
			export PATH=$PATH:${jre}/bin:$PWD/build-bin
			cp -r bin build-bin
			patchShebangs --build build-bin
			kotlinc-native -Xcheck-dependencies
			rm -r build-bin
		'';
		installPhase = ''
			mkdir -p $out
			mv * $out
			rm $out/bin/kotlinc # kotlinc will be removed in the future
		'';

		dontFixup = true;
		dontStrip = true;
		dontPatchELF = true;

		outputHashMode = "recursive";
		outputHashAlgo = "sha256";
		outputHash = "01kxmkd9vcjl0x4g9ylihz6z426zlm7jk2y5q580zs0prncqrk7x";
	};
in stdenv.mkDerivation {
	inherit pname;
	inherit version;

	dontUnpack = true;
	buildInputs = [ makeWrapper unwrapped ];
	propagatedBuildInputs = [ jre ];

	installPhase = ''
		mkdir -p $out/bin
		for p in $(ls ${unwrapped}/bin/); do
			makeWrapper ${unwrapped}/bin/$p $out/bin/$p \
				--prefix PATH ":" ${jre}/bin \
				--set KONAN_DATA_DIR ${unwrapped}/konan-data \
			;
		done
	'';
}
