{ lib, config, ... }:
{
  options = {
  };

  config =
    let
      cfg = config.system.networking.general;
    in
    {
      # TODO
      # idk what this is for
      networking.firewall.allowedTCPPorts = lib.mkIf (cfg.staticIp != null) [
        53
        80
        443
      ];
    };
}
