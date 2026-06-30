{
  description = "Common NixOS configuration for Matt's computers";

  inputs = {
    basix.url = "github:NotAShelf/Basix";
  };

  outputs = { basix, ... }: {
    nixosModules.default = {
      imports = [
        ./default.nix
        (
          { config, lib, ... }:
          let
            colors = config.villain.colors;
            palette = basix.schemeData."${colors.system}"."${colors.slug}".palette;
          in
          {
            villain.colors.palette = lib.mkDefault palette;
          }
        )
      ];
    };

    templates = {
      default = {
        path = ./template/default;
        description = "Template for a NixOS system that uses villain";
      };

      with-dotfiles = {
        path = ./template/with-dotfiles;
        description = "Template for a NixOS system with both villain and mattbun/dotfiles";
      };
    };
  };
}
