#!/bin/sh

rm -rf /nix/var/nix/profiles/judge_*

nix flake show --json \
	| jq '.packages."x86_64-linux"|keys[]' \
	| xargs -I {} nix profile install --profile /nix/var/nix/profiles/judge_{} .#{}
