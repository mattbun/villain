{
  description = "Common NixOS configuration for Matt's computers";

  inputs = {
    basix.url = "github:NotAShelf/Basix";
  };

  outputs = { basix, ... }: {
    nixosModules.default = (import ./default.nix { inherit basix; });
  };
}
