{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.hyprland-desktop.hyprpolkitagent = {
      enable = lib.mkEnableOption "Enables the hyprpolkitagent";
    };
  };
  config =
    let
      cfg = config.system.desktop.hyprland-desktop.hyprpolkitagent;
    in
    lib.mkIf cfg.enable {
      security.polkit.package = pkgs.hyprpolkitagent;
    };
}
