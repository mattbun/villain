stamp_file ?= .stamp
watched_files = $(shell find . -type f -not -name $(stamp_file))

.PHONY: switch
switch: $(stamp_file)
$(stamp_file): $(watched_files)
	sudo nixos-rebuild switch --flake .#default
	@touch $(stamp_file)

.PHONY: build
build:
	nixos-rebuild build --flake .#default

.PHONY: update-nixos update-nixos-flake
update: update-flake switch
update-flake:
	nix flake update --flake .

# config - generate a nixos config
.PHONY: config
config:
	nixos-generate-config --flake --dir .

.PHONY: clean-stamp
clean-stamp:
	rm $(stamp-file)
