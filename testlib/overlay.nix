self: super: with super; {
	testlib = runCommandLocal "testlib" {
		version = "0.9.45";
		headerFile = fetchurl {
			url = "https://github.com/MikeMirzayanov/testlib/raw/2d20123984e9479b8a56ebe0d6a51e23ad7c35b3/testlib.h";
			sha256 = "sha256-uzI+PIkoUhSWYHbg0j1aKVxfYSbaf/GYwSdt25XssaA=";
		};
	} ''
		set -e
		mkdir -p $out/include
		cp -v $headerFile $out/include/testlib.h
	'';
}
