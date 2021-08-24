let pkgs = (import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/430a043a187872d8b065c073839997719b564611.tar.gz") {
	overlays = [
		(import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
	];
});
in with pkgs; {
	# Basic utils
	inherit coreutils;
	inherit bash;
	inherit gnutar;
	inherit openssl;

	# C, C++
	gcc = (callPackage ./gcc-luogu { inherit pkgs; }).gcc;

	# Rust
	rust = rust-bin.nightly."2021-08-23".default;

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

	# Java 8
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

	# Why? check ./kotlin-native/default.nix
	# # Kotlin/Native
	# kotlin-native = (callPackage ./kotlin-native { inherit pkgs; });
}
