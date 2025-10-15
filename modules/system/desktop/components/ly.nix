{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.ly = {
      enable = lib.mkEnableOption "Enables the ly module";
    };
  };
  config =
    let
      cfg = config.system.desktop.components.ly;
    in
    lib.mkIf cfg.enable {
      services.displayManager.ly = {
        enable = true;
        settings = {
          allow_empty_password = true;
          animation = "none";
          asterisk = "*";
          auth_fails = 10;
          clear_password = true;
          hide_borders = true;
          text_in_center = true;
        };
      };
    };
}
