{ config, lib, pkgs, ... }:

let
  cfg = config.villain.traefik;

  traefikConfig = pkgs.writeText "traefik.yaml" (builtins.toJSON {
    providers = {
      docker = {
        exposedByDefault = false;
      };
    };
    api = {
      basePath = "/traefik";
    };
  });
in
{
  options.villain.traefik.enable = lib.mkEnableOption "Traefik";

  config = lib.mkIf cfg.enable {
    villain.homer.sections.services.items = lib.mkOrder 1099 [
      {
        name = "Traefik";
        logo = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/traefik.png";
        type = "Traefik";
        url = "/traefik";
      }
    ];

    virtualisation.oci-containers.containers.traefik = {
      image = "docker.io/traefik:latest";
      labels = {
        "io.containers.autoupdate" = "registry";
        "traefik.enable" = "true";
        "traefik.http.routers.traefik.rule" = "PathPrefix(`/traefik`)";
        "traefik.http.routers.traefik.service" = "api@internal";
      };
      ports = [ "80:80" ];
      volumes = [
        "${traefikConfig}:/traefik.yaml"
        "/run/podman/podman.sock:/var/run/docker.sock"
      ];
    };
  };
}
