{ lib, config, ... }:
{
  options = {
    system.desktop.hyprland-desktop.hyprlock.enable = lib.mkEnableOption "Enables Hyplock";
  };

  config =
    let
      cfg = config.system.desktop.hyprland-desktop.hyprlock;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.settings.users.primary} =
        let
          nixos-config = config;
        in
        { ... }:
        {

          programs.hyprlock.enable = true;
          programs.hyprlock.settings = {
            background = {
              monitor = "";
              path = "/home/${nixos-config.settings.users.primary}/.config/wall/paper";
            };
          };
        };
    };
}
