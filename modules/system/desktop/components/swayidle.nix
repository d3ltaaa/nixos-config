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
        in
        { ... }:
        {
          services = {
            swayidle = {
              enable = true;
              package = pkgs.swayidle;
              timeouts = [
                {
                  timeout = 30;
                  command = "${pkgs.dunst}/bin/dunstify 'Locking in 5 seconds'";
                }

                {
                  timeout = 35;
                  command = "${pkgs.hyprlock}/bin/hyprlock &";
                }

                {
                  timeout = 50;
                  command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
                  resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
                }

                {
                  timeout = 60;
                  command = "${pkgs.systemd}/bin/systemctl suspend";
                }
              ];
              events = [
                {
                  event = "before-sleep";
                  command = "${pkgs.hyprlock}/bin/hyprlock &";
                }
                {
                  event = "after-resume";
                  command = "${pkgs.niri}/bin/niri msg action power-on-monitors";
                }
              ];
            };
          };
        };
    };
}
