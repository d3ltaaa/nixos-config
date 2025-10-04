{
  lib,
  config,
  nixpkgs-stable,
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
      environment.systemPackages = [
        nixpkgs-stable.hyprpolkitagent
      ];
    };
}
