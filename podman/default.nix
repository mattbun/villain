{ config, lib, ... }: {
  options.podman = {
    autoUpdate = lib.mkOption {
      description = "Whether to enable podman automatic image updating";
      type = lib.types.bool;
      default = true;
    };

    autoPrune = lib.mkOption {
      description = "Whether to enable podman automatic image pruning";
      type = lib.types.bool;
      default = true;
    };
  };

  config = let cfg = config.podman; in {
    # Automatically update containers
    systemd.timers."podman-auto-update".wantedBy = lib.mkIf cfg.autoUpdate [ "multi-user.target" ];

    # Automatically prune containers
    virtualisation.podman.autoPrune.enable = cfg.autoPrune;
  };
}
