{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.hyprland-desktop.hyprland = {
      enable = lib.mkEnableOption "Enable hyprland as windowManager";
      monitor = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = [ "eDP-1, 1920x1080@60, 0x0, 1" ];
      };
      workspaces = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
      };
    };
  };

  config =
    let
      cfg = config.system.desktop.hyprland-desktop.hyprland;
      cfg-hyprland = config.system.desktop.hyprland-desktop;
    in
    lib.mkIf cfg.enable {

      programs.hyprland = lib.mkIf cfg.enable {
        enable = true;
        xwayland.enable = true;
      };

      environment.systemPackages = [
        (pkgs.writeScriptBin "hyprland-start-script" ''
          #!${pkgs.bash}/bin/bash

          ${lib.optionalString cfg-hyprland.hyprlock.enable ''
            hyprlock &
          ''}
          ${lib.optionalString cfg-hyprland.hyprpolkitagent.enable ''
            systemctl --user start hyprpolkitagent &
          ''}
          ${lib.optionalString cfg-hyprland.swww.enable ''
            swww-daemon &
            swww restore &
          ''}

          hyprpm reload -n

          ${lib.optionalString cfg-hyprland.waybar.enable ''
            waybar &
          ''}
        '')
      ];

      home-manager.users.${config.system.user.general.primary} =
        let
          nixos-config = config;
          nixos-cfg = cfg;
        in
        { config, ... }:
        {
          wayland.windowManager.hyprland = lib.mkIf nixos-cfg.enable {
            enable = true;
            xwayland.enable = true;
            systemd.enable = true;

            # extraConfig is important for use with nwg-displays
            extraConfig = "
              source=~/.config/hypr/monitors.conf
              source=~/.config/hypr/workspaces.conf
              ";

            settings = {

              env = [
                "_JAVA_AWT_WM_NONREPARENTING,1"
                "XCURSOR_SIZE,24"
                "XCURSOR_THEME, Bibata-Modern-Ice"
                "WLR_NO_HARDWARE_CURSORS,1"
              ];

              input = {
                kb_layout = "de";
                follow_mouse = 1;
                touchpad = {
                  natural_scroll = "no";
                };
              };

              general = {
                gaps_in = 10;
                gaps_out = 20;
                border_size = 3;
                "col.active_border" = "rgb(${config.colorScheme.palette.base05})";
                "col.inactive_border" = "rgb(${config.colorScheme.palette.base02})";

                layout = "dwindle";
                allow_tearing = false;
              };

              monitor = lib.mkIf (
                nixos-config.system.desktop.hyprland-desktop.settings.nwg-displays.enable != true
                && nixos-cfg.monitor != null
              ) nixos-cfg.monitor;
              workspace = lib.mkIf (
                nixos-config.system.desktop.hyprland-desktop.settings.nwg-displays.enable != true
                && nixos-cfg.workspaces != null
              ) nixos-cfg.workspaces;

              plugin = {
                hyprspace = {
                };
                # hyprexpo = {
                #   columns = 3;
                #   gap_size = 5;
                #   skip_empty = true;
                #   bg_col = "rgb(${config.colorScheme.palette.base00})";
                #   workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1
                #   gesture_distance = 300; # how far is the "max" for the gesture
                # };
                hyprbars = {
                  bar_height = 20;
                  bar_title_enabled = false;
                  bar_part_of_window = false;
                  bar_precedenixos-confige_over_border = false;
                  bar_color = "rgb(${config.colorScheme.palette.base00})";
                  bar_blur = true;
                  col.text = "rgb(${config.colorScheme.palette.base05})";
                  bar_padding = 5;
                  bar_button_padding = 15;
                  hyprbars-button = [
                    "rgb(${config.colorScheme.palette.base00}), 16,  , hyprctl dispatch killactive"
                    "rgb(${config.colorScheme.palette.base00}), 16,  , hyprctl dispatch fullscreen 1"
                    "rgb(${config.colorScheme.palette.base00}), 16,  , hyprctl dispatch togglefloating"
                    "rgb(${config.colorScheme.palette.base00}), 16, 󰋴 , resize_window.sh"

                  ];
                };
              };

              animations = {
                enabled = "yes";

                bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

                animation = [
                  "windows, 1, 1, myBezier, popin 100%"
                  "windowsOut, 1, 1, default, popin 100%"
                  "border, 1, 1, default"
                  "borderangle, 1, 1, default"
                  "fade, 1, 1, default"
                  "workspaces, 1, 1, default"

                ];
              };

              decoration = {
                rounding = 5;
                blur = {
                  enabled = true;
                  size = 5;
                  passes = 2;
                };
                # windowrule = "opacity 0.9, foot";
              };

              dwindle = {
                pseudotile = "yes";
                preserve_split = "yes";
              };

              # gestures = {
              #   gesture = "3, horizontal, workspace";
              # };

              misc = {
                force_default_wallpaper = 0;
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
                enable_swallow = true;
                swallow_regex = "^(kitty|alacritty)$";
                enable_anr_dialog = false;
                anr_missed_pings = 3;
              };

              "$mod" = "SUPER";
              bind = [
                "$mod SHIFT, M, exit,"

                "$mod, X, killactive, "
                "$mod, Z, togglesplit"
                "$mod, F, fullscreen,"
                "$mod, T, togglefloating,"

                "$mod, L, movefocus, r"
                "$mod, H, movefocus, l"
                "$mod, K, movefocus, u"
                "$mod, J, movefocus, d"

                "$mod SHIFT, L, movewindow, r"
                "$mod SHIFT, H, movewindow, l"
                "$mod SHIFT, K, movewindow, u"
                "$mod SHIFT, J, movewindow, d"

                "$mod, 1, workspace, 1"
                "$mod, 2, workspace, 2"
                "$mod, 3, workspace, 3"
                "$mod, 4, workspace, 4"
                "$mod, 5, workspace, 5"
                "$mod, 6, workspace, 6"
                "$mod, 7, workspace, 7"
                "$mod, 8, workspace, 8"
                "$mod, 9, workspace, 9"
                "$mod, 0, workspace, 10"

                "$mod SHIFT, 1, movetoworkspace, 1"
                "$mod SHIFT, 2, movetoworkspace, 2"
                "$mod SHIFT, 3, movetoworkspace, 3"
                "$mod SHIFT, 4, movetoworkspace, 4"
                "$mod SHIFT, 5, movetoworkspace, 5"
                "$mod SHIFT, 6, movetoworkspace, 6"
                "$mod SHIFT, 7, movetoworkspace, 7"
                "$mod SHIFT, 8, movetoworkspace, 8"
                "$mod SHIFT, 9, movetoworkspace, 9"
                "$mod SHIFT, 0, movetoworkspace, 10"

                "$mod, mouse_down, workspace, e+1"
                "$mod, mouse_up, workspace, e-1"
                "$mod, I, workspace, e+1"
                "$mod, U, workspace, e-1"

                "$mod SHIFT, mouse_down, movetoworkspace, e+1"
                "$mod SHIFT, mouse_up, movetoworkspace, e-1"
                "$mod SHIFT, I, movetoworkspace, e+1"
                "$mod SHIFT, U, movetoworkspace, e-1"

                "$mod, D, togglespecialworkspace, magic"
                "$mod SHIFT, D, movetoworkspace, special:magic"

                "$mod, S, exec, menu_options"
                "$mod SHIFT, S, exec, menu_system"
                "$mod, C, exec, menu_options updates"
                "$mod, P, exec, menu_options energy"
                "$mod, V, exec, toggle_vpn.sh"

                "$mod, SPACE, exec, rofi -show drun -case-insensitive"

                "$mod SHIFT, W, exec, pkill waybar; waybar"

                "$mod SHIFT, N, exec, dunstctl history-pop"
                "$mod, N, exec, dunstctl close"
                "$mod CONTROL, N, exec, dunstctl close-all && dunstctl history-clear"

                "$mod, G, exec, hyprlock"
              ];

              bindm = [
                "$mod, mouse:272, movewindow"
                "$mod, mouse:273, resizewindow"

              ];

              bindel = [
                ",XF86MonBrightnessUp, exec, scr_light up"
                ",XF86MonBrightnessDown, exec, scr_light down"
              ];

              binde = [
                ",XF86AudioMute, exec, scr_volume mute"
                ",XF86AudioLowerVolume, exec, scr_volume dec"
                ",XF86AudioRaiseVolume, exec, scr_volume inc"
                ",XF86AudioPlay, exec, playerctl play-pause"
                ",XF86AudioPrev, exec, playerctl previous"
                ",XF86AudioNext, exec, playerctl next"

                "$mod CONTROL, L, resizeactive, 40 0"
                "$mod CONTROL, H, resizeactive, -40 0"
                "$mod CONTROL, K, resizeactive, 0 -40"
                "$mod CONTROL, J, resizeactive, 0 40"
              ];

              exec-once = "hyprland-start-script";
            };

            plugins = [
              # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
              pkgs.hyprlandPlugins.hyprbars
              pkgs.hyprlandPlugins.hyprexpo
            ];
          };
        };
    };
}
