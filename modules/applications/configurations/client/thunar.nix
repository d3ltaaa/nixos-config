{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    applications.configurations.client.thunar = {
      enable = lib.mkEnableOption "Enables Thunar module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.thunar;
    in
    lib.mkIf cfg.enable {
      environment.variables = {
        FILEMANAGER = "thunar";
      };
      services = {
        gvfs.enable = true; # set of backends like trash management
        tumbler.enable = true; # thumbnails
      };

      programs = {
        # xfconf.enable = true; # configuration daemon for xfce applications
        # file-roller.enable = true; # archive-operations

        thunar = {
          enable = true;
          plugins = with nixpkgs-stable.xfce; [
            # thunar-archive-plugin
            # thunar-volman
          ];
        };
      };

      # systemd.user.services.thunar-daemon = {
      #   description = "Enable thunar-daemon";
      #   after = [ "network.target" ];
      #   wantedBy = [ "default.target" ];
      #   serviceConfig = {
      #     Type = "oneshot";
      #     RemainAfterExit = true;
      #     ExecStart = "${nixpkgs-stable.xfce.thunar}/bin/thunar --daemon";
      #   };
      # };

      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        {
          xdg.mimeApps = {
            enable = true;
            defaultApplications = {
              "inode/directory" = [ "thunar.desktop" ];
              "x-scheme-handler/file" = [ "thunar.desktop" ];
              "applications/x-gnome-saved-search" = [ "thunar.desktop" ];
            };
          };
          wayland.windowManager.hyprland.settings.bind = [
            "$mod, E, exec, thunar"
          ];
        };
    };
}
