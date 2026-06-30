nixosPath := ./nixos
homePath := ./home

.PHONY: *

# switch - apply configurations
switch: switch-nixos switch-home

switch-home:
	cd $(homePath) && make switch

switch-nixos:
	cd $(nixosPath) && make switch

# template - create templates for nixos and home flakes
template: template-home template-nixos

template-home:
	nix flake new -t github:mattbun/dotfiles $(homePath)

template-nixos:
	nix flake new -t github:mattbun/villain $(nixosPath)
