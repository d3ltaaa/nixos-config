{ lib, config, ... }:
{
  options = {
    hardware.usb = {
      enable = lib.mkEnableOption "Enables udisks2";
    };
  };

  config =
    let
      cfg = config.hardware.usb;
    in
    lib.mkIf cfg.enable {
      services.udisks2.enable = true;
    };
}
