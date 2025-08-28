{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.packages.flatpaks = {
      flatpaks.default = lib.mkEnableOption "Enables Flatpaks";
    };
  };

  config =
    let
      cfg = config.applications.packages.flatpaks;
      flatpak-pkgs = [
        "org.gnome.Decibels"
        "io.emeric.toolblex"
        "com.obsproject.Studio"
        "net.mkiol.SpeechNote"
        "app.zen_browser.zen"
        "org.bleachbit.BleachBit"
        "com.borgbase.Vorta" # Vorta backups
      ];
    in
    lib.mkIf cfg.enable {
      # has to be enabled in order for flatpaks to work!
      xdg.portal = lib.mkIf config.applications.packages.libraries.flatpaks.default {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
      };
      services.flatpak = lib.mkIf config.applications.packages.libraries.flatpaks.default {
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
