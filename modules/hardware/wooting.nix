{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.wooting = {
      enable = lib.mkEnableOption "Enables wootility";
    };
  };

  config =
    let
      cfg = config.hardware.wooting;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ wootility ];
      services.udev.packages = [ pkgs.wooting-udev-rules ];
    };
}
