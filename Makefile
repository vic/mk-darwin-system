.PHONY: test all

test: check-templates flake-check nixfmt-check

all: nixfmt build

nixfmt:
	nix run '.#fmt'

nixfmt-check:
	nix run '.#fmt' -- --check

check-templates:
	bash test/check-templates.bash

flake-check:
	nix flake check

build:
	nix build
