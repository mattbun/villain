{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    villain.url = "github:mattbun/villain";
  };

  outputs = { nixpkgs, villain, ... }: {
    nixosConfigurations = rec {
      "frieza" = default; # TODO must match hostname of system
      default = nixpkgs.lib.nixosSystem {
        modules = [
          ./villain.nix

          # TODO Copy from /etx/nixos or generate with `nixos-generate-config --flake --dir .`
          ./configuration.nix
          ./hardware-configuration.nix

          villain.nixosModules.default
        ];
      };
    };
  };
}
