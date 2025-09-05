{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.packages.flatpaks = {
      enable = lib.mkEnableOption "Enables Flatpaks";
    };
  };

  config =
    let
      cfg = config.applications.packages.flatpaks;
      flatpak-pkgs = [
        "io.emeric.toolblex"
        "com.obsproject.Studio"
        "net.mkiol.SpeechNote"
        "com.borgbase.Vorta" # Vorta backups
      ];
    in
    lib.mkIf cfg.enable {
      # has to be enabled in order for flatpaks to work!
      xdg.portal = lib.mkIf config.applications.packages.flatpaks.enable {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
      };
      services.flatpak = lib.mkIf config.applications.packages.flatpaks.enable {
        enable = true;
        remotes = lib.mkOptionDefault [
          {
            name = "flathub-beta";
            location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
          }
        ];
        update.auto.enable = false;
        uninstallUnmanaged = true;

        # Add here the flatpaks you want to install
        packages = flatpak-pkgs;
      };
    };
}
