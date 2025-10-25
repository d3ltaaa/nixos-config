{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.Wooting = {
      enable = lib.mkEnableOption "Enables wootility";
    };
  };

  config =
    let
      cfg = config.hardware.Wooting;
    in
    lib.mkIf cfg.enable {
      hardware.wooting.enable = true;
    };
}
