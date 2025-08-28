{ lib, config, ... }:
{
  options = {
    hardware.audio = {
      enable = lib.mkEnableOption "Enable Audio";
    };
  };

  config =
    let
      cfg = config.hardware.audio;
    in
    lib.mkIf cfg.enable {
    };
}
