self: super: let
	pname = "luogu-gcc";

	applyLuogu = gcc: let
		cc = gcc.cc.overrideAttrs(a: with a; {
			inherit pname;
			patches = patches ++ [
				./disable-pragma-and-attribute-for-optimize.patch
			];
		});
	in super.wrapCC(cc);
in {
	luogu-gcc = applyLuogu(super.gcc13);
	luogu-gcc930 = applyLuogu(super.gcc930);
}
