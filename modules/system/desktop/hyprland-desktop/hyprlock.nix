{ lib, config, ... }:
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
            };

            input-field = {
              monitor = "";
              size = "200, 50";
              outline_thickness = 3;
              dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8;
              dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0;
              dots_center = true;
              dots_rounding = -1;
              outer_color = "rgb(${config.colorScheme.palette.base00})";
              inner_color = "rgb(${config.colorScheme.palette.base05})";
              font_color = "rgb(${config.colorScheme.palette.base00})";
              fade_on_empty = true;
              fade_timeout = 1000;
              placeholder_text = "<i> Input Password...</i>";
              hide_input = false;
              rounding = -1; # -1 means complete rounding (circle/oval)
              check_color = "rgb(${config.colorScheme.palette.base0A})";
              fail_color = "rgb(${config.colorScheme.palette.base08})"; # if authentication failed, changes outer_color and fail message color
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
              fail_transition = 300; # transition time in ms between normal outer_color and fail_color
              capslock_color = -1;
              numlock_color = -1;
              bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
              invert_numlock = false; # change color if numlock is off
              swap_font_color = false; # see below
              position = "0, -20";
              halign = "center";
              valign = "center";
            };

            image = {
              monitor = "";
              path = "$HOME/.cache/square_wallpaper.png";
              size = 280; # lesser side if not 1:1 ratio
              rounding = -1; # negative values mean circle
              border_size = 4;
              border_color = "rgb(${config.colorScheme.palette.base05})";
              rotate = 0; # degrees, counter-clockwise
              reload_time = -1; # seconds between reloading, 0 to reload with SIGUSR2
              position = "0, 200";
              halign = "center";
              valign = "center";
            };
          };
        };
    };
}
