{
  lib,
  config,
  nixpkgs-stable,
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
      hardware.opentabletdriver.package = nixpkgs-stable.opentabletdriver;
    };
}
