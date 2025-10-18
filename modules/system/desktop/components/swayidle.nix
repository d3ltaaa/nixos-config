{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.swayidle = {
      enable = lib.mkEnableOption "Enables swayidle";
    };
  };

  config =
    let
      cfg = config.system.desktop.components.swayidle;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.system.user.general.primary} =
        let
          nixos-cfg = cfg;
          nixos-components = config.system.desktop.components;
        in
        { ... }:
        {
          services = {
            swayidle = {
              enable = true;
              package = pkgs.swayidle;
              timeouts = [
                {
                  timeout = 120;
                  command =
                    if nixos-components.dunst.enable then "${pkgs.dunst}/bin/dunstify 'Locking in 20 seconds'" else "";
                }

                {
                  timeout = 140;
                  command = if nixos-components.hyprlock.enable then "${pkgs.hyprlock}/bin/hyprlock &" else "";
                }

                {
                  timeout = 200;
                  command =
                    if nixos-components.niri.enable then
                      "${pkgs.niri}/bin/niri msg action power-off-monitors"
                    else if nixos-components.hyprland.enable then
                      "hyprctl dispatch dpms off"
                    else
                      "";
                  resumeCommand =
                    if nixos-components.niri.enable then
                      "${pkgs.niri}/bin/niri msg action power-on-monitors"
                    else if nixos-components.hyprland.enable then
                      "${pkgs.hyprland}/bin/hyprctl dispatch dpms on && ${pkgs.brightnessctl}/bin/brightnessctl -r"
                    else
                      "";
                }

                {
                  timeout = 260;
                  command = "${pkgs.systemd}/bin/systemctl suspend";
                }
              ];
              events = [
                {
                  event = "before-sleep";
                  command = if nixos-components.hyprlock.enable then "${pkgs.hyprlock}/bin/hyprlock &" else "";
                }
                {
                  event = "after-resume";
                  command =
                    if nixos-components.niri.enable then
                      "${pkgs.niri}/bin/niri msg action power-on-monitors"
                    else if nixos-components.hyprland.enable then
                      "${pkgs.hyprland}/bin/hyprctl dispatch dpms on && ${pkgs.brightnessctl}/bin/brightnessctl -r"
                    else
                      "";
                }
              ];
            };
          };
        };
    };
}
