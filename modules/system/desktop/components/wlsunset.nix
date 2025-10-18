{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.wlsunset.enable = lib.mkEnableOption "Enables Swww module";
  };

  config =
    let
      cfg = config.system.desktop.components.wlsunset;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.system.user.general.primary} =
        { ... }:
        {
          services.wlsunset = {
            enable = true;
            package = pkgs.wlsunset;
            sunrise = "6:30";
            sunset = "18:30";
          };
        };
    };
}
