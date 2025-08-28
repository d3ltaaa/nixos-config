{ lib, config, ... }:
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
      services.nginx = {
        enable = cfg.enable;
        virtualHosts = cfg.virtualHosts;
      };
    };
}
