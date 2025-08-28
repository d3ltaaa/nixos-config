{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.hyprland-desktop.settings = {
      nwg-display.enable = lib.mkEnableOption "Enables nwg-display";
    };
  };

  config =
    let
      cfg = config.system.desktop.hyprland-desktop.settings;
    in
    {
      environment.systemPackages = [ ] ++ lib.mkIf cfg.nwg-display.enable [ pkgs.nwg-display ];
    };
}
