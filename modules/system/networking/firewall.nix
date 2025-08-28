{ lib, config, ... }:
{
  options = {
  };

  config =
    let
      cfg = config;
    in
    lib.mkIf cfg {
      # idk what this is for
      firewall.allowedTCPPorts =
        lib.mkIf cfg.staticIp != null [
          53
          80
          443
        ];
    };
}
