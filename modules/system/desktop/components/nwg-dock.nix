{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.nwg-dock = {
      enable = lib.mkEnableOption "Enables the nwg-dock";
    };
  };
  config =
    let
      cfg = config.system.desktop.components.nwg-dock;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ nwg-dock-hyprland ];
    };
  # there is a problem with the icons and scaling the display resolution.
}
