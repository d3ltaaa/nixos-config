{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.drawingTablet = {
      enable = lib.mkEnableOption "Enables opentabletdriver";
    };
  };

  config =
    let
      cfg = config.hardware.drawingTablet;
    in
    lib.mkIf cfg.enable {
      hardware.opentabletdriver.enable = true;
      hardware.opentabletdriver.package = pkgs.opentabletdriver;
      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0937", MODE="0666"
        KERNEL=="uinput",MODE:="0666",OPTIONS+="static_node=uinput"
        SUBSYSTEMS=="usb",ATTRS{idVendor}=="28bd",MODE:="0666"

      '';
    };
}
