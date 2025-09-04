{ lib, config, ... }:
{
  options = {
    applications.configurations.client.msmtp = {
      enable = lib.mkEnableOption "Enables smtp";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.msmtp;
    in
    lib.mkIf cfg.enable {
      programs.msmtp = {
        enable = true;
        accounts.default = {
          auth = true;
          tls = true;
          port = 587;
          host = config.secrets.mailHost;
          from = config.secrets.mailEmail;
          user = config.secrets.mailEmail;
          passwordeval = "cat /etc/credentials/mail/password";
        };
      };
    };
}
