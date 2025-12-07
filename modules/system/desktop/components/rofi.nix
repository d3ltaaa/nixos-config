{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.rofi.enable = lib.mkEnableOption "Enables Rofi module";
  };

  config =
    let
      cfg = config.system.desktop.components.rofi;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        {
          programs.rofi =
            let
              inherit (config.lib.formats.rasi) mkLiteral;
              rofi-theme = {

                "*" = {
                  background-color = mkLiteral "transparent";
                  text-color = mkLiteral "#${config.colorScheme.palette.base05}";
                  border-color = mkLiteral "#${config.colorScheme.palette.base05}";
                  dpadding = mkLiteral "10px";
                  dspacing = mkLiteral "10px";
                  rborder = mkLiteral "10px";
                  sborder = mkLiteral "4px";
                };

                "window" = {
                  background-color = mkLiteral "#${config.colorScheme.palette.base00}e5";
                  border = mkLiteral "@sborder";
                  border-radius = mkLiteral "@rborder";
                  children = [ "mainbox" ];
                  height = mkLiteral "600";
                  padding = mkLiteral "0";
                  width = mkLiteral "600";
                };

                "mainbox" = {
                  children = [
                    "inputbar"
                    "listview"
                  ];
                  orientation = mkLiteral "vertical";
                  padding = mkLiteral "@dpadding";
                  spacing = mkLiteral "@dspacing";
                };

                "inputbar" = {
                  background-color = mkLiteral "#${config.colorScheme.palette.base02}e5";
                  border = mkLiteral "@sborder";
                  border-radius = mkLiteral "@rborder";
                  children = [
                    "prompt"
                    "entry"
                  ];
                };

                "prompt" = {
                  background-color = mkLiteral "transparent";
                  enabled = mkLiteral "true";
                  horizontal-align = mkLiteral "0.50";
                  padding = mkLiteral "15 5 15 15";
                  vertical-align = mkLiteral "0.50";
                };

                "entry" = {
                  background-color = mkLiteral "transparent";
                  blink = mkLiteral "false";
                  horizontal-align = mkLiteral "0.45";
                  padding = mkLiteral "15 0 15 0";
                  placeholder = mkLiteral "\"\"";
                  placeholder-color = mkLiteral "#${config.colorScheme.palette.base04}";
                  vertical-align = mkLiteral "0.50";
                };

                "listview" = {
                  columns = mkLiteral "1";
                  lines = mkLiteral "8";
                  scrollbar = mkLiteral "false";
                  spacing = mkLiteral "@dspacing";
                };

                "element" = {
                  horizontal-align = mkLiteral "0";
                  orientation = mkLiteral "horizontal";
                  padding = mkLiteral "@dpadding";
                  position = mkLiteral "east";
                  vertical-align = mkLiteral "0";
                };

                "element alternate active" = { };
                "element alternate normal" = { };
                "element alternate urgent" = { };
                "element normal active" = { };
                "element normal normal" = { };
                "element normal urgent" = { };
                "element selected active" = { };
                "element selected normal" = {
                  background-color = mkLiteral "#${config.colorScheme.palette.base02}e5";
                  border = mkLiteral "@sborder";
                  border-radius = mkLiteral "@rborder";
                };
                "element selected urgent" = { };
                "element-icon" = {
                  background-color = mkLiteral "transparent";
                  align = mkLiteral "center";
                  size = mkLiteral "3ch";
                  vertical-align = mkLiteral "0";
                  yoffset = mkLiteral "50";
                };
                "element-text" = {
                  background-color = mkLiteral "transparent";
                  vertical-align = mkLiteral "0.5";
                };
                "message " = { };
                "textbox" = {
                  font = mkLiteral "\"InconsolataGo Nerd Font Bold 11\"";
                  horizontal-align = mkLiteral "0.50";
                };
              };
            in
            {
              enable = true;
              theme = rofi-theme;
              package = pkgs.rofi;
              extraConfig = {
                kb-row-up = "Up,alt+k,Shift+Tab,Shift+ISO_Left_Tab";
                kb-row-down = "Down,alt+j";
                kb-accept-entry = "Return";
                terminal = "foot";
                kb-remove-to-eol = "alt+Shift+e";
                kb-mode-next = "Shift+Right,alt+Tab,alt+o";
                kb-mode-complete = "";
                kb-mode-previous = "Shift+Left,alt+Shift+Tab,alt+i";
                kb-remove-char-back = "BackSpace";
                kb-clear-line = "";
                kb-remove-word-back = "alt+w";
                kb-cancel = "Escape,MouseSecondary";
                hover-select = true;
                me-select-entry = "";
                me-accept-entry = "MousePrimary";

                display-run = "";
                display-drun = "";
                display-window = "";
                drun-display-format = "{icon} {name}";
                modi = "window,run,drun";
                show-icons = true;
                # // font = "Meslo Nerd Font 12";
              };
            };
          wayland.windowManager.hyprland.settings.bind = [
            "$mod, SPACE, exec, rofi -show drun -case-insensitive"
          ];

          xdg.configFile."rofi/settings.rasi".text = ''
            window {
              fullscreen: true;
              border: 0px;
            }
            mainbox {
              margin:     15% 30%;
            }'';

          xdg.configFile."rofi/powermenu.rasi".text = ''

            configuration {
                show-icons:                 false;
            }
            * {
                background:     #${config.colorScheme.palette.base00}e5;
                background-alt:     #${config.colorScheme.palette.base01};
                foreground:     #${config.colorScheme.palette.base05};
                selected:     #${config.colorScheme.palette.base05};
                active:     #${config.colorScheme.palette.base0B};
                urgent:     #${config.colorScheme.palette.base08};
                box-margin:                  40% 15%;
                list-spacing:                5%;
                general-padding:             0px;
                element-padding:             2% 0%;
                element-radius:              20px;
                general-radius:              100%;
                font: "InconsolataGo Nerd Font Bold 11";
                element-font: "InconsolataGo Nerd Font Bold 40";
            }

            /*****----- Main Window -----*****/
            window {
                /* properties for window widget */
                transparency:                "real";
                fullscreen:                  true;

                /* properties for all widgets */
                enabled:                     true;
                margin:                      0px;
                padding:                     0px;
                border:                      0px solid;
                border-radius:               0px;
                border-color:                @selected;
                cursor:                      "default";
                background-color:            @background;
            }

            /*****----- Main Box -----*****/
            mainbox {
                enabled:                     true;
                margin:                      0px;
                padding:                     var(box-margin);
                border:                      0px solid;
                border-radius:               0px;
                border-color:                @selected;
                background-color:            transparent;
                children:                    [  "listview" ];
            }

            /*****----- Listview -----*****/
            listview {
                enabled:                     true;
                columns:                     6;
                lines:                       1;
                cycle:                       true;
                dynamic:                     true;
                scrollbar:                   false;
                layout:                      vertical;
                reverse:                     false;
                fixed-height:                true;
                fixed-columns:               true;

                spacing:                     var(list-spacing);
                margin:                      0px;
                padding:                     0px;
                border:                      0px solid;
                border-radius:               0px;
                border-color:                @selected;
                background-color:            transparent;
                text-color:                  @foreground;
                cursor:                      "default";
            }

            /*****----- Elements -----*****/
            element {
                enabled:                     true;
                spacing:                     0px;
                margin:                      0px;
                padding:                     var(element-padding);
                border:                      0px solid;
                border-radius:               var(element-radius);
                border-color:                @selected;
                background-color:            @background-alt;
                text-color:                  @foreground;
                cursor:                      pointer;
            }
            element-text {
                font:                        var(element-font);
                background-color:            transparent;
                text-color:                  inherit;
                cursor:                      inherit;
                vertical-align:              0.5;
                horizontal-align:            0.5;
            }
            element selected.normal {
                background-color:            var(selected);
                text-color:                  var(background);
            }
          '';
        };
    };
}
