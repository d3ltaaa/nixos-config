{ lib, config, ... }:
{
  options = {
    secrets = {
      serverAddress = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      mailHost = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      mailEmail = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      ipv64KeyFile = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      acmeEmail = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      githubUsername = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      githubEmail = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      monitoringEmail = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      privateWireguardKey = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      searxSecret = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
    };
  };
}
