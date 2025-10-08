{
  lib,
  config,
  pkgs,
  ...
}:
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
        package = pkgs.openssh;
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "no";
        };
      };
    };
}
