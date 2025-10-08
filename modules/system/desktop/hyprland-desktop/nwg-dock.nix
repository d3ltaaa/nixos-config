{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.hyprland-desktop.nwg-dock = {
      enable = lib.mkEnableOption "Enables the nwg-dock";
    };
  };
  config =
    let
      cfg = config.system.desktop.hyprland-desktop.nwg-dock;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ nwg-dock-hyprland ];
    };
  # there is a problem with the icons and scaling the display resolution.
}
