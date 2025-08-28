{ lib, config, ... }:
{
  options = {
    enable = lib.mkEnableOption "Enables acme configuration";
    domain = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "hil.falk@protonmail.com";
    };
    dnsProvider = lib.mkOption {
      type = lib.types.str;
      default = "ipv64";
    };
    domainNames = lib.mkOption {
      type = lib.types.listOf (lib.types.str);
    };
  };

  config =
    let
      cfg = config.system.networking.acme;
    in
    lib.mkIf cfg.enable {
      # remember to put api key into /etc/credentials/acmeIPV64.cert

      # regenerate certs with
      # sudo rm -r /var/lib/acme
      # sudo systemctl restart acme-setup.service
      # sudo nixos-rebuild

      security.acme = {
        acceptTerms = true;
        defaults = {
          email = cfg.email;
          dnsProvider = cfg.dnsProvider;
          dnsResolver = "1.1.1.1:53";
        };
        certs."${cfg.domain}" = {
          # domain = "*.${serverAddress}";
          credentialFiles = {
            IPV64_API_KEY_FILE = lib.mkIf (cfg.dnsProvider == "ipv64") "/etc/credentials/acmeIPV64.cert";
          };
          extraDomainNames = cfg.domainNames;
        };
      };
    };
}
