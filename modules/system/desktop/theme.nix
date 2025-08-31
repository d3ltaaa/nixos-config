{
  lib,
  config,
  pkgs,
  nix-colors,
  ...
}:
{
  options = {
    system.desktop.theme = {
      colorSchemes = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
      };
      gtk = {
        enable = lib.mkEnableOption "Enables gtk theming";
        theme.name = lib.mkOption {
          type = lib.types.str;
        };
        theme.package = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
        };
        cursor.name = lib.mkOption {
          type = lib.types.str;
        };
        cursor.package = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
        };
        icon.name = lib.mkOption {
          type = lib.types.str;
        };
        icon.package = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
        };
      };
      qt = {
        enable = lib.mkEnableOption "Enables qt theming";
        theme.name = lib.mkOption {
          type = lib.types.str;
        };
        theme.package = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
        };
        style.name = lib.mkOption {
          type = lib.types.str;
        };
        style.package = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
        };
      };
    };
  };

  config =
    let
      cfg = config.system.desktop.theme;
    in
    {
      home-manager.users.${config.system.user.general.primary} =
        let
          nixos-config = config;
        in
        { config, inputs, ... }:
        {
          imports = [
            inputs.nix-colors.homeManagerModules.default
          ];

          colorScheme =
            if cfg.colorSchemes == null then
              {
                name = "catppuccin-macchiato";
                palette = {
                  base00 = "1e2030"; # #1e2030 default background
                  base01 = "24273a"; # #24273a lighter background (status bars, line numbers, folding marks)
                  base02 = "363a4f"; # #363a4f selection background
                  base03 = "494d64"; # #494d64 comments, invisibles, line highlighting
                  base04 = "5b6078"; # #5b6078 dark foreground
                  base05 = "ffffff"; # #ffffff default foreground, delimiters, operators
                  base06 = "cad3f5"; # #cad3f5 light foreground
                  base07 = "b7bdf8"; # #b7bdf8 light background
                  base08 = "ed8796"; # #ed8796 variables, xml tags, markup link text
                  base09 = "f5a97f"; # #f5a97f integers, boolean, constants
                  base0A = "eed49f"; # #eed49f classes, markup bold, search text background
                  base0B = "a6da95"; # #a6da95 strings, inherited class, markup code
                  base0C = "8bd5ca"; # #8bd5ca support, regular expressions, escape characters
                  base0D = "8aadf4"; # #8aadf4 functions, methods, headings
                  base0E = "c6a0f6"; # #c6a0f6 keywords, storage, selector
                  base0F = "f0c6c6"; # #f0c6c6 deprecated
                };
              }
            else
              inputs.nix-colors.colorSchemes.${cfg.colorSchemes};

          gtk = lib.mkIf cfg.gtk.enable {
            enable = true;
            theme.name = cfg.gtk.theme.name;
            theme.package = lib.mkIf (cfg.gtk.theme.package != null) pkgs.${cfg.gtk.theme.package};
            cursorTheme.name = cfg.gtk.cursor.name;
            cursorTheme.package = lib.mkIf (cfg.gtk.cursor.package != null) pkgs.${cfg.gtk.cursor.package};
            iconTheme.name = cfg.gtk.icon.name;
            iconTheme.package = lib.mkIf (cfg.gtk.icon.package != null) pkgs.${cfg.gtk.icon.package};
          };

          qt = lib.mkIf cfg.qt.enable {
            enable = true;
            platformTheme.name = cfg.qt.theme.name;
            platformTheme.package = lib.mkIf (cfg.qt.theme.package != null) pkgs.${cfg.gtk.icon.package};
            style.name = cfg.qt.style.name;
            style.package = lib.mkIf (cfg.qt.style.package != null) pkgs.${cfg.gtk.style.package};
          };
        };
    };

}
