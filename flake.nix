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
  };
}
