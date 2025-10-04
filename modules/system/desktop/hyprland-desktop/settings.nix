{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    system.desktop.hyprland-desktop.settings = {
      nwg-displays.enable = lib.mkEnableOption "Enables nwg-display";
    };
  };

  config =
    let
      cfg = config.system.desktop.hyprland-desktop.settings;
    in
    {
      environment.systemPackages = [
      ]
      ++ lib.optionals cfg.nwg-displays.enable [
        nixpkgs-stable.nwg-displays
      ];
    };
}
