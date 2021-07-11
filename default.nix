with (import <nixpkgs> {
	overlays = [
		(import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
	];
}); {
	# C, C++
	gcc = (callPackage ./gcc-luogu {}).gcc;

	# Rust
	rust = rust-bin.nightly.latest.default;

	# Haskell
	inherit ghc;

	# Pascal
	inherit fpc;

	# Ruby
	inherit ruby;

	# PHP
	inherit php80;

	# Perl
	inherit perl;

	# Python 3
	python3 = python39.withPackages(p: with p; [
		numpy
	]);
	pypy3 = pypy3;

	# Python 2
	python2 = python27.withPackages(p: with p; [
		numpy
	]);
	pypy2 = pypy;

	# C#, F#, Visual Basic
	inherit mono;

	# Java
	inherit jdk8;

	# OCaml
	inherit ocaml;

	# # Julia
	# inherit julia;

	# Lua
	inherit lua;

	# Scala
	inherit scala;

	# Golang
	inherit go;

	# Node.js
	inherit nodejs;

	# Kotlin/JVM
	inherit kotlin;

	# Kotlin/Native
	kotlin-native = callPackage ./kotlin-native {};
}
