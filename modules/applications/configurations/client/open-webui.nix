{ lib, config, ... }:
{
  options = {
    applications.configurations.client.open-webui = {
      enable = lib.mkEnableOption "Enables the open-webui desktop application";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.open-webui;
      cfg-brave = config.applications.configurations.client.brave;
    in
    lib.mkIf cfg.enable
    && cfg-brave.enable {
      home-manager.users.${config.settings.users.primary} =
        let
          nixos-config = config;
        in
        { config, ... }:
        {
          xdg.desktopEntries.open-webui = {
            name = "Open-Webui";
            exec = "brave --app=https://open-webui.${nixos-config.settings.general.serverAddress}";
            startupNotify = false;
            terminal = false;
            icon = "openai";
          };
        };
    };
}
