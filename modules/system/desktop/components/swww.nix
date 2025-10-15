{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.swww.enable = lib.mkEnableOption "Enables Swww module";
  };

  config =
    let
      cfg = config.system.desktop.components.swww;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.system.user.general.primary} =
        { ... }:
        {
          services.swww = {
            enable = true;
            package = pkgs.swww;
          };
        };
    };
}
