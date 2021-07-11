with (import <nixpkgs> {});
let pkgs = (import ./default.nix);
in with pkgs; pkgs // {
	gcc = mkShell { packages = [ gcc ]; };

	python2 = python2.env;
	pypy2 = mkShell { packages = [ pypy2 ]; };
	python3 = python3.env;
	pypy3 = mkShell { packages = [ pypy3 ]; };

	rust = mkShell { packages = [ rust ]; };

	kotlin-native = mkShell { packages = [ kotlin-native ]; };
}
