{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.security.features.gnupg = {
      enable = lib.mkEnableOption "Enables Gnupg";
    };
  };

  config =
    let
      cfg = config.system.security.features.gnupg;
    in
    lib.mkIf cfg.enable {
      programs.gnupg.agent = {
        enable = true;
        package = pkgs.pinentry-gnome3;
      };
    };
}
