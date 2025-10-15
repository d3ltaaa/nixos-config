{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.satty.enable = lib.mkEnableOption "Enables Swappy Module";
  };

  config =
    let
      cfg = config.system.desktop.components.satty;
      cfg-hyprland = config.system.desktop.components.hyprland;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ satty ]; # stable fails with "egl display fails to create"
      home-manager.users.${config.system.user.general.primary} =
        { lib, config, ... }:
        let
          nixos-cfg-hyprland = cfg-hyprland;
        in
        {
          wayland.windowManager.hyprland = lib.mkIf nixos-cfg-hyprland.enable {
            settings = {
              bind = [
                "$mod, Q, exec, grim -g \"$(slurp)\" -t ppm - | satty --filename - "
              ];
            };
          };

          xdg.configFile."satty/config.toml".source = (pkgs.formats.toml { }).generate "satty-config" {
            general = {
              # Start Satty in fullscreen mode
              fullscreen = false;
              # Exit directly after copy/save action
              early-exit = true;
              # Draw corners of rectangles round if the value is greater than 0 (0 disables rounded corners)
              corner-roundness = 12;
              # Select the tool on startup [possible values: pointer, crop, line, arrow, rectangle, text, marker, blur, brush]
              initial-tool = "brush";
              # Configure the command to be called on copy, for example `wl-copy`
              copy-command = "wl-copy";
              # Increase or decrease the size of the annotations
              annotation-size-factor = 2;
              # Filename to use for saving action. Omit to disable saving to file. Might contain format specifiers: https://docs.rs/chrono/latest/chrono/format/strftime/index.html
              output-filename = "${config.xdg.userDirs.extraConfig.XDG_SCREENSHOT_DIR}/satty-$(date '+%Y%m%d-%H:%M:%S').png";
              # After copying the screenshot, save it to a file as well
              save-after-copy = false;
              # Hide toolbars by default
              default-hide-toolbars = false;
              # The primary highlighter to use, the other is accessible by holding CTRL at the start of a highlight [possible values: block, freehand]
              primary-highlighter = "block";
              # Disable notifications
              disable-notifications = false;
              # Action to perform when the Enter key is pressed [possible values: save-to-clipboard, save-to-file]
              # Deprecated: use actions-on-enter instead
              action-on-enter = "save-to-clipboard";
              # Right click to copy
              # Deprecated: use actions-on-right-click instead
              right-click-copy = false;
            };

            # Font to use for text annotations
            font = {
              family = "Roboto";
              style = "Bold";
            };
            # Custom colours for the colour palette
            color-palette = {
              # These will be shown in the toolbar for quick selection
              palette = [
                "#00ffff"
                "#a52a2a"
                "#dc143c"
                "#ff1493"
                "#ffd700"
                "#008000"
              ];

              # These will be available in the color picker as presets
              # Leave empty to use GTK's default
              custom = [
                "#00ffff"
                "#a52a2a"
                "#dc143c"
                "#ff1493"
                "#ffd700"
                "#008000"
              ];
            };
          };
        };
    };
}
