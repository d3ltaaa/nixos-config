{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.hyprland-desktop.rofi.enable = lib.mkEnableOption "Enables Rofi module";
  };

  config =
    let
      cfg = config.system.desktop.hyprland-desktop.rofi;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.settings.users.primary} =
        { config, ... }:
        {
          programs.rofi =
            let
              inherit (config.lib.formats.rasi) mkLiteral;
              rofi-theme = {

                "*" = {
                  background-color = mkLiteral "#${config.colorScheme.palette.base00}";
                  text-color = mkLiteral "#${config.colorScheme.palette.base05}";
                  border-color = mkLiteral "#${config.colorScheme.palette.base05}";
                  dpadding = mkLiteral "10px";
                  dspacing = mkLiteral "10px";
                  rborder = mkLiteral "10px";
                  sborder = mkLiteral "4px";
                };

                "window" = {
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
                  background-color = mkLiteral "#${config.colorScheme.palette.base02}";
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
                  background-color = mkLiteral "#${config.colorScheme.palette.base02}";
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
              package = pkgs.rofi-wayland;
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
        };
    };
}
