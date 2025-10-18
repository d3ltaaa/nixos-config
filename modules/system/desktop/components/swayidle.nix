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
                  timeout = 180;
                  command = "'notify-send 'Locking in 5 seconds' -t 5000'";
                }

                {
                  timeout = 185;
                  command = "swaylock";
                }

                {
                  timeout = 190;
                  command = "swaymsg 'output * dpms off'";
                  resumeCommand = "swaymsg 'output * dpms on'";
                }

                {
                  timeout = 195;
                  command = "'systemctl suspend'";
                }
              ];
              events = [
                {
                  event = "before-sleep";
                  command = "swaylock";
                }
              ];
            };
          };
        };
    };
}
