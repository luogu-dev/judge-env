{
	description = "Luogu Judge Environment";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05-small";
		nixpkgs_gcc930.url = "github:NixOS/nixpkgs/99cd95772761842712f77c291d26443ee039d862";
		rust-overlay.url = "github:oxalica/rust-overlay";
	};
	outputs = inputs@{ self, nixpkgs, nixpkgs-stable, nixpkgs_gcc930, rust-overlay, ... }: let
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
				(import ./checker/overlay.nix)
				(self: super: { pypy3 = nixpkgs-stable.legacyPackages.${super.system}.pypy3; })  # pypy workaround (NixOS/nixpkgs#419942)
			];
		};

		createEnv = name: packages: (pkgs.buildEnv {
			name = "ljudge-env_${builtins.replaceStrings ["/"] ["_"] name}";
			paths = with pkgs; [coreutils bash] ++ packages;
		});
	in {
		packages."${system}" = lib.mapAttrs createEnv (with pkgs; {
			nul = [];
			checker = [ljudge-checker];
			text = [gnutar gzip];
			gcc = [luogu-gcc];
			gcc-930 = [luogu-gcc930];
			rustc = [rust-bin.stable.latest.default luogu-gcc];
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
			julia = [julia];
		});
		# packages."${system}" = {
		# 	text = createJudgeProfile "text" [gnutar gzip];

		# 	# C-family: GCC
		# 	gcc = pkgs.luogu-gcc;
		# 	gcc9 = pkgs.luogu-gcc-9;

		# 	# Rust
		# 	rust = pkgs.rust-bin.nightly.latest.default;
		# };
	};
}
