.PHONY: test all

test: check-templates nixfmt-check

all: nixfmt build

nixfmt:
	find . -type f -iname "*.nix" -print0 | xargs -0 nixfmt

nixfmt-check:
	find . -type f -iname "*.nix" -print0 | xargs -0 nixfmt -c

check-templates:
	bash test/check-templates.bash

build:
	nix build
