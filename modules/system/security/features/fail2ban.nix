{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    system.security.features.fail2ban = {
      enable = lib.mkEnableOption "Enables fail2ban";
    };
  };

  config =
    let
      cfg = config.system.security.features.fail2ban;
    in
    lib.mkIf cfg.enable {

      system.security.monitoring.services = [
        {
          notify = "${config.secrets.monitoringEmail}";
          flag = 0;
          service = "fail2ban.service";
          pattern = "error|warning|critical";
          title = "Fail2ban service alert";
          timeframe = "1 day ago";
        }
      ];
      services.fail2ban = {
        enable = true;
        package = nixpkgs-stable.fail2ban;
        # Ban IP after 5 failures
        maxretry = 5;
        ignoreIP = [
          # Whitelist some subnets
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "8.8.8.8" # whitelist a specific IP
          "nixos.wiki" # resolve the IP via DNS
        ];
        bantime = "24h"; # Ban IPs for one day on the first ban
        bantime-increment = {
          enable = true; # Enable increment of bantime after each violation
          multipliers = "1 2 4 8 16 32 64";
          maxtime = "168h"; # Do not ban for more than 1 week
          # overalljails = true; # Calculate the bantime based on all the violations
        };
      };
    };
}
