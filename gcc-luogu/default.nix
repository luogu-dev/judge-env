{ pkgs ? import <nixpkgs> {} }: with pkgs;
let
	pname = "luogu-gcc";
	sourceCC = gcc11.cc;

	cc = sourceCC.overrideAttrs(a: with a; {
		inherit pname;
		patches = patches ++ [
			./disable-pragma-and-attribute-for-optimize.patch
		];
	});
	gcc = wrapCC(cc);
in {
	inherit gcc;
	inherit cc;
}
