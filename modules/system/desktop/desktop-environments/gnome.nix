{ lib, config, ... }:
{
  options = {
    system.desktop.desktop-environments.gnome-desktop.enable =
      lib.mkEnableOption "Enables all Modules for required for gnome-desktop";
  };
  config =
    let
      cfg = config.system.desktop.desktop-environments.gnome-desktop;
    in
    {
      system.desktop.components = lib.mkIf cfg.enable {
        gnome.enable = true;
        rofi.enable = true;
        settings.scripts.enable = true;
      };
    };
}
