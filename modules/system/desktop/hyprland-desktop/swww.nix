{ lib, config, ... }:
{
  options = {
    system.desktop.hyprland-desktop.swww.enable = lib.mkEnableOption "Enables Swww module";
  };

  config =
    let
      cfg = config.system.desktop.hyprland-desktop.swww;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.settings.users.primary} =
        { ... }:
        {
          services.swww.enable = true;
        };
    };
}
