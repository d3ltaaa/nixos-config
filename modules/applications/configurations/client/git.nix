{
  lib,
  config,
  pkgs,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.git = {
      enable = lib.mkEnableOption "Enables git module";
      username = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      email = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.git;
    in
    lib.mkIf cfg.enable {
      programs.git = {
        enable = true;
        package = pkgs.gitFull;
        config.credential.helper = "manager";
        config.credential."https://github.com".username = cfg.username;
        config.credential.credentialstore = "cache";
      };

      home-manager.users.${config.settings.users.primary} =
        let
          nixos-config = config;
        in
        { config, ... }:
        {
          programs.git = {
            enable = true;
            userName = nixos-config.applications.configuration.git.username;
            userEmail = nixos-config.applications.configuration.git.email;
          };
        };
    };
}
