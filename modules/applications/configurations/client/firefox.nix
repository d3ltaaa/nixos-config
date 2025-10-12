{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.firefox = {
      enable = lib.mkEnableOption "Enables Firefox module and screensharing capabilities";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.firefox;
    in
    lib.mkIf cfg.enable {
      programs.firefox = {
        enable = true;
        package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { });
      };

      hardware.audio.enable = lib.mkDefault true; # needs pipewire

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
      };
      home-manager.users.${config.system.user.general.primary} =
        let
          nixos-config = config;
        in
        { config, ... }:
        {
          wayland.windowManager.hyprland.settings.bind = [
            "$mod, B, exec, firefox"
          ];
        };
    };
}
