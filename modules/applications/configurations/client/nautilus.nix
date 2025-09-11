{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.nautilus = {
      enable = lib.mkEnableOption "Enables Nautilus module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.nautilus;
    in
    lib.mkIf cfg.enable {
      environment.variables = {
        FILEMANAGER = "nautilus";
      };
      environment.systemPackages = with pkgs; [ nautilus ];
      services.gvfs.enable = true;
      services.gnome.tinysparql.enable = true;
      services.gnome.localsearch.enable = true;
      programs.nautilus-open-any-terminal.enable = true;
      services.gnome.sushi.enable = true;

      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        {
          xdg.mimeApps = {
            enable = true;
            defaultApplications = {
              "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
              "x-scheme-handler/file" = [ "org.gnome.Nautilus.desktop" ];
              "applications/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
            };
          };
          wayland.windowManager.hyprland.settings.bind = [
            "$mod, E, exec, nautilus"
          ];
        };
    };
}
