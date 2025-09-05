{ lib, config, ... }:
{
  options = {
    system.security.features.passwords = {
      vaultwarden.enable = lib.mkEnableOption "Enables Bitwarden web-application";
    };
  };

  config =
    let
      cfg = config.system.security.features.passwords;
      cfg-brave = config.applications.configurations.client.brave;
    in

    lib.mkIf (cfg.vaultwarden.enable && cfg-brave.enable) {
      home-manager.users.${config.system.user.general.primary} =
        let
          nixos-config = config;
        in
        { config, ... }:
        {
          xdg.desktopEntries.vaultwarden = {
            name = "Vaultwarden";
            exec = "brave --app=https://vault.${nixos-config.secrets.serverAddress}";
            startupNotify = false;
            terminal = false;
            icon = "bitwarden";
          };
        };
    };
}
