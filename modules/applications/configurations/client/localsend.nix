{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.localsend = {
      enable = lib.mkEnableOption "Enables localsend module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.localsend;
    in
    lib.mkIf cfg.enable {
      programs.localsend = {
        enable = true;
      };
    };
}
