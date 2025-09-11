{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.networking.general = {
      lanInterface = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      wifiInterface = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      staticIp = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      defaultGateway = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      nameservers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "1.1.1.1" ];
      };
    };
  };

  config =
    let
      cfg = config.system.networking.general;
    in
    {
      system.activationScripts = {
        rfkillUnblockWlan = {
          text = ''
            rfkill unblock wlan
          '';
          deps = [ ];
        };
      };
      networking = {
        networkmanager.enable = true;
        networkmanager.wifi.powersave = true;
        networkmanager.wifi.backend = "iwd";
        networkmanager.dns = lib.mkIf (cfg.nameservers != [ "1.1.1.1" ]) "none";

        useDHCP = lib.mkIf (cfg.staticIp != null) false;
        interfaces.${cfg.lanInterface}.ipv4.addresses = lib.mkIf (cfg.staticIp != null) [
          {
            address = cfg.staticIp;
            prefixLength = 24;
          }
        ];
        defaultGateway = lib.mkIf (cfg.defaultGateway != null) cfg.defaultGateway;
        nameservers = cfg.nameservers;

      };
    };
}
