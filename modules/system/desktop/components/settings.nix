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
      scripts.enable = lib.mkEnableOption "Enables settings scripts";
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
      ]
      ++ lib.optionals cfg.scripts.enable [
        (import ./settings/menu_system.nix { inherit pkgs; })
        (import ./settings/get_system_stats.nix { inherit pkgs; })
        (import ./settings/get_brightness.nix { inherit pkgs; })
        (import ./settings/script_light.nix {
          inherit pkgs;
          inherit config;
        })
        (import ./settings/menu_options.nix {
          inherit pkgs;
          inherit config;
        })
      ];
    };
}
