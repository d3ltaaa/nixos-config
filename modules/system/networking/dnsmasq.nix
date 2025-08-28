{ lib, config, ... }:
{
  options = {
    system.networking.dnsmasq = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      address = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };
    };
  };

  config =
    let
      cfg = config.system.networking.dnsmasq;
    in
    lib.mkIf cfg.enable {
      services.dnsmasq = {
        enable = cfg.enable;
        settings = {
          domain-needed = true;
          bogus-priv = true;
          no-resolv = true;
          log-queries = true;
          log-facility = "/var/log/dnsmasq.log";

          server = [
            "1.1.1.1"
          ];

          listen-address = [
            "127.0.0.1"
            "::1"
            "${config.system.networking.general.staticIp}" # TODO What is this for? If static IP is null, it wont work.
            "fd00::11"
          ];

          address = cfg.address;
        };
      };
    };
}
