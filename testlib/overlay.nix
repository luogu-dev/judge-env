self: super: with super; {
	testlib = runCommandLocal "testlib" {
		version = "0.9.41";
		headerFile = fetchurl {
			url = "https://github.com/MikeMirzayanov/testlib/raw/68f9f300b6abebec82d2a68d8ca04394f2664fb6/testlib.h";
			sha256 = "sha256-cPdMVw8rRdYwhq5uTEG7tcX/1EKMupkUu8A5bSm+ENg=";
		};
	} ''
		set -e
		mkdir -p $out/include
		cp -v $headerFile $out/include/testlib.h
	'';
}
