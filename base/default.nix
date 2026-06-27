{ config, lib, ... }: {
  options.villain = {
    name = lib.mkOption {
      description = "name of the system";
      type = lib.types.str;
      default = "nixos";
    };

    flakePath = lib.mkOption {
      description = "path to the flake directory to use for automatic upgrades";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    repoPath = lib.mkOption {
      description = "path to the git repository containing nixos configuration";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = let cfg = config.villain; in {
    networking.hostName = cfg.name;

    nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];

      # Enable automatic nix store garbage collection
      gc.automatic = lib.mkDefault true;
    };

    # Update flake.lock 
    system.autoUpgrade.flake = cfg.flakePath;

    # Enable git globally
    programs.git = {
      enable = true;

      # Fixes autoUpgrade 'repository path is not owned by current user'
      config.safe.directory = lib.mkIf (cfg.flakePath != null) cfg.repoPath;
    };
  };
}
