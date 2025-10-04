{
  lib,
  config,
  nixpkgs-stable,
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
      hardware.bluetooth.package = nixpkgs-stable.bluez;
    };
}
