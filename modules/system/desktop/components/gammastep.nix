{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.gammastep.enable = lib.mkEnableOption "Enables Swww module";
  };

  config =
    let
      cfg = config.system.desktop.components.gammastep;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.system.user.general.primary} =
        { ... }:
        {
          services.gammastep = {
            enable = true;
            package = pkgs.gammastep;
            sunrise = "6:30";
            sunset = "18:30";
          };
        };
    };
}
