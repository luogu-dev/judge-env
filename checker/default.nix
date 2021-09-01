{ pkgs ? import <nixpkgs> {} }: with pkgs;
stdenv.mkDerivation rec {
	pname = "luogu-checkers";
	version = "0.1.0";

	src = ./src;

	buildInputs = [ cmake ];

	configurePhase = "cmake .";

	buildPhase = "make";

	installPhase = ''
		mkdir -p $out/bin
		mv {noip,strict}-checker $out/bin
	'';
}
