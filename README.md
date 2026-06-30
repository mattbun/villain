# villain

villain is a NixOS module with common configurations used in my NixOS systems.

## Highlights

* Homer module with base16/base24 theme
* Traefik reverse proxy
* Podman autoUpdate and autoPrune
* Automatic nix garbage collection
* Root user `alias vim=nvim` and `EDITOR=nvim`

## Getting started

### With the default template

The default template creates a NixOS configuration flake that uses villain.

```bash
# Create flake from template
nix flake new -t github:mattbun/villain destination-dir

# Open the created flake
cd destination-dir

# Add existing NixOS configurations
cp /etc/nixos/configuration.nix .
cp /etc/nixos/hardware-configuration.nix .

# nixos-rebuild switch ...
make
```

### With the dotfiles template

The `with-dotfiles` template creates a Makefile that integrates a villain NixOS configuration flake and a [mattbun/dotfiles](https://github.com/mattbun/dotfiles) home configuration flake.

```bash
# Create flake from template
nix flake new -t github:mattbun/villain#with-dotfiles destination-dir

# Open the created flake
cd destination-dir

# Create flakes under ./nixos and ./home
make template
```

### By Hand

Add to `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    villain.url = "github:mattbun/villain";
  };

  outputs = { nixpkgs, villain, ... }: {
    nixosConfigurations.frieza = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        villain.nixosModules.default
      ];
    };
  };
}
```

Then configure it:

```nix
{ config, ... }: {
  villain = {
    name = "frieza";
    colors.accent = "magenta";

    repoPath = "/home/matt/src/mattbun/frieza";
    flakePath = config.villain.repoPath + "/nixos";

    traefik.enable = true;
    homer = {
      enable = true;
      subtitle = "Galactic Emperor";
      logo = "assets/icons/logo.png";
      container.volumes = [
        "${./homer/assets/icons}:/www/assets/icons"
      ];
    };
  };

  # This option is configured but still needs to be enabled
  system.autoUpgrade.enable = true;
}
```
