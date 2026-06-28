nixosPath ?= .
stampFileNixos ?= $(nixosPath)/.stamp

NIXOS_FILES = $(shell find $(nixosPath) -type f -not -path $(stampFileNixos))

.PHONY: switch-nixos
switch-nixos: $(stampFileNixos)
$(stampFileNixos): $(NIXOS_FILES)
	sudo nixos-rebuild switch --flake $(nixosPath)#default
	@touch $(stampFileNixos)

.PHONY: nixos
nixos: clean-stamp-nixos switch-nixos

.PHONY: build-nixos
build-nixos:
	nixos-rebuild build --flake $(nixosPath)#default

.PHONY: update-nixos update-nixos-flake
update-nixos: update-nixos-flake switch-nixos
update-nixos-flake:
	nix flake update --flake $(nixosPath)

# nixos-config - generate a nixos config
.PHONY: nixos-config
nixos-config:
	nixos-generate-config --flake --dir $(nixosPath)

.PHONY: clean-stamp-nixos
clean-stamp-nixos:
	rm $(stampFileNixos)
