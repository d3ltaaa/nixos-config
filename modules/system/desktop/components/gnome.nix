{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.gnome = {
      enable = lib.mkEnableOption "Enable Gnome Desktop";
    };
  };
  config =
    let
      cfg = config.system.desktop.components.gnome;
    in
    lib.mkIf cfg.enable {
      # Pre 25.11
      services.xserver.enable = true;
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;

      # As of 25.11
      # services.displayManager.gdm.enable = true;
      # services.desktopManager.gnome.enable = true;

      # To disable installing GNOME's suite of applications
      # and only be left with GNOME shell.
      services.gnome.core-apps.enable = false;
      services.gnome.core-developer-tools.enable = false;
      services.gnome.games.enable = false;
      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
      ];
    };
}
