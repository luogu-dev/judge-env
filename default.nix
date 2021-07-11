{ nixpkgs ? import <nixpkgs> {} }: with nixpkgs; 
let
	gcc = (callPackage ./gcc-luogu {}).gcc;

	kotlin-native = callPackage ./kotlin-native {};

	python3 = python39.withPackages(p: with p; [
		numpy
	]);

	python2 = python27.withPackages(p: with p; [
		numpy
	]);

	pypy2 = pypy;
in {
	# C, C++
	inherit gcc;

	# Rust
	inherit rustc;

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
	inherit python3;
	inherit pypy3;

	# Python 2
	inherit python2;
	inherit pypy2;

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
	inherit kotlin-native;
}
