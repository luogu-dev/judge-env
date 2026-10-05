self: super: with super; let
	pname = "luogu-gcc";

	applyLuogu = gcc: glibcLocales: additionalPatches: wrapCCWith {
		cc = gcc.cc.overrideAttrs(a: with a; {
			inherit pname;
			patches = patches ++ additionalPatches;
		});
		extraBuildCommands = ''
			echo "-idirafter ${testlib}/include" >> $out/nix-support/libc-cflags
			echo "export LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive" >> $out/nix-support/cc-wrapper-hook
		'';
	};
in {
	luogu-gcc = applyLuogu gcc15 ljudge-glibcLocales [
		./13_disable-pragma-and-attribute-for-optimize.patch
	];
	luogu-gcc930 = applyLuogu gcc930 gcc930_ljudge-glibcLocales [
		./9_disable-pragma-and-attribute-for-optimize.patch
	];
}
