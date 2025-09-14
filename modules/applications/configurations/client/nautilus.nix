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
          # override default desktop entry, due to problems (opening twice after boot)
          xdg.desktopEntries = {
            "org.gnome.Nautilus" = {
              name = "Files";
              genericName = "Nautilus File Manager";
              exec = "nautilus --no-desktop --new-window %U";
              icon = "org.gnome.Nautilus";
              categories = [
                "System"
                "FileManager"
              ];
              terminal = false;
            };
          };

          wayland.windowManager.hyprland.settings.bind = [
            "$mod, E, exec, nautilus"
          ];
        };
    };
}
