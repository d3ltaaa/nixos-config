{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.hyprpolkitagent = {
      enable = lib.mkEnableOption "Enables the hyprpolkitagent";
    };
  };
  config =
    let
      cfg = config.system.desktop.components.hyprpolkitagent;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        pkgs.hyprpolkitagent
      ];
      systemd.user.services.hyprpolkitagent = {
        enable = true;
      };
    };
}
