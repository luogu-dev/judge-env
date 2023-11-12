self: super: with super; let
	pname = "luogu-gcc";

	applyLuogu = gcc: additionalPatches: wrapCCWith {
		cc = gcc.cc.overrideAttrs(a: with a; {
			inherit pname;
			patches = patches ++ additionalPatches;
		});
		extraBuildCommands = ''
			echo "-idirafter ${testlib}/include" >> $out/nix-support/libc-cflags
		'';
	};
in {
	luogu-gcc = applyLuogu gcc13 [
		./13_disable-pragma-and-attribute-for-optimize.patch
	];
	luogu-gcc930 = applyLuogu gcc930 [
		./9_disable-pragma-and-attribute-for-optimize.patch
	];
}
