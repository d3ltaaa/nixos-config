{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    system.networking.nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      virtualHosts = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrs);
      };
    };
  };

  config =
    let
      cfg = config.system.networking.nginx;
    in
    lib.mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
      services.nginx = {
        enable = cfg.enable;
        package = nixpkgs-stable.nginx;
        virtualHosts = cfg.virtualHosts;
      };
    };
}
