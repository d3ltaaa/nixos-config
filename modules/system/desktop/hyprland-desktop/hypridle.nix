{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.hyprland-desktop.hypridle = {
      enable = lib.mkEnableOption "Enables hypridle";
    };
  };

  config =
    let
      cfg = config.system.desktop.hyprland-desktop.hypridle;
    in
    lib.mkIf cfg.enable {
      services = {
        hypridle.enable = cfg.enable;
        hypridle.package = pkgs.hypridle;
      };
      home-manager.users.${config.system.user.general.primary} =
        let
          nixos-cfg = cfg;
        in
        { ... }:
        {
          services.hypridle = lib.mkIf nixos-cfg.enable {
            enable = true;
            settings = {
              general = {
                lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
                before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
                after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
              };

              listener = [
                {
                  timeout = 200; # 5min
                  on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
                }

                {
                  timeout = 260; # 5.5min
                  on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
                  on-resume = "hyprctl dispatch dpms on && brightnessctl -r"; # screen on when activity is detected after timeout has fired.
                }

                {
                  timeout = 300; # 30min
                  on-timeout = "systemctl suspend"; # suspend pc
                }
              ];
            };
          };
        };
    };
}
