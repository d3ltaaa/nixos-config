{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.gnomepolkitagent = {
      enable = lib.mkEnableOption "Enables the gnomepolkitagent";
    };
  };
  config =
    let
      cfg = config.system.desktop.components.hyprpolkitagent;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ polkit_gnome ];
      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
}
