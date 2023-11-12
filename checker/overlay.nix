self: super: let
	inherit(super) stdenv;
in {
	ljudge-checker = stdenv.mkDerivation (with super; {
		pname = "ljudge-checkers";
		version = "0.1.0";
		src = ./src;

		buildInputs = [ cmake ];
		configurePhase = "cmake .";
		buildPhase = "make";
		installPhase = ''
			mkdir -p $out/bin
			mv {noip,strict}-checker $out/bin
		'';
	});
}
