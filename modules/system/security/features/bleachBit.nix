{ lib, config, ... }:
{
  options = {
    system.security.features.bleachBit = {
      enable = lib.mkEnableOption "Enables bleachBit";
    };
  };

  config =
    let
      cfg = config.system.security.features.bleachBit;
      cfg-flatpak = config.applications.packages.flatpaks;
    in
    lib.mkIf (cfg.enable && cfg-flatpak.enable) {
      services.flatpak.packages = [
        "org.bleachbit.BleachBit"
      ];
    };
}
