{
  description = "Common NixOS configuration for Matt's computers";

  outputs = { ... }: {
    nixosModules.default = import ./default.nix;
  };
}
