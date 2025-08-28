{ lib, config, ... }:
{
  options = {
    secrets = {
      serverAddress = lib.mkOption {
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
      privateWireguardKey = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
    };
  };
}
