{ config, lib, ... }:
let
  cfg = config.villain.colors;

  colors = {
    "black" = "base01"; # ansi00
    "red" = "base08"; # ansi01
    "green" = "base0B"; # ansi02
    "yellow" = "base0A"; # ansi03
    "blue" = "base0D"; # ansi04
    "magenta" = "base0E"; # ansi05
    "cyan" = "base0C"; # ansi06
    "white" = "base05"; # ansi07
    "bright-black" = "base04"; # ansi08
    "bright-red" = "base12"; #ansi09
    "bright-green" = "base14"; # ansi10
    "bright-yellow" = "base13"; # ansi11
    "bright-blue" = "base16"; # ansi12
    "bright-magenta" = "base17"; # ansi13
    "bright-cyan" = "base15"; # ansi14
    "bright-white" = "base07"; # ansi15
    "orange" = "base09";
    "brown" = "base0F";
  };

  colorNameToBase = colorName: colors."${colorName}";
in
{
  options.villain.colors = {
    accent = lib.mkOption {
      type = lib.types.enum (lib.attrsets.attrNames colors);
    };

    accentPrimary = lib.mkOption {
      type = lib.types.enum (lib.attrsets.attrNames colors);
      default = cfg.accent;
    };

    accentSecondary = lib.mkOption {
      type = lib.types.enum (lib.attrsets.attrNames colors);
      default = "bright-${cfg.accentPrimary}";
    };

    accentPrimaryColor = lib.mkOption {
      type = lib.types.str;
      default = cfg.palette."${colorNameToBase cfg.accentPrimary}";
    };

    accentSecondaryColor = lib.mkOption {
      type = lib.types.str;
      default = cfg.palette."${colorNameToBase cfg.accentSecondary}";
    };

    system = lib.mkOption {
      type = lib.types.enum [ "base16" "base24" ];
      default = "base24";
    };

    slug = lib.mkOption {
      type = lib.types.str;
      default = "0x96f";
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
}
