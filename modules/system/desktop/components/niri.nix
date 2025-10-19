{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.niri = {
      enable = lib.mkEnableOption "Enables the niri";
    };
  };
  config =
    let
      cfg = config.system.desktop.components.niri;
    in
    lib.mkIf cfg.enable {
      programs.niri.enable = true;
      environment.systemPackages = with pkgs; [
        xwayland-satellite
      ];
      home-manager.users.${config.system.user.general.primary} =
        { lib, config, ... }:
        {
          xdg.configFile."niri/config.kdl".text =
            let
              palette = config.colorScheme.palette;
            in
            ''
              input {
                  keyboard {
                      xkb {
                          layout "de"
                      }
                      numlock
                  }
                  touchpad {
                      // off
                      tap
                      natural-scroll
                      // accel-speed 0.2
                      // accel-profile "flat"
                      // scroll-method "two-finger"
                      // disabled-on-external-mouse
                  }

                  mouse {
                      // off
                      // natural-scroll
                      // accel-speed 0.2
                      // accel-profile "flat"
                      // scroll-method "no-scroll"
                  }

                  trackpoint {
                      // off
                      // natural-scroll
                      // accel-speed 0.2
                      // accel-profile "flat"
                      // scroll-method "on-button-down"
                      // scroll-button 273
                      // scroll-button-lock
                      // middle-emulation
                  }

                  warp-mouse-to-focus
                  focus-follows-mouse max-scroll-amount="0%"
              }

              overview {
                backdrop-color "#${palette.base01}"
                zoom 0.4
              };

              // Use a custom build of xwayland-satellite.
              // xwayland-satellite {
              //     path "/run/current-system/sw/bin/xwayland-satellite"
              // }

              cursor {
                  xcursor-theme "Bibata-Modern-Ice"
                  xcursor-size 24
                  hide-when-typing
              }

              output "DP-3" {
                  // off
                  mode "2560x1440"
                  scale 1
                  transform "normal" // normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
                  position x=0 y=0
              }
              output "DP-2" {
                  // off
                  mode "1920x1080"
                  scale 1
                  transform "normal" // normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
                  position x=2560 y=0
              }

              layout {
                  gaps 16
                  center-focused-column "on-overflow"
                  preset-column-widths {
                      proportion 0.33333
                      proportion 0.5
                      proportion 0.66667
                      proportion 1.0
                  }
                  preset-window-heights {
                    proportion 0.33333
                    proportion 0.5
                    proportion 0.66667
                    proportion 1.0
                  }
                  default-column-width { proportion 1.0;}
                  focus-ring {
                      off
                  }
                  border {
                      width 4
                      active-color "#${palette.base05}"
                      inactive-color "#${palette.base01}"
                      urgent-color "#${palette.base08}"
                  }
                  struts {
                      left 40
                      right 40
                      // top 64
                      // bottom 64
                  }
              }


              // spawn-at-startup "hyprlock" //TODO: only start if no displaymanager enabled maybe script =>
              // spawn-at-startup "waybar"
              spawn-at-startup "autostart-script"
              // spawn-sh-at-startup "qs -c ~/source/qs/MyAwesomeShell"

              hotkey-overlay {
                  skip-at-startup
              }

              prefer-no-csd
              screenshot-path "~/Bilder/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

              animations {
                  // off
                  slowdown 0.3
              }

              window-rule {
                  match app-id=r#"foot$"#
                  match app-id=r#"org.gnome.Nautilus$"#
                  default-column-width { proportion 0.5; }
              }

              window-rule {
                  match app-id=r#"firefox$"# title="^Picture-in-Picture$"
                  open-floating true
              }

              window-rule {
                  match app-id=r#"FLOATING-SETTINGS$"#
                  match app-id=r#"waypaper$"#
                  default-column-width { fixed 800; }
                  default-window-height { fixed 800; }
                  open-floating true
              }

              window-rule {
                  geometry-corner-radius 4
                  clip-to-geometry true
              }

              binds {
                  Mod+SHIFT+O { show-hotkey-overlay; }
                  Mod+O repeat=false { toggle-overview; }


                  XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "pulsemixer --change-volume +5"; }
                  XF86AudioLowerVolume allow-when-locked=true { spawn-sh "pulsemixer --change-volume -5"; }
                  XF86AudioMute        allow-when-locked=true { spawn-sh "pulsemixer --toggle-mute"; }
                  XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
                  XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
                  XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
                  XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }
                  XF86MonBrightnessUp  allow-when-locked=true { spawn-sh "script_light up"; }
                  XF86MonBrightnessDown allow-when-locked=true { spawn-sh "script_light down"; }

                  Mod+X repeat=false { close-window; }

                  Mod+H     { focus-column-left; }
                  Mod+J     { focus-window-down; }
                  Mod+K     { focus-window-up; }
                  Mod+L     { focus-column-right; }

                  Mod+Shift+H     { move-column-left; }
                  Mod+Shift+J     { move-window-down; }
                  Mod+Shift+K     { move-window-up; }
                  Mod+Shift+L     { move-column-right; }

                  Mod+Home { focus-column-first; }
                  Mod+End  { focus-column-last; }
                  Mod+Shift+Home { move-column-to-first; }
                  Mod+Shift+End  { move-column-to-last; }

                  ISO_Level3_Shift+H     { focus-monitor-left; }
                  ISO_Level3_Shift+J     { focus-monitor-down; }
                  ISO_Level3_Shift+K     { focus-monitor-up; }
                  ISO_Level3_Shift+L     { focus-monitor-right; }

                  ISO_Level3_Shift+Shift+H     { move-window-to-monitor-left; }
                  ISO_Level3_Shift+Shift+J     { move-window-to-monitor-down; }
                  ISO_Level3_Shift+Shift+K     { move-window-to-monitor-up; }
                  ISO_Level3_Shift+Shift+L     { move-window-to-monitor-right; }

                  Mod+I              { focus-workspace-down; }
                  Mod+U              { focus-workspace-up; }
                  Mod+Shift+I         { move-window-to-workspace-down; }
                  Mod+Shift+U         { move-window-to-workspace-up; }

                  Mod+Ctrl+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
                  Mod+Ctrl+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
                  Mod+Ctrl+Shift+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
                  Mod+Ctrl+Shift+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

                  Mod+WheelScrollRight      { focus-column-right; }
                  Mod+WheelScrollLeft       { focus-column-left; }
                  Mod+Shift+WheelScrollRight { move-column-right; }
                  Mod+Shift+WheelScrollLeft  { move-column-left; }

                  Mod+WheelScrollDown      { focus-column-right; }
                  Mod+WheelScrollUp        { focus-column-left; }
                  Mod+Shift+WheelScrollDown { move-column-right; }
                  Mod+Shift+WheelScrollUp   { move-column-left; }

                  Mod+1 { focus-workspace 1; }
                  Mod+2 { focus-workspace 2; }
                  Mod+3 { focus-workspace 3; }
                  Mod+4 { focus-workspace 4; }
                  Mod+5 { focus-workspace 5; }
                  Mod+6 { focus-workspace 6; }
                  Mod+7 { focus-workspace 7; }
                  Mod+8 { focus-workspace 8; }
                  Mod+9 { focus-workspace 9; }
                  Mod+Shift+1 { move-column-to-workspace 1; }
                  Mod+Shift+2 { move-column-to-workspace 2; }
                  Mod+Shift+3 { move-column-to-workspace 3; }
                  Mod+Shift+4 { move-column-to-workspace 4; }
                  Mod+Shift+5 { move-column-to-workspace 5; }
                  Mod+Shift+6 { move-column-to-workspace 6; }
                  Mod+Shift+7 { move-column-to-workspace 7; }
                  Mod+Shift+8 { move-column-to-workspace 8; }
                  Mod+Shift+9 { move-column-to-workspace 9; }

                  Mod+R { consume-or-expel-window-left; }
                  Mod+D { consume-or-expel-window-right; }
                  Mod+Comma  { consume-window-into-column; }
                  Mod+Period { expel-window-from-column; }

                  Mod+A { switch-preset-column-width; }
                  Mod+Shift+A { switch-preset-window-height; }
                  Mod+Ctrl+A { reset-window-height; }

                  Mod+F { maximize-column; }
                  Mod+Ctrl+F { fullscreen-window; }

                  Mod+Shift+F { expand-column-to-available-width; }

                  Mod+C { center-column; }

                  Mod+Ctrl+H { set-column-width "-10%"; }
                  Mod+Ctrl+L { set-column-width "+10%"; }
                  Mod+Ctrl+K { set-window-height "-10%"; }
                  Mod+Ctrl+J { set-window-height "+10%"; }

                  Mod+T       { toggle-window-floating; }
                  Mod+Shift+T { switch-focus-between-floating-and-tiling; }

                  Mod+W { toggle-column-tabbed-display; }

                  // Actions to switch layouts.
                  // Note: if you uncomment these, make sure you do NOT have
                  // a matching layout switch hotkey configured in xkb options above.
                  // Having both at once on the same hotkey will break the switching,
                  // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
                  // Mod+Space       { switch-layout "next"; }
                  // Mod+Shift+Space { switch-layout "prev"; }

                  Mod+Q { screenshot; }
                  Mod+Ctrl+Q { screenshot-screen; }
                  Mod+Shift+Q { screenshot-window; }

                  Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

                  Mod+Shift+E { quit; }
                  Ctrl+Alt+Delete { quit; }
                  Mod+Shift+P { power-off-monitors; }

                  Mod+P hotkey-overlay-title="Menu energy" { spawn-sh "menu_options energy"; }
                  Mod+S hotkey-overlay-title="Menu options" { spawn-sh "menu_options main"; }
                  Mod+Shift+S hotkey-overlay-title="Menu system" { spawn-sh "menu_system"; }
                  Mod+V hotkey-overlay-title="Menu vpn" { spawn-sh "toggle_vpn.sh"; }

                  Mod+B hotkey-overlay-title="Run an Application: brave" { spawn "brave"; }
                  Mod+E hotkey-overlay-title="Run an Application: files" { spawn "nautilus"; }
                  Mod+Space hotkey-overlay-title="Run an Application: rofi" { spawn-sh "rofi -show drun -case-insensitive"; }
                  Mod+Shift+Return hotkey-overlay-title="Open a Terminal: foot" { spawn "foot"; }

                  Mod+Shift+W hotkey-overlay-title="Restart an Application: waybar" { spawn-sh "pkill waybar; waybar"; }
                  Mod+G hotkey-overlay-title="Lock the Screen: hyprlock" { spawn "hyprlock"; }

                  Mod+Ctrl+N hotkey-overlay-title="Notification: Close all" { spawn-sh "dunstctl close-all && dunstctl history-clear"; }
                  Mod+Shift+N hotkey-overlay-title="Notification: Bring back last" { spawn-sh "dunstctl history-pop"; }
                  Mod+N hotkey-overlay-title="Notification: Close current" { spawn-sh "dunstctl close"; }

              }
            '';
        };
    };
}
