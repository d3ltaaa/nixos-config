{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    hardware.brightness = {
      enable = lib.mkEnableOption "Enables brightness module";
      monitorType = lib.mkOption {
        type = lib.types.enum [
          "internal"
          "external"
        ];
        default = "internal";
      };
    };
  };

  config =
    let
      cfg = config.hardware.brightness;
    in
    lib.mkIf cfg.enable (
      lib.mkMerge [
        (lib.mkIf (cfg.monitorType == "internal") {
          environment.systemPackages = with nixpkgs-stable; [
            brillo
            brightnessctl
          ];
          environment.variables.MONITOR_TYPE = "internal";
        })
        (lib.mkIf (cfg.monitorType == "external") {
          environment.systemPackages = with nixpkgs-stable; [
            ddcutil
          ];
          hardware.i2c.enable = true;
          environment.variables.MONITOR_TYPE = "external";
        })
      ]
    );
}
