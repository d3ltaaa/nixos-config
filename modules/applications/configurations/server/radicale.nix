{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.server.radicale = {
      enable = lib.mkEnableOption "Enables radicale server";
    };
  };

  config =
    let
      cfg = config.applications.configurations.server.radicale;
    in
    lib.mkIf cfg.enable {
      services.radicale = {
        enable = true;
        package = pkgs.radicale;
        settings = {
          server = {
            # Configure host and port if needed
            hosts = "0.0.0.0:5232";
          };
          auth = {
            type = "none";
          };
          # Add any other configuration options you need
        };
      };

      # Optional: Open the firewall port
      networking.firewall.allowedTCPPorts = [ 5232 ];
    };
}
