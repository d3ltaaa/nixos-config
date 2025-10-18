{ lib, config, ... }:
{
  options = {
    system.desktop.desktop-environments.hyprland-desktop.enable =
      lib.mkEnableOption "Enables all Modules for required for hyprland-desktop";
  };
  config =
    let
      cfg = config.system.desktop.desktop-environments.hyprland-desktop;
    in
    {
      system.desktop.components = lib.mkIf cfg.enable {
        autostart.enable = true;
        hyprland = {
          enable = true;
        };
        niri = {
          enable = lib.mkDefault false;
        };
        hypridle = {
          enable = true;
        };
        hyprlock = {
          enable = true;
        };
        hyprpolkitagent = {
          enable = true;
        };
        gnomepolkitagent = {
          enable = false;
        };
        greetd = {
          enable = false;
        };
        ly = {
          enable = false;
        };
        waybar = {
          enable = true;
        };
        rofi = {
          enable = true;
        };
        swappy = {
          enable = false;
        };
        satty = {
          enable = true;
        };
        swww = {
          enable = true;
        };
        cliphist = {
          enable = true;
        };
        dunst = {
          enable = true;
        };
        dconf = {
          enable = true;
        };
        # nwg-dock = {
        #   enable = true;
        # };
        settings = {
          # TODO impala etc
          nwg-displays = {
            enable = true;
          };
        };
      };
    };
}
