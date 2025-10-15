{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.settings = {
      nwg-displays.enable = lib.mkEnableOption "Enables nwg-display";
    };
  };

  config =
    let
      cfg = config.system.desktop.components.settings;
    in
    {
      environment.systemPackages = [
      ]
      ++ lib.optionals cfg.nwg-displays.enable [
        pkgs.nwg-displays
      ];
    };
}
