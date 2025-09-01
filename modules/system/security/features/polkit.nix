{ lib, config, ... }:
{
  options = {
    system.security.features.polkit = {
      enable = lib.mkEnableOption "Enables Polkit";
    };
  };
  config =
    let
      cfg = config.system.security.features.polkit;
    in
    lib.mkIf cfg.enable {
      security.polkit.enable = true;
    };
}
