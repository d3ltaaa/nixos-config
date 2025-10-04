{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
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
      networking.firewall.allowedTCPPorts = lib.mkIf (cfg.staticIp != null) [
        53
      ];
      services.dnsmasq = {
        enable = cfg.enable;
        package = nixpkgs-stable.dnsmasq;
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
            "127.0.0.1" # ipv4 localhost
            "::1" # ipv6 localhost
            "${config.system.networking.general.staticIp}"
          ];

          address = cfg.address;
        };
      };
    };
}
