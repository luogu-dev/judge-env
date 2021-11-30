{ pkgs ? import <nixpkgs> {} }: with pkgs;
let
	pname = "luogu-gcc";
	
	cc = gcc11.cc.overrideAttrs(a: with a; {
		inherit pname;
		patches = patches ++ [
			./disable-pragma-and-attribute-for-optimize.patch
		];
	});
	gcc = wrapCC(cc);
	
	cc9 = pkgs.gcc9.cc.overrideAttrs(a: with a; {
		inherit pname;
		patches = patches ++ [
			./disable-pragma-and-attribute-for-optimize.patch
		];
	});
	gcc9 = wrapCC(cc9);
in {
	inherit gcc;
	inherit cc;
	
	inherit gcc9;
	inherit cc9;
}
