{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.brave = {
      enable = lib.mkEnableOption "Enables Brave Browser";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.brave;
    in
    lib.mkIf cfg.enable {
      environment.variables = {
        NIXOS_OZONE_WL = 1;
      };
      programs.chromium.enable = true;

      environment.systemPackages = with pkgs; [
        (pkgs.writeShellScriptBin "brave" ''
          exec ${pkgs.brave}/bin/brave \
            --ozone-platform=wayland \
            --disable-features=WaylandWpColorManagerV1 \
            "$@"
        '')
        # brave crashed on hyprland when moving between monitors
        # https://github.com/brave/brave-browser/issues/49921
      ];
      home-manager.users.${config.system.user.general.primary} =
        let
          nixos-config = config;
        in
        { config, ... }:
        {
          xdg.desktopEntries.brave = {
            name = "Brave";
            exec = "brave %U";
            startupNotify = false;
            terminal = false;
            icon = "brave-browser";
            genericName = "Web Browser";
            comment = "Browse the Web securely";
            categories = [
              "Network"
              "WebBrowser"
            ];
            mimeType = [
              "x-scheme-handler/http"
              "x-scheme-handler/https"
              "x-scheme-handler/ftp"
              "x-scheme-handler/chrome"
              "text/html"
              "application/x-xpinstall"
            ];
          };
        };
    };
}
