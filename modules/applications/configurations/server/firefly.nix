{ lib, config, ... }:
{
  options = {
    applications.configurations.server.firefly = {
      enable = lib.mkEnableOption "Enables Firefly module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.server.firefly;
    in
    lib.mkIf cfg.enable {
      services.firefly-iii.enable = true;
    };
}
