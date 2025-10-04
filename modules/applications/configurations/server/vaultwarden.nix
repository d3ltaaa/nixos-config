{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    applications.configurations.server.vaultwarden = {
      enable = lib.mkEnableOption "Enables Vaultwarden module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.server.vaultwarden;
    in
    lib.mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = [ 8222 ];
      services.vaultwarden = {
        enable = true;
        package = nixpkgs-stable.vaultwarden;
        config = {
          ROCKET_ADDRESS = "192.168.2.12";
          ROCKET_PORT = "8222";
        };
      };
    };
}
