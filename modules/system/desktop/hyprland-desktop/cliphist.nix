{ lib, config, ... }:
{
  options = {
    system.desktop.hyprland-desktop.cliphist.enable = lib.mkEnableOption "Enables Cliphist module";
  };

  config =
    let
      cfg = config.system.desktop.hyprland-desktop.cliphist;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.settings.users.primary} =
        { ... }:
        {
          services.cliphist.enable = true;
        };
    };
}
