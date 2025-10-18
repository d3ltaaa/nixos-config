{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.niri = {
      enable = lib.mkEnableOption "Enables the niri";
    };
  };
  config =
    let
      cfg = config.system.desktop.components.niri;
    in
    lib.mkIf cfg.enable {
      programs.niri.enable = true;
      environment.systemPackages = with pkgs; [
        xwayland-satellite
      ];
    };
}
