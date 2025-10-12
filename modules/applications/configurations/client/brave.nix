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
        brave
        # (pkgs.writeShellScriptBin "brave" ''
        #   exec ${pkgs.brave}/bin/brave \
        #     --ozone-platform=wayland \
        #     --disable-features=WaylandWpColorManagerV1 \
        #     "$@"
        # '')
        # # brave crashed on hyprland when moving between monitors
        # # https://github.com/brave/brave-browser/issues/49921
      ];
      home-manager.users.${config.system.user.general.primary} =
        let
          nixos-config = config;
        in
        { config, ... }:
        {
          wayland.windowManager.hyprland.settings.bind = [
            "$mod, B, exec, brave"
          ];
        };
    };
}
