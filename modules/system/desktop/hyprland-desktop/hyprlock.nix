{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    system.desktop.hyprland-desktop.hyprlock.enable = lib.mkEnableOption "Enables Hyplock";
  };

  config =
    let
      cfg = config.system.desktop.hyprland-desktop.hyprlock;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.system.user.general.primary} =
        let
          nixos-config = config;
          nixos-cfg = cfg;
        in
        { config, ... }:
        lib.mkIf nixos-cfg.enable {
          programs.hyprlock.enable = true;
          programs.hyprlock.settings = {
            background = {
              monitor = "";
              path = "/home/${nixos-config.system.user.general.primary}/.config/wall/paper";
              blur_passes = 2;
            };

            auth = {
              pam = {
                enabled = true;
                # module = "su";
              };
              fingerprint = lib.mkIf nixos-config.hardware.fingerprint.enable {
                enabled = true;
              };
            };

            input-field = {
              monitor = "";
              size = "300, 60";
              outline_thickness = 2;
              dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8;
              dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0;
              dots_center = true;
              outer_color = "rgb(${config.colorScheme.palette.base00})";
              inner_color = "rgb(${config.colorScheme.palette.base05})";
              font_color = "rgb(${config.colorScheme.palette.base00})";
              fade_on_empty = false;
              font_family = "SF Pro Display Bold";
              placeholder_text = ''<span>Enter Password...</span>'';
              hide_input = false;
              position = "0, -290";
              halign = "center";
              valign = "center";
            };

            label = [
              {
                # USER
                monitor = "";
                text = "   $USER";
                color = "rgb(${config.colorScheme.palette.base0D})";
                font_size = 22;
                font_family = "SF Pro Display Bold";
                position = "0, -220";
                halign = "center";
                valign = "center";
              }

              {
                # Time-Hour
                monitor = "";
                text = ''cmd[update:1000] echo "<span>$(date +"%H")</span>"'';
                color = "rgb(${config.colorScheme.palette.base05})";
                font_size = 125;
                font_family = "StretchPro";
                position = "-80, 220";
                halign = "center";
                valign = "center";
              }

              {
                # Time-Minute
                monitor = "";
                text = ''cmd[update:1000] echo "<span>$(date +"%M")</span>"'';
                color = "rgb(${config.colorScheme.palette.base0D})";
                font_size = 125;
                font_family = "StretchPro";
                position = "0, 70";
                halign = "center";
                valign = "center";
              }
              {

                # Day-Month-Date
                monitor = "";
                text = ''cmd[update:1000] echo -e "$(date "+%A, %d. %B %Y")"'';
                color = "rgb(${config.colorScheme.palette.base05})";
                font_size = 22;
                font_family = "Suisse Int'l Mono";
                position = "20, -25";
                halign = "center";
                valign = "center";
              }
            ];
          };
        };
    };
}
