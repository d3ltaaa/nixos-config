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
      home-manager.users.${config.system.user.general.primary} =
        let
          nixos-config = config;
          nixos-cfg = cfg;
        in
        { ... }:
        lib.mkIf nixos-cfg.enable {
          programs.hyprlock.enable = true;
          programs.hyprlock.settings = {
            background = {
              monitor = "";
              path = "/home/${nixos-config.system.user.general.primary}/.config/wall/paper";
            };
          };
        };
    };
}
