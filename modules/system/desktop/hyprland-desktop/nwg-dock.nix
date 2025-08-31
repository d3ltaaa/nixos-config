{ lib, config, ... }:
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

    };
}
