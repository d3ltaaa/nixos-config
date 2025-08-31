{ lib, config, ... }:
{
  options = {
    applications.configurations.server.n8n = {
      enable = lib.mkEnableOption "Enables n8n";
    };
  };

  config =
    let
      cfg = config.applications.configurations.server.n8n;
    in
    lib.mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = [ 5678 ];
      services.n8n.enable = true;
    };
}
