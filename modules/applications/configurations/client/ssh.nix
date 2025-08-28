{ lib, config, ... }:
{
  options = {
    applications.configurations.client.ssh = {
      enable = lib.mkEnableOption "Enables ssh";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.ssh;
    in
    lib.mkIf cfg.enable {
      services.openssh = {
        enable = true;
        passwordAuthentication = false;
        permitRootLogin = "no";
      };
    };
}
