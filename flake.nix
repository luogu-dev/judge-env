{
	description = "Luogu Judge Environment";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
		nixpkgs_gcc930.url = "github:NixOS/nixpkgs/99cd95772761842712f77c291d26443ee039d862";
		rust-overlay = {
			url = "github:oxalica/rust-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = inputs@{ self, nixpkgs, nixpkgs_gcc930, rust-overlay, ... }: let
		system = "x86_64-linux";

		inherit(nixpkgs) lib;
		pkgs = import nixpkgs {
			inherit system;
			overlays = [
				rust-overlay.overlays.default
				(self: super: {
					gcc930 = nixpkgs_gcc930.legacyPackages.${super.system}.gcc9;
				})
				(import ./testlib/overlay.nix)
				(import ./gcc/overlay.nix)
				(import ./ghc/overlay.nix)
				(import ./checker/overlay.nix)
			];
		};

		createEnv = name: packages: (pkgs.buildEnv {
			name = "ljudge-env_${builtins.replaceStrings ["/"] ["_"] name}";
			paths = with pkgs; [coreutils bash] ++ packages;
		});

		envPkgs = lib.mapAttrs createEnv (with pkgs; {
			nul = [];
			checker = [ljudge-checker];
			text = [gnutar gzip];
			gcc = [luogu-gcc];
			gcc-930 = [luogu-gcc930];
			rustc = [rust-bin.stable.latest.minimal luogu-gcc];
			ghc = [ghc];
			python3-c = [(python313.withPackages (p: with p; [
				numpy
			]))];
			python3-py = [pypy3];
			pascal-fpc = [fpc binutils];
			go = [go];
			php = [(php84.buildEnv {
				extensions = { all, ... }: with all; [
					opcache ctype posix filter bcmath
					iconv mbstring readline gmp
				];
			})];
			ruby = [ruby];
			js-node = [nodejs_22];
			perl = [perl];
			java-8 = [jdk8_headless];
			java-21 = [jdk21_headless];
			kotlin-jvm = [(kotlin.override { jre = jdk21_headless; })];
			scala = [(scala.override { jre = jdk21_headless; })];
			lua = [lua];
			mono = [mono]; # TODO: use dotnet
			ocaml = [ocaml luogu-gcc];
			julia = [julia-bin];
		});
	in {
		packages."${system}" = envPkgs;
		overlays.default = self: super: { ljudge-envs = envPkgs; };
	};
}
