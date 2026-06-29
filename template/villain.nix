{ config, ... }: {
  villain = {
    name = "frieza"; # TODO
    colors.accent = "magenta"; # TODO red, orange, yellow, green, blue, cyan, or magenta

    repoPath = "/home/matt/src/mattbun/frieza"; # TODO
    flakePath = config.villain.repoPath + "/nixos";

    traefik.enable = true;
    homer = {
      enable = true;
      subtitle = "Galactic Emperor"; # TODO
      logo = "assets/icons/logo.png";
      container.volumes = [
        "${./homer/assets/icons}:/www/assets/icons"
      ];
    };
  };
}
