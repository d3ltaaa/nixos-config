{ lib, config, ... }:
{
  options = {
    system.networking.bridgedNetwork.enable = lib.mkEnableOption "Enables a bridged Network";
  };

  config =
    let
      cfg = config.system.networking.bridgedNetwork;
    in
    lib.mkIf cfg {
      # bridged network
      nat = lib.mkIf cfg.enable {
        enable = true;
        externalInterface = config.system.networking.general.lanInterface;
        internalInterfaces = [ "wg0" ];
      };
    };
}
