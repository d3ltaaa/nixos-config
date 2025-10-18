{ lib, config, ... }:
{
  options = {
    system.desktop.desktop-environments.niri-desktop.enable =
      lib.mkEnableOption "Enables all Modules for required for niri-desktop";
  };
  config =
    let
      cfg = config.system.desktop.desktop-environments.niri-desktop;
    in
    {
      system.desktop.components = lib.mkIf cfg.enable {
        autostart.enable = true;
        hyprland = {
          enable = lib.mkDefault false;
        };
        niri = {
          enable = true;
        };
        hypridle = {
          enable = false;
        };
        hyprlock = {
          enable = true;
        };
        hyprpolkitagent = {
          enable = false;
        };
        gnomepolkitagent = {
          enable = true;
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
          nwg-displays.enable = false;
          scripts.enable = true;
        };
      };
    };
}
