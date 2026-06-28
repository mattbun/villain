{ config, lib, pkgs, ... }:

let
  cfg = config.villain.homer;
  colorScheme = config.villain.colors;
in
{
  options.villain.homer = {
    enable = lib.mkEnableOption "homer";

    title = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
    };

    subtitle = lib.mkOption {
      type = lib.types.str;
      default = "";
    };

    logo = lib.mkOption {
      type = lib.types.str;
      default = "";
    };

    footer = lib.mkOption {
      type = lib.types.str;
      default = "";
    };

    stylesheet = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    links = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          icon = lib.mkOption { type = lib.types.str; };
          url = lib.mkOption { type = lib.types.str; };
          target = lib.mkOption {
            type = lib.types.str;
            default = "_blank";
          };
        };
      });
      default = [ ];
    };

    container = {
      labels = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };

      volumes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };

    sections = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          order = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          items = lib.mkOption {
            type = lib.types.listOf lib.types.attrs;
            default = [ ];
          };
        };
      });
      default = { };
    };

    colorScheme = lib.mkOption {
      description = "Color scheme for homer theme";
      type = lib.types.submodule {
        options = {
          accentPrimary = lib.mkOption {
            description = "Color to use as primary accent";
            type = lib.types.str;
            default = config.villain.colorscheme.accentPrimaryColor;
          };

          accentSecondary = lib.mkOption {
            description = "Color to use as secondary accent";
            type = lib.types.str;
            default = config.villain.colorscheme.accentSecondaryColor;
          };

          palette = lib.mkOption {
            description = "base24 color palette, matches schema of NotAShelf/Basix";
            type = lib.types.submodule {
              options = {
                base00 = lib.mkOption { type = lib.types.str; };
                base01 = lib.mkOption { type = lib.types.str; };
                base02 = lib.mkOption { type = lib.types.str; };
                base03 = lib.mkOption { type = lib.types.str; };
                base04 = lib.mkOption { type = lib.types.str; };
                base05 = lib.mkOption { type = lib.types.str; };
                base06 = lib.mkOption { type = lib.types.str; };
                base07 = lib.mkOption { type = lib.types.str; };
                base08 = lib.mkOption { type = lib.types.str; };
                base09 = lib.mkOption { type = lib.types.str; };
                base0A = lib.mkOption { type = lib.types.str; };
                base0B = lib.mkOption { type = lib.types.str; };
                base0C = lib.mkOption { type = lib.types.str; };
                base0D = lib.mkOption { type = lib.types.str; };
                base0E = lib.mkOption { type = lib.types.str; };
                base0F = lib.mkOption { type = lib.types.str; };
                base10 = lib.mkOption { type = lib.types.str; };
                base11 = lib.mkOption { type = lib.types.str; };
                base12 = lib.mkOption { type = lib.types.str; };
                base13 = lib.mkOption { type = lib.types.str; };
                base14 = lib.mkOption { type = lib.types.str; };
                base15 = lib.mkOption { type = lib.types.str; };
                base16 = lib.mkOption { type = lib.types.str; };
                base17 = lib.mkOption { type = lib.types.str; };
              };
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.homer = {
      image = "docker.io/b4bz/homer:latest";

      environment = {
        TZ = config.time.timeZone;
      };

      labels = {
        "io.containers.autoupdate" = "registry";
      } // cfg.container.labels;

      volumes =
        let
          homerConfig = pkgs.writeText "homer.yml" (builtins.toJSON {
            title = cfg.title;
            subtitle = cfg.subtitle;
            logo = cfg.logo;
            footer = cfg.footer;
            links = cfg.links;
            stylesheet = [
              "assets/nix-homer.css"
            ];
            services = lib.lists.sort (a: b: a.order < b.order)
              (lib.attrsets.mapAttrsToList
                (_name: section: {
                  name = section.name;
                  order = section.order;
                  items = section.items;
                })
                cfg.sections);
          });

          css = pkgs.writeText "nix-homer.css" /* css */ ''
            .light {
              --highlight-primary: ${colorScheme.accentPrimary};
              --highlight-secondary: ${colorScheme.accentSecondary};
              --highlight-hover: ${colorScheme.accentPrimary};
              --background: ${colorScheme.palette.base07};
              --card-background: ${colorScheme.palette.base06};
              --text: ${colorScheme.palette.base00};
              --text-header: ${colorScheme.palette.base00};
              --text-title: ${colorScheme.palette.base01};
              --text-subtitle: ${colorScheme.palette.base02};
              --card-shadow: rgba(0, 0, 0, 0.1);
              --link: #3273dc;
              --link-hover: #363636;
              --background-image: none;

              --highlight-variant-inverted: #363636;
            }

            .dark {
              --highlight-primary: ${colorScheme.accentPrimary};
              --highlight-secondary: ${colorScheme.accentSecondary};
              --highlight-hover: ${colorScheme.accentPrimary};
              --background: ${colorScheme.palette.base00};
              --card-background: ${colorScheme.palette.base01};
              --text: ${colorScheme.palette.base07};
              --text-header: ${colorScheme.palette.base00};
              --text-title: ${colorScheme.palette.base06};
              --text-subtitle: ${colorScheme.palette.base05};
              --card-shadow: rgba(0, 0, 0, 0.4);
              --link: #3273dc;
              --link-hover: #144aa2;
              --background-image: none;

              --highlight-variant-inverted: #f5f5f5;
            }

            #app {
              --highlight-blue: ${colorScheme.palette.base0D};
              --highlight-red: ${colorScheme.palette.base08};
              --highlight-pink: ${colorScheme.palette.base0A};
              --highlight-orange: ${colorScheme.palette.base09};
              --highlight-green: ${colorScheme.palette.base0B};
              --highlight-purple: ${colorScheme.palette.base0E};
            }

            /* make search icon the same color as other header text */
            .search-label:before {
              color: var(--text-header);
            }
          '';

          manifest = pkgs.writeText "site.webmanifest" (builtins.toJSON {
            "name" = cfg.title;
            "short_name" = cfg.title;
            "theme_color" = colorScheme.accentPrimaryColor;
            "background_color" = colorScheme.accentPrimaryColor;
            "display" = "standalone";

            # These should be generated by https://realfavicongenerator.net/
            "icons" = [
              {
                "src" = "/assets/icons/web-app-manifest-192x192.png";
                "sizes" = "192x192";
                "type" = "image/png";
                "purpose" = "maskable";
              }
              {
                "src" = "/assets/icons/web-app-manifest-512x512.png";
                "sizes" = "512x512";
                "type" = "image/png";
                "purpose" = "maskable";
              }
            ];
          });
        in
        cfg.container.volumes ++ [
          "${homerConfig}:/www/assets/config.yml"
          "${css}:/www/assets/nix-homer.css"
          "${manifest}:/www/manifest.json"
        ];
    };
  };
}
