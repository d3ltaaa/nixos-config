{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.blueTooth = {
      enable = lib.mkEnableOption "Enables Bluetooth";
    };
  };

  config =
    let
      cfg = config.hardware.blueTooth;
    in
    lib.mkIf cfg.enable {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.package = pkgs.bluez;
    };
}
